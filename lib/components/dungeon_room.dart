import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game/pixel_dungeon_game.dart';
import 'enemy_spawner.dart';

class DungeonRoom extends PositionComponent with HasGameReference<PixelDungeonGame> {
  DungeonRoom({required this.roomSize})
      : super(position: Vector2.zero(), size: roomSize);

  final Vector2 roomSize;
  List<Enemy> enemies = [];
  bool doorsOpen = false;

  // Room visual components
  late RectangleComponent floor;
  late List<RectangleComponent> walls;
  late List<DoorComponent> doors;

  bool get isCleared => enemies.every((e) => e.isDead || e.isRemoved);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _buildRoom();
  }

  void _buildRoom() {
    // Floor
    floor = RectangleComponent(
      size: Vector2(roomSize.x - 40, roomSize.y - 40),
      position: Vector2(20, 20),
      paint: Paint()..color = const Color(0xFF2D2D44),
    );
    add(floor);

    // Walls
    final wallColor = const Color(0xFF4A4A6A);
    final wallPaint = Paint()..color = wallColor;

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

    // Add some random obstacles
    _addObstacles();

    // Doors (initially closed)
    doors = [
      DoorComponent(
        position: Vector2(roomSize.x / 2 - 20, 0),
        size: Vector2(40, 20),
      ),
    ];
    for (final door in doors) {
      add(door);
    }
  }

  void _addObstacles() {
    final random = Random();
    final obstacleCount = 2 + random.nextInt(4);
    final obstacleColor = const Color(0xFF5C5C7A);

    for (int i = 0; i < obstacleCount; i++) {
      final obstacleSize = Vector2(
        24 + random.nextDouble() * 32,
        24 + random.nextDouble() * 32,
      );
      final pos = Vector2(
        40 + random.nextDouble() * (roomSize.x - 80 - obstacleSize.x),
        40 + random.nextDouble() * (roomSize.y - 80 - obstacleSize.y),
      );

      // Don't place obstacles too close to center (player spawn)
      if ((pos - Vector2(400, 300)).length < 80) continue;

      add(RectangleComponent(
        size: obstacleSize,
        position: pos,
        paint: Paint()..color = obstacleColor,
      ));
    }
  }

  void openDoors() {
    doorsOpen = true;
    for (final door in doors) {
      door.open();
    }
  }

  void regenerate() {
    enemies.clear();
    doorsOpen = false;
    removeAll(children);
    _buildRoom();
  }
}

class DoorComponent extends PositionComponent {
  DoorComponent({required Vector2 position, required Vector2 size})
      : super(position: position, size: size);

  bool isOpen = false;
  late RectangleComponent visual;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    visual = RectangleComponent(
      size: size,
      paint: Paint()..color = const Color(0xFF8B4513),
    );
    add(visual);
  }

  void open() {
    isOpen = true;
    visual.paint.color = const Color(0xFF4CAF50);
  }
}
