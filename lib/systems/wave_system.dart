import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../components/enemy_spawner.dart';
import '../components/enemies/spawn_marker.dart';
import '../data/dungeon_map.dart';
import '../game/pixel_dungeon_game.dart';

/// Per-room wave manager. Tracks how many waves have spawned and when the
/// room is fully cleared.
class WaveSystem {
  WaveSystem({required this.game, required this.room});

  final PixelDungeonGame game;
  final RoomNode room;

  int currentWave = 0;
  int totalWaves = 2;
  bool _waveActive = false;
  int _pendingSpawns = 0;
  bool _disposed = false;
  final List<Enemy> _liveEnemies = [];
  final Random _random = Random();

  void start({required int waveCount, required EnemySpawner spawner}) {
    currentWave = 0;
    totalWaves = waveCount;
    _waveActive = false;
    _pendingSpawns = 0;
    _disposed = false;
    _liveEnemies.clear();
    _spawnNextWave(spawner);
  }

  /// Mark this wave system as disposed (floor changed). Prevents stale
  /// Future.delayed callbacks from firing.
  void dispose() {
    _disposed = true;
    _liveEnemies.clear();
  }

  void update(EnemySpawner spawner) {
    if (!_waveActive || _disposed) return;
    // Remove dead/removed enemies from tracking
    _liveEnemies.removeWhere((e) => e.isDead || e.isRemoved);
    // Wait for both pending markers and live enemies to finish before advancing
    if (_liveEnemies.isEmpty && _pendingSpawns == 0) {
      _waveActive = false;
      if (currentWave < totalWaves) {
        Future.delayed(const Duration(milliseconds: 800), () {
          if (!_disposed) _spawnNextWave(spawner);
        });
      } else {
        // All waves cleared — notify game
        if (!_disposed) game.onRoomCleared(room);
      }
    }
  }

  bool get allWavesCleared => !_waveActive && currentWave >= totalWaves;

  void _spawnNextWave(EnemySpawner spawner) {
    currentWave++;
    _waveActive = true;

    final config = game.currentFloorConfig;
    final waveSize = (config.baseEnemyCount * (0.6 + 0.3 * currentWave)).ceil();
    _pendingSpawns += waveSize;

    for (int i = 0; i < waveSize; i++) {
      final pos = _randomSpawnPosition();
      final spawnType = _pickSpawnAnim();
      final markerColor = _markerColorForWave(currentWave);

      final marker = SpawnMarker(
        position: pos,
        color: markerColor,
        spawnAnim: spawnType,
        duration: 0.9 + _random.nextDouble() * 0.3,
        onComplete: (spawnPos) {
          _spawnEnemyWithAnim(spawner, spawnPos, spawnType);
        },
      );
      game.world.add(marker);
    }
  }

  Vector2 _randomSpawnPosition() {
    double x, y;
    final playerPos = game.player.position;
    int tries = 0;
    do {
      x = room.worldPosition.x + 60 +
          _random.nextDouble() * (room.size.x - 120);
      y = room.worldPosition.y + 60 +
          _random.nextDouble() * (room.size.y - 120);
      tries++;
    } while ((Vector2(x, y) - playerPos).length < 140 && tries < 10);
    return Vector2(x, y);
  }

  SpawnAnimType _pickSpawnAnim() {
    final r = _random.nextDouble();
    if (r < 0.4) return SpawnAnimType.groundEmerge;
    if (r < 0.7) return SpawnAnimType.skyDrop;
    if (r < 0.9) return SpawnAnimType.portalAppear;
    return SpawnAnimType.shatterIn;
  }

  Color _markerColorForWave(int wave) {
    if (wave == 1) return const Color(0xFFFF7043);
    if (wave == 2) return const Color(0xFFFF1744);
    return const Color(0xFFAB47BC);
  }

  void _spawnEnemyWithAnim(EnemySpawner spawner, Vector2 pos, SpawnAnimType type) {
    if (_disposed) return;
    final config = game.currentFloorConfig;
    final enemy = spawner.createEnemyForWave(pos, config);
    game.world.add(SpawnAnimation(
      position: pos,
      color: enemy.color,
      type: type,
      duration: 0.5,
    ));
    game.world.add(enemy);
    _liveEnemies.add(enemy);
    if (_pendingSpawns > 0) _pendingSpawns--;
  }
}
