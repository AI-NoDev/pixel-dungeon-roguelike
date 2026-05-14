import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Spawn types determine how the enemy enters the scene.
enum SpawnAnimType {
  groundEmerge,    // Rises from ground (default)
  skyDrop,         // Falls from sky
  portalAppear,    // Magic portal materialization
  shatterIn,       // Glass-shatter inward
}

/// Ground marker that warns the player where an enemy will spawn.
/// Pulses red/orange for ~1 second before the enemy appears.
class SpawnMarker extends PositionComponent {
  SpawnMarker({
    required Vector2 position,
    required this.color,
    required this.spawnAnim,
    this.duration = 1.0,
    this.radius = 18,
    required this.onComplete,
  }) : super(
          position: position,
          anchor: Anchor.center,
          size: Vector2.all(radius * 2),
        );

  final Color color;
  final SpawnAnimType spawnAnim;
  final double duration;
  final double radius;
  final void Function(Vector2 position) onComplete;

  double _elapsed = 0;
  double _pulse = 0;
  final Paint _paint = Paint();

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
    _pulse += dt * 8;
    if (_elapsed >= duration) {
      // Spawn the actual enemy at this position
      onComplete(position.clone());
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final progress = (_elapsed / duration).clamp(0.0, 1.0);
    final pulse = 0.5 + sin(_pulse) * 0.5;

    // Outer warning ring (pulses red/orange)
    _paint
      ..color = color.withValues(alpha: pulse * 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(Offset(radius, radius), radius * 0.9, _paint);

    // Inner filled circle (grows over duration)
    _paint
      ..color = color.withValues(alpha: pulse * 0.4)
      ..style = PaintingStyle.fill;
    final innerR = radius * 0.4 * progress;
    canvas.drawCircle(Offset(radius, radius), innerR, _paint);

    // Cross-hair lines
    _paint
      ..color = Colors.white.withValues(alpha: pulse * 0.6)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(radius - radius * 0.7, radius),
      Offset(radius + radius * 0.7, radius),
      _paint,
    );
    canvas.drawLine(
      Offset(radius, radius - radius * 0.7),
      Offset(radius, radius + radius * 0.7),
      _paint,
    );
  }
}

/// Animation that plays when enemy emerges (after marker fades).
class SpawnAnimation extends PositionComponent {
  SpawnAnimation({
    required Vector2 position,
    required this.color,
    required this.type,
    this.duration = 0.5,
    this.radius = 16,
  }) : super(
          position: position,
          anchor: Anchor.center,
          size: Vector2.all(radius * 4),
        );

  final Color color;
  final SpawnAnimType type;
  final double duration;
  final double radius;

  double _elapsed = 0;
  final Paint _paint = Paint();

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
    if (_elapsed >= duration) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final progress = (_elapsed / duration).clamp(0.0, 1.0);
    final cx = size.x / 2;
    final cy = size.y / 2;

    switch (type) {
      case SpawnAnimType.groundEmerge:
        _renderGroundEmerge(canvas, cx, cy, progress);
        break;
      case SpawnAnimType.skyDrop:
        _renderSkyDrop(canvas, cx, cy, progress);
        break;
      case SpawnAnimType.portalAppear:
        _renderPortal(canvas, cx, cy, progress);
        break;
      case SpawnAnimType.shatterIn:
        _renderShatter(canvas, cx, cy, progress);
        break;
    }
  }

  void _renderGroundEmerge(Canvas canvas, double cx, double cy, double progress) {
    // Brown dust cloud expanding from ground
    final dustColor = const Color(0xFF8D6E63);
    _paint
      ..color = dustColor.withValues(alpha: (1 - progress) * 0.6)
      ..style = PaintingStyle.fill;
    final r = radius * 1.5 * progress;
    canvas.drawCircle(Offset(cx, cy), r, _paint);

    // Dirt particles flying up
    for (int i = 0; i < 6; i++) {
      final angle = (2 * pi * i / 6);
      final px = cx + cos(angle) * r * 0.8;
      final py = cy + sin(angle) * r * 0.5 - progress * 8;
      _paint.color = dustColor.withValues(alpha: (1 - progress));
      canvas.drawCircle(Offset(px, py), 1.5, _paint);
    }
  }

  void _renderSkyDrop(Canvas canvas, double cx, double cy, double progress) {
    // Vertical streak from above
    _paint
      ..color = color.withValues(alpha: (1 - progress).clamp(0.0, 1.0))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final dropY = -30 + 40 * progress;
    canvas.drawLine(Offset(cx, dropY), Offset(cx, cy), _paint);

    // Impact ring at landing
    if (progress > 0.7) {
      final ringP = (progress - 0.7) / 0.3;
      _paint
        ..color = Colors.white.withValues(alpha: 1 - ringP)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(Offset(cx, cy), radius * 1.5 * ringP, _paint);
    }
  }

  void _renderPortal(Canvas canvas, double cx, double cy, double progress) {
    // Magic portal swirl
    final portalColor = color;
    for (int i = 0; i < 3; i++) {
      _paint
        ..color = portalColor.withValues(
          alpha: (1 - progress) * (1 - i * 0.3),
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      final r = radius * (1 - progress * 0.5) * (1 - i * 0.2);
      canvas.drawCircle(Offset(cx, cy), r, _paint);
    }
    // Inner core
    _paint
      ..color = Colors.white.withValues(alpha: 1 - progress)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy), radius * 0.3 * (1 - progress), _paint);
  }

  void _renderShatter(Canvas canvas, double cx, double cy, double progress) {
    // 8 shards converging inward
    _paint
      ..color = color.withValues(alpha: 1 - progress)
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 8; i++) {
      final angle = (2 * pi * i / 8);
      final dist = radius * 1.5 * (1 - progress);
      final px = cx + cos(angle) * dist;
      final py = cy + sin(angle) * dist;
      canvas.drawCircle(Offset(px, py), 2, _paint);
    }
  }
}
