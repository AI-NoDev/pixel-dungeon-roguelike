import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game/pixel_dungeon_game.dart';
import '../data/floor_config.dart';
import '../data/weapons.dart';
import '../systems/particle_system.dart';
import '../systems/element_system.dart';
import '../components/item_drop.dart';
import 'bullet.dart';
import 'dungeon_room.dart';
import 'enemies/slime_species.dart';
import 'floating_text.dart';

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

    final player = game.player;
    final direction = (player.position - position);
    if (direction.length > 40) {
      position += direction.normalized() * speed * dt;
    }

    if (shootInterval > 0) {
      _shootTimer += dt;
      if (_shootTimer >= shootInterval) {
        shoot();
        _shootTimer = 0;
      }
    }

    position.x = position.x.clamp(30, 770);
    position.y = position.y.clamp(30, 570);
  }

  void shoot() {
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

    // Show floating damage number
    game.world.add(FloatingText.damage(
      position + Vector2(0, -8),
      damage,
    ));

    body.paint.color = Colors.white;
    Future.delayed(const Duration(milliseconds: 80), () {
      if (!isDead) body.paint.color = color;
    });

    if (hp <= 0) {
      hp = 0;
      isDead = true;
      onDeath();
    }
  }

  void onDeath() {
    game.gameState.enemiesKilled++;
    final goldDrop = 10 + Random().nextInt(10);
    game.gameState.gold += goldDrop;
    // Show gold pickup text
    game.world.add(FloatingText.gold(
      position + Vector2(0, 4),
      goldDrop,
    ));
    // Spawn particles
    ParticleSystem.spawnDeathEffect(game.world, position, color);
    // Try to drop item
    ItemDropSystem.trySpawnDrop(game, position);
    removeFromParent();
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Bullet && other.isPlayerBullet) {
      takeDamage(other.damage);
      // Apply element
      if (other.element != ElementType.none) {
        ElementSystem.applyElement(game, this, other.element, other.damage);
      }
      other.removeFromParent();
    }
  }
}

/// Slime - basic melee
class SlimeEnemy extends Enemy {
  SlimeEnemy({required super.position, int difficulty = 1})
      : super(
          maxHp: 30 + difficulty * 10,
          speed: 60 + difficulty * 5,
          contactDamage: 10 + difficulty * 2,
          color: const Color(0xFF66BB6A),
        );
}

/// Skeleton - ranged shooter
class SkeletonEnemy extends Enemy {
  SkeletonEnemy({required super.position, int difficulty = 1})
      : super(
          maxHp: 20 + difficulty * 8,
          speed: 30 + difficulty * 3,
          contactDamage: 5,
          color: const Color(0xFFBDBDBD),
          shootInterval: (2.0 - difficulty * 0.1).clamp(0.5, 2.0),
          bulletDamage: 8 + difficulty * 2,
        );
}

/// Goblin - fast melee
class GoblinEnemy extends Enemy {
  GoblinEnemy({required super.position, int difficulty = 1})
      : super(
          maxHp: 15 + difficulty * 5,
          speed: 100 + difficulty * 10,
          contactDamage: 8 + difficulty * 2,
          color: const Color(0xFFFF8A65),
        );
}

/// Golem - tank
class GolemEnemy extends Enemy {
  GolemEnemy({required super.position, int difficulty = 1})
      : super(
          maxHp: 80 + difficulty * 20,
          speed: 25 + difficulty * 2,
          contactDamage: 20 + difficulty * 5,
          color: const Color(0xFF8D6E63),
        );
}

/// Mage enemy - ranged with burst
class MageEnemy extends Enemy {
  MageEnemy({required super.position, int difficulty = 1})
      : super(
          maxHp: 25 + difficulty * 6,
          speed: 35 + difficulty * 3,
          contactDamage: 5,
          color: const Color(0xFFCE93D8),
          shootInterval: (1.8 - difficulty * 0.08).clamp(0.6, 1.8),
          bulletDamage: 12 + difficulty * 3,
        );

  @override
  void shoot() {
    // Mage shoots 3 bullets in a spread
    final player = game.player;
    final baseDir = (player.position - position).normalized();
    final baseAngle = atan2(baseDir.y, baseDir.x);

    for (int i = 0; i < 3; i++) {
      final angle = baseAngle - 0.2 + 0.2 * i;
      final dir = Vector2(cos(angle), sin(angle));
      final bullet = Bullet(
        position: position + dir * 16,
        direction: dir,
        speed: 160,
        damage: bulletDamage,
        isPlayerBullet: false,
        color: const Color(0xFFCE93D8),
      );
      game.world.add(bullet);
    }
  }
}

/// Bomber - explodes on death
class BomberEnemy extends Enemy {
  BomberEnemy({required super.position, int difficulty = 1})
      : super(
          maxHp: 20 + difficulty * 4,
          speed: 80 + difficulty * 8,
          contactDamage: 30 + difficulty * 5,
          color: const Color(0xFFFF5722),
        );

  @override
  void onDeath() {
    // Explode: shoot bullets in all directions
    for (int i = 0; i < 8; i++) {
      final angle = (2 * pi / 8) * i;
      final dir = Vector2(cos(angle), sin(angle));
      final bullet = Bullet(
        position: position + dir * 12,
        direction: dir,
        speed: 150,
        damage: 15,
        isPlayerBullet: false,
        color: const Color(0xFFFF5722),
      );
      game.world.add(bullet);
    }
    super.onDeath();
  }
}

