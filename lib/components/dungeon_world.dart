import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../data/dungeon_map.dart';
import '../data/dungeon_theme.dart';
import '../data/floor_config.dart';
import '../game/pixel_dungeon_game.dart';

/// Renders the entire dungeon (all rooms + corridors) in world space.
/// Each room and corridor is drawn at its world position so the camera can
/// roam between them. Walls block bullets via collision hitboxes.
class DungeonWorld extends PositionComponent
    with HasGameReference<PixelDungeonGame> {
  DungeonWorld({required this.map, required this.theme});

  final DungeonMap map;
  final DungeonTheme theme;

  static const double wallThickness = 20;
  static const double corridorWidth = 80;
  static const double doorWidth = 60;

  final List<RoomVisual> roomVisuals = [];
  final List<CorridorVisual> corridorVisuals = [];

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _buildRooms();
    _buildCorridors();
  }

  void _buildRooms() {
    for (final room in map.rooms) {
      final visual = RoomVisual(node: room, theme: theme);
      add(visual);
      roomVisuals.add(visual);
    }
  }

  void _buildCorridors() {
    for (final corridor in map.corridors) {
      final a = map.getRoom(corridor.roomA);
      final b = map.getRoom(corridor.roomB);
      final visual = CorridorVisual(
        roomA: a,
        roomB: b,
        theme: theme,
      );
      add(visual);
      corridorVisuals.add(visual);
    }
  }

  /// Find which room contains a world position.
  RoomNode? roomAt(Vector2 worldPos) {
    for (final room in map.rooms) {
      final r = Rect.fromLTWH(
        room.worldPosition.x,
        room.worldPosition.y,
        room.size.x,
        room.size.y,
      );
      if (r.contains(Offset(worldPos.x, worldPos.y))) {
        return room;
      }
    }
    return null;
  }
}

/// Visual representation of a single room (floor + walls).
class RoomVisual extends PositionComponent
    with HasGameReference<PixelDungeonGame> {
  RoomVisual({required this.node, required this.theme})
      : super(
          position: node.worldPosition,
          size: node.size,
        );

  final RoomNode node;
  final DungeonTheme theme;

  late RectangleComponent floor;
  final Random _rng = Random();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Floor
    floor = RectangleComponent(
      size: size,
      paint: Paint()..color = theme.floorColor,
    );
    add(floor);

    // Subtle grid pattern for floor texture
    _addFloorTiles();

    // Walls (will be cut where corridors connect)
    _buildWalls();
  }

  void _addFloorTiles() {
    final tileSize = 40.0;
    final tilePaint = Paint()
      ..color = theme.accentColor.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (double x = 0; x < size.x; x += tileSize) {
      for (double y = 0; y < size.y; y += tileSize) {
        add(RectangleComponent(
          size: Vector2(tileSize, tileSize),
          position: Vector2(x, y),
          paint: tilePaint,
        ));
      }
    }
  }

  void _buildWalls() {
    final wallPaint = Paint()..color = theme.wallColor;
    final t = DungeonWorld.wallThickness;
    // Top wall
    add(WallSegment(
      size: Vector2(size.x, t),
      position: Vector2.zero(),
      paint: wallPaint,
    ));
    // Bottom wall
    add(WallSegment(
      size: Vector2(size.x, t),
      position: Vector2(0, size.y - t),
      paint: wallPaint,
    ));
    // Left wall
    add(WallSegment(
      size: Vector2(t, size.y),
      position: Vector2.zero(),
      paint: wallPaint,
    ));
    // Right wall
    add(WallSegment(
      size: Vector2(t, size.y),
      position: Vector2(size.x - t, 0),
      paint: wallPaint,
    ));
  }
}

/// Corridor between two rooms. Drawn as a path.
class CorridorVisual extends PositionComponent
    with HasGameReference<PixelDungeonGame> {
  CorridorVisual({
    required this.roomA,
    required this.roomB,
    required this.theme,
  });

  final RoomNode roomA;
  final RoomNode roomB;
  final DungeonTheme theme;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final centerA = roomA.center;
    final centerB = roomB.center;

    final dx = (roomB.gridX - roomA.gridX);
    final dy = (roomB.gridY - roomA.gridY);

    if (dx != 0) {
      // Horizontal corridor
      _buildHorizontalCorridor(centerA, centerB);
    } else {
      // Vertical corridor
      _buildVerticalCorridor(centerA, centerB);
    }
  }

  void _buildHorizontalCorridor(Vector2 centerA, Vector2 centerB) {
    final left = centerA.x < centerB.x ? roomA : roomB;
    final right = centerA.x < centerB.x ? roomB : roomA;
    final startX = left.worldPosition.x + left.size.x;
    final endX = right.worldPosition.x;
    final centerY = (left.center.y + right.center.y) / 2;
    final width = endX - startX;
    if (width <= 0) return;

    // Floor
    add(RectangleComponent(
      size: Vector2(width, DungeonWorld.corridorWidth),
      position: Vector2(startX, centerY - DungeonWorld.corridorWidth / 2),
      paint: Paint()..color = theme.floorColor,
    ));
    // Top wall
    add(WallSegment(
      size: Vector2(width, DungeonWorld.wallThickness),
      position: Vector2(startX, centerY - DungeonWorld.corridorWidth / 2 - DungeonWorld.wallThickness),
      paint: Paint()..color = theme.wallColor,
    ));
    // Bottom wall
    add(WallSegment(
      size: Vector2(width, DungeonWorld.wallThickness),
      position: Vector2(startX, centerY + DungeonWorld.corridorWidth / 2),
      paint: Paint()..color = theme.wallColor,
    ));
  }

  void _buildVerticalCorridor(Vector2 centerA, Vector2 centerB) {
    final top = centerA.y < centerB.y ? roomA : roomB;
    final bot = centerA.y < centerB.y ? roomB : roomA;
    final startY = top.worldPosition.y + top.size.y;
    final endY = bot.worldPosition.y;
    final centerX = (top.center.x + bot.center.x) / 2;
    final height = endY - startY;
    if (height <= 0) return;

    add(RectangleComponent(
      size: Vector2(DungeonWorld.corridorWidth, height),
      position: Vector2(centerX - DungeonWorld.corridorWidth / 2, startY),
      paint: Paint()..color = theme.floorColor,
    ));
    add(WallSegment(
      size: Vector2(DungeonWorld.wallThickness, height),
      position: Vector2(centerX - DungeonWorld.corridorWidth / 2 - DungeonWorld.wallThickness, startY),
      paint: Paint()..color = theme.wallColor,
    ));
    add(WallSegment(
      size: Vector2(DungeonWorld.wallThickness, height),
      position: Vector2(centerX + DungeonWorld.corridorWidth / 2, startY),
      paint: Paint()..color = theme.wallColor,
    ));
  }
}

/// A wall segment that blocks bullets and the player.
class WallSegment extends RectangleComponent with CollisionCallbacks {
  WallSegment({
    required super.size,
    required super.position,
    required super.paint,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }
}
