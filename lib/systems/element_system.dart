import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../data/weapons.dart';
import '../components/enemy_spawner.dart';
import '../components/element_status_indicator.dart';
import '../game/pixel_dungeon_game.dart';
import 'particle_system.dart';

/// Element status effects on enemies
class ElementStatus {
  ElementType type;
  double duration;
  double tickTimer;

  ElementStatus({required this.type, required this.duration, this.tickTimer = 0});
}

/// Manages elemental reactions between different elements
class ElementSystem {
  /// Apply element to enemy and check for reactions
  static void applyElement(
    PixelDungeonGame game,
    Enemy enemy,
    ElementType element,
    double damage,
  ) {
    if (element == ElementType.none) return;

    // Check if enemy already has a different element applied
    final existingElement = _getEnemyElement(enemy);

    if (existingElement != null && existingElement != element) {
      // REACTION! Two different elements combine
      _triggerReaction(game, enemy, existingElement, element, damage);
      _clearEnemyElement(enemy);
    } else {
      // Apply new element status
      _setEnemyElement(enemy, element);
      _applyElementEffect(game, enemy, element, damage);
    }
  }

  static void _triggerReaction(
    PixelDungeonGame game,
    Enemy enemy,
    ElementType first,
    ElementType second,
    double damage,
  ) {
    final reactionType = _getReactionType(first, second);

    switch (reactionType) {
      case ReactionType.vaporize:
        // Fire + Ice = Vaporize (2x damage burst)
        enemy.takeDamage(damage * 2);
        ParticleSystem.spawnDeathEffect(game.world, enemy.position, Colors.white);
        break;

      case ReactionType.overload:
        // Lightning + Fire = Overload (AoE explosion)
        _aoeExplosion(game, enemy.position, damage * 1.5, 80);
        ParticleSystem.spawnBossPhaseEffect(game.world, enemy.position, Colors.orange);
        break;

      case ReactionType.freeze:
        // Ice + Lightning = Freeze (stun + shatter damage)
        enemy.speed *= 0.3; // Slow to 30%
        enemy.takeDamage(damage * 1.5);
        ParticleSystem.spawnHitEffect(game.world, enemy.position, Colors.cyan);
        // Restore speed after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          if (!enemy.isDead) enemy.speed /= 0.3;
        });
        break;

      case ReactionType.toxic:
        // Poison + Fire = Toxic cloud (DoT AoE)
        _toxicCloud(game, enemy.position, damage * 0.5);
        ParticleSystem.spawnDeathEffect(game.world, enemy.position, Colors.green);
        break;

      case ReactionType.corrode:
        // Poison + Ice = Corrode (defense down + damage)
        enemy.takeDamage(damage * 1.8);
        // Enemies take more damage for a while (simulated by reducing HP further)
        ParticleSystem.spawnHitEffect(game.world, enemy.position, Colors.purple);
        break;

      case ReactionType.chain:
        // Lightning + Poison = Chain (spread to nearby enemies)
        _chainLightning(game, enemy, damage * 0.8);
        ParticleSystem.spawnHitEffect(game.world, enemy.position, Colors.yellow);
        break;

