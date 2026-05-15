import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Lightweight particle effects.
///
/// Each "burst" is rendered as a single PositionComponent that owns N
/// particles and draws them all in one render() pass. Avoids creating
/// CircleComponents-per-particle which was producing 60-120 components
/// per kill and dragging down the renderer.
class ParticleSystem {
  static void spawnHitEffect(Component parent, Vector2 position, Color color) {
    parent.add(_ParticleBurst(
      position: position.clone(),
      color: color,
      count: 5,
      speed: 200,
      lifetime: 0.35,
      sizePx: 2.5,
      randomDirections: true,
    ));
  }

  static void spawnDeathEffect(Component parent, Vector2 position, Color color) {
    parent.add(_ParticleBurst(
      position: position.clone(),
      color: color,
      count: 8,
      speed: 140,
      lifetime: 0.55,
      sizePx: 3.5,
      randomDirections: false,
    ));
  }

  static void spawnPickupEffect(Component parent, Vector2 position, Color color) {
    parent.add(_ParticleBurst(
      position: position.clone(),
      color: color,
      count: 6,
      speed: 90,
      lifetime: 0.5,
      sizePx: 2,
      upwardBias: -50,
      fadeOut: true,
      randomDirections: false,
    ));
  }

  static void spawnBossPhaseEffect(Component parent, Vector2 position, Color color) {
    parent.add(_ParticleBurst(
      position: position.clone(),
      color: color,
      count: 14,
      speed: 200,
      lifetime: 0.8,
      sizePx: 4,
      fadeOut: true,
      randomDirections: false,
    ));
  }
}

class _ParticleBurst extends PositionComponent {
  _ParticleBurst({
    required Vector2 position,
    required this.color,
    required this.count,
    required this.speed,
    required this.lifetime,
    required this.sizePx,
    this.fadeOut = false,
    this.upwardBias = 0,
    this.randomDirections = true,
  }) : super(position: position);

  final Color color;
  final int count;
  final double speed;
  final double lifetime;
  final double sizePx;
  final bool fadeOut;
  final double upwardBias;
  final bool randomDirections;

  late final List<Vector2> _offsets;
  late final List<Vector2> _vels;
  final Paint _paint = Paint();
  double _t = 0;
  static final Random _rng = Random();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _offsets = [];
    _vels = [];
    for (int i = 0; i < count; i++) {
      double a;
      double s;
      if (randomDirections) {
        a = _rng.nextDouble() * 2 * pi;
        s = speed * (0.5 + _rng.nextDouble() * 0.5);
      } else {
        a = (2 * pi / count) * i;
        s = speed * (0.7 + _rng.nextDouble() * 0.3);
      }
      _offsets.add(Vector2.zero());
      _vels.add(Vector2(cos(a) * s, sin(a) * s + upwardBias));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _t += dt;
    for (int i = 0; i < _offsets.length; i++) {
      _offsets[i] += _vels[i] * dt;
      _vels[i].scale(0.92);
    }
    if (_t >= lifetime) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final p = (1 - _t / lifetime).clamp(0.0, 1.0);
    final alpha = fadeOut ? p : 1.0;
    _paint.color = color.withValues(alpha: alpha);
    final r = sizePx;
    for (final o in _offsets) {
      canvas.drawCircle(Offset(o.x, o.y), r, _paint);
    }
  }
}
