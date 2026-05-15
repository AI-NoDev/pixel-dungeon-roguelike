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
    ..color = const Color(0xFF000000).withValues(alpha: 0.92);
  final Paint _corridorFogPaint = Paint()
    ..color = const Color(0xFF000000).withValues(alpha: 0.92);

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

    // Cover corridors that connect two unvisited rooms
    for (final corridor in map.corridors) {
      final a = map.getRoom(corridor.roomA);
      final b = map.getRoom(corridor.roomB);
      // If neither room is visited, fog the corridor
      if (!a.visited && !b.visited) {
        _fogCorridor(canvas, a, b);
      }
    }
  }

  void _fogCorridor(Canvas canvas, RoomNode a, RoomNode b) {
    final dx = b.gridX - a.gridX;
    final cw = 80.0;
    final wt = 20.0;

    if (dx != 0) {
      final left = a.center.x < b.center.x ? a : b;
      final right = a.center.x < b.center.x ? b : a;
      final startX = left.worldPosition.x + left.size.x;
      final endX = right.worldPosition.x;
      final centerY = (left.center.y + right.center.y) / 2;
      final width = endX - startX;
      if (width > 0) {
        canvas.drawRect(
          Rect.fromLTWH(startX, centerY - cw / 2 - wt, width, cw + wt * 2),
          _corridorFogPaint,
        );
      }
    } else {
      final top = a.center.y < b.center.y ? a : b;
      final bot = a.center.y < b.center.y ? b : a;
      final startY = top.worldPosition.y + top.size.y;
      final endY = bot.worldPosition.y;
      final centerX = (top.center.x + bot.center.x) / 2;
      final height = endY - startY;
      if (height > 0) {
        canvas.drawRect(
          Rect.fromLTWH(centerX - cw / 2 - wt, startY, cw + wt * 2, height),
          _corridorFogPaint,
        );
      }
    }
  }
}
