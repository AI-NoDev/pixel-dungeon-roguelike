import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game/pixel_dungeon_game.dart';
import '../data/weapons.dart';
import '../data/talents.dart';
import '../systems/preferences.dart';
import 'bullet.dart';
import 'enemy_spawner.dart';
import 'floating_text.dart';
import 'aura_effect.dart';

class Player extends PositionComponent with HasGameReference<PixelDungeonGame>, CollisionCallbacks {
  Player({required Vector2 position})
      : super(
          position: position,
          size: Vector2(32, 32),
          anchor: Anchor.center,
        );

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

  // Current weapon
  WeaponData? currentWeapon;

  // Computed stats
  double get speed => baseSpeed * speedMultiplier;
  double get attackDamage => (currentWeapon?.damage ?? baseDamage) * damageMultiplier;
  double get attackInterval => 1.0 / ((currentWeapon?.fireRate ?? baseFireRate) * fireRateMultiplier);
  double get bulletSpeed => (currentWeapon?.bulletSpeed ?? baseBulletSpeed) * bulletSpeedMultiplier;
  int get bulletsPerShot => (currentWeapon?.bulletsPerShot ?? 1) + extraBullets;
  double get spread => (currentWeapon?.spread ?? 0) * (1.0 - spreadReduction);

  // State
  Vector2 moveDirection = Vector2.zero();
  Vector2 aimDirection = Vector2(1, 0);
  double _shootTimer = 0;
  bool isShooting = false;
  bool isDead = false;

  // Talents collected
  List<TalentData> talents = [];

  // Visual
  late RectangleComponent body;
  late RectangleComponent weapon;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    body = RectangleComponent(
      size: Vector2(28, 28),
      position: Vector2(2, 2),
      paint: Paint()..color = const Color(0xFF4FC3F7),
    );
    add(body);

    weapon = RectangleComponent(
      size: Vector2(16, 4),
      position: Vector2(24, 14),
      paint: Paint()..color = const Color(0xFFFFD54F),
    );
    add(weapon);

    add(RectangleHitbox(size: Vector2(28, 28), position: Vector2(2, 2)));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isDead) return;

    // Movement
    if (moveDirection.length > 0) {
      final normalizedDir = moveDirection.normalized();
      position += normalizedDir * speed * dt;
      position.x = position.x.clamp(40, 760);
      position.y = position.y.clamp(40, 560);
    }

    // Auto-aim: only adjusts aim direction, does NOT auto-fire
    // Player still needs to hold the right stick to shoot
    if (GamePreferences.autoAim) {
      final autoTarget = _findNearestEnemy(GamePreferences.autoAimRange);
      if (autoTarget != null) {
        final autoDir = (autoTarget.position - position).normalized();
        // If player isn't manually aiming, snap to enemy
        if (!isShooting) {
          aimDirection = autoDir;
        } else {
          // Soft assist: blend manual aim toward target
          aimDirection = (aimDirection + autoDir * 0.3).normalized();
        }
      }
    }

    // Shooting only when player explicitly fires
    _shootTimer += dt;
    if (isShooting && _shootTimer >= attackInterval) {
      _shoot();
      _shootTimer = 0;
    }

    // Update weapon visual
    if (aimDirection.length > 0) {
      final angle = atan2(aimDirection.y, aimDirection.x);
      weapon.angle = angle;
      weapon.position = Vector2(
        16 + cos(angle) * 12,
        16 + sin(angle) * 12 - 2,
      );
    }
  }

  Enemy? _findNearestEnemy(double maxRange) {
    Enemy? nearest;
    double nearestDist = maxRange;
    for (final c in game.world.children) {
      if (c is Enemy && !c.isDead) {
        final d = c.position.distanceTo(position);
        if (d < nearestDist) {
          nearestDist = d;
          nearest = c;
        }
      }
    }
    return nearest;
  }

  void _shoot() {
    if (aimDirection.length == 0) return;

    final baseAngle = atan2(aimDirection.y, aimDirection.x);

    // Roll critical hit per shot (10% base chance, can be modified by talents later)
    final isCritical = Random().nextDouble() < critChance;
    final critMultiplier = isCritical ? 2.0 : 1.0;

    for (int i = 0; i < bulletsPerShot; i++) {
      double angle = baseAngle;

      if (bulletsPerShot > 1) {
        // Spread bullets evenly
        final totalSpread = spread > 0 ? spread : 0.3;
        angle = baseAngle - totalSpread / 2 + (totalSpread / (bulletsPerShot - 1)) * i;
      }

      final bulletDir = Vector2(cos(angle), sin(angle));
      final bulletPos = position + bulletDir * 20;

      final bullet = Bullet(
        position: bulletPos,
        direction: bulletDir,
        speed: bulletSpeed,
        damage: attackDamage * critMultiplier,
        isPlayerBullet: true,
        color: currentWeapon?.color ?? const Color(0xFFFFD54F),
        element: currentWeapon?.element ?? ElementType.none,
        isCritical: isCritical,
      );

      game.world.add(bullet);
    }
  }

  void equipWeapon(WeaponData weaponData) {
    currentWeapon = weaponData;
    // Update weapon visual color
    weapon.paint.color = weaponData.color;
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

    body.paint.color = const Color(0xFFFF5252);
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!isDead) body.paint.color = const Color(0xFF4FC3F7);
    });

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
    body.paint.color = const Color(0xFF4FC3F7);
    weapon.paint.color = const Color(0xFFFFD54F);

    // Reset all talent modifiers
    damageMultiplier = 1.0;
    fireRateMultiplier = 1.0;
    speedMultiplier = 1.0;
    bulletSpeedMultiplier = 1.0;
    extraBullets = 0;
    spreadReduction = 0;
    talents.clear();
    currentWeapon = null;
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Enemy) {
      takeDamage(other.contactDamage);
    }
  }
}
