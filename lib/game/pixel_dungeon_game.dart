import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../components/player.dart';
import '../components/dungeon_room.dart';
import '../components/enemy_spawner.dart';
import '../systems/input_system.dart';
import '../systems/combat_system.dart';
import '../data/game_state.dart';

class PixelDungeonGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  late Player player;
  late DungeonRoom currentRoom;
  late EnemySpawner enemySpawner;
  late CombatSystem combatSystem;

  final GameState gameState = GameState();
  final InputSystem inputSystem = InputSystem();

  // Camera follows player
  @override
  Color backgroundColor() => const Color(0xFF1a1a2e);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Setup camera
    camera.viewfinder.anchor = Anchor.center;

    // Create dungeon room
    currentRoom = DungeonRoom(roomSize: Vector2(800, 600));
    world.add(currentRoom);

    // Create player at center of room
    player = Player(position: Vector2(400, 300));
    world.add(player);

    // Setup enemy spawner
    enemySpawner = EnemySpawner(game: this);
    enemySpawner.spawnEnemiesForRoom(currentRoom);

    // Setup combat system
    combatSystem = CombatSystem(game: this);

    // Camera follows player
    camera.follow(player);
  }

  @override
  void update(double dt) {
    super.update(dt);
    combatSystem.update(dt);

    // Check if room is cleared
    if (currentRoom.isCleared && !currentRoom.doorsOpen) {
      currentRoom.openDoors();
      gameState.roomsCleared++;
    }
  }

  void moveToNextRoom() {
    gameState.currentFloor++;
    // Remove old enemies
    world.children.whereType<Enemy>().forEach((e) => e.removeFromParent());

    // Generate new room
    currentRoom.regenerate();
    player.position = Vector2(400, 300);

    // Spawn new enemies (harder)
    enemySpawner.spawnEnemiesForRoom(currentRoom);
  }

  void onPlayerDeath() {
    gameState.isGameOver = true;
    pauseEngine();
  }

  void restartGame() {
    gameState.reset();
    resumeEngine();
    player.reset();
    moveToNextRoom();
  }
}
