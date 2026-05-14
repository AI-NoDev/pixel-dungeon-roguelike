import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'slime_base.dart';

// ============================================================
// Tier 1: Common Slimes (10 species)
// ============================================================

class GreenSlime extends SlimeBase {
  GreenSlime({required super.position, int difficulty = 1})
      : super(
          maxHp: 30 + difficulty * 5,
          speed: 60 + difficulty * 3,
          contactDamage: 10 + difficulty * 2,
          color: const Color(0xFF66BB6A),
          spriteId: 'green',
          canvasSize: 16,
        );
}

class PinkBouncer extends SlimeBase {
  PinkBouncer({required super.position, int difficulty = 1})
      : super(
          maxHp: 25 + difficulty * 4,
          speed: 100 + difficulty * 5,
          contactDamage: 8 + difficulty * 2,
          color: const Color(0xFFF48FB1),
          spriteId: 'pink',
          canvasSize: 16,
        );
}

class AcidSpitter extends SlimeBase {
  AcidSpitter({required super.position, int difficulty = 1})
      : super(
          maxHp: 20 + difficulty * 4,
          speed: 30 + difficulty * 2,
          contactDamage: 5.0 + difficulty,
          color: const Color(0xFFFFEE58),
          spriteId: 'acid',
          canvasSize: 16,
          shootInterval: 1.5,
          bulletDamage: 12,
        );
}

class BlueFrostJelly extends SlimeBase {
  BlueFrostJelly({required super.position, int difficulty = 1})
      : super(
          maxHp: 35 + difficulty * 6,
          speed: 40 + difficulty * 2,
          contactDamage: 8 + difficulty * 2,
          color: const Color(0xFF4FC3F7),
          spriteId: 'frost',
          canvasSize: 16,
        );
}

class LavaBubbler extends SlimeBase {
  LavaBubbler({required super.position, int difficulty = 1})
      : super(
          maxHp: 30 + difficulty * 5,
          speed: 50 + difficulty * 3,
          contactDamage: 12 + difficulty * 2,
          color: const Color(0xFFFF5722),
          spriteId: 'lava',
          canvasSize: 16,
        );
}

class ThunderJolt extends SlimeBase {
  ThunderJolt({required super.position, int difficulty = 1})
      : super(
          maxHp: 25 + difficulty * 4,
          speed: 130 + difficulty * 5,
          contactDamage: 10 + difficulty * 2,
          color: const Color(0xFFFFEB3B),
          spriteId: 'thunder',
          canvasSize: 16,
        );
}

class ToxicGoo extends SlimeBase {
  ToxicGoo({required super.position, int difficulty = 1})
      : super(
          maxHp: 40 + difficulty * 6,
          speed: 35 + difficulty * 2,
          contactDamage: 10 + difficulty * 2,
          color: const Color(0xFF9CCC65),
          spriteId: 'toxic',
          canvasSize: 16,
        );
}

class MegaGoo extends SlimeBase {
  MegaGoo({required super.position, int difficulty = 1})
      : super(
          maxHp: 80 + difficulty * 10,
          speed: 25 + difficulty * 2,
          contactDamage: 20 + difficulty * 3,
          color: const Color(0xFF4DB6AC),
          spriteId: 'mega',
          canvasSize: 24,
        );

  @override
  void onSlimeDeath() {
    // Split into 2 Green Slimes
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!isMounted) {
        game.world.add(GreenSlime(position: position + Vector2(-20, 0)));
        game.world.add(GreenSlime(position: position + Vector2(20, 0)));
      }
    });
  }
}

class SpikeSlime extends SlimeBase {
  SpikeSlime({required super.position, int difficulty = 1})
      : super(
          maxHp: 50 + difficulty * 8,
          speed: 50 + difficulty * 3,
          contactDamage: 15 + difficulty * 2,
          color: const Color(0xFF607D8B),
          spriteId: 'spike',
          canvasSize: 16,
        );
}

