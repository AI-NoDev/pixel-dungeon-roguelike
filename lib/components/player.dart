import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import '../game/pixel_dungeon_game.dart';
import '../data/weapons.dart';
import '../data/talents.dart';
import '../data/heroes.dart';
import '../systems/preferences.dart';
import 'bullet.dart';
import 'enemy_spawner.dart';
import 'floating_text.dart';
import 'aura_effect.dart';
import 'decal.dart';
import 'muzzle_flash.dart';
import 'melee_swing.dart';
import '../systems/audio_system.dart';

class Player extends PositionComponent with HasGameReference<PixelDungeonGame>, CollisionCallbacks {
  Player({required Vector2 position, this.heroType = HeroType.knight})
      : super(
          position: position,
          size: Vector2(32, 32),
          anchor: Anchor.center,
        );

  final HeroType heroType;

  // Base stats
  double maxHp = 100;
  double hp = 100;
  double baseSpeed = 150;
  double baseDamage = 20;
  double baseFireRate = 3.0;
  double baseBulletSpeed = 300;

  // Talent multipliers
  double damageMultiplier = 1.0;
  double fireRateMultiplier = 1.0;
  double speedMultiplier = 1.0;
  double critChance = 0.10;  // 10% base critical hit chance
  double bulletSpeedMultiplier = 1.0;
  int extraBullets = 0;
  double spreadReduction = 0;

  // Weapon slots:
  //   - primary = the starter pistol that you always have. Cannot be dropped.
  //     Has infinite ammo so you can never run out.
  //   - secondary = picked-up weapon (only one slot). Has limited ammo and
  //     auto-falls back to primary when empty.
  WeaponData primaryWeapon = WeaponPool.starterPistol;
  WeaponData? secondaryWeapon;
  int secondaryAmmo = 0;

  /// The weapon currently being fired (secondary if held + has ammo, else primary).
  WeaponData get activeWeapon {
    if (secondaryWeapon != null && secondaryAmmo > 0) return secondaryWeapon!;
    return primaryWeapon;
  }

  /// Backwards compat — many systems used `currentWeapon`.
  WeaponData get currentWeapon => activeWeapon;

  // Computed stats based on active weapon
  double get speed => baseSpeed * speedMultiplier;
  double get attackDamage => activeWeapon.damage * damageMultiplier;
  double get attackInterval => 1.0 / (activeWeapon.fireRate * fireRateMultiplier);
  double get bulletSpeed => activeWeapon.bulletSpeed * bulletSpeedMultiplier;
  int get bulletsPerShot => activeWeapon.bulletsPerShot + extraBullets;
  double get spread => activeWeapon.spread * (1.0 - spreadReduction);

  // State
  Vector2 moveDirection = Vector2.zero();
  Vector2 aimDirection = Vector2(1, 0);
  double _shootTimer = 0;
  bool isShooting = false;        // finger on aim joystick (auto-aim or manual)
  bool isManualAim = false;       // dragged outside deadzone
  bool isDead = false;

  // Talents collected
  List<TalentData> talents = [];

  // Visual: sprite-based hero
  SpriteAnimationComponent? _animComp;
  SpriteAnimation? _idleAnim;
  SpriteAnimation? _walkAnim;
  SpriteAnimation? _hurtAnim;
  bool _isMoving = false;

  // Weapon visual: actual sprite (fallback to coloured rect on missing asset).
  SpriteComponent? _weaponSprite;
  RectangleComponent? _weaponFallback;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load animated hero sprite
    final heroId = _heroSpriteId();
    try {
      _idleAnim = await _loadAnim('hero_${heroId}_idle.png', 4, 0.18);
      _walkAnim = await _loadAnim('hero_${heroId}_walk.png', 4, 0.10);
      _hurtAnim = await _loadAnim('hero_${heroId}_hurt.png', 2, 0.10);
      _animComp = SpriteAnimationComponent(
        animation: _idleAnim,
        size: Vector2(32, 32),
        anchor: Anchor.topLeft,
      );
      add(_animComp!);
    } catch (_) {
      // Fallback rectangle if sprites missing
      add(RectangleComponent(
        size: Vector2(28, 28),
        position: Vector2(2, 2),
        paint: Paint()..color = const Color(0xFF4FC3F7),
      ));
    }

    await _refreshWeaponSprite();

