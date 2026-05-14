import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game/pixel_dungeon_game.dart';
import '../data/dungeon_theme.dart';
import '../data/floor_config.dart';
import 'enemy_spawner.dart';

class DungeonRoom extends PositionComponent with HasGameReference<PixelDungeonGame> {
  DungeonRoom({required this.roomSize})
      : super(position: Vector2.zero(), size: roomSize);

  final Vector2 roomSize;
  List<Enemy> enemies = [];
  bool doorsOpen = false;
  RoomType roomType = RoomType.combat;
  DungeonTheme theme = DungeonTheme.crypt;

  final Random _random = Random();

  bool get isCleared {
    if (roomType == RoomType.treasure ||
        roomType == RoomType.shop ||
        roomType == RoomType.rest) {
      return true; // Non-combat rooms are always "cleared"
    }
    return enemies.every((e) => e.isDead || e.isRemoved);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _buildRoom();
  }

  void setConfig(RoomType type, DungeonTheme newTheme) {
    roomType = type;
    theme = newTheme;
  }

  void _buildRoom() {
    // Floor
    add(RectangleComponent(
      size: Vector2(roomSize.x - 40, roomSize.y - 40),
      position: Vector2(20, 20),
      paint: Paint()..color = theme.floorColor,
    ));

    // Floor decoration tiles (grid pattern)
    _addFloorDecoration();

    // Walls
    final wallPaint = Paint()..color = theme.wallColor;

    // Top wall
    add(RectangleComponent(
      size: Vector2(roomSize.x, 20),
      position: Vector2.zero(),
      paint: wallPaint,
    ));
    // Bottom wall
    add(RectangleComponent(
      size: Vector2(roomSize.x, 20),
      position: Vector2(0, roomSize.y - 20),
      paint: wallPaint,
    ));
    // Left wall
    add(RectangleComponent(
      size: Vector2(20, roomSize.y),
      position: Vector2.zero(),
      paint: wallPaint,
    ));
    // Right wall
    add(RectangleComponent(
      size: Vector2(20, roomSize.y),
      position: Vector2(roomSize.x - 20, 0),
      paint: wallPaint,
    ));

    // Wall accent (inner border)
    final accentPaint = Paint()
      ..color = theme.accentColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    add(RectangleComponent(
      size: Vector2(roomSize.x - 44, roomSize.y - 44),
      position: Vector2(22, 22),
      paint: accentPaint,
    ));

    // Room-type specific content
    switch (roomType) {
      case RoomType.combat:
      case RoomType.elite:
        _addCombatObstacles();
        break;
      case RoomType.treasure:
        _addTreasureContent();
        break;
      case RoomType.shop:
        _addShopContent();
        break;
      case RoomType.rest:
        _addRestContent();
        break;
      case RoomType.boss:
        _addBossArena();
        break;
    }

    // Door (top center)
    add(_DoorComponent(
      position: Vector2(roomSize.x / 2 - 20, 0),
      size: Vector2(40, 20),
      theme: theme,
    ));
  }

  void _addFloorDecoration() {
    // Subtle grid pattern
    final tileSize = 40.0;
    final tilePaint = Paint()
      ..color = theme.accentColor.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (double x = 20; x < roomSize.x - 20; x += tileSize) {
      for (double y = 20; y < roomSize.y - 20; y += tileSize) {
        add(RectangleComponent(
          size: Vector2(tileSize, tileSize),
          position: Vector2(x, y),
          paint: tilePaint,
        ));
      }
    }

    // Random floor stains/details
    for (int i = 0; i < 5; i++) {
      final pos = Vector2(
        40 + _random.nextDouble() * (roomSize.x - 80),
        40 + _random.nextDouble() * (roomSize.y - 80),
      );
      add(CircleComponent(
        radius: 3 + _random.nextDouble() * 5,
        position: pos,
        paint: Paint()..color = theme.accentColor.withValues(alpha: 0.08),
      ));
    }
  }

