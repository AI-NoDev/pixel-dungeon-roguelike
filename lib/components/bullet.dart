import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game/pixel_dungeon_game.dart';
import 'player.dart';

class Bullet extends PositionComponent
    with HasGameReference<PixelDungeonGame>, CollisionCallbacks {
  Bullet({
    required Vector2 position,
    required this.direction,
    required this.speed,
    required this.damage,
    required this.isPlayerBullet,
  }) : super(
          position: position,
          size: Vector2(8, 8),
          anchor: Anchor.center,
        );

  final Vector2 direction;
  final double speed;
  final double damage;
  final bool isPlayerBullet;
  double _lifetime = 0;
  static const double maxLifetime = 3.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final color = isPlayerBullet
        ? const Color(0xFFFFD54F)
        : const Color(0xFFEF5350);

    add(CircleComponent(
      radius: 4,
      paint: Paint()..color = color,
    ));

    add(CircleHitbox(radius: 4));
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += direction * speed * dt;
    _lifetime += dt;

    // Remove if out of bounds or too old
    if (_lifetime > maxLifetime ||
        position.x < -50 || position.x > 850 ||
        position.y < -50 || position.y > 650) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (!isPlayerBullet && other is Player) {
      other.takeDamage(damage);
      removeFromParent();
    }
    // Player bullets hitting enemies is handled in Enemy class
  }
}
