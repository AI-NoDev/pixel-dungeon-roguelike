import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../data/heroes.dart';
import '../game/pixel_dungeon_game.dart';
import '../components/enemy_spawner.dart';
import 'particle_system.dart';

/// Active skill system for heroes
class SkillSystem {
  final PixelDungeonGame game;

  double cooldownTimer = 0;
  double maxCooldown = 10.0; // seconds
  bool isReady = true;

  SkillSystem({required this.game});

  double get cooldownProgress => isReady ? 1.0 : (1.0 - cooldownTimer / maxCooldown);

  void update(double dt) {
    if (!isReady) {
      cooldownTimer -= dt;
      if (cooldownTimer <= 0) {
        isReady = true;
        cooldownTimer = 0;
      }
    }
  }

  void activateSkill() {
    if (!isReady) return;

    isReady = false;
    cooldownTimer = maxCooldown;

    switch (game.selectedHero.type) {
      case HeroType.knight:
        _knightShieldBash();
        break;
      case HeroType.ranger:
        _rangerArrowRain();
        break;
      case HeroType.mage:
        _mageNovaBlast();
        break;
      case HeroType.rogue:
        _rogueShadowStep();
        break;
    }
  }

  /// Knight: Knockback nearby enemies + 2s invincibility
  void _knightShieldBash() {
    final playerPos = game.player.position;
    final enemies = game.world.children.whereType<Enemy>();

    for (final enemy in enemies) {
      final dist = (enemy.position - playerPos).length;
      if (dist < 100 && !enemy.isDead) {
        // Knockback
        final dir = (enemy.position - playerPos).normalized();
        enemy.position += dir * 80;
        enemy.takeDamage(15);
      }
    }

    // Visual effect
    ParticleSystem.spawnBossPhaseEffect(game.world, playerPos, Colors.lightBlue);

    // Brief invincibility (simulated by healing)
    game.player.heal(20);
  }

  /// Ranger: Rain arrows in a target area for 3 seconds
  void _rangerArrowRain() {
    final targetPos = game.player.position + game.player.aimDirection * 150;
    int ticks = 0;

    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 200));
      if (ticks >= 15) return false;

      // Spawn arrows falling in the area
      final offset = Vector2(
        (Random().nextDouble() - 0.5) * 80,
        (Random().nextDouble() - 0.5) * 80,
      );
      final arrowPos = targetPos + offset;

      // Damage enemies in area
      final enemies = game.world.children.whereType<Enemy>();
      for (final enemy in enemies) {
        if ((enemy.position - arrowPos).length < 30 && !enemy.isDead) {
          enemy.takeDamage(game.player.attackDamage * 0.4);
        }
      }

      ParticleSystem.spawnHitEffect(game.world, arrowPos, Colors.green);
      ticks++;
      return true;
    });
  }

  /// Mage: Explode all nearby enemies with arcane energy
  void _mageNovaBlast() {
    final playerPos = game.player.position;
    final enemies = game.world.children.whereType<Enemy>();

    for (final enemy in enemies) {
      final dist = (enemy.position - playerPos).length;
      if (dist < 150 && !enemy.isDead) {
        enemy.takeDamage(game.player.attackDamage * 2);
        ParticleSystem.spawnHitEffect(game.world, enemy.position, Colors.purple);
      }
    }

    // Big visual nova
    ParticleSystem.spawnBossPhaseEffect(game.world, playerPos, Colors.purple);
  }

  /// Rogue: Invisible + speed boost for 3 seconds
  void _rogueShadowStep() {
    // Speed boost
    game.player.speedMultiplier *= 1.5;
    // Visual: make player semi-transparent (simulated via color)
    game.player.body.paint.color = const Color(0x664FC3F7);

    Future.delayed(const Duration(seconds: 3), () {
      if (!game.player.isDead) {
        game.player.speedMultiplier /= 1.5;
        game.player.body.paint.color = const Color(0xFF4FC3F7);
      }
    });

    ParticleSystem.spawnPickupEffect(game.world, game.player.position, Colors.amber);
  }
}
