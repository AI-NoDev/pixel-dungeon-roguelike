import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Simple particle effect system
class ParticleSystem {
  static void spawnHitEffect(Component parent, Vector2 position, Color color) {
    for (int i = 0; i < 6; i++) {
      final particle = _Particle(
        position: position.clone(),
        color: color,
        velocity: Vector2(
          (Random().nextDouble() - 0.5) * 200,
          (Random().nextDouble() - 0.5) * 200,
        ),
        lifetime: 0.3 + Random().nextDouble() * 0.2,
        particleSize: 2 + Random().nextDouble() * 3,
      );
      parent.add(particle);
    }
  }

  static void spawnDeathEffect(Component parent, Vector2 position, Color color) {
    for (int i = 0; i < 12; i++) {
      final angle = (2 * pi / 12) * i;
      final speed = 80 + Random().nextDouble() * 120;
      final particle = _Particle(
        position: position.clone(),
        color: color,
        velocity: Vector2(cos(angle) * speed, sin(angle) * speed),
        lifetime: 0.4 + Random().nextDouble() * 0.3,
        particleSize: 3 + Random().nextDouble() * 4,
      );
      parent.add(particle);
    }
  }

  static void spawnPickupEffect(Component parent, Vector2 position, Color color) {
    for (int i = 0; i < 8; i++) {
      final angle = (2 * pi / 8) * i;
      final particle = _Particle(
        position: position.clone(),
        color: color,
        velocity: Vector2(cos(angle) * 60, sin(angle) * 60 - 50),
        lifetime: 0.5,
        particleSize: 2 + Random().nextDouble() * 2,
        fadeOut: true,
      );
      parent.add(particle);
    }
  }

  static void spawnBossPhaseEffect(Component parent, Vector2 position, Color color) {
    for (int i = 0; i < 20; i++) {
      final angle = (2 * pi / 20) * i;
      final speed = 100 + Random().nextDouble() * 150;
      final particle = _Particle(
        position: position.clone(),
        color: color,
        velocity: Vector2(cos(angle) * speed, sin(angle) * speed),
        lifetime: 0.6 + Random().nextDouble() * 0.4,
        particleSize: 4 + Random().nextDouble() * 4,
        fadeOut: true,
      );
      parent.add(particle);
    }
  }
}

class _Particle extends PositionComponent {
  _Particle({
    required Vector2 position,
    required this.color,
    required this.velocity,
    required this.lifetime,
    required this.particleSize,
    this.fadeOut = false,
  }) : _remainingLife = lifetime,
       super(position: position, size: Vector2.all(particleSize));

  final Color color;
  final Vector2 velocity;
  final double lifetime;
  final double particleSize;
  final bool fadeOut;
  double _remainingLife;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleComponent(
      radius: particleSize / 2,
      paint: Paint()..color = color,
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
    velocity.scale(0.95); // friction
    _remainingLife -= dt;

    if (fadeOut) {
      final alpha = (_remainingLife / lifetime).clamp(0.0, 1.0);
      children.whereType<CircleComponent>().forEach((c) {
        c.paint.color = color.withValues(alpha: alpha);
      });
    }

    if (_remainingLife <= 0) {
      removeFromParent();
    }
  }
}
