import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../data/talents.dart';
import '../game/pixel_dungeon_game.dart';
import 'player.dart';

/// A talent scroll that drops on the ground. Walking near it shows a prompt;
/// closer interaction picks it up and triggers the talent picker UI.
class TalentPickup extends PositionComponent
    with HasGameReference<PixelDungeonGame>, CollisionCallbacks {
  TalentPickup({required Vector2 position, required this.choices})
      : super(
          position: position,
          size: Vector2(20, 20),
          anchor: Anchor.center,
        );

  final List<TalentData> choices;
  double _bobTimer = 0;
  double _baseY = 0;
  bool _consumed = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _baseY = position.y;

    // Glowing scroll/orb
    add(CircleComponent(
      radius: 9,
      paint: Paint()..color = const Color(0xFFFFD54F).withValues(alpha: 0.4),
    ));
    add(CircleComponent(
      radius: 6,
      position: Vector2.all(3),
      paint: Paint()..color = const Color(0xFFFFD700),
    ));
    add(CircleComponent(
      radius: 3,
      position: Vector2.all(6),
      paint: Paint()..color = const Color(0xFFFFFFFF),
    ));

    add(CircleHitbox(radius: 14));
  }

  @override
  void update(double dt) {
    super.update(dt);
    _bobTimer += dt * 3;
    position.y = _baseY + sin(_bobTimer) * 3;
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Player && !_consumed) {
      _consumed = true;
      // Trigger talent picker
      game.pendingTalentChoices = choices;
      game.onShowTalentPicker?.call();
      game.pauseEngine();
      removeFromParent();
    }
  }
}
