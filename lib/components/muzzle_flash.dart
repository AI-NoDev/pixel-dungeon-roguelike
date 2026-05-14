import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Brief flash drawn at the muzzle of the player's weapon when firing.
/// Lives ~80ms then auto-removes.
class MuzzleFlash extends PositionComponent {
  MuzzleFlash({
    required Vector2 position,
    required this.angle,
    this.color = const Color(0xFFFFE082),
    this.size_ = 20,
  }) : super(
          position: position,
          anchor: Anchor.center,
        );

  @override
  // ignore: overridden_fields
  double angle;
  final Color color;
  final double size_;
  double _t = 0;
  static const double _life = 0.08;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final p = (1 - _t / _life).clamp(0.0, 1.0);
    canvas.save();
    canvas.rotate(angle);

    // Hot core
    final paint = Paint()..color = Colors.white.withValues(alpha: p);
    canvas.drawCircle(Offset.zero, 4 * p, paint);

    // Outer flame
    paint.color = color.withValues(alpha: p * 0.85);
    canvas.drawCircle(Offset(size_ * 0.3 * p, 0), 5 * p, paint);

    // Sparks (forward cone)
    final r = Random();
    paint.color = Colors.white.withValues(alpha: p);
    for (int i = 0; i < 4; i++) {
      final off = Offset(
        size_ * 0.6 * p + r.nextDouble() * 4,
        (r.nextDouble() - 0.5) * 6 * p,
      );
      canvas.drawCircle(off, 1.2, paint);
    }
    canvas.restore();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _t += dt;
    if (_t >= _life) removeFromParent();
  }
}
