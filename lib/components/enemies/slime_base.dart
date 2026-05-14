import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../game/pixel_dungeon_game.dart';
import '../../systems/particle_system.dart';
import '../enemy_spawner.dart';

/// Base class for all slime variants
/// Provides bouncing animation and slime-specific behaviors
abstract class SlimeBase extends Enemy {
  SlimeBase({
    required super.position,
    required super.maxHp,
    required super.speed,
    required super.contactDamage,
    required super.color,
    super.shootInterval,
    super.bulletDamage,
  });

  // Bouncing animation
  double _bounceTimer = 0;
  double _bounceOffset = 0;
  double get bounceFrequency => 4.0;

  // Color palette
  Color get highlightColor => _lighten(color, 0.3);
  Color get shadowColor => _darken(color, 0.4);

  // Optional slime body
  RectangleComponent? slimeShadow;
  RectangleComponent? slimeHighlight;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Replace simple body with slime-shaped visual
    body.removeFromParent();

    // Shadow at bottom (small dark oval)
    slimeShadow = RectangleComponent(
      size: Vector2(18, 4),
      position: Vector2(3, 18),
      paint: Paint()..color = Colors.black.withValues(alpha: 0.3),
    );
    add(slimeShadow!);

    // Main body (slime shape)
    body = RectangleComponent(
      size: Vector2(20, 16),
      position: Vector2(2, 6),
      paint: Paint()..color = color,
    );
    add(body);

    // Highlight (top-left, gives it a glossy 3D look)
    slimeHighlight = RectangleComponent(
      size: Vector2(6, 4),
      position: Vector2(5, 8),
      paint: Paint()..color = highlightColor,
    );
    add(slimeHighlight!);

    // Eyes
    add(RectangleComponent(
      size: Vector2(2, 2),
      position: Vector2(8, 12),
      paint: Paint()..color = Colors.black,
    ));
    add(RectangleComponent(
      size: Vector2(2, 2),
      position: Vector2(14, 12),
      paint: Paint()..color = Colors.black,
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isDead) return;

    // Bouncing animation
    _bounceTimer += dt * bounceFrequency;
    _bounceOffset = (sin(_bounceTimer).abs()) * 3;
    if (slimeHighlight != null) {
      slimeHighlight!.position = Vector2(5, 8 - _bounceOffset * 0.3);
    }
    body.position = Vector2(2, 6 - _bounceOffset * 0.5);
  }

  /// Override for slime-specific death effects
  void onSlimeDeath() {}

  @override
  void _onDeath() {
    onSlimeDeath();
    super._onDeath();
  }

  static Color _lighten(Color c, double amount) {
    final hsl = HSLColor.fromColor(c);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  static Color _darken(Color c, double amount) {
    final hsl = HSLColor.fromColor(c);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }
}

/// Helper to spawn particles
extension SlimeParticles on SlimeBase {
  void spawnSlimeDeathParticles({Color? customColor, int count = 12}) {
    ParticleSystem.spawnDeathEffect(
      game.world,
      position,
      customColor ?? color,
    );
  }
}
