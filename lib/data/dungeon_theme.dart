import 'package:flutter/material.dart';

/// Visual themes for different dungeon floors
enum DungeonThemeType { crypt, cave, fortress, inferno, void_ }

class DungeonTheme {
  final DungeonThemeType type;
  final String name;
  final Color floorColor;
  final Color wallColor;
  final Color accentColor;
  final Color obstacleColor;
  final Color doorColor;
  final Color backgroundColor;
  final List<Color> enemyTints;

  const DungeonTheme({
    required this.type,
    required this.name,
    required this.floorColor,
    required this.wallColor,
    required this.accentColor,
    required this.obstacleColor,
    required this.doorColor,
    required this.backgroundColor,
    required this.enemyTints,
  });

  static DungeonTheme getThemeForFloor(int floor) {
    if (floor <= 5) return crypt;
    if (floor <= 10) return cave;
    if (floor <= 15) return fortress;
    if (floor <= 20) return inferno;
    return voidTheme;
  }

  // Floor 1-5: Dark stone crypt
  static const crypt = DungeonTheme(
    type: DungeonThemeType.crypt,
    name: 'Ancient Crypt',
    floorColor: Color(0xFF2D2D44),
    wallColor: Color(0xFF4A4A6A),
    accentColor: Color(0xFF6A6A8A),
    obstacleColor: Color(0xFF5C5C7A),
    doorColor: Color(0xFF8B4513),
    backgroundColor: Color(0xFF1a1a2e),
    enemyTints: [Color(0xFF66BB6A), Color(0xFFBDBDBD), Color(0xFFFF8A65)],
  );

  // Floor 6-10: Natural cave
  static const cave = DungeonTheme(
    type: DungeonThemeType.cave,
    name: 'Crystal Cave',
    floorColor: Color(0xFF2E3B2E),
    wallColor: Color(0xFF4A5D4A),
    accentColor: Color(0xFF80CBC4),
    obstacleColor: Color(0xFF3E5C3E),
    doorColor: Color(0xFF6D4C41),
    backgroundColor: Color(0xFF1B2B1B),
    enemyTints: [Color(0xFF4DB6AC), Color(0xFF81C784), Color(0xFFA5D6A7)],
  );

  // Floor 11-15: Stone fortress
  static const fortress = DungeonTheme(
    type: DungeonThemeType.fortress,
    name: 'Iron Fortress',
    floorColor: Color(0xFF37474F),
    wallColor: Color(0xFF546E7A),
    accentColor: Color(0xFFFFB74D),
    obstacleColor: Color(0xFF455A64),
    doorColor: Color(0xFF795548),
    backgroundColor: Color(0xFF263238),
    enemyTints: [Color(0xFFFFB74D), Color(0xFF90A4AE), Color(0xFFE57373)],
  );

  // Floor 16-20: Inferno
  static const inferno = DungeonTheme(
    type: DungeonThemeType.inferno,
    name: 'Inferno Depths',
    floorColor: Color(0xFF3E2723),
    wallColor: Color(0xFF5D4037),
    accentColor: Color(0xFFFF7043),
    obstacleColor: Color(0xFF4E342E),
    doorColor: Color(0xFFBF360C),
    backgroundColor: Color(0xFF1B0000),
    enemyTints: [Color(0xFFFF5722), Color(0xFFFF8A65), Color(0xFFFFAB91)],
  );

  // Floor 21+: Void
  static const voidTheme = DungeonTheme(
    type: DungeonThemeType.void_,
    name: 'The Void',
    floorColor: Color(0xFF1A1A2E),
    wallColor: Color(0xFF311B92),
    accentColor: Color(0xFFE040FB),
    obstacleColor: Color(0xFF4A148C),
    doorColor: Color(0xFF7C4DFF),
    backgroundColor: Color(0xFF0D0D1A),
    enemyTints: [Color(0xFFCE93D8), Color(0xFFB39DDB), Color(0xFF80DEEA)],
  );
}
