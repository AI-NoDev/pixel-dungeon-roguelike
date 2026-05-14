import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../components/player.dart';
import '../components/dungeon_world.dart';
import '../components/enemy_spawner.dart';
import '../components/boss.dart';
import '../components/bullet.dart';
import '../components/decal.dart';
import '../components/fog_of_war.dart';
import '../components/talent_pickup.dart';
import '../components/floating_text.dart';
import '../systems/input_system.dart';
import '../systems/combat_system.dart';
import '../systems/skill_system.dart';
import '../data/game_state.dart';
import '../data/weapons.dart';
import '../data/talents.dart';
import '../data/floor_config.dart';
import '../data/dungeon_theme.dart';
import '../data/dungeon_map.dart';
import '../data/boss_data.dart';
import '../data/heroes.dart';

class PixelDungeonGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  late Player player;
  late DungeonWorld dungeonWorld;
  late EnemySpawner enemySpawner;
  late CombatSystem combatSystem;
  late FogOfWar fogOfWar;

  final GameState gameState = GameState();
  final InputSystem inputSystem = InputSystem();
  late final SkillSystem skillSystem = SkillSystem(game: this);

  // Floor + map state
  late FloorConfig currentFloorConfig;
  late DungeonMap dungeonMap;
  RoomNode? currentRoom;

  // UI callbacks
  VoidCallback? onShowTalentPicker;
  VoidCallback? onShowWeaponPickup;
  VoidCallback? onShowShop;
  VoidCallback? onStateChanged;
  VoidCallback? onBossDefeated;
  VoidCallback? onFloorComplete;

  List<TalentData>? pendingTalentChoices;
  WeaponData? pendingWeapon;

  HeroData selectedHero = HeroData.knight;
  BossEnemy? currentBoss;

  @override
  Color backgroundColor() => const Color(0xFF0D0D1A);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewfinder.anchor = Anchor.center;

    _initFloor();
  }

  void _initFloor() {
    currentFloorConfig = FloorConfig.getConfig(gameState.currentFloor);
    dungeonMap = DungeonMap.generate(currentFloorConfig);

    // Build dungeon world
    dungeonWorld = DungeonWorld(
      map: dungeonMap,
      theme: currentFloorConfig.theme,
    );
    world.add(dungeonWorld);

    // Spawn player at start room center
    final startRoom = dungeonMap.getRoom(dungeonMap.startRoomId);
    player = Player(position: startRoom.center);
    _applyHeroStats();
    world.add(player);

    // Fog of war on top of world (but below UI)
    fogOfWar = FogOfWar(map: dungeonMap);
    world.add(fogOfWar);

    enemySpawner = EnemySpawner(game: this);
    combatSystem = CombatSystem(game: this);

    // Camera follows player
    camera.follow(player);
    camera.viewfinder.zoom = 1.2;

    // Mark start room as visited
    currentRoom = startRoom;
    startRoom.visited = true;
  }

  void _applyHeroStats() {
    player.maxHp = selectedHero.maxHp;
    player.hp = selectedHero.maxHp;
    player.baseSpeed = selectedHero.speed;
    player.baseDamage = selectedHero.damage;
    player.baseFireRate = selectedHero.fireRate;
  }

  @override
  void update(double dt) {
    super.update(dt);
    combatSystem.update(dt);
    skillSystem.update(dt);
    enemySpawner.update(dt);

    // Detect room transitions for fog of war + spawn triggers
    final newRoom = dungeonWorld.roomAt(player.position);
    if (newRoom != null && newRoom.id != currentRoom?.id) {
      _onPlayerEnterRoom(newRoom);
    }
  }

  void _onPlayerEnterRoom(RoomNode room) {
    currentRoom = room;
    if (!room.visited) {
      room.visited = true;
      _triggerRoomEncounter(room);
    }
  }

  void _triggerRoomEncounter(RoomNode room) {
    switch (room.type) {
      case RoomType.combat:
      case RoomType.elite:
        // Trigger waves of enemies
        final wave = room.type == RoomType.elite ? 3 : 2;
        enemySpawner.spawnWavesInRoom(room, waveCount: wave);
        break;
      case RoomType.boss:
        _spawnBoss(room);
        break;
      case RoomType.treasure:
        _spawnTreasure(room);
        break;
      case RoomType.rest:
        player.heal(player.maxHp * 0.3);
        break;
      case RoomType.shop:
        onShowShop?.call();
        pauseEngine();
        break;
    }
  }

  /// Called by enemy_spawner when a room's last wave is cleared.
  void onRoomCleared(RoomNode room) {
    if (room.cleared) return;
    room.cleared = true;
    gameState.roomsCleared++;
    onStateChanged?.call();

    // Drop a talent pickup as reward for combat/elite rooms
    if (room.type == RoomType.combat || room.type == RoomType.elite) {
      final talents = TalentPool.getRandomChoices();
      world.add(TalentPickup(
        position: room.center,
        choices: talents,
      ));
    }

    // Boss room → next floor
    if (room.type == RoomType.boss) {
      gameState.gold += 100;
      onBossDefeated?.call();
      Future.delayed(const Duration(milliseconds: 1500), () {
        moveToNextFloor();
      });
    }
  }

  void _spawnBoss(RoomNode room) {
    final bossData = BossData.getBossForFloor(gameState.currentFloor);
    currentBoss = BossEnemy(position: room.center + Vector2(0, -100), data: bossData);
    world.add(currentBoss!);
  }

  void _spawnTreasure(RoomNode room) {
    pendingWeapon = WeaponPool.getRandomWeapon(floor: gameState.currentFloor);
    onShowWeaponPickup?.call();
    pauseEngine();
  }

  // ---- Talent picker callbacks ----

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

  void moveToNextFloor() {
    gameState.currentFloor++;
    _cleanupAll();
    _initFloor();
    onFloorComplete?.call();
    onStateChanged?.call();
  }

  void _cleanupAll() {
    world.children.whereType<Enemy>().forEach((e) => e.removeFromParent());
    world.children.whereType<Bullet>().forEach((b) => b.removeFromParent());
    world.children.whereType<Decal>().forEach((d) => d.removeFromParent());
    world.children.whereType<TalentPickup>().forEach((t) => t.removeFromParent());
    currentBoss?.removeFromParent();
    currentBoss = null;
    dungeonWorld.removeFromParent();
    fogOfWar.removeFromParent();
    player.removeFromParent();
  }

  void onPlayerDeath() {
    gameState.isGameOver = true;
    pauseEngine();
    onStateChanged?.call();
  }

  void restartGame() {
    gameState.reset();
    _cleanupAll();
    _initFloor();
    resumeEngine();
    onStateChanged?.call();
  }

  // Backward-compat for HUD widgets / old code:
  String get currentRoomLabelKey {
    if (currentRoom == null) return 'room_combat';
    switch (currentRoom!.type) {
      case RoomType.combat: return 'room_combat';
      case RoomType.elite: return 'room_elite';
      case RoomType.treasure: return 'room_treasure';
      case RoomType.shop: return 'room_shop';
      case RoomType.rest: return 'room_rest';
      case RoomType.boss: return 'room_boss';
    }
  }

  String get currentRoomIndexLabel => '';

  String get currentThemeKey {
    switch (currentFloorConfig.theme.type) {
      case DungeonThemeType.crypt: return 'theme_crypt';
      case DungeonThemeType.cave: return 'theme_cave';
      case DungeonThemeType.fortress: return 'theme_fortress';
      case DungeonThemeType.inferno: return 'theme_inferno';
      case DungeonThemeType.void_: return 'theme_void';
    }
  }
}
