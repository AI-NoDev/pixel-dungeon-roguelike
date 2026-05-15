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

  /// Cached absolute wall rectangles. Populated on first access.
  final List<Rect> wallRects = [];
  bool _wallsCollected = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _buildRooms();
    _buildCorridors();
  }

  /// Walk the world tree and collect every wall rect. Cheap (~50 entries).
  /// Called lazily because room+corridor children mount during their own
  /// onLoad which runs after our buildRooms / buildCorridors.
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
    _wallsCollected = true;
  }

  void _ensureWallsCollected() {
    if (_wallsCollected && wallRects.isNotEmpty) return;
    _collectWallRects();
  }

  /// True if [rect] overlaps any wall.
  bool overlapsWall(Rect rect) {
    _ensureWallsCollected();
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

  /// Find which room contains a world position. Also checks corridors —
  /// if the player is in a corridor, returns the nearest connected room.
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
    // Not in any room — might be in a corridor. Return null (keep current room).
    return null;
  }
}

enum RoomSide { top, bottom, left, right }

class _DoorRange {
  _DoorRange({required this.start, required this.end});
  final double start;
  final double end;
}

/// Visual representation of a single room as an organic slime cavern.
/// Renders irregular cave walls, moss, puddles, stalactites — not a grid.
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

  final Random _rng = Random();

  // Pre-computed cave shape
  late final Path _floorPath;
  late final Path _wallEdgePath;
  late final Paint _floorPaint;
  late final Paint _bgPaint;
  late final Paint _wallPaint;
  late final Paint _edgePaint;
  late final Paint _mossPaint;
  late final Paint _puddlePaint;
  late final List<Offset> _mossSpots;
  late final List<Offset> _puddleSpots;
  late final List<_Stalactite> _stalactites;
  late final List<Offset> _noiseSpots;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _bgPaint = Paint()..color = theme.backgroundColor;
    _floorPaint = Paint()..color = theme.floorColor;
    _wallPaint = Paint()..color = theme.wallColor;
    _edgePaint = Paint()
      ..color = theme.wallColor.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    _mossPaint = Paint()..color = const Color(0xFF2E7D32).withValues(alpha: 0.25);
    _puddlePaint = Paint()..color = const Color(0xFF66BB6A).withValues(alpha: 0.18);

    _generateCaveShape();
    _generateDetails();
    await _addDecor();
    _buildWalls();
  }

  void _generateCaveShape() {
    final w = size.x;
    final h = size.y;
    final margin = 28.0;
    final points = <Offset>[];

    // Walk around perimeter with random insets for organic edges.
    for (double x = margin; x < w - margin; x += 25 + _rng.nextDouble() * 20) {
      points.add(Offset(x, margin + _rng.nextDouble() * 12));
    }
    for (double y = margin; y < h - margin; y += 25 + _rng.nextDouble() * 20) {
      points.add(Offset(w - margin - _rng.nextDouble() * 12, y));
    }
    for (double x = w - margin; x > margin; x -= 25 + _rng.nextDouble() * 20) {
      points.add(Offset(x, h - margin - _rng.nextDouble() * 12));
    }
    for (double y = h - margin; y > margin; y -= 25 + _rng.nextDouble() * 20) {
      points.add(Offset(margin + _rng.nextDouble() * 12, y));
    }

    _floorPath = Path();
    if (points.isNotEmpty) {
      _floorPath.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        final prev = points[i - 1];
        final curr = points[i];
        _floorPath.quadraticBezierTo(
          prev.dx, prev.dy,
          (prev.dx + curr.dx) / 2, (prev.dy + curr.dy) / 2,
        );
      }
      _floorPath.close();
    }

    // Slightly larger wall edge
    final cx = w / 2, cy = h / 2;
    _wallEdgePath = Path();
    final wallPts = points.map((p) {
      final dx = p.dx - cx;
      final dy = p.dy - cy;
      final s = 1.06 + _rng.nextDouble() * 0.03;
      return Offset(cx + dx * s, cy + dy * s);
    }).toList();
    if (wallPts.isNotEmpty) {
      _wallEdgePath.moveTo(wallPts.first.dx, wallPts.first.dy);
      for (int i = 1; i < wallPts.length; i++) {
        final prev = wallPts[i - 1];
        final curr = wallPts[i];
        _wallEdgePath.quadraticBezierTo(
          prev.dx, prev.dy,
          (prev.dx + curr.dx) / 2, (prev.dy + curr.dy) / 2,
        );
      }
      _wallEdgePath.close();
    }
  }

  void _generateDetails() {
    _mossSpots = List.generate(3 + _rng.nextInt(3), (_) => Offset(
      60 + _rng.nextDouble() * (size.x - 120),
      60 + _rng.nextDouble() * (size.y - 120),
    ));
    _puddleSpots = List.generate(1 + _rng.nextInt(3), (_) => Offset(
      80 + _rng.nextDouble() * (size.x - 160),
      80 + _rng.nextDouble() * (size.y - 160),
    ));
    _stalactites = List.generate(2 + _rng.nextInt(3), (_) => _Stalactite(
      x: 50 + _rng.nextDouble() * (size.x - 100),
      length: 12 + _rng.nextDouble() * 20,
      width: 3 + _rng.nextDouble() * 3,
    ));
    // Deterministic noise dots (no per-frame random)
    _noiseSpots = List.generate(30, (i) => Offset(
      40 + ((i * 37 + i * i * 7) % (size.x - 80).toInt()).toDouble(),
      40 + ((i * 53 + i * i * 3) % (size.y - 80).toInt()).toDouble(),
    ));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Dark cave void background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), _bgPaint);

    // Rocky wall border
    canvas.drawPath(_wallEdgePath, _wallPaint);

    // Cave floor (organic shape)
    canvas.drawPath(_floorPath, _floorPaint);

    // Subtle floor noise
    final noisePaint = Paint()..color = theme.accentColor.withValues(alpha: 0.04);
    for (final spot in _noiseSpots) {
      canvas.drawCircle(spot, 1.5, noisePaint);
    }

    // Moss patches
    for (final spot in _mossSpots) {
      canvas.drawCircle(spot, 7, _mossPaint);
    }

    // Slime puddles
    for (final spot in _puddleSpots) {
      canvas.drawOval(
        Rect.fromCenter(center: spot, width: 28, height: 16),
        _puddlePaint,
      );
      canvas.drawCircle(
        spot + const Offset(-3, -2), 3,
        Paint()..color = Colors.white.withValues(alpha: 0.08),
      );
    }

    // Stalactites
    final stalPaint = Paint()..color = theme.wallColor;
    for (final s in _stalactites) {
      final path = Path()
        ..moveTo(s.x - s.width / 2, 18)
        ..lineTo(s.x, 18 + s.length)
        ..lineTo(s.x + s.width / 2, 18)
        ..close();
      canvas.drawPath(path, stalPaint);
    }

    // Edge outline
    canvas.drawPath(_floorPath, _edgePaint);
  }

  Future<void> _addDecor() async {
    final caveDecor = const ['crystal', 'mushroom', 'bones', 'skull', 'crack'];
    final count = 2 + _rng.nextInt(2);
    for (int i = 0; i < count; i++) {
      final id = caveDecor[_rng.nextInt(caveDecor.length)];
      final pos = _floorSpot();
      try {
        final image = await game.images.load('decor/$id.png');
        add(SpriteComponent(
          sprite: Sprite(image),
          size: Vector2.all(28),
          anchor: Anchor.topLeft,
          position: pos,
        ));
      } catch (_) {}
    }
  }

  Vector2 _floorSpot() => Vector2(
    80 + _rng.nextDouble() * (size.x - 160),
    80 + _rng.nextDouble() * (size.y - 160),
  );

  void _buildWalls() {
    // Invisible collision walls (same rect positions as before).
    final wallPaint = Paint()..color = Colors.transparent;
    final t = DungeonWorld.wallThickness;

    void buildH(double y, _DoorRange? door) {
      if (door == null) {
        add(WallSegment(size: Vector2(size.x, t), position: Vector2(0, y), paint: wallPaint));
        return;
      }
      if (door.start > 0) add(WallSegment(size: Vector2(door.start, t), position: Vector2(0, y), paint: wallPaint));
      if (door.end < size.x) add(WallSegment(size: Vector2(size.x - door.end, t), position: Vector2(door.end, y), paint: wallPaint));
    }

    void buildV(double x, _DoorRange? door) {
      if (door == null) {
        add(WallSegment(size: Vector2(t, size.y), position: Vector2(x, 0), paint: wallPaint));
        return;
      }
      if (door.start > 0) add(WallSegment(size: Vector2(t, door.start), position: Vector2(x, 0), paint: wallPaint));
      if (door.end < size.y) add(WallSegment(size: Vector2(t, size.y - door.end), position: Vector2(x, door.end), paint: wallPaint));
    }

    buildH(0, doors[RoomSide.top]);
    buildH(size.y - t, doors[RoomSide.bottom]);
    buildV(0, doors[RoomSide.left]);
    buildV(size.x - t, doors[RoomSide.right]);
  }
}