class TarSlime extends SlimeBase {
  TarSlime({required super.position, int difficulty = 1})
      : super(
          maxHp: 50 + difficulty * 7,
          speed: 25 + difficulty * 2,
          contactDamage: 8.0 + difficulty,
          color: const Color(0xFF212121),
          spriteId: 'tar',
          canvasSize: 16,
        );
}

// ============================================================
// Tier 2: Mutant Slimes (8 species)
// ============================================================

class MutantSlime extends SlimeBase {
  MutantSlime({required super.position, int difficulty = 1})
      : super(
          maxHp: 50 + difficulty * 7,
          speed: 70 + difficulty * 3,
          contactDamage: 15 + difficulty * 2,
          color: const Color(0xFFE040FB),
          spriteId: 'mutant',
          canvasSize: 16,
        );
}

class CrystallineSlime extends SlimeBase {
  CrystallineSlime({required super.position, int difficulty = 1})
      : super(
          maxHp: 100 + difficulty * 12,
          speed: 30 + difficulty * 2,
          contactDamage: 20 + difficulty * 3,
          color: const Color(0xFFB388FF),
          spriteId: 'crystal',
          canvasSize: 16,
        );

  @override
  void takeDamage(double damage, {bool isCritical = false}) {
    super.takeDamage(damage * 0.7, isCritical: isCritical); // 30% physical damage reduction
  }
}

class RegeneratingSlime extends SlimeBase {
  RegeneratingSlime({required super.position, int difficulty = 1})
      : super(
          maxHp: 60 + difficulty * 10,
          speed: 40 + difficulty * 2,
          contactDamage: 12 + difficulty * 2,
          color: const Color(0xFF69F0AE),
          spriteId: 'regen',
          canvasSize: 16,
        );

  double _regenTimer = 0;

  @override
  void update(double dt) {
    super.update(dt);
    if (isDead) return;
    _regenTimer += dt;
    if (_regenTimer >= 1.0) {
      hp = (hp + maxHp * 0.05).clamp(0, maxHp);
      _regenTimer = 0;
    }
  }
}

class BombSlime extends SlimeBase {
  BombSlime({required super.position, int difficulty = 1})
      : super(
          maxHp: 30 + difficulty * 5,
          speed: 100 + difficulty * 5,
          contactDamage: 0,  // Doesn't deal contact damage, only on explode
          color: const Color(0xFFFF5722),
          spriteId: 'bomb',
          canvasSize: 16,
        );

  @override
  void onSlimeDeath() {
    // Explode in radius
    final dist = (game.player.position - position).length;
    if (dist < 50) {
      game.player.takeDamage(35);
    }
  }
}

class CorrosiveSlime extends SlimeBase {
  CorrosiveSlime({required super.position, int difficulty = 1})
      : super(
          maxHp: 45 + difficulty * 7,
          speed: 35 + difficulty * 2,
          contactDamage: 10 + difficulty * 2,
          color: const Color(0xFF5D4037),
          spriteId: 'corrosive',
          canvasSize: 16,
        );
}

class PhantomSlime extends SlimeBase {
  PhantomSlime({required super.position, int difficulty = 1})
      : super(
          maxHp: 40 + difficulty * 6,
          speed: 80 + difficulty * 4,
          contactDamage: 12 + difficulty * 2,
          color: const Color(0xFFB39DDB),
          spriteId: 'phantom',
          canvasSize: 16,
        );

  double _stealthTimer = 0;
  bool _isStealth = false;

  @override
  void update(double dt) {
    super.update(dt);
    if (isDead) return;
    _stealthTimer += dt;
    if (_stealthTimer > (_isStealth ? 1.5 : 3.0)) {
      _isStealth = !_isStealth;
      _stealthTimer = 0;
      // Note: opacity effect would require additional sprite manipulation
    }
  }
}

class MagneticSlime extends SlimeBase {
  MagneticSlime({required super.position, int difficulty = 1})
      : super(
          maxHp: 60 + difficulty * 8,
          speed: 30 + difficulty * 2,
          contactDamage: 10 + difficulty * 2,
          color: const Color(0xFFFF6F00),
          spriteId: 'magnetic',
          canvasSize: 16,
        );

