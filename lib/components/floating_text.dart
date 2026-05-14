import 'package:flame/components.dart';
import 'package:flame/effects.dart';
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
    this.outlineColor = const Color(0xFF000000),
  }) : super(
          text: text,
          position: position,
          anchor: Anchor.center,
          textRenderer: TextPaint(
            style: TextStyle(
              color: color,
              fontSize: fontSize,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              shadows: [
                Shadow(
                  color: const Color(0xFF000000),
                  offset: const Offset(1, 1),
                  blurRadius: 0,
                ),
                Shadow(
                  color: const Color(0xFF000000),
                  offset: const Offset(-1, -1),
                  blurRadius: 0,
                ),
                Shadow(
                  color: const Color(0xFF000000),
                  offset: const Offset(1, -1),
                  blurRadius: 0,
                ),
                Shadow(
                  color: const Color(0xFF000000),
                  offset: const Offset(-1, 1),
                  blurRadius: 0,
                ),
              ],
            ),
          ),
        );

  final double duration;
  final double driftDistance;
  final Color outlineColor;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Drift upward
    add(MoveEffect.by(
      Vector2(0, -driftDistance),
      EffectController(duration: duration, curve: Curves.easeOut),
    ));

    // Fade out and remove
    add(OpacityEffect.fadeOut(
      EffectController(
        duration: duration * 0.7,
        startDelay: duration * 0.3,
      ),
      onComplete: () => removeFromParent(),
    ));
  }

  // Convenience constructors

  /// Damage to enemies (white-yellow text)
  factory FloatingText.damage(
    Vector2 position,
    double damage, {
    bool isCritical = false,
  }) {
    return FloatingText(
      text: '-${damage.toInt()}',
      position: position,
      color: isCritical
          ? const Color(0xFFFFEB3B)
          : const Color(0xFFFFFFFF),
      fontSize: isCritical ? 18 : 14,
      duration: 0.8,
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