class _Stalactite {
  final double x, length, width;
  _Stalactite({required this.x, required this.length, required this.width});
}

/// Corridor between two rooms. Drawn as an organic tunnel.
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

  final Random _rng = Random();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final dx = (roomB.gridX - roomA.gridX);

    if (dx != 0) {
      _buildHorizontalCorridor(roomA.center, roomB.center);
    } else {
      _buildVerticalCorridor(roomA.center, roomB.center);
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

    final cw = DungeonWorld.corridorWidth;
    final wt = DungeonWorld.wallThickness;

    // Organic tunnel floor (slightly wavy)
    add(_TunnelFloor(
      tunnelPos: Vector2(startX, centerY - cw / 2),
      tunnelSize: Vector2(width, cw),
      theme: theme,
      horizontal: true,
    ));

    // Invisible collision walls
    final wp = Paint()..color = Colors.transparent;
    add(WallSegment(
      size: Vector2(width, wt),
      position: Vector2(startX, centerY - cw / 2 - wt),
      paint: wp,
    ));
    add(WallSegment(
      size: Vector2(width, wt),
      position: Vector2(startX, centerY + cw / 2),
      paint: wp,
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

    final cw = DungeonWorld.corridorWidth;
    final wt = DungeonWorld.wallThickness;

    add(_TunnelFloor(
      tunnelPos: Vector2(centerX - cw / 2, startY),
      tunnelSize: Vector2(cw, height),
      theme: theme,
      horizontal: false,
    ));

    final wp = Paint()..color = Colors.transparent;
    add(WallSegment(
      size: Vector2(wt, height),
      position: Vector2(centerX - cw / 2 - wt, startY),
      paint: wp,
    ));
    add(WallSegment(
      size: Vector2(wt, height),
      position: Vector2(centerX + cw / 2, startY),
      paint: wp,
    ));
  }
}

/// Renders a tunnel floor with organic edges and subtle details.
class _TunnelFloor extends PositionComponent {
  _TunnelFloor({
    required Vector2 tunnelPos,
    required Vector2 tunnelSize,
    required this.theme,
    required this.horizontal,
  }) : super(position: tunnelPos, size: tunnelSize);

  final DungeonTheme theme;
  final bool horizontal;
  final Random _rng = Random();

  late final Paint _floorPaint;
  late final Paint _wallPaint;
  late final Paint _edgePaint;
  late final Path _tunnelPath;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _floorPaint = Paint()..color = theme.floorColor;
    _wallPaint = Paint()..color = theme.wallColor;
    _edgePaint = Paint()
      ..color = theme.wallColor.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    _tunnelPath = _buildTunnelPath();
  }

  Path _buildTunnelPath() {
    final path = Path();
    final w = size.x;
    final h = size.y;
    final margin = 6.0;

    if (horizontal) {
      // Top edge (wavy)
      path.moveTo(0, margin);
      for (double x = 0; x < w; x += 20) {
        final jitter = margin + _rng.nextDouble() * 5;
        path.lineTo(x, jitter);
      }
      path.lineTo(w, margin);
      // Bottom edge (wavy)
      path.lineTo(w, h - margin);
      for (double x = w; x > 0; x -= 20) {
        final jitter = h - margin - _rng.nextDouble() * 5;
        path.lineTo(x, jitter);
      }
      path.lineTo(0, h - margin);
      path.close();
    } else {
      // Left edge
      path.moveTo(margin, 0);
      for (double y = 0; y < h; y += 20) {
        final jitter = margin + _rng.nextDouble() * 5;
        path.lineTo(jitter, y);
      }
      path.lineTo(margin, h);
      // Right edge
      path.lineTo(w - margin, h);
      for (double y = h; y > 0; y -= 20) {
        final jitter = w - margin - _rng.nextDouble() * 5;
        path.lineTo(jitter, y);
      }
      path.lineTo(w - margin, 0);
      path.close();
    }
    return path;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Background void
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = theme.backgroundColor);
    // Wall border
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), _wallPaint);
    // Organic floor
    canvas.drawPath(_tunnelPath, _floorPaint);
    canvas.drawPath(_tunnelPath, _edgePaint);
  }
}

/// A wall segment that blocks bullets and the player.
///
/// Note: we deliberately do NOT add a Flame collision hitbox to walls.
/// With 5+ rooms × 8 wall segments each, registering them all in the
/// global collision system caused N×M bullet/enemy ↔ wall pair checks
/// every frame and tanked perf. Bullets check `DungeonWorld.pointInWall`
/// manually each tick (one cheap rect-array scan), and the player's
/// movement uses the same lookup for sliding.
class WallSegment extends RectangleComponent {
  WallSegment({
    required super.size,
    required super.position,
    required super.paint,
  });
}