    add(RectangleHitbox(size: Vector2(20, 22), position: Vector2(6, 5)));
  }

  String _heroSpriteId() {
    switch (heroType) {
      case HeroType.knight: return 'knight';
      case HeroType.ranger: return 'ranger';
      case HeroType.mage:   return 'mage';
      case HeroType.rogue:  return 'rogue';
    }
  }

  Future<SpriteAnimation> _loadAnim(String filename, int frames, double step) async {
    final image = await game.images.load('heroes/$filename');
    final src = image.width ~/ frames;
    final sheet = SpriteSheet(image: image, srcSize: Vector2.all(src.toDouble()));
    return sheet.createAnimation(row: 0, stepTime: step, to: frames);
  }

  /// Build (or rebuild) the weapon sprite for the active weapon.
  Future<void> _refreshWeaponSprite() async {
    _weaponSprite?.removeFromParent();
    _weaponFallback?.removeFromParent();
    _weaponSprite = null;
    _weaponFallback = null;

    final w = activeWeapon;
    try {
      final image = await game.images.load('weapons/weapon_${w.spriteId}.png');
      // The source PNGs include a 1-pixel rarity border around the icon
      // (used by the inventory UI). Crop it off so the in-hand weapon
      // does not look like a square frame.
      final src = Vector2(
        (image.width - 2).toDouble(),
        (image.height - 2).toDouble(),
      );
      final sprite = Sprite(
        image,
        srcPosition: Vector2(1, 1),
        srcSize: src,
      );
      _weaponSprite = SpriteComponent(
        sprite: sprite,
        size: Vector2.all(20),
        anchor: Anchor.center,
        position: Vector2(16 + 12, 16),
      );
      add(_weaponSprite!);
    } catch (_) {
      _weaponFallback = RectangleComponent(
        size: Vector2(16, 4),
        position: Vector2(24, 14),
        paint: Paint()..color = w.color,
      );
      add(_weaponFallback!);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isDead) return;

    // Movement
    if (moveDirection.length > 0) {
      final normalizedDir = moveDirection.normalized();
      // Try to move; if the new position would land us inside a wall,
      // slide along the unblocked axis instead.
      final desired = position + normalizedDir * speed * dt;
      if (!_collidesWithWall(desired)) {
        position = desired;
      } else {
        // Try sliding along X only
        final slideX = position + Vector2(normalizedDir.x * speed * dt, 0);
        final slideY = position + Vector2(0, normalizedDir.y * speed * dt);
        if (!_collidesWithWall(slideX)) {
          position = slideX;
        } else if (!_collidesWithWall(slideY)) {
          position = slideY;
        }
      }
    }

    // Walk vs idle animation
    final movingNow = moveDirection.length > 0;
    if (movingNow != _isMoving && _animComp != null) {
      _isMoving = movingNow;
      _animComp!.animation = _isMoving ? _walkAnim : _idleAnim;
    }

    // Auto-aim while finger is on aim joystick but not dragged out.
    // Range is large + always-on so a tiny finger jiggle never disables it.
    if (isShooting && !isManualAim) {
      final autoTarget = _findNearestEnemy(GamePreferences.autoAimRange);
      if (autoTarget != null) {
        aimDirection = (autoTarget.position - position).normalized();
      }
    }

    // Shooting: finger is on aim joystick (any mode triggers fire)
    _shootTimer += dt;
    if (isShooting && _shootTimer >= attackInterval) {
      _shoot();
      _shootTimer = 0;
    }

    // Update weapon visual (rotation + offset around player)
    _updateWeaponVisual();
  }

  void _updateWeaponVisual() {
    if (aimDirection.length == 0) return;
    final angle = atan2(aimDirection.y, aimDirection.x);
    if (_weaponSprite != null) {
      _weaponSprite!.angle = angle;
      _weaponSprite!.position = Vector2(
        16 + cos(angle) * 14,
        16 + sin(angle) * 14,
      );
    } else if (_weaponFallback != null) {
      _weaponFallback!.angle = angle;
      _weaponFallback!.position = Vector2(
        16 + cos(angle) * 12,
        16 + sin(angle) * 12 - 2,
      );
    }
  }

  Enemy? _findNearestEnemy(double maxRange) {
    Enemy? nearest;
    double nearestDistSq = maxRange * maxRange;
    final ppos = position;
    // Use squared distance to avoid sqrt per enemy.
    for (final c in game.world.children) {
      if (c is Enemy && !c.isDead) {
        final dx = c.position.x - ppos.x;
        final dy = c.position.y - ppos.y;
        final dSq = dx * dx + dy * dy;
        if (dSq < nearestDistSq) {
          nearestDistSq = dSq;
          nearest = c;
        }
      }
    }
    return nearest;
  }

  void _shoot() {
    if (aimDirection.length == 0) return;

    final w = activeWeapon;
    final baseAngle = atan2(aimDirection.y, aimDirection.x);

    // Roll critical hit per shot
    final isCritical = Random().nextDouble() < critChance;
    final critMultiplier = isCritical ? 2.0 : 1.0;

    if (w.isMelee) {
      _meleeAttack(w, baseAngle, isCritical, critMultiplier);
    } else {
      _rangedAttack(w, baseAngle, isCritical, critMultiplier);
    }

    // Consume ammo if firing the secondary
    if (secondaryWeapon != null && secondaryWeapon == w && secondaryAmmo > 0) {
      secondaryAmmo--;
      if (secondaryAmmo <= 0) {
        secondaryWeapon = null;
        secondaryAmmo = 0;
        _refreshWeaponSprite();
        game.world.add(FloatingText.buff(
          position + Vector2(0, -20),
          'OUT OF AMMO',
        ));
        game.onStateChanged?.call();
      } else {
        game.onStateChanged?.call();
      }
    }
  }

  /// Melee attack: swing the weapon in an arc, damage enemies in range.
  void _meleeAttack(WeaponData w, double angle, bool isCritical, double critMult) {
    game.world.add(MeleeSwing(
      position: position.clone(),
      aimAngle: angle,
      weapon: w,
      damage: attackDamage * critMult,
      isCritical: isCritical,
    ));

    // Weapon visual: quick rotation animation (swing).
    _animateWeaponSwing(angle);

    // Screen shake on heavy melee
    if (w.type == WeaponType.hammer || w.type == WeaponType.axe) {
      game.shake(5, 0.2);
    } else if (isCritical) {
      game.shake(3, 0.12);
    }
  }

  /// Ranged attack: fire bullets.
  void _rangedAttack(WeaponData w, double baseAngle, bool isCritical, double critMult) {
    final shotsThis = bulletsPerShot;
    for (int i = 0; i < shotsThis; i++) {
      double angle = baseAngle;

      if (shotsThis > 1) {
        final totalSpread = spread > 0 ? spread : 0.3;
        angle = baseAngle - totalSpread / 2 + (totalSpread / (shotsThis - 1)) * i;
      }

      final bulletDir = Vector2(cos(angle), sin(angle));
      final bulletPos = position + bulletDir * 20;

      final bullet = Bullet(
        position: bulletPos,
        direction: bulletDir,
        speed: bulletSpeed,
        damage: attackDamage * critMult,
        isPlayerBullet: true,
        color: w.color,
        element: w.element,
        isCritical: isCritical,
      );

      game.world.add(bullet);
    }

    // Muzzle flash at end of weapon
    final muzzlePos = position + Vector2(cos(baseAngle), sin(baseAngle)) * 22;
    game.world.add(MuzzleFlash(
      position: muzzlePos,
      angle: baseAngle,
      color: w.color,
      size_: bulletsPerShot > 1 ? 24 : 18,
    ));

    // SFX based on weapon type
    AudioSystem.playShoot(_audioStyleFor(w));

    // Subtle screen shake on heavy weapons
    if (w.type == WeaponType.rocket || w.type == WeaponType.sniper) {
      game.shake(4, 0.18);
    } else if (isCritical) {
      game.shake(2, 0.1);
    }
  }

  /// Quick weapon rotation animation for melee swing.
  void _animateWeaponSwing(double angle) {
    // Rotate weapon sprite forward then back over ~0.15s.
    final target = _weaponSprite ?? _weaponFallback;
    if (target == null) return;
    final startAngle = angle;
    final swingAngle = 1.2; // radians forward
    target.angle = startAngle + swingAngle;
    Future.delayed(const Duration(milliseconds: 80), () {
      if (target.isMounted) target.angle = startAngle + swingAngle * 0.5;
    });
    Future.delayed(const Duration(milliseconds: 150), () {
      if (target.isMounted) target.angle = startAngle;
    });
  }

  String _audioStyleFor(WeaponData w) {
    final t = w.type.toString();
    if (t.contains('rocket') || t.contains('sniper') || t.contains('crossbow')) {
      return 'heavy';
    }
    if (t.contains('laser')) return 'laser';
    return 'normal';
  }

  /// Equip a weapon picked up from the floor. The starter pistol is never
  /// replaced — new weapons go into the secondary slot.
  void equipWeapon(WeaponData weaponData) {
    secondaryWeapon = weaponData;
    secondaryAmmo = weaponData.maxAmmo;
    _refreshWeaponSprite();
    game.onStateChanged?.call();
  }

  void applyTalent(TalentData talent) {
    talents.add(talent);
    damageMultiplier *= talent.damageMultiplier;
    fireRateMultiplier *= talent.fireRateMultiplier;
    speedMultiplier *= talent.speedMultiplier;
    bulletSpeedMultiplier *= talent.bulletSpeedMultiplier;
    extraBullets += talent.extraBullets;
    spreadReduction = (spreadReduction + talent.spreadReduction).clamp(0, 0.9);

    if (talent.maxHpBonus != 0) {
      maxHp += talent.maxHpBonus;
      if (talent.maxHpBonus > 0) hp += talent.maxHpBonus;
    }

    if (talent.healAmount > 0) {
      heal(talent.healAmount);
    }

    AudioSystem.playLevelUp();

    // Spawn ascension aura (level up effect)
    game.world.add(AuraEffect(
      position: position.clone(),
      color: const Color(0xFFFFD54F),  // golden ascension
      duration: 1.5,
      maxRadius: 50,
      thickness: 3,
      particleCount: 12,
    ));
    game.world.add(AuraEffect(
      position: position.clone(),
      color: talent.color,
      duration: 1.2,
      maxRadius: 40,
      thickness: 2,
      particleCount: 8,
    ));
    // Show talent name
    game.world.add(FloatingText.buff(
      position + Vector2(0, -20),
      'LEVEL UP',
    ));
  }

  void takeDamage(double damage) {
    if (isDead) return;
    hp -= damage;

    // Show floating damage number
    game.world.add(FloatingText.playerDamage(
      position + Vector2(0, -10),
      damage,
    ));

    // Blood splat decal at feet
    final blood = Decal(
      position: position + Vector2(0, 8),
      type: DecalType.bloodSplat,
      color: const Color(0xFF7F0000),
      size_: 14,
    );
    game.world.add(blood);
    DecalManager.track(blood);

    AudioSystem.playPlayerHit();
    game.shake(6, 0.25);

    // Hurt animation flash
    if (_animComp != null && _hurtAnim != null) {
      _animComp!.animation = _hurtAnim;
      Future.delayed(const Duration(milliseconds: 200), () {
        if (!isDead && _animComp != null) {
          _animComp!.animation = _isMoving ? _walkAnim : _idleAnim;
        }
      });
    }

    if (hp <= 0) {
      hp = 0;
      isDead = true;
      game.onPlayerDeath();
    }
  }

  void heal(double amount) {
    final actualHeal = (amount).clamp(0.0, maxHp - hp);
    hp = (hp + amount).clamp(0, maxHp);

    if (actualHeal > 0) {
      // Show floating heal text
      game.world.add(FloatingText.heal(
        position + Vector2(0, -10),
        actualHeal.toDouble(),
      ));
      // Heal aura
      game.world.add(AuraEffect(
        position: position.clone(),
        color: const Color(0xFF66BB6A),
        duration: 0.8,
        maxRadius: 35,
      ));
    }
  }

  /// Trigger a buff aura effect (damage boost, speed boost etc.)
  void showBuffAura(Color color, String label) {
    game.world.add(AuraEffect(
      position: position.clone(),
      color: color,
      duration: 1.0,
      maxRadius: 40,
    ));
    game.world.add(FloatingText.buff(
      position + Vector2(0, -16),
      label,
    ));
  }

  void reset() {
    hp = 100;
    maxHp = 100;
    isDead = false;
    position = Vector2(400, 300);

    // Reset all talent modifiers
    damageMultiplier = 1.0;
    fireRateMultiplier = 1.0;
    speedMultiplier = 1.0;
    bulletSpeedMultiplier = 1.0;
    extraBullets = 0;
    spreadReduction = 0;
    talents.clear();

    // Restore default starter weapon, drop any pickup
    primaryWeapon = WeaponPool.starterPistol;
    secondaryWeapon = null;
    secondaryAmmo = 0;
    _refreshWeaponSprite();
  }

  /// Set opacity of player sprite (used by Rogue's Shadow Step).
  void setOpacity(double value) {
    final clamped = value.clamp(0.0, 1.0);
    if (_animComp != null) {
      _animComp!.opacity = clamped;
    }
    if (_weaponSprite != null) {
      _weaponSprite!.opacity = clamped;
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Enemy) {
      takeDamage(other.contactDamage);
    }
  }

  /// True if [pos] would put the player inside a wall hitbox.
  bool _collidesWithWall(Vector2 pos) {
    return game.dungeonWorld.pointInWall(pos, radius: 12);
  }
}
