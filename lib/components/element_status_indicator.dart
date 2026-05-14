import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../data/weapons.dart';

/// Visual indicator for elemental status effects on entities.
/// Floats above the entity showing fire/ice/lightning/poison status.
class ElementStatusIndicator extends PositionComponent {
  ElementStatusIndicator({
    required this.element,
    required this.duration,
    super.position,
  }) : super(anchor: Anchor.center, size: Vector2(20, 8));

  final ElementType element;
  final double duration;

  double _elapsed = 0;
  double _pulsePhase = 0;
  final Paint _paint = Paint();

  Color get _statusColor {
    switch (element) {
      case ElementType.fire:
        return const Color(0xFFFF6F00);
      case ElementType.ice:
        return const Color(0xFF4FC3F7);
      case ElementType.lightning:
        return const Color(0xFFFFEB3B);
      case ElementType.poison:
        return const Color(0xFF76FF03);
      case ElementType.none:
        return Colors.white;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
    _pulsePhase += dt * 6;
    if (_elapsed >= duration) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final progress = _elapsed / duration;
    final alpha = (1.0 - progress * 0.3).clamp(0.0, 1.0);
    final pulse = 0.7 + sin(_pulsePhase) * 0.3;

    // Draw status icon based on element
    switch (element) {
      case ElementType.fire:
        _drawFire(canvas, alpha, pulse);
        break;
      case ElementType.ice:
        _drawIce(canvas, alpha, pulse);
        break;
      case ElementType.lightning:
        _drawLightning(canvas, alpha, pulse);
        break;
      case ElementType.poison:
        _drawPoison(canvas, alpha, pulse);
        break;
      case ElementType.none:
        break;
    }
  }

  void _drawFire(Canvas canvas, double alpha, double pulse) {
    // Triangular flame shape
    _paint.color = _statusColor.withValues(alpha: alpha * pulse);
    _paint.style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(10, 0)
      ..lineTo(14, 4)
      ..lineTo(12, 6)
      ..lineTo(10, 4)
      ..lineTo(8, 6)
      ..lineTo(6, 4)
      ..close();
    canvas.drawPath(path, _paint);

    // Inner highlight
    _paint.color = Colors.white.withValues(alpha: alpha * 0.6);
    canvas.drawCircle(const Offset(10, 4), 1, _paint);
  }

  void _drawIce(Canvas canvas, double alpha, double pulse) {
    // Snowflake / ice crystal
    _paint.color = _statusColor.withValues(alpha: alpha * pulse);
    _paint.style = PaintingStyle.stroke;
    _paint.strokeWidth = 1.5;

    // Cross lines
    canvas.drawLine(const Offset(6, 4), const Offset(14, 4), _paint);
    canvas.drawLine(const Offset(10, 0), const Offset(10, 8), _paint);
    canvas.drawLine(const Offset(7, 1), const Offset(13, 7), _paint);
    canvas.drawLine(const Offset(7, 7), const Offset(13, 1), _paint);

    // Center
    _paint.style = PaintingStyle.fill;
    _paint.color = Colors.white.withValues(alpha: alpha);
    canvas.drawCircle(const Offset(10, 4), 1, _paint);
  }

  void _drawLightning(Canvas canvas, double alpha, double pulse) {
    // Lightning bolt zigzag
    _paint.color = _statusColor.withValues(alpha: alpha);
    _paint.style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(11, 0)
      ..lineTo(7, 4)
      ..lineTo(10, 4)
      ..lineTo(8, 8)
      ..lineTo(13, 3)
      ..lineTo(10, 3)
      ..lineTo(13, 0)
      ..close();
    canvas.drawPath(path, _paint);

    // Glow
    _paint.color = Colors.white.withValues(alpha: alpha * pulse * 0.5);
    canvas.drawCircle(const Offset(10, 4), 5, _paint);
  }

  void _drawPoison(Canvas canvas, double alpha, double pulse) {
    // Bubbling poison drops
    _paint.color = _statusColor.withValues(alpha: alpha);
    _paint.style = PaintingStyle.fill;

    canvas.drawCircle(const Offset(10, 4), 2, _paint);
    canvas.drawCircle(Offset(7, 2 + pulse), 1, _paint);
    canvas.drawCircle(Offset(13, 6 - pulse), 1, _paint);

    // Poison skull pattern (eyes)
    _paint.color = const Color(0xFF1B5E20).withValues(alpha: alpha);
    canvas.drawCircle(const Offset(9, 3), 0.5, _paint);
    canvas.drawCircle(const Offset(11, 3), 0.5, _paint);
  }
}