  void _addCombatObstacles() {
    final obstacleCount = roomType == RoomType.elite
        ? 2 + _random.nextInt(3)
        : 3 + _random.nextInt(4);

    for (int i = 0; i < obstacleCount; i++) {
      final obstacleSize = Vector2(
        24 + _random.nextDouble() * 32,
        24 + _random.nextDouble() * 32,
      );
      final pos = Vector2(
        50 + _random.nextDouble() * (roomSize.x - 100 - obstacleSize.x),
        50 + _random.nextDouble() * (roomSize.y - 100 - obstacleSize.y),
      );

      // Don't place near center (player spawn)
      if ((pos - Vector2(400, 300)).length < 100) continue;

      add(RectangleComponent(
        size: obstacleSize,
        position: pos,
        paint: Paint()..color = theme.obstacleColor,
      ));
    }

    // Add pillars for elite rooms
    if (roomType == RoomType.elite) {
      final pillarPositions = [
        Vector2(150, 150),
        Vector2(650, 150),
        Vector2(150, 450),
        Vector2(650, 450),
      ];
      for (final pos in pillarPositions) {
        add(CircleComponent(
          radius: 12,
          position: pos,
          paint: Paint()..color = theme.wallColor,
        ));
      }
    }
  }

  void _addTreasureContent() {
    // Treasure chest visual (center)
    add(RectangleComponent(
      size: Vector2(32, 24),
      position: Vector2(roomSize.x / 2 - 16, roomSize.y / 2 - 12),
      paint: Paint()..color = const Color(0xFFFFD54F),
    ));
    // Chest lid
    add(RectangleComponent(
      size: Vector2(36, 8),
      position: Vector2(roomSize.x / 2 - 18, roomSize.y / 2 - 16),
      paint: Paint()..color = const Color(0xFFFFA000),
    ));
  }

  void _addShopContent() {
    // Shop counter
    add(RectangleComponent(
      size: Vector2(200, 16),
      position: Vector2(roomSize.x / 2 - 100, 80),
      paint: Paint()..color = const Color(0xFF6D4C41),
    ));
    // Shop items display (3 pedestals)
    for (int i = 0; i < 3; i++) {
      final x = roomSize.x / 2 - 100 + i * 80;
      add(RectangleComponent(
        size: Vector2(24, 24),
        position: Vector2(x, 120),
        paint: Paint()..color = theme.accentColor.withValues(alpha: 0.5),
      ));
    }
  }

  void _addRestContent() {
    // Campfire visual
    add(CircleComponent(
      radius: 16,
      position: Vector2(roomSize.x / 2, roomSize.y / 2),
      paint: Paint()..color = const Color(0xFFFF8A65),
    ));
    add(CircleComponent(
      radius: 10,
      position: Vector2(roomSize.x / 2, roomSize.y / 2),
      paint: Paint()..color = const Color(0xFFFFD54F),
    ));
    // Sitting logs
    add(RectangleComponent(
      size: Vector2(40, 12),
      position: Vector2(roomSize.x / 2 - 60, roomSize.y / 2 + 30),
      paint: Paint()..color = const Color(0xFF5D4037),
    ));
    add(RectangleComponent(
      size: Vector2(40, 12),
      position: Vector2(roomSize.x / 2 + 20, roomSize.y / 2 + 30),
      paint: Paint()..color = const Color(0xFF5D4037),
    ));
  }

  void _addBossArena() {
    // Open arena with corner pillars
    final pillarPositions = [
      Vector2(80, 80),
      Vector2(roomSize.x - 80, 80),
      Vector2(80, roomSize.y - 80),
      Vector2(roomSize.x - 80, roomSize.y - 80),
    ];
    for (final pos in pillarPositions) {
      add(CircleComponent(
        radius: 16,
        position: pos,
        paint: Paint()..color = theme.wallColor,
      ));
      // Pillar glow
      add(CircleComponent(
        radius: 20,
        position: pos,
        paint: Paint()..color = theme.accentColor.withValues(alpha: 0.2),
      ));
    }

    // Center arena marking
    add(CircleComponent(
      radius: 80,
      position: Vector2(roomSize.x / 2, roomSize.y / 2),
      paint: Paint()
        ..color = theme.accentColor.withValues(alpha: 0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    ));
  }

  void openDoors() {
    doorsOpen = true;
    final door = children.whereType<_DoorComponent>().firstOrNull;
    door?.open();
  }

  void regenerate() {
    enemies.clear();
    doorsOpen = false;
    removeAll(children);
    _buildRoom();
  }
}

class _DoorComponent extends PositionComponent {
  _DoorComponent({
    required Vector2 position,
    required Vector2 size,
    required this.theme,
  }) : super(position: position, size: size);

  final DungeonTheme theme;
  bool isOpen = false;
  late RectangleComponent visual;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    visual = RectangleComponent(
      size: size,
      paint: Paint()..color = theme.doorColor,
    );
    add(visual);
  }

  void open() {
    isOpen = true;
    visual.paint.color = const Color(0xFF4CAF50);
  }
}