  @override
  void update(double dt) {
    super.update(dt);
    if (isDead) return;
    // Pull player slightly
    final dist = position.distanceTo(game.player.position);
    if (dist < 80 && dist > 20) {
      final dir = (position - game.player.position).normalized();
      game.player.position += dir * 20 * dt;
    }
  }
}

class RainbowSlime extends SlimeBase {
  RainbowSlime({required super.position, int difficulty = 1})
      : super(
          maxHp: 200 + difficulty * 20,
          speed: 50 + difficulty * 3,
          contactDamage: 15 + difficulty * 2,
          color: const Color(0xFFFFD700),
          spriteId: 'rainbow',
          canvasSize: 16,
        );

  @override
  void onSlimeDeath() {
    // Drop massive gold reward
    game.gameState.gold += 100;
  }
}

// ============================================================
// Tier 3: Elite Slimes & Bosses (5 species)
// ============================================================

class SlimeKnight extends SlimeBase {
  SlimeKnight({required super.position, int difficulty = 1})
      : super(
          maxHp: 200 + difficulty * 20,
          speed: 60 + difficulty * 3,
          contactDamage: 25 + difficulty * 3,
          color: const Color(0xFFC2185B),
          spriteId: 'knight',
          canvasSize: 24,
        );

  @override
  void takeDamage(double damage, {bool isCritical = false}) {
    super.takeDamage(damage * 0.5, isCritical: isCritical); // Armor reduces damage 50%
  }

  @override
  void onSlimeDeath() {
    // Summon 2 Mega Goos
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!isMounted) {
        game.world.add(MegaGoo(position: position + Vector2(-25, 0)));
        game.world.add(MegaGoo(position: position + Vector2(25, 0)));
      }
    });
  }
}

class SlimeMage extends SlimeBase {
  SlimeMage({required super.position, int difficulty = 1})
      : super(
          maxHp: 150 + difficulty * 15,
          speed: 40 + difficulty * 2,
          contactDamage: 5,
          color: const Color(0xFF6A1B9A),
          spriteId: 'mage',
          canvasSize: 24,
          shootInterval: 2.0,
          bulletDamage: 18,
        );
}

class KingsGuard extends SlimeBase {
  KingsGuard({required super.position, int difficulty = 1})
      : super(
          maxHp: 180 + difficulty * 18,
          speed: 70 + difficulty * 3,
          contactDamage: 25 + difficulty * 3,
          color: const Color(0xFF9C27B0),
          spriteId: 'guard',
          canvasSize: 24,
        );
}

class SlimeKing extends SlimeBase {
  SlimeKing({required super.position})
      : super(
          maxHp: 500,
          speed: 40,
          contactDamage: 30,
          color: const Color(0xFFFFD54F),
          spriteId: 'king',
          canvasSize: 48,
        );

  int _phase = 1;

  @override
  void update(double dt) {
    super.update(dt);
    if (isDead) return;
    final hpPercent = hp / maxHp;
    final newPhase = hpPercent > 0.7 ? 1
                   : hpPercent > 0.4 ? 2
                   : hpPercent > 0.15 ? 3
                   : 4;
    if (newPhase != _phase) {
      _phase = newPhase;
      // Phase transitions get stronger
      speed = 40 + (_phase - 1) * 15;
    }
  }

  @override
  void onSlimeDeath() {
    // Massive gold drop
    game.gameState.gold += 200;
  }
}

class AncientSlime extends SlimeBase {
  AncientSlime({required super.position})
      : super(
          maxHp: 1500,
          speed: 50,
          contactDamage: 50,
          color: const Color(0xFF80DEEA),
          spriteId: 'ancient',
          canvasSize: 60,
        );

  @override
  void onSlimeDeath() {
    // Legendary reward
    game.gameState.gold += 500;
  }
}
