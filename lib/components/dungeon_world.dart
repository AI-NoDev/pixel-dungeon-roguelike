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

  /// Cached absolute wall rectangles (computed once after build).
  final List<Rect> wallRects = [];

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _buildRooms();
    _buildCorridors();
    // Defer wall rect collection one tick so children mount and
    // toAbsoluteRect returns valid values.
    Future.microtask(_collectWallRects);
  }

  void _collectWallRects() {
    wallRects.clear();
    void walk(Component c) {
      if (c is WallSegment) {
        wallRects.add(c.toAbsoluteRect());
      }
      for (final ch in c.children) {
        walk(ch);
      }
    }
    walk(this);
  }

  /// True if [rect] overlaps any wall.
  bool overlapsWall(Rect rect) {
    for (final w in wallRects) {
      if (w.overlaps(rect)) return true;
    }
    return false;
  }

  /// True if a small probe at [pos] is inside a wall.
  bool pointInWall(Vector2 pos, {double radius = 12}) {
    final r = Rect.fromCircle(center: Offset(pos.x, pos.y), radius: radius);
    return overlapsWall(r);
  }

  void _buildRooms() {
    for (final room in map.rooms) {
      // Compute door cutouts for this room based on corridors.
      final doors = _doorsForRoom(room);
      final visual = RoomVisual(node: room, theme: theme, doors: doors);
      add(visual);
      roomVisuals.add(visual);
    }
  }

  /// For each side of [room], compute door (start, end) range in local coords,
  /// or null if no door on that side.
  Map<RoomSide, _DoorRange?> _doorsForRoom(RoomNode room) {
    final result = <RoomSide, _DoorRange?>{
      RoomSide.top: null,
      RoomSide.bottom: null,
      RoomSide.left: null,
      RoomSide.right: null,
    };

    for (final c in map.corridorsFor(room.id)) {
      final other = map.getRoom(c.roomA == room.id ? c.roomB : c.roomA);
      final dx = other.gridX - room.gridX;
      final dy = other.gridY - room.gridY;

      if (dx > 0) {
        // Door on right wall, in local Y coords
        final centerY = (room.center.y + other.center.y) / 2 - room.worldPosition.y;
        result[RoomSide.right] = _DoorRange(
          start: centerY - corridorWidth / 2,
          end: centerY + corridorWidth / 2,
        );
      } else if (dx < 0) {
        final centerY = (room.center.y + other.center.y) / 2 - room.worldPosition.y;
        result[RoomSide.left] = _DoorRange(
          start: centerY - corridorWidth / 2,
          end: centerY + corridorWidth / 2,
        );
      } else if (dy > 0) {
        // Door on bottom wall, in local X coords
        final centerX = (room.center.x + other.center.x) / 2 - room.worldPosition.x;
        result[RoomSide.bottom] = _DoorRange(
          start: centerX - corridorWidth / 2,
          end: centerX + corridorWidth / 2,
        );
      } else if (dy < 0) {
        final centerX = (room.center.x + other.center.x) / 2 - room.worldPosition.x;
        result[RoomSide.top] = _DoorRange(
          start: centerX - corridorWidth / 2,
          end: centerX + corridorWidth / 2,
        );
      }
    }

    return result;
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

enum RoomSide { top, bottom, left, right }

class _DoorRange {
  _DoorRange({required this.start, required this.end});
  final double start;
  final double end;
}

/// Visual representation of a single room (floor + walls).
class RoomVisual extends PositionComponent
    with HasGameReference<PixelDungeonGame> {
  RoomVisual({required this.node, required this.theme, required this.doors})
      : super(
          position: node.worldPosition,
          size: node.size,
        );

  final RoomNode node;
  final DungeonTheme theme;
  final Map<RoomSide, _DoorRange?> doors;

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

    // Horizontal wall builder (top or bottom). Splits the wall around any
    // door cutout to leave the corridor open.
    void buildHorizontal(double y, _DoorRange? door) {
      if (door == null) {
        add(WallSegment(
          size: Vector2(size.x, t),
          position: Vector2(0, y),
          paint: wallPaint,
        ));
        return;
      }
      // Left segment
      if (door.start > 0) {
        add(WallSegment(
          size: Vector2(door.start, t),
          position: Vector2(0, y),
          paint: wallPaint,
        ));
      }
      // Right segment
      if (door.end < size.x) {
        add(WallSegment(
          size: Vector2(size.x - door.end, t),
          position: Vector2(door.end, y),
          paint: wallPaint,
        ));
      }
    }

    // Vertical wall builder (left or right).
    void buildVertical(double x, _DoorRange? door) {
      if (door == null) {
        add(WallSegment(
          size: Vector2(t, size.y),
          position: Vector2(x, 0),
          paint: wallPaint,
        ));
        return;
      }
      // Top segment
      if (door.start > 0) {
        add(WallSegment(
          size: Vector2(t, door.start),
          position: Vector2(x, 0),
          paint: wallPaint,
        ));
      }
      // Bottom segment
      if (door.end < size.y) {
        add(WallSegment(
          size: Vector2(t, size.y - door.end),
          position: Vector2(x, door.end),
          paint: wallPaint,
        ));
      }
    }

    buildHorizontal(0, doors[RoomSide.top]);
    buildHorizontal(size.y - t, doors[RoomSide.bottom]);
    buildVertical(0, doors[RoomSide.left]);
    buildVertical(size.x - t, doors[RoomSide.right]);
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
