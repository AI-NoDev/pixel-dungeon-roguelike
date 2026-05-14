import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game/pixel_dungeon_game.dart';
import '../data/items.dart';
import 'player.dart';

/// Dropped item that player can pick up by walking over
class ItemDrop extends PositionComponent
    with HasGameReference<PixelDungeonGame>, CollisionCallbacks {
  ItemDrop({required Vector2 position, required this.itemData})
      : super(
          position: position,
          size: Vector2(16, 16),
          anchor: Anchor.center,
        );

  final ItemData itemData;
  double _bobTimer = 0;
  double _startY = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _startY = position.y;

    // Item visual
    add(CircleComponent(
      radius: 7,
      paint: Paint()..color = itemData.color.withValues(alpha: 0.8),
    ));

    // Inner glow
    add(CircleComponent(
      radius: 4,
      position: Vector2(3, 3),
      paint: Paint()..color = itemData.color,
    ));

    // Pickup hitbox (slightly larger for easier pickup)
    add(CircleHitbox(radius: 12));
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Bobbing animation
    _bobTimer += dt * 3;
    position.y = _startY + sin(_bobTimer) * 3;
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Player) {
      _applyItem();
      removeFromParent();
    }
  }

  void _applyItem() {
    switch (itemData.type) {
      case ItemType.healthPotion:
        game.player.heal(itemData.value);
        break;
      case ItemType.coin:
        game.gameState.gold += itemData.value.toInt();
        break;
      case ItemType.speedBoost:
        game.player.speedMultiplier *= (1 + itemData.value);
        break;
      case ItemType.damageBoost:
        game.player.damageMultiplier *= (1 + itemData.value);
        break;
      case ItemType.shield:
        // TODO: implement shield mechanic
        game.player.heal(20);
        break;
      case ItemType.key:
        // TODO: implement key mechanic
        break;
    }
  }
}

/// Spawns item drops from enemy deaths
class ItemDropSystem {
  static void trySpawnDrop(PixelDungeonGame game, Vector2 position) {
    final item = ItemData.getRandomDrop(dropChance: 0.35);
    if (item != null) {
      final drop = ItemDrop(position: position, itemData: item);
      game.world.add(drop);
    }
  }
}
