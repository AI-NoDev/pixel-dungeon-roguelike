import 'dungeon_theme.dart';

/// Configuration for each floor's structure
class FloorConfig {
  final int floorNumber;
  final int roomCount; // rooms before boss
  final int baseEnemyCount;
  final double enemyHpMultiplier;
  final double enemyDamageMultiplier;
  final double enemySpeedMultiplier;
  final bool hasBoss;
  final DungeonTheme theme;

  const FloorConfig({
    required this.floorNumber,
    required this.roomCount,
    required this.baseEnemyCount,
    required this.enemyHpMultiplier,
    required this.enemyDamageMultiplier,
    required this.enemySpeedMultiplier,
    required this.hasBoss,
    required this.theme,
  });

  static FloorConfig getConfig(int floor) {
    final theme = DungeonTheme.getThemeForFloor(floor);

    return FloorConfig(
      floorNumber: floor,
      roomCount: 4 + (floor ~/ 3).clamp(0, 6), // 4-10 rooms per floor
      baseEnemyCount: 3 + (floor * 0.5).floor().clamp(0, 8),
      enemyHpMultiplier: 1.0 + (floor - 1) * 0.15,
      enemyDamageMultiplier: 1.0 + (floor - 1) * 0.1,
      enemySpeedMultiplier: 1.0 + (floor - 1) * 0.05,
      hasBoss: floor % 5 == 0, // Boss every 5 floors
      theme: theme,
    );
  }
}

/// Room types within a floor
enum RoomType {
  combat,     // Normal enemy room
  elite,      // Harder enemies, better rewards
  treasure,   // Free loot, no enemies
  shop,       // Buy items with gold
  boss,       // Boss fight
  rest,       // Heal some HP
}

class RoomConfig {
  final RoomType type;
  final int roomIndex;
  final int totalRooms;

  const RoomConfig({
    required this.type,
    required this.roomIndex,
    required this.totalRooms,
  });

  /// Generate room sequence for a floor
  static List<RoomConfig> generateFloorRooms(FloorConfig floorConfig) {
    final rooms = <RoomConfig>[];
    final totalRooms = floorConfig.roomCount;

    for (int i = 0; i < totalRooms; i++) {
      RoomType type;

      if (i == totalRooms - 1 && floorConfig.hasBoss) {
        type = RoomType.boss;
      } else if (i == totalRooms ~/ 2) {
        // Mid-floor: rest or treasure
        type = floorConfig.floorNumber % 2 == 0
            ? RoomType.treasure
            : RoomType.rest;
      } else if (i == totalRooms - 2 && floorConfig.hasBoss) {
        // Room before boss: shop
        type = RoomType.shop;
      } else if (i > 0 && i % 3 == 0) {
        // Every 3rd room: elite
        type = RoomType.elite;
      } else {
        type = RoomType.combat;
      }

      rooms.add(RoomConfig(
        type: type,
        roomIndex: i,
        totalRooms: totalRooms,
      ));
    }

    return rooms;
  }
}
