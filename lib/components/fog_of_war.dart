import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../data/dungeon_map.dart';
import '../game/pixel_dungeon_game.dart';

/// Renders dark fog over rooms the player hasn't visited yet.
/// Uses world coordinates so fog scrolls with the camera.
/// Once a room is visited it stays revealed (lighter fog or none).
class FogOfWar extends PositionComponent
    with HasGameReference<PixelDungeonGame> {
  FogOfWar({required this.map}) : super(priority: 100);

  final DungeonMap map;
  final Paint _unvisitedPaint = Paint()
    ..color = const Color(0xFF000000).withValues(alpha: 0.95);

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Cover unvisited rooms with thick black
    for (final room in map.rooms) {
      if (!room.visited) {
        final r = Rect.fromLTWH(
          room.worldPosition.x,
          room.worldPosition.y,
          room.size.x,
          room.size.y,
        );
        canvas.drawRect(r, _unvisitedPaint);
      }
    }
  }
}
