import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game/pixel_dungeon_game.dart';
import '../data/weapons.dart';
import '../systems/element_system.dart';
import '../systems/audio_system.dart';
import 'enemy_spawner.dart';
import 'floating_text.dart';

/// Visual + damage arc for a melee weapon swing.
///
/// When the player attacks with a melee weapon, this component is spawned
/// at the player's position. It:
/// 1. Renders a sweeping arc (the weapon trail).
/// 2. On the first frame, finds all enemies within the arc and deals damage.
/// 3. Self-removes after the animation completes (~0.2s).
///
/// No bullet is created — the swing IS the attack.
class MeleeSwing extends PositionComponent
    with HasGameReference<PixelDungeonGame> {
  MeleeSwing({
    required Vector2 position,
    required this.aimAngle,
    required this.weapon,
    required this.damage,
    required this.isCritical,
  }) : super(position: position, anchor: Anchor.center);

  final double aimAngle;
  final WeaponData weapon;
  final double damage;
  final bool isCritical;

  static const double _duration = 0.2;
  double _t = 0;
  bool _hitApplied = false;
  final Paint _paint = Paint();

  @override
  void update(double dt) {
    super.update(dt);
    _t += dt;

    // Apply damage on first tick (so it's instant on attack press).
    if (!_hitApplied) {
      _hitApplied = true;
      _applyDamage();
    }

    if (_t >= _duration) removeFromParent();
  }

  void _applyDamage() {
    final range = weapon.meleeRange;
    final halfArc = weapon.meleeArc / 2;
    final rangeSq = range * range;

    for (final c in game.world.children) {
      if (c is Enemy && !c.isDead) {
        final dx = c.position.x - position.x;
        final dy = c.position.y - position.y;
        final distSq = dx * dx + dy * dy;
        if (distSq > rangeSq) continue;

        // Check if enemy is within the swing arc.
        final angleToEnemy = atan2(dy, dx);
        var diff = (angleToEnemy - aimAngle) % (2 * pi);
        if (diff > pi) diff -= 2 * pi;
        if (diff.abs() > halfArc) continue;

        // Hit!
        c.takeDamage(damage, isCritical: isCritical);
        if (weapon.element != ElementType.none) {
          ElementSystem.applyElement(game, c, weapon.element, damage);
        }
      }
    }

    // SFX
    AudioSystem.playShoot('heavy');
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final progress = (_t / _duration).clamp(0.0, 1.0);
    final alpha = (1.0 - progress);
    final range = weapon.meleeRange;
    final halfArc = weapon.meleeArc / 2;

    // Draw the swing arc trail.
    _paint
      ..color = weapon.color.withValues(alpha: alpha * 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6 * (1 - progress * 0.5);

    // Sweep from startAngle to endAngle.
    final sweepStart = aimAngle - halfArc + halfArc * 2 * progress * 0.3;
    final sweepEnd = weapon.meleeArc * (0.7 + 0.3 * progress);
    final rect = Rect.fromCircle(center: Offset.zero, radius: range * (0.5 + 0.5 * progress));
    canvas.drawArc(rect, sweepStart, sweepEnd, false, _paint);

    // Inner brighter arc.
    _paint
      ..color = Colors.white.withValues(alpha: alpha * 0.5)
      ..strokeWidth = 3;
    final innerRect = Rect.fromCircle(center: Offset.zero, radius: range * 0.4 * (0.5 + 0.5 * progress));
    canvas.drawArc(innerRect, sweepStart, sweepEnd, false, _paint);
  }
}
