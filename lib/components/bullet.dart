import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import '../game/pixel_dungeon_game.dart';
import '../data/weapons.dart';
import 'player.dart';

class Bullet extends PositionComponent
    with HasGameReference<PixelDungeonGame>, CollisionCallbacks {
  Bullet({
    required Vector2 position,
    required this.direction,
    required this.speed,
    required this.damage,
    required this.isPlayerBullet,
    this.color = const Color(0xFFFFD54F),
    this.element = ElementType.none,
    this.isCritical = false,
  }) : super(
          position: position,
          size: Vector2(16, 16),
          anchor: Anchor.center,
        );

  final Vector2 direction;
  final double speed;
  final double damage;
  final bool isPlayerBullet;
  final Color color;
  final ElementType element;
  final bool isCritical;
  double _lifetime = 0;
  static const double maxLifetime = 3.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    try {
      // Choose sprite based on element / origin
      final spriteName = _getSpriteName();
      final image = await game.images.load('bullets/$spriteName.png');
      final frameCount = image.width ~/ 8; // bullets are 8px wide

      if (frameCount > 1) {
        // Animated bullet
        final spriteSheet = SpriteSheet(
          image: image,
          srcSize: Vector2.all(8),
        );
        final anim = spriteSheet.createAnimation(
          row: 0,
          stepTime: 0.08,
          to: frameCount,
          loop: true,
        );
        add(SpriteAnimationComponent(
          animation: anim,
          size: Vector2.all(16),
          anchor: Anchor.center,
          position: Vector2.all(8),
        ));
      } else {
        // Static bullet
        final sprite = Sprite(image);
        add(SpriteComponent(
          sprite: sprite,
          size: Vector2.all(16),
          anchor: Anchor.center,
          position: Vector2.all(8),
        ));
      }
    } catch (_) {
      // Fallback: colored circle
      final bulletColor = isPlayerBullet ? color : const Color(0xFFEF5350);
      add(CircleComponent(
        radius: 4,
        paint: Paint()..color = bulletColor,
        position: Vector2.all(4),
      ));
    }

    add(CircleHitbox(radius: 4, position: Vector2.all(4)));
  }

  String _getSpriteName() {
    if (!isPlayerBullet) return 'bullet_enemy';
    switch (element) {
      case ElementType.fire:
        return 'bullet_fire';
      case ElementType.ice:
        return 'bullet_ice';
      case ElementType.lightning:
        return 'bullet_lightning';
      case ElementType.poison:
        return 'bullet_poison';
      case ElementType.holy:
        return 'bullet_holy';
      case ElementType.dark:
        return 'bullet_dark';
      case ElementType.none:
        return 'bullet_basic';
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += direction * speed * dt;
    _lifetime += dt;

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
  }
}