      case ReactionType.none:
        break;
    }
  }

  static void _applyElementEffect(
    PixelDungeonGame game,
    Enemy enemy,
    ElementType element,
    double damage,
  ) {
    // Show status indicator above enemy
    if (element != ElementType.none) {
      _spawnStatusIndicator(game, enemy, element, _getElementDuration(element));
    }

    switch (element) {
      case ElementType.fire:
        _applyBurn(game, enemy, damage * 0.3);
        break;
      case ElementType.ice:
        enemy.speed *= 0.6;
        Future.delayed(const Duration(seconds: 3), () {
          if (!enemy.isDead) enemy.speed /= 0.6;
        });
        break;
      case ElementType.lightning:
        final originalSpeed = enemy.speed;
        enemy.speed = 0;
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!enemy.isDead) enemy.speed = originalSpeed;
        });
        break;
      case ElementType.poison:
        _applyPoison(game, enemy, damage * 0.2);
        break;
      case ElementType.none:
        break;
    }
  }

  static double _getElementDuration(ElementType element) {
    switch (element) {
      case ElementType.fire:
        return 2.0;
      case ElementType.ice:
        return 3.0;
      case ElementType.lightning:
        return 0.5;
      case ElementType.poison:
        return 4.0;
      case ElementType.none:
        return 0;
    }
  }

  static void _spawnStatusIndicator(
    PixelDungeonGame game,
    Enemy enemy,
    ElementType element,
    double duration,
  ) {
    final indicator = ElementStatusIndicator(
      element: element,
      duration: duration,
      position: enemy.position + Vector2(0, -16),
    );
    game.world.add(indicator);
    // Make indicator follow enemy
    indicator.add(_FollowComponent(target: enemy));
  }

  static void _applyBurn(PixelDungeonGame game, Enemy enemy, double dps) {
    int ticks = 0;
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      if (enemy.isDead || ticks >= 4) return false;
      enemy.takeDamage(dps);
      ParticleSystem.spawnHitEffect(game.world, enemy.position, Colors.orange);
      ticks++;
      return true;
    });
  }

  static void _applyPoison(PixelDungeonGame game, Enemy enemy, double dps) {
    int ticks = 0;
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 800));
      if (enemy.isDead || ticks >= 5) return false;
      enemy.takeDamage(dps);
      ParticleSystem.spawnHitEffect(game.world, enemy.position, Colors.green);
      ticks++;
      return true;
    });
  }

  static void _aoeExplosion(PixelDungeonGame game, Vector2 center, double damage, double radius) {
    final enemies = game.world.children.whereType<Enemy>();
    for (final enemy in enemies) {
      if ((enemy.position - center).length <= radius && !enemy.isDead) {
        enemy.takeDamage(damage);
      }
    }
  }

  static void _toxicCloud(PixelDungeonGame game, Vector2 center, double dps) {
    int ticks = 0;
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 600));
      if (ticks >= 5) return false;
      final enemies = game.world.children.whereType<Enemy>();
      for (final enemy in enemies) {
        if ((enemy.position - center).length <= 60 && !enemy.isDead) {
          enemy.takeDamage(dps);
        }
      }
      ticks++;
      return true;
    });
  }

  static void _chainLightning(PixelDungeonGame game, Enemy source, double damage) {
    final enemies = game.world.children.whereType<Enemy>().toList();
    int chains = 0;
    Enemy current = source;

    for (final enemy in enemies) {
      if (enemy == source || enemy.isDead) continue;
      if ((enemy.position - current.position).length <= 100) {
        enemy.takeDamage(damage * (1 - chains * 0.2));
        ParticleSystem.spawnHitEffect(game.world, enemy.position, Colors.yellow);
        current = enemy;
        chains++;
        if (chains >= 3) break;
      }
    }
  }

  // Simple element tracking using enemy color tint
  static final Map<int, ElementType> _enemyElements = {};

  static ElementType? _getEnemyElement(Enemy enemy) {
    return _enemyElements[enemy.hashCode];
  }

  static void _setEnemyElement(Enemy enemy, ElementType element) {
    _enemyElements[enemy.hashCode] = element;
    // Auto-clear after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      _enemyElements.remove(enemy.hashCode);
    });
  }

  static void _clearEnemyElement(Enemy enemy) {
    _enemyElements.remove(enemy.hashCode);
  }

  static ReactionType _getReactionType(ElementType a, ElementType b) {
    final pair = {a, b};
    if (pair.contains(ElementType.fire) && pair.contains(ElementType.ice)) {
      return ReactionType.vaporize;
    }
    if (pair.contains(ElementType.lightning) && pair.contains(ElementType.fire)) {
      return ReactionType.overload;
    }
    if (pair.contains(ElementType.ice) && pair.contains(ElementType.lightning)) {
      return ReactionType.freeze;
    }
    if (pair.contains(ElementType.poison) && pair.contains(ElementType.fire)) {
      return ReactionType.toxic;
    }
    if (pair.contains(ElementType.poison) && pair.contains(ElementType.ice)) {
      return ReactionType.corrode;
    }
    if (pair.contains(ElementType.lightning) && pair.contains(ElementType.poison)) {
      return ReactionType.chain;
    }
    return ReactionType.none;
  }
}

enum ReactionType {
  none,
  vaporize,   // Fire + Ice: 2x damage burst
  overload,   // Lightning + Fire: AoE explosion
  freeze,     // Ice + Lightning: Stun + shatter
  toxic,      // Poison + Fire: DoT AoE cloud
  corrode,    // Poison + Ice: Defense down
  chain,      // Lightning + Poison: Chain to nearby
}


/// Helper component that makes its parent follow a target position.
class _FollowComponent extends Component {
  _FollowComponent({required this.target});

  final PositionComponent target;
  static const double offsetY = -16;

  @override
  void update(double dt) {
    super.update(dt);
    if (parent is PositionComponent && !target.isRemoved) {
      (parent as PositionComponent).position = Vector2(
        target.position.x,
        target.position.y + offsetY,
      );
    }
  }
}
