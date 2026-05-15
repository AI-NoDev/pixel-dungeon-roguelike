import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';

/// Floating combat text (damage / heal / status) that drifts upward and fades.
class FloatingText extends TextComponent {
  FloatingText({
    required String text,
    required Vector2 position,
    Color color = const Color(0xFFFFFFFF),
    double fontSize = 14,
    bool bold = true,
    this.duration = 1.0,
    this.driftDistance = 30,
  })  : _color = color,
        _fontSize = fontSize,
        _bold = bold,
        super(
          text: text,
          position: position,
          anchor: Anchor.center,
        );

  final double duration;
  final double driftDistance;
  final Color _color;
  final double _fontSize;
  final bool _bold;

  double _elapsed = 0;
  late final Vector2 _startPos;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _startPos = position.clone();
    _updateRenderer(1.0);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;

    final progress = (_elapsed / duration).clamp(0.0, 1.0);

    // Drift upward (ease out)
    final easeOut = 1 - (1 - progress) * (1 - progress);
    position = _startPos + Vector2(0, -driftDistance * easeOut);

    // Fade in last 30%
    final fadeStart = 0.3;
    double alpha = 1.0;
    if (progress > fadeStart) {
      alpha = 1.0 - (progress - fadeStart) / (1.0 - fadeStart);
    }
    _maybeUpdateRenderer(alpha.clamp(0.0, 1.0));

    if (_elapsed >= duration) {
      removeFromParent();
    }
  }

  void _updateRenderer(double alpha) {
    final faded = _color.withValues(alpha: alpha);
    final shadowAlpha = (alpha * 255).round();
    final shadowColor = Color.fromARGB(shadowAlpha, 0, 0, 0);

    textRenderer = TextPaint(
      style: TextStyle(
        color: faded,
        fontSize: _fontSize,
        fontWeight: _bold ? FontWeight.bold : FontWeight.normal,
        shadows: [
          Shadow(color: shadowColor, offset: const Offset(1, 1)),
          Shadow(color: shadowColor, offset: const Offset(-1, -1)),
          Shadow(color: shadowColor, offset: const Offset(1, -1)),
          Shadow(color: shadowColor, offset: const Offset(-1, 1)),
        ],
      ),
    );
  }

  /// Throttle full TextPaint rebuilds — they recompile a Paragraph each
  /// time and dominate hot loops when many floaters are alive at once.
  double _lastPaintAlpha = -1;
  void _maybeUpdateRenderer(double alpha) {
    if ((alpha - _lastPaintAlpha).abs() < 0.05) return;
    _lastPaintAlpha = alpha;
    _updateRenderer(alpha);
  }

  // Convenience constructors

  /// Damage to enemies (orange-yellow text, red bigger for crit)
  /// Optionally tinted by element color.
  factory FloatingText.damage(
    Vector2 position,
    double damage, {
    bool isCritical = false,
    Color? elementColor,
  }) {
    Color textColor;
    if (isCritical) {
      textColor = const Color(0xFFFF1744);
    } else if (elementColor != null) {
      textColor = elementColor;
    } else {
      textColor = const Color(0xFFFFA726);
    }
    return FloatingText(
      text: isCritical ? '-${damage.toInt()}!' : '-${damage.toInt()}',
      position: position,
      color: textColor,
      fontSize: isCritical ? 22 : 14,
      duration: isCritical ? 1.0 : 0.7,
      driftDistance: isCritical ? 36 : 26,
    );
  }

  /// Damage to player (red text)
  factory FloatingText.playerDamage(
    Vector2 position,
    double damage,
  ) {
    return FloatingText(
      text: '-${damage.toInt()}',
      position: position,
      color: const Color(0xFFEF5350),
      fontSize: 16,
      duration: 0.8,
    );
  }

  /// Heal (green +text)
  factory FloatingText.heal(
    Vector2 position,
    double amount,
  ) {
    return FloatingText(
      text: '+${amount.toInt()}',
      position: position,
      color: const Color(0xFF66BB6A),
      fontSize: 16,
      duration: 1.0,
    );
  }

  /// Buff status (blue text)
  factory FloatingText.buff(
    Vector2 position,
    String label,
  ) {
    return FloatingText(
      text: label,
      position: position,
      color: const Color(0xFF4FC3F7),
      fontSize: 12,
      duration: 1.2,
    );
  }

  /// Gold pickup (yellow text)
  factory FloatingText.gold(
    Vector2 position,
    int amount,
  ) {
    return FloatingText(
      text: '+$amount',
      position: position,
      color: const Color(0xFFFFD700),
      fontSize: 12,
      duration: 0.8,
    );
  }
}
