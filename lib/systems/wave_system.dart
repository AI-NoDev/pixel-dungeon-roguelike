import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../components/enemy_spawner.dart';
import '../components/enemies/spawn_marker.dart';
import '../components/dungeon_room.dart';
import '../game/pixel_dungeon_game.dart';

/// Manages enemy waves within a single room.
/// Each room has 2-3 waves; the next wave only spawns when previous is cleared.
class WaveSystem {
  WaveSystem({required this.game, required this.room});

  final PixelDungeonGame game;
  final DungeonRoom room;

  int currentWave = 0;
  int totalWaves = 2;
  bool _waveActive = false;
  final Random _random = Random();

  /// Initialize for a new room based on room type.
  void start({required int waveCount, required EnemySpawner spawner}) {
    currentWave = 0;
    totalWaves = waveCount;
    _waveActive = false;
    _spawnNextWave(spawner);
  }

  /// Check if all enemies dead -> spawn next wave OR mark room done.
  void update(EnemySpawner spawner) {
    if (!_waveActive) return;
    if (room.enemies.every((e) => e.isDead || e.isRemoved)) {
      _waveActive = false;
      if (currentWave < totalWaves) {
        // Brief delay between waves
        Future.delayed(const Duration(milliseconds: 800), () {
          _spawnNextWave(spawner);
        });
      }
    }
  }

  bool get allWavesCleared => !_waveActive && currentWave >= totalWaves;

  void _spawnNextWave(EnemySpawner spawner) {
    currentWave++;
    _waveActive = true;
    room.enemies.clear();

    // Wave size increases with wave number
    final config = game.currentFloorConfig;
    final waveSize = (config.baseEnemyCount * (0.6 + 0.3 * currentWave)).ceil();

    for (int i = 0; i < waveSize; i++) {
      final pos = _randomSpawnPosition();
      final spawnType = _pickSpawnAnim();
      final markerColor = _markerColorForWave(currentWave);

      // Drop a marker first; enemy emerges after marker animation
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
    do {
      x = 60 + _random.nextDouble() * 680;
      y = 60 + _random.nextDouble() * 480;
    } while ((Vector2(x, y) - playerPos).length < 140);
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
    if (wave == 1) return const Color(0xFFFF7043); // orange
    if (wave == 2) return const Color(0xFFFF1744); // red
    return const Color(0xFFAB47BC); // purple for late waves
  }

  void _spawnEnemyWithAnim(EnemySpawner spawner, Vector2 pos, SpawnAnimType type) {
    // Play spawn animation visual
    final config = game.currentFloorConfig;
    final enemy = spawner.createEnemyForWave(pos, config);
    game.world.add(SpawnAnimation(
      position: pos,
      color: enemy.color,
      type: type,
      duration: 0.5,
    ));
    // Add the actual enemy
    game.world.add(enemy);
    room.enemies.add(enemy);
  }
}
