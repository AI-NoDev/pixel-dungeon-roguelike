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
import '../data/weapons.dart';
import '../data/talents.dart';

class PixelDungeonGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  late Player player;
  late DungeonRoom currentRoom;
  late EnemySpawner enemySpawner;
  late CombatSystem combatSystem;

  final GameState gameState = GameState();
  final InputSystem inputSystem = InputSystem();

  // UI state callbacks
  VoidCallback? onShowTalentPicker;
  VoidCallback? onShowWeaponPickup;
  VoidCallback? onStateChanged;

  // Pending rewards
  List<TalentData>? pendingTalentChoices;
  WeaponData? pendingWeapon;

  @override
  Color backgroundColor() => const Color(0xFF1a1a2e);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.viewfinder.anchor = Anchor.center;

    currentRoom = DungeonRoom(roomSize: Vector2(800, 600));
    world.add(currentRoom);

    player = Player(position: Vector2(400, 300));
    world.add(player);

    enemySpawner = EnemySpawner(game: this);
    enemySpawner.spawnEnemiesForRoom(currentRoom);

    combatSystem = CombatSystem(game: this);

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
      _onRoomCleared();
    }
  }

  void _onRoomCleared() {
    // Every room cleared: offer talent
    pendingTalentChoices = TalentPool.getRandomChoices();
    onShowTalentPicker?.call();
    pauseEngine();

    // Every 2 rooms: also drop a weapon
    if (gameState.roomsCleared % 2 == 0) {
      pendingWeapon = WeaponPool.getRandomWeapon(floor: gameState.currentFloor);
    }
  }

  void onTalentPicked() {
    pendingTalentChoices = null;

    // Show weapon pickup if available
    if (pendingWeapon != null) {
      onShowWeaponPickup?.call();
    } else {
      resumeEngine();
      onStateChanged?.call();
    }
  }

  void onWeaponAccepted() {
    if (pendingWeapon != null) {
      player.equipWeapon(pendingWeapon!);
    }
    pendingWeapon = null;
    resumeEngine();
    onStateChanged?.call();
  }

  void onWeaponDeclined() {
    pendingWeapon = null;
    resumeEngine();
    onStateChanged?.call();
  }

  void moveToNextRoom() {
    gameState.currentFloor++;
    world.children.whereType<Enemy>().forEach((e) => e.removeFromParent());

    currentRoom.regenerate();
    player.position = Vector2(400, 300);

    enemySpawner.spawnEnemiesForRoom(currentRoom);
    onStateChanged?.call();
  }

  void onPlayerDeath() {
    gameState.isGameOver = true;
    pauseEngine();
    onStateChanged?.call();
  }

  void restartGame() {
    gameState.reset();
    resumeEngine();
    player.reset();
    moveToNextRoom();
    onStateChanged?.call();
  }
}
