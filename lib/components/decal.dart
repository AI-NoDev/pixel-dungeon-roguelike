import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Persistent ground decal (corpse, bullet hole, slime puddle, etc.)
/// Stays on the floor for the duration of the room.
class Decal extends PositionComponent {
  Decal({
    required Vector2 position,
    required this.type,
    required this.color,
    this.size_ = 16,
    this.lifetime,  // null = permanent
    int priority = -1, // render below entities
  }) : super(
          position: position,
          anchor: Anchor.center,
          size: Vector2.all(size_.toDouble()),
          priority: priority,
        );

  final DecalType type;
  final Color color;
  final int size_;
  final double? lifetime;

  double _elapsed = 0;
  final Paint _paint = Paint();
  final Random _random = Random();
  late final List<Offset> _splatPoints;
  late final double _rotation;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _rotation = _random.nextDouble() * 6.28;
    _splatPoints = _generateSplatPoints();
  }

  List<Offset> _generateSplatPoints() {
    final points = <Offset>[];
    final count = type == DecalType.slimePuddle ? 6 : 4;
    final maxR = size_ * 0.4;
    for (int i = 0; i < count; i++) {
      final angle = _random.nextDouble() * 6.28;
      final r = _random.nextDouble() * maxR;
      points.add(Offset(cos(angle) * r, sin(angle) * r));
    }
    return points;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (lifetime != null) {
      _elapsed += dt;
      if (_elapsed >= lifetime!) {
        removeFromParent();
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Fade if has lifetime
    final alpha = lifetime == null
        ? 1.0
        : (1.0 - _elapsed / lifetime!).clamp(0.0, 1.0);

    final cx = size.x / 2;
    final cy = size.y / 2;

    switch (type) {
      case DecalType.bulletHole:
        _renderBulletHole(canvas, cx, cy, alpha);
        break;
      case DecalType.slimePuddle:
        _renderSlimePuddle(canvas, cx, cy, alpha);
        break;
      case DecalType.corpse:
        _renderCorpse(canvas, cx, cy, alpha);
        break;
      case DecalType.bloodSplat:
        _renderBloodSplat(canvas, cx, cy, alpha);
        break;
      case DecalType.scorch:
        _renderScorch(canvas, cx, cy, alpha);
        break;
    }
  }

  void _renderBulletHole(Canvas c, double cx, double cy, double alpha) {
    // Small dark dot with crack pattern
    _paint.color = Colors.black.withValues(alpha: alpha * 0.7);
    _paint.style = PaintingStyle.fill;
    c.drawCircle(Offset(cx, cy), 2, _paint);

    // Cracks
    _paint.color = Colors.black.withValues(alpha: alpha * 0.4);
    _paint.style = PaintingStyle.stroke;
    _paint.strokeWidth = 1;
    for (int i = 0; i < 4; i++) {
      final angle = _rotation + (i * pi / 2);
      c.drawLine(
        Offset(cx, cy),
        Offset(cx + cos(angle) * 4, cy + sin(angle) * 4),
        _paint,
      );
    }
  }

  void _renderSlimePuddle(Canvas c, double cx, double cy, double alpha) {
    // Multi-blob splat
    _paint.style = PaintingStyle.fill;
    _paint.color = color.withValues(alpha: alpha * 0.5);
    // Main body
    c.drawCircle(Offset(cx, cy), size_ * 0.35, _paint);
    // Blobs around
    _paint.color = color.withValues(alpha: alpha * 0.4);
    for (final p in _splatPoints) {
      c.drawCircle(Offset(cx + p.dx, cy + p.dy), 2 + _random.nextDouble(), _paint);
    }
    // Highlight
    _paint.color = Colors.white.withValues(alpha: alpha * 0.3);
    c.drawCircle(Offset(cx - 2, cy - 2), 1.5, _paint);
  }

  void _renderCorpse(Canvas c, double cx, double cy, double alpha) {
    // Flattened body shape (oval)
    _paint.style = PaintingStyle.fill;
    _paint.color = color.withValues(alpha: alpha * 0.6);

    final rect = Rect.fromCenter(
      center: Offset(cx, cy),
      width: size_ * 0.7,
      height: size_ * 0.4,
    );
    c.drawOval(rect, _paint);

    // Darker shadow
    _paint.color = Colors.black.withValues(alpha: alpha * 0.3);
    c.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + 1), width: size_ * 0.5, height: size_ * 0.2),
      _paint,
    );
  }

  void _renderBloodSplat(Canvas c, double cx, double cy, double alpha) {
    // Red splat marks
    _paint.style = PaintingStyle.fill;
    _paint.color = const Color(0xFF7F0000).withValues(alpha: alpha * 0.5);
    c.drawCircle(Offset(cx, cy), size_ * 0.3, _paint);
    for (final p in _splatPoints) {
      c.drawCircle(Offset(cx + p.dx, cy + p.dy), 1.5, _paint);
    }
  }

  void _renderScorch(Canvas c, double cx, double cy, double alpha) {
    // Black burn mark
    _paint.style = PaintingStyle.fill;
    _paint.color = Colors.black.withValues(alpha: alpha * 0.6);
    c.drawCircle(Offset(cx, cy), size_ * 0.4, _paint);
    // Inner darker
    _paint.color = Colors.black.withValues(alpha: alpha * 0.85);
    c.drawCircle(Offset(cx, cy), size_ * 0.2, _paint);
  }
}

enum DecalType {
  bulletHole,    // Wall/ground bullet impact
  slimePuddle,   // Slime death residue
  corpse,        // Generic enemy corpse
  bloodSplat,    // Player/enemy hit splatter
  scorch,        // Fire/explosion burn mark
}
