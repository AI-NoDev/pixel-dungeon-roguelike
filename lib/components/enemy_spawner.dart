import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game/pixel_dungeon_game.dart';
import 'bullet.dart';
import 'dungeon_room.dart';

/// Base enemy class
class Enemy extends PositionComponent
    with HasGameReference<PixelDungeonGame>, CollisionCallbacks {
  Enemy({
    required Vector2 position,
    required this.maxHp,
    required this.speed,
    required this.contactDamage,
    required this.color,
    this.shootInterval = 0,
    this.bulletDamage = 10,
  }) : hp = maxHp,
       super(
         position: position,
         size: Vector2(24, 24),
         anchor: Anchor.center,
       );

  double maxHp;
  double hp;
  double speed;
  double contactDamage;
  double shootInterval;
  double bulletDamage;
  Color color;

  double _shootTimer = 0;
  bool isDead = false;

  late RectangleComponent body;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    body = RectangleComponent(
      size: Vector2(20, 20),
      position: Vector2(2, 2),
      paint: Paint()..color = color,
    );
    add(body);
    add(RectangleHitbox(size: Vector2(20, 20), position: Vector2(2, 2)));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isDead) return;

    // Move towards player
    final player = game.player;
    final direction = (player.position - position);
    if (direction.length > 40) {
      position += direction.normalized() * speed * dt;
    }

    // Shoot if ranged enemy
    if (shootInterval > 0) {
      _shootTimer += dt;
      if (_shootTimer >= shootInterval) {
        _shoot();
        _shootTimer = 0;
      }
    }

    // Clamp to room bounds
    position.x = position.x.clamp(30, 770);
    position.y = position.y.clamp(30, 570);
  }

  void _shoot() {
    final player = game.player;
    final direction = (player.position - position).normalized();

    final bullet = Bullet(
      position: position + direction * 16,
      direction: direction,
      speed: 180,
      damage: bulletDamage,
      isPlayerBullet: false,
    );
    game.world.add(bullet);
  }

  void takeDamage(double damage) {
    if (isDead) return;
    hp -= damage;

    // Flash white
    body.paint.color = Colors.white;
    Future.delayed(const Duration(milliseconds: 80), () {
      if (!isDead) body.paint.color = color;
    });

    if (hp <= 0) {
      hp = 0;
      isDead = true;
      _onDeath();
    }
  }

  void _onDeath() {
    game.gameState.enemiesKilled++;
    game.gameState.gold += (10 + Random().nextInt(10));
    removeFromParent();
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Bullet && other.isPlayerBullet) {
      takeDamage(other.damage);
      other.removeFromParent();
    }
  }
}

/// Melee enemy - charges at player
class SlimeEnemy extends Enemy {
  SlimeEnemy({required Vector2 position, int difficulty = 1})
      : super(
          position: position,
          maxHp: 30 + difficulty * 10,
          speed: 60 + difficulty * 5,
          contactDamage: 10 + difficulty * 2,
          color: const Color(0xFF66BB6A),
        );
}

/// Ranged enemy - shoots at player
class SkeletonEnemy extends Enemy {
  SkeletonEnemy({required Vector2 position, int difficulty = 1})
      : super(
          position: position,
          maxHp: 20 + difficulty * 8,
          speed: 30 + difficulty * 3,
          contactDamage: 5,
          color: const Color(0xFFBDBDBD),
          shootInterval: 2.0 - difficulty * 0.1,
          bulletDamage: 8 + difficulty * 2,
        );
}

/// Fast enemy - quick but fragile
class GoblinEnemy extends Enemy {
  GoblinEnemy({required Vector2 position, int difficulty = 1})
      : super(
          position: position,
          maxHp: 15 + difficulty * 5,
          speed: 100 + difficulty * 10,
          contactDamage: 8 + difficulty * 2,
          color: const Color(0xFFFF8A65),
        );
}

/// Tank enemy - slow but tough
class GolemEnemy extends Enemy {
  GolemEnemy({required Vector2 position, int difficulty = 1})
      : super(
          position: position,
          maxHp: 80 + difficulty * 20,
          speed: 25 + difficulty * 2,
          contactDamage: 20 + difficulty * 5,
          color: const Color(0xFF8D6E63),
        );
}

/// Enemy spawner system
class EnemySpawner {
  final PixelDungeonGame game;
  final Random _random = Random();

  EnemySpawner({required this.game});

  void spawnEnemiesForRoom(DungeonRoom room) {
    final difficulty = game.gameState.currentFloor;
    final enemyCount = 3 + (difficulty * 0.5).floor().clamp(0, 8);

    for (int i = 0; i < enemyCount; i++) {
      final pos = _randomPositionInRoom();
      final enemy = _createRandomEnemy(pos, difficulty);
      game.world.add(enemy);
      room.enemies.add(enemy);
    }
  }

  Vector2 _randomPositionInRoom() {
    // Avoid spawning too close to player (center)
    double x, y;
    do {
      x = 60 + _random.nextDouble() * 680;
      y = 60 + _random.nextDouble() * 480;
    } while ((Vector2(x, y) - Vector2(400, 300)).length < 100);
    return Vector2(x, y);
  }

  Enemy _createRandomEnemy(Vector2 position, int difficulty) {
    final roll = _random.nextDouble();
    if (difficulty < 3) {
      // Early floors: mostly slimes and goblins
      if (roll < 0.4) return SlimeEnemy(position: position, difficulty: difficulty);
      if (roll < 0.7) return GoblinEnemy(position: position, difficulty: difficulty);
      return SkeletonEnemy(position: position, difficulty: difficulty);
    } else {
      // Later floors: add golems
      if (roll < 0.25) return SlimeEnemy(position: position, difficulty: difficulty);
      if (roll < 0.45) return GoblinEnemy(position: position, difficulty: difficulty);
      if (roll < 0.7) return SkeletonEnemy(position: position, difficulty: difficulty);
      return GolemEnemy(position: position, difficulty: difficulty);
    }
  }
}