/// Enemy spawner system
class EnemySpawner {
  final PixelDungeonGame game;
  final Random _random = Random();

  EnemySpawner({required this.game});

  void spawnEnemiesForRoom(DungeonRoom room) {
    final config = game.currentFloorConfig;
    final enemyCount = config.baseEnemyCount;

    for (int i = 0; i < enemyCount; i++) {
      final pos = _randomPositionInRoom();
      final enemy = _createRandomEnemy(pos, config);
      game.world.add(enemy);
      room.enemies.add(enemy);
    }
  }

  void spawnEliteRoom(DungeonRoom room) {
    final config = game.currentFloorConfig;
    // Elite rooms: fewer but stronger enemies
    final enemyCount = (config.baseEnemyCount * 0.7).ceil();

    for (int i = 0; i < enemyCount; i++) {
      final pos = _randomPositionInRoom();
      final enemy = _createEliteEnemy(pos, config);
      game.world.add(enemy);
      room.enemies.add(enemy);
    }
  }

  Vector2 _randomPositionInRoom() {
    double x, y;
    do {
      x = 60 + _random.nextDouble() * 680;
      y = 60 + _random.nextDouble() * 480;
    } while ((Vector2(x, y) - Vector2(400, 300)).length < 120);
    return Vector2(x, y);
  }

  Enemy _createRandomEnemy(Vector2 position, FloorConfig config) {
    final difficulty = config.floorNumber;
    final roll = _random.nextDouble();

    Enemy enemy;

    // Floor 1-2: Easy slimes
    if (difficulty <= 2) {
      if (roll < 0.5) {
        enemy = GreenSlime(position: position, difficulty: difficulty);
      } else if (roll < 0.85) {
        enemy = PinkBouncer(position: position, difficulty: difficulty);
      } else {
        enemy = AcidSpitter(position: position, difficulty: difficulty);
      }
    }
    // Floor 3-4: Add elemental slimes
    else if (difficulty <= 4) {
      if (roll < 0.20) {
        enemy = GreenSlime(position: position, difficulty: difficulty);
      } else if (roll < 0.35) {
        enemy = PinkBouncer(position: position, difficulty: difficulty);
      } else if (roll < 0.50) {
        enemy = AcidSpitter(position: position, difficulty: difficulty);
      } else if (roll < 0.65) {
        enemy = BlueFrostJelly(position: position, difficulty: difficulty);
      } else if (roll < 0.78) {
        enemy = LavaBubbler(position: position, difficulty: difficulty);
      } else if (roll < 0.88) {
        enemy = ToxicGoo(position: position, difficulty: difficulty);
      } else if (roll < 0.95) {
        enemy = MegaGoo(position: position, difficulty: difficulty);
      } else {
        enemy = BombSlime(position: position, difficulty: difficulty);
      }
    }
    // Floor 5+: All slimes including mutants
    else {
      // 0.5% chance of legendary Rainbow Slime
      if (roll < 0.005) {
        enemy = RainbowSlime(position: position, difficulty: difficulty);
      } else if (roll < 0.15) {
        enemy = GreenSlime(position: position, difficulty: difficulty);
      } else if (roll < 0.25) {
        enemy = ThunderJolt(position: position, difficulty: difficulty);
      } else if (roll < 0.35) {
        enemy = SpikeSlime(position: position, difficulty: difficulty);
      } else if (roll < 0.45) {
        enemy = TarSlime(position: position, difficulty: difficulty);
      } else if (roll < 0.55) {
        enemy = MutantSlime(position: position, difficulty: difficulty);
      } else if (roll < 0.65) {
        enemy = CrystallineSlime(position: position, difficulty: difficulty);
      } else if (roll < 0.72) {
        enemy = RegeneratingSlime(position: position, difficulty: difficulty);
      } else if (roll < 0.80) {
        enemy = BombSlime(position: position, difficulty: difficulty);
      } else if (roll < 0.86) {
        enemy = CorrosiveSlime(position: position, difficulty: difficulty);
      } else if (roll < 0.92) {
        enemy = PhantomSlime(position: position, difficulty: difficulty);
      } else {
        enemy = MagneticSlime(position: position, difficulty: difficulty);
      }
    }

    // Apply floor multipliers
    enemy.maxHp *= config.enemyHpMultiplier;
    enemy.hp = enemy.maxHp;
    enemy.contactDamage *= config.enemyDamageMultiplier;
    enemy.speed *= config.enemySpeedMultiplier;

    return enemy;
  }

  Enemy _createEliteEnemy(Vector2 position, FloorConfig config) {
    final difficulty = config.floorNumber;
    final roll = _random.nextDouble();

    Enemy enemy;
    if (roll < 0.35) {
      enemy = SlimeKnight(position: position, difficulty: difficulty);
    } else if (roll < 0.7) {
      enemy = SlimeMage(position: position, difficulty: difficulty);
    } else {
      enemy = KingsGuard(position: position, difficulty: difficulty);
    }

    enemy.maxHp *= config.enemyHpMultiplier;
    enemy.hp = enemy.maxHp;
    enemy.contactDamage *= config.enemyDamageMultiplier;
    return enemy;
  }
}
