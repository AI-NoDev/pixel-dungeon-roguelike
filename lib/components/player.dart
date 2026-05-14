import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game/pixel_dungeon_game.dart';
import 'bullet.dart';
import 'enemy_spawner.dart';

class Player extends PositionComponent with HasGameReference<PixelDungeonGame>, CollisionCallbacks {
  Player({required Vector2 position})
      : super(
          position: position,
          size: Vector2(32, 32),
          anchor: Anchor.center,
        );

  // Stats
  double maxHp = 100;
  double hp = 100;
  double speed = 150;
  double attackDamage = 20;
  double attackSpeed = 0.3; // seconds between shots
  double bulletSpeed = 300;

  // State
  Vector2 moveDirection = Vector2.zero();
  Vector2 aimDirection = Vector2(1, 0);
  double _shootTimer = 0;
  bool isShooting = false;
  bool isDead = false;

  // Visual
  late RectangleComponent body;
  late RectangleComponent weapon;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Player body (pixel art placeholder - blue square with details)
    body = RectangleComponent(
      size: Vector2(28, 28),
      position: Vector2(2, 2),
      paint: Paint()..color = const Color(0xFF4FC3F7),
    );
    add(body);

    // Weapon indicator
    weapon = RectangleComponent(
      size: Vector2(16, 4),
      position: Vector2(24, 14),
      paint: Paint()..color = const Color(0xFFFFD54F),
    );
    add(weapon);

    // Collision hitbox
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

      // Clamp to room bounds (with padding)
      position.x = position.x.clamp(40, 760);
      position.y = position.y.clamp(40, 560);
    }

    // Shooting
    _shootTimer += dt;
    if (isShooting && _shootTimer >= attackSpeed) {
      _shoot();
      _shootTimer = 0;
    }

    // Update weapon rotation to face aim direction
    if (aimDirection.length > 0) {
      final angle = atan2(aimDirection.y, aimDirection.x);
      weapon.angle = angle;
      weapon.position = Vector2(
        16 + cos(angle) * 12,
        16 + sin(angle) * 12 - 2,
      );
    }
  }

  void _shoot() {
    if (aimDirection.length == 0) return;

    final bulletDir = aimDirection.normalized();
    final bulletPos = position + bulletDir * 20;

    final bullet = Bullet(
      position: bulletPos,
      direction: bulletDir,
      speed: bulletSpeed,
      damage: attackDamage,
      isPlayerBullet: true,
    );

    game.world.add(bullet);
  }

  void takeDamage(double damage) {
    if (isDead) return;
    hp -= damage;

    // Flash red
    body.paint.color = const Color(0xFFFF5252);
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!isDead) {
        body.paint.color = const Color(0xFF4FC3F7);
      }
    });

    if (hp <= 0) {
      hp = 0;
      isDead = true;
      game.onPlayerDeath();
    }
  }

  void heal(double amount) {
    hp = (hp + amount).clamp(0, maxHp);
  }

  void reset() {
    hp = maxHp;
    isDead = false;
    position = Vector2(400, 300);
    body.paint.color = const Color(0xFF4FC3F7);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Enemy) {
      takeDamage(other.contactDamage);
    }
  }
}
