import 'dart:math';
import 'package:flame/components.dart';
import 'floor_config.dart';

/// Procedural dungeon map composed of multiple rooms connected by corridors.
class DungeonMap {
  DungeonMap({
    required this.rooms,
    required this.corridors,
    required this.startRoomId,
    required this.bossRoomId,
  });

  final List<RoomNode> rooms;
  final List<Corridor> corridors;
  final int startRoomId;
  final int bossRoomId;

  RoomNode getRoom(int id) => rooms.firstWhere((r) => r.id == id);

  /// Get all corridors connected to a given room.
  List<Corridor> corridorsFor(int roomId) =>
      corridors.where((c) => c.roomA == roomId || c.roomB == roomId).toList();

  /// Get neighbor room IDs.
  List<int> neighborsOf(int roomId) {
    return corridorsFor(roomId).map((c) {
      return c.roomA == roomId ? c.roomB : c.roomA;
    }).toList();
  }

  /// Generate a random map for given floor config.
  /// Layout: 5-9 rooms in a connected graph.
  static DungeonMap generate(FloorConfig floorConfig) {
    final random = Random(DateTime.now().millisecondsSinceEpoch);
    // Number of rooms scales with floor (5 base + small growth)
    final roomCount = 5 + (floorConfig.floorNumber ~/ 2).clamp(0, 4);

    // Place rooms on a loose grid (non-overlapping)
    final rooms = <RoomNode>[];
    const cellSize = 900.0; // distance between room centers
    const roomW = 800.0;
    const roomH = 600.0;

    // Start room at (0, 0)
    rooms.add(RoomNode(
      id: 0,
      type: RoomType.combat,
      gridX: 0,
      gridY: 0,
      worldPosition: Vector2.zero(),
      size: Vector2(roomW, roomH),
      visited: false,
      cleared: false,
    ));

    final used = <(int, int)>{(0, 0)};
    final placeQueue = <int>[0];

    while (rooms.length < roomCount && placeQueue.isNotEmpty) {
      final fromIdx = random.nextInt(placeQueue.length);
      final fromId = placeQueue.removeAt(fromIdx);
      final from = rooms[fromId];

      // Try directions in random order
      final directions = [
        (1, 0), (-1, 0), (0, 1), (0, -1),
      ]..shuffle(random);

      for (final (dx, dy) in directions) {
        if (rooms.length >= roomCount) break;
        final nx = from.gridX + dx;
        final ny = from.gridY + dy;
        if (used.contains((nx, ny))) continue;

        final newId = rooms.length;
        final isLast = rooms.length == roomCount - 1;
        final isMid = rooms.length == roomCount ~/ 2;

        RoomType type;
        if (isLast) {
          type = floorConfig.hasBoss ? RoomType.boss : RoomType.combat;
        } else if (isMid && random.nextDouble() < 0.5) {
          type = RoomType.treasure;
        } else if (random.nextDouble() < 0.15) {
          type = RoomType.elite;
        } else if (random.nextDouble() < 0.1) {
          type = RoomType.rest;
        } else {
          type = RoomType.combat;
        }

        rooms.add(RoomNode(
          id: newId,
          type: type,
          gridX: nx,
          gridY: ny,
          worldPosition: Vector2(nx * cellSize, ny * cellSize),
          size: Vector2(roomW, roomH),
          visited: false,
          cleared: false,
        ));
        used.add((nx, ny));
        placeQueue.add(newId);
      }
    }

    // Build corridors: for each room, connect to neighbors (orthogonal grid)
    final corridors = <Corridor>[];
    final connected = <(int, int)>{};

    for (final room in rooms) {
      // Find adjacent rooms on grid
      final neighbors = rooms.where((r) =>
        (r.gridX - room.gridX).abs() + (r.gridY - room.gridY).abs() == 1).toList();

      for (final n in neighbors) {
        final pair = (min(room.id, n.id), max(room.id, n.id));
        if (connected.contains(pair)) continue;

        // Random chance to skip some adjacencies (creates 1-2 corridors per room avg)
        if (corridors.isNotEmpty && random.nextDouble() < 0.3) continue;

        connected.add(pair);
        corridors.add(Corridor(roomA: room.id, roomB: n.id));
      }
    }

    // Find boss room id
    final bossRoom = rooms.lastWhere(
      (r) => r.type == RoomType.boss,
      orElse: () => rooms.last,
    );

    return DungeonMap(
      rooms: rooms,
      corridors: corridors,
      startRoomId: 0,
      bossRoomId: bossRoom.id,
    );
  }
}

/// A single room in the dungeon graph.
class RoomNode {
  RoomNode({
    required this.id,
    required this.type,
    required this.gridX,
    required this.gridY,
    required this.worldPosition,
    required this.size,
    required this.visited,
    required this.cleared,
  });

  final int id;
  final RoomType type;
  final int gridX;
  final int gridY;
  final Vector2 worldPosition;
  final Vector2 size;
  bool visited;
  bool cleared;

  /// Center of room in world coordinates.
  Vector2 get center => worldPosition + size / 2;

  RoomNode copyWith({bool? visited, bool? cleared}) {
    return RoomNode(
      id: id,
      type: type,
      gridX: gridX,
      gridY: gridY,
      worldPosition: worldPosition,
      size: size,
      visited: visited ?? this.visited,
      cleared: cleared ?? this.cleared,
    );
  }
}

/// Corridor connecting two rooms. Allows player and enemies to pass.
class Corridor {
  Corridor({required this.roomA, required this.roomB});
  final int roomA;
  final int roomB;
}
