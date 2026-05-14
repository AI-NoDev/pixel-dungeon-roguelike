import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Aura ring effect (heal, buff, level up, etc.) that follows the parent.
class AuraEffect extends PositionComponent {
  AuraEffect({
    required this.color,
    this.duration = 1.0,
    this.maxRadius = 40,
    this.startRadius = 8,
    this.thickness = 2,
    this.particleCount = 8,
    super.position,
  }) : super(anchor: Anchor.center, size: Vector2.all(maxRadius * 2));

  final Color color;
  final double duration;
  final double maxRadius;
  final double startRadius;
  final double thickness;
  final int particleCount;

  double _elapsed = 0;
  double _currentRadius = 0;
  double _opacity = 1.0;
  final Paint _ringPaint = Paint();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _currentRadius = startRadius;

    // Spawn rising particles
    for (int i = 0; i < particleCount; i++) {
      final angle = (2 * pi * i / particleCount);
      add(_AuraParticle(
        color: color,
        startAngle: angle,
        radius: maxRadius * 0.5,
        duration: duration,
      ));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
    final progress = (_elapsed / duration).clamp(0.0, 1.0);
    _currentRadius = startRadius + (maxRadius - startRadius) * progress;
    _opacity = (1.0 - progress).clamp(0.0, 1.0);

    if (_elapsed >= duration) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _ringPaint
      ..color = color.withValues(alpha: _opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness;

    canvas.drawCircle(
      Offset(maxRadius, maxRadius),
      _currentRadius,
      _ringPaint,
    );
  }
}

class _AuraParticle extends PositionComponent {
  _AuraParticle({
    required this.color,
    required this.startAngle,
    required this.radius,
    required this.duration,
  }) : super(anchor: Anchor.center, size: Vector2.all(3));

  final Color color;
  final double startAngle;
  final double radius;
  final double duration;

  double _elapsed = 0;
  final Paint _paint = Paint();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Position relative to parent center
    final parentSize = (parent! as AuraEffect).size;
    position = parentSize / 2;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
    final progress = (_elapsed / duration).clamp(0.0, 1.0);

    // Move outward and upward
    final parentSize = (parent! as AuraEffect).size;
    final cx = parentSize.x / 2;
    final cy = parentSize.y / 2;
    final r = radius * progress;
    position = Vector2(
      cx + cos(startAngle) * r,
      cy + sin(startAngle) * r - 30 * progress, // upward drift
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final progress = (_elapsed / duration).clamp(0.0, 1.0);
    final alpha = (1.0 - progress).clamp(0.0, 1.0);
    _paint.color = color.withValues(alpha: alpha);
    canvas.drawCircle(Offset(0, 0), 1.5, _paint);
  }
}

/// Persistent buff aura (e.g. damage boost, speed boost) attached to player
class BuffAura extends PositionComponent {
  BuffAura({
    required this.color,
    this.duration = 5.0,
    this.radius = 20,
  }) : super(anchor: Anchor.center, size: Vector2.all(radius * 2));

  final Color color;
  final double duration;
  final double radius;

  double _elapsed = 0;
  double _pulsePhase = 0;
  final Paint _paint = Paint();

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
    _pulsePhase += dt * 3;
    if (_elapsed >= duration) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final pulse = 0.7 + sin(_pulsePhase) * 0.3;
    final alpha = (0.4 * pulse).clamp(0.0, 1.0);
    _paint
      ..color = color.withValues(alpha: alpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(Offset(radius, radius), radius * pulse, _paint);
  }
}
