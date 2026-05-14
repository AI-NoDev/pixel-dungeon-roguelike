import 'dart:math';

/// Daily challenge with fixed seed for fair competition
class DailyChallenge {
  final int seed;
  final String name;
  final List<ChallengeModifier> modifiers;
  final int bonusGoldMultiplier;

  const DailyChallenge({
    required this.seed,
    required this.name,
    required this.modifiers,
    required this.bonusGoldMultiplier,
  });

  /// Generate today's challenge based on date
  static DailyChallenge getToday() {
    final now = DateTime.now();
    final seed = now.year * 10000 + now.month * 100 + now.day;
    final random = Random(seed);

    // Pick 2-3 random modifiers
    final allMods = List<ChallengeModifier>.from(ChallengeModifier.values);
    allMods.shuffle(random);
    final modCount = 2 + random.nextInt(2);
    final mods = allMods.take(modCount).toList();

    // Generate name
    final names = [
      'Gauntlet of Pain',
      'Speed Demon',
      'Glass Cannon',
      'Bullet Hell',
      'Endurance Test',
      'Chaos Run',
      'Iron Will',
      'Berserker Mode',
    ];
    final name = names[random.nextInt(names.length)];

    return DailyChallenge(
      seed: seed,
      name: name,
      modifiers: mods,
      bonusGoldMultiplier: 2 + mods.length,
    );
  }
}

enum ChallengeModifier {
  doubleEnemies,      // 2x enemy count
  halfHp,            // Player starts with 50% HP
  noHealing,         // Can't heal
  fastEnemies,       // Enemies move 50% faster
  eliteOnly,         // All rooms are elite
  noWeaponDrops,     // No weapon pickups
  oneHitKill,        // Enemies die in one hit but deal 3x damage
  timerMode,         // Must clear rooms within time limit
}

extension ChallengeModifierExt on ChallengeModifier {
  String get displayName {
    switch (this) {
      case ChallengeModifier.doubleEnemies:
        return 'Double Enemies';
      case ChallengeModifier.halfHp:
        return 'Half HP';
      case ChallengeModifier.noHealing:
        return 'No Healing';
      case ChallengeModifier.fastEnemies:
        return 'Fast Enemies';
      case ChallengeModifier.eliteOnly:
        return 'All Elite';
      case ChallengeModifier.noWeaponDrops:
        return 'No Weapons';
      case ChallengeModifier.oneHitKill:
        return 'Glass Cannon';
      case ChallengeModifier.timerMode:
        return 'Speed Run';
    }
  }

  String get description {
    switch (this) {
      case ChallengeModifier.doubleEnemies:
        return 'Twice as many enemies spawn';
      case ChallengeModifier.halfHp:
        return 'Start with 50% max HP';
      case ChallengeModifier.noHealing:
        return 'Cannot heal during the run';
      case ChallengeModifier.fastEnemies:
        return 'Enemies move 50% faster';
      case ChallengeModifier.eliteOnly:
        return 'All combat rooms are elite';
      case ChallengeModifier.noWeaponDrops:
        return 'No weapon drops from enemies';
      case ChallengeModifier.oneHitKill:
        return 'One-hit kills but take 3x damage';
      case ChallengeModifier.timerMode:
        return 'Clear each room within 30 seconds';
    }
  }
}
