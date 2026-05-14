import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game/pixel_dungeon_game.dart';
import '../data/boss_data.dart';
import 'bullet.dart';
import 'player.dart';

class BossEnemy extends PositionComponent
    with HasGameReference<PixelDungeonGame>, CollisionCallbacks {
  BossEnemy({required Vector2 position, required this.data})
      : hp = data.hp,
        maxHp = data.hp,
        currentSpeed = data.speed,
        currentShootInterval = data.shootInterval,
        super(
          position: position,
          size: Vector2(data.size, data.size),
          anchor: Anchor.center,
        );

  final BossData data;
  double hp;
  double maxHp;
  double currentSpeed;
  double currentShootInterval;
  bool isDead = false;

  double _shootTimer = 0;
  double _patternTimer = 0;
  int _currentPhaseIndex = 0;
  BossAttackPattern _currentPattern = BossAttackPattern.radial;

  late RectangleComponent body;
  late RectangleComponent hpBarBg;
  late RectangleComponent hpBarFill;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Boss body
    body = RectangleComponent(
      size: Vector2(data.size - 4, data.size - 4),
      position: Vector2(2, 2),
      paint: Paint()..color = data.color,
    );
    add(body);

    // Inner detail
    add(RectangleComponent(
      size: Vector2(data.size * 0.5, data.size * 0.5),
      position: Vector2(data.size * 0.25, data.size * 0.25),
      paint: Paint()..color = data.color.withValues(alpha: 0.5),
    ));

    // Hitbox
    add(RectangleHitbox(
      size: Vector2(data.size - 4, data.size - 4),
      position: Vector2(2, 2),
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isDead) return;

    // Check phase transitions
    _updatePhase();

    // Movement - chase player but keep some distance
    final player = game.player;
    final direction = player.position - position;
    final distance = direction.length;

    if (distance > 120) {
      position += direction.normalized() * currentSpeed * dt;
    } else if (distance < 80) {
      // Back away if too close
      position -= direction.normalized() * currentSpeed * 0.5 * dt;
    }

    // Clamp to room bounds
    position.x = position.x.clamp(50, 750);
    position.y = position.y.clamp(50, 550);

    // Attack patterns
    _shootTimer += dt;
    _patternTimer += dt;

    // Switch attack pattern every 4 seconds
    if (_patternTimer > 4.0) {
      _patternTimer = 0;
      _currentPattern = BossAttackPattern
          .values[Random().nextInt(BossAttackPattern.values.length)];
    }

    if (_shootTimer >= currentShootInterval) {
      _executeAttack();
      _shootTimer = 0;
    }
  }

  void _updatePhase() {
    final hpPercent = hp / maxHp;
    for (int i = data.phases.length - 1; i >= 0; i--) {
      if (hpPercent <= data.phases[i].hpThreshold && i > _currentPhaseIndex) {
        _currentPhaseIndex = i;
        currentSpeed = data.speed * data.phases[i].speedMultiplier;
        currentShootInterval =
            data.shootInterval / data.phases[i].fireRateMultiplier;

        // Flash on phase change
        body.paint.color = Colors.white;
        Future.delayed(const Duration(milliseconds: 200), () {
          if (!isDead) body.paint.color = data.color;
        });
        break;
      }
    }
  }

  void _executeAttack() {
    switch (_currentPattern) {
      case BossAttackPattern.radial:
        _shootRadial();
        break;
      case BossAttackPattern.aimed:
        _shootAimed();
        break;
      case BossAttackPattern.spiral:
        _shootSpiral();
        break;
      case BossAttackPattern.burst:
        _shootBurst();
        break;
    }
  }

  void _shootRadial() {
    // Shoot bullets in all directions
    final count = data.bulletCount;
    for (int i = 0; i < count; i++) {
      final angle = (2 * pi / count) * i;
      _fireBullet(Vector2(cos(angle), sin(angle)));
    }
  }

  void _shootAimed() {
    // Shoot directly at player with some spread
    final player = game.player;
    final baseDir = (player.position - position).normalized();
    final baseAngle = atan2(baseDir.y, baseDir.x);

    for (int i = 0; i < 5; i++) {
      final angle = baseAngle - 0.3 + (0.6 / 4) * i;
      _fireBullet(Vector2(cos(angle), sin(angle)));
    }
  }

  void _shootSpiral() {
    // Rotating spiral pattern
    final baseAngle = _patternTimer * 3;
    for (int i = 0; i < 4; i++) {
      final angle = baseAngle + (pi / 2) * i;
      _fireBullet(Vector2(cos(angle), sin(angle)));
    }
  }

  void _shootBurst() {
    // Quick burst of bullets at player
    final player = game.player;
    final dir = (player.position - position).normalized();
    for (int i = 0; i < 3; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (!isDead && isMounted) {
          _fireBullet(dir);
        }
      });
    }
  }

  void _fireBullet(Vector2 direction) {
    final bullet = Bullet(
      position: position + direction * (data.size / 2 + 5),
      direction: direction,
      speed: 200,
      damage: data.bulletDamage,
      isPlayerBullet: false,
      color: data.color.withValues(alpha: 0.8),
    );
    game.world.add(bullet);
  }

  void takeDamage(double damage) {
    if (isDead) return;
    hp -= damage;

    body.paint.color = Colors.white;
    Future.delayed(const Duration(milliseconds: 60), () {
      if (!isDead) body.paint.color = data.color;
    });

    if (hp <= 0) {
      hp = 0;
      isDead = true;
      _onDeath();
    }
  }

  void _onDeath() {
    game.gameState.enemiesKilled++;
    game.gameState.gold += 100 + data.hp.toInt() ~/ 10;
    removeFromParent();
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Bullet && other.isPlayerBullet) {
      takeDamage(other.damage);
      other.removeFromParent();
    }
    if (other is Player) {
      other.takeDamage(data.contactDamage);
    }
  }
}

enum BossAttackPattern { radial, aimed, spiral, burst }
