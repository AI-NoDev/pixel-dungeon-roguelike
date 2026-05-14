import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../components/player.dart';
import '../components/dungeon_room.dart';
import '../components/enemy_spawner.dart';
import '../components/boss.dart';
import '../components/bullet.dart';
import '../systems/input_system.dart';
import '../systems/combat_system.dart';
import '../systems/skill_system.dart';
import '../data/game_state.dart';
import '../data/weapons.dart';
import '../data/talents.dart';
import '../data/floor_config.dart';
import '../data/dungeon_theme.dart';
import '../data/boss_data.dart';
import '../data/heroes.dart';

class PixelDungeonGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  late Player player;
  late DungeonRoom currentRoom;
  late EnemySpawner enemySpawner;
  late CombatSystem combatSystem;

  final GameState gameState = GameState();
  final InputSystem inputSystem = InputSystem();
  late SkillSystem skillSystem;

  // Floor/Room tracking
  late FloorConfig currentFloorConfig;
  late List<RoomConfig> currentFloorRooms;
  int currentRoomIndex = 0;

  // Hero selection
  HeroData selectedHero = HeroData.knight;

  // UI state callbacks
  VoidCallback? onShowTalentPicker;
  VoidCallback? onShowWeaponPickup;
  VoidCallback? onStateChanged;
  VoidCallback? onBossDefeated;
  VoidCallback? onFloorComplete;

  // Pending rewards
  List<TalentData>? pendingTalentChoices;
  WeaponData? pendingWeapon;

  // Boss tracking
  BossEnemy? currentBoss;

  @override
  Color backgroundColor() => const Color(0xFF1a1a2e);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.viewfinder.anchor = Anchor.center;

    // Initialize floor
    currentFloorConfig = FloorConfig.getConfig(gameState.currentFloor);
    currentFloorRooms = RoomConfig.generateFloorRooms(currentFloorConfig);
    currentRoomIndex = 0;

    // Create room
    currentRoom = DungeonRoom(roomSize: Vector2(800, 600));
    currentRoom.setConfig(
      currentFloorRooms[currentRoomIndex].type,
      currentFloorConfig.theme,
    );
    world.add(currentRoom);

    // Create player
    player = Player(position: Vector2(400, 300));
    _applyHeroStats();
    world.add(player);

    // Spawn enemies for first room
    enemySpawner = EnemySpawner(game: this);
    _spawnForCurrentRoom();

    // Setup combat
    combatSystem = CombatSystem(game: this);
    skillSystem = SkillSystem(game: this);

    camera.follow(player);
  }

  void _applyHeroStats() {
    player.maxHp = selectedHero.maxHp;
    player.hp = selectedHero.maxHp;
    player.baseSpeed = selectedHero.speed;
    player.baseDamage = selectedHero.damage;
    player.baseFireRate = selectedHero.fireRate;
  }

  void _spawnForCurrentRoom() {
    final roomConfig = currentFloorRooms[currentRoomIndex];

    switch (roomConfig.type) {
      case RoomType.combat:
        enemySpawner.spawnEnemiesForRoom(currentRoom);
        break;
      case RoomType.elite:
        enemySpawner.spawnEliteRoom(currentRoom);
        break;
      case RoomType.boss:
        _spawnBoss();
        break;
      case RoomType.treasure:
      case RoomType.shop:
      case RoomType.rest:
        // No enemies in these rooms
        // Handle special room effects
        _handleSpecialRoom(roomConfig.type);
        break;
    }
  }

  void _spawnBoss() {
    final bossData = BossData.getBossForFloor(gameState.currentFloor);
    currentBoss = BossEnemy(
      position: Vector2(400, 200),
      data: bossData,
    );
    world.add(currentBoss!);
    currentRoom.enemies.clear(); // Boss room uses boss tracking instead
  }

  // Shop state
  VoidCallback? onShowShop;

  void _handleSpecialRoom(RoomType type) {
    switch (type) {
      case RoomType.rest:
        // Heal 30% of max HP
        player.heal(player.maxHp * 0.3);
        break;
      case RoomType.treasure:
        // Give a random weapon
        pendingWeapon = WeaponPool.getRandomWeapon(floor: gameState.currentFloor);
        onShowWeaponPickup?.call();
        pauseEngine();
        break;
      case RoomType.shop:
        onShowShop?.call();
        pauseEngine();
        break;
      default:
        break;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    combatSystem.update(dt);
    skillSystem.update(dt);

    // Check room clear conditions
    if (_isCurrentRoomCleared() && !currentRoom.doorsOpen) {
      currentRoom.openDoors();
      gameState.roomsCleared++;
      _onRoomCleared();
    }
  }

  bool _isCurrentRoomCleared() {
    final roomType = currentFloorRooms[currentRoomIndex].type;

    if (roomType == RoomType.boss) {
      return currentBoss?.isDead ?? false;
    }

    return currentRoom.isCleared;
  }

  void _onRoomCleared() {
    final roomType = currentFloorRooms[currentRoomIndex].type;

    if (roomType == RoomType.boss) {
      // Boss defeated!
      gameState.gold += 100;
      onBossDefeated?.call();
    }

    // Offer talent for combat/elite/boss rooms
    if (roomType == RoomType.combat ||
        roomType == RoomType.elite ||
        roomType == RoomType.boss) {
      pendingTalentChoices = TalentPool.getRandomChoices();
      onShowTalentPicker?.call();
      pauseEngine();
    }

    // Weapon drop every 2 combat rooms
    if (gameState.roomsCleared % 2 == 0 && roomType != RoomType.boss) {
      pendingWeapon = WeaponPool.getRandomWeapon(floor: gameState.currentFloor);
    }
  }

  void onTalentPicked() {
    pendingTalentChoices = null;

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
    currentRoomIndex++;

    // Check if floor is complete
    if (currentRoomIndex >= currentFloorRooms.length) {
      _moveToNextFloor();
      return;
    }

    // Clean up current room
    _cleanupRoom();

    // Setup new room
    currentRoom.setConfig(
      currentFloorRooms[currentRoomIndex].type,
      currentFloorConfig.theme,
    );
    currentRoom.regenerate();
    player.position = Vector2(400, 500); // Enter from bottom

    // Spawn enemies
    _spawnForCurrentRoom();
    onStateChanged?.call();
  }

  void _moveToNextFloor() {
    gameState.currentFloor++;
    currentRoomIndex = 0;

    // Generate new floor
    currentFloorConfig = FloorConfig.getConfig(gameState.currentFloor);
    currentFloorRooms = RoomConfig.generateFloorRooms(currentFloorConfig);

    // Clean and rebuild
    _cleanupRoom();
    currentRoom.setConfig(
      currentFloorRooms[0].type,
      currentFloorConfig.theme,
    );
    currentRoom.regenerate();
    player.position = Vector2(400, 500);

    _spawnForCurrentRoom();
    onFloorComplete?.call();
    onStateChanged?.call();
  }

  void _cleanupRoom() {
    // Remove all enemies
    world.children.whereType<Enemy>().forEach((e) => e.removeFromParent());
    // Remove boss if exists
    currentBoss?.removeFromParent();
    currentBoss = null;
    // Remove bullets
    world.children.whereType<Bullet>().forEach((b) => b.removeFromParent());
  }

  void onPlayerDeath() {
    gameState.isGameOver = true;
    pauseEngine();
    onStateChanged?.call();
  }

  void restartGame() {
    gameState.reset();
    currentRoomIndex = 0;
    currentFloorConfig = FloorConfig.getConfig(1);
    currentFloorRooms = RoomConfig.generateFloorRooms(currentFloorConfig);

    _cleanupRoom();
    currentRoom.setConfig(RoomType.combat, DungeonTheme.crypt);
    currentRoom.regenerate();

    player.reset();
    _applyHeroStats();
    player.position = Vector2(400, 300);

    _spawnForCurrentRoom();
    resumeEngine();
    onStateChanged?.call();
  }

  /// Get current room info for HUD
  String get currentRoomLabel {
    final room = currentFloorRooms[currentRoomIndex];
    switch (room.type) {
      case RoomType.combat:
        return 'Room ${currentRoomIndex + 1}/${currentFloorRooms.length}';
      case RoomType.elite:
        return 'Elite Room';
      case RoomType.treasure:
        return 'Treasure Room';
      case RoomType.shop:
        return 'Shop';
      case RoomType.rest:
        return 'Rest Area';
      case RoomType.boss:
        return 'BOSS';
    }
  }

  String get currentThemeName => currentFloorConfig.theme.name;
}
