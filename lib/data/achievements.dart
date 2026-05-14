import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AchievementId {
  firstBlood,
  floorFive,
  floorTen,
  floorTwenty,
  bossSlayer,
  goldHoarder,
  speedRunner,
  collector,
  survivor,
  perfectRoom,
}

class Achievement {
  final AchievementId id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final int rewardGold;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.rewardGold,
  });

  static const List<Achievement> all = [
    Achievement(
      id: AchievementId.firstBlood,
      name: 'First Blood',
      description: 'Kill your first enemy',
      icon: Icons.dangerous,
      color: Color(0xFFEF5350),
      rewardGold: 10,
    ),
    Achievement(
      id: AchievementId.floorFive,
      name: 'Dungeon Diver',
      description: 'Reach floor 5',
      icon: Icons.stairs,
      color: Color(0xFF66BB6A),
      rewardGold: 50,
    ),
    Achievement(
      id: AchievementId.floorTen,
      name: 'Deep Explorer',
      description: 'Reach floor 10',
      icon: Icons.explore,
      color: Color(0xFF42A5F5),
      rewardGold: 100,
    ),
    Achievement(
      id: AchievementId.floorTwenty,
      name: 'Abyss Walker',
      description: 'Reach floor 20',
      icon: Icons.auto_awesome,
      color: Color(0xFFAB47BC),
      rewardGold: 300,
    ),
    Achievement(
      id: AchievementId.bossSlayer,
      name: 'Boss Slayer',
      description: 'Defeat your first boss',
      icon: Icons.whatshot,
      color: Color(0xFFFF7043),
      rewardGold: 75,
    ),
    Achievement(
      id: AchievementId.goldHoarder,
      name: 'Gold Hoarder',
      description: 'Earn 1000 total gold',
      icon: Icons.monetization_on,
      color: Color(0xFFFFD54F),
      rewardGold: 100,
    ),
    Achievement(
      id: AchievementId.speedRunner,
      name: 'Speed Runner',
      description: 'Clear a room in under 5 seconds',
      icon: Icons.timer,
      color: Color(0xFF26C6DA),
      rewardGold: 50,
    ),
    Achievement(
      id: AchievementId.collector,
      name: 'Collector',
      description: 'Pick up 50 items in one run',
      icon: Icons.inventory_2,
      color: Color(0xFF8D6E63),
      rewardGold: 60,
    ),
    Achievement(
      id: AchievementId.survivor,
      name: 'Survivor',
      description: 'Finish a floor with less than 10% HP',
      icon: Icons.favorite_border,
      color: Color(0xFFE91E63),
      rewardGold: 80,
    ),
    Achievement(
      id: AchievementId.perfectRoom,
      name: 'Untouchable',
      description: 'Clear a room without taking damage',
      icon: Icons.shield,
      color: Color(0xFF7C4DFF),
      rewardGold: 40,
    ),
  ];
}

class AchievementSystem {
  static const _key = 'achievements_unlocked';

  static Future<Set<AchievementId>> getUnlocked() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    return list.map((s) => AchievementId.values.firstWhere((e) => e.name == s)).toSet();
  }

  static Future<bool> unlock(AchievementId id) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    if (list.contains(id.name)) return false; // Already unlocked
    list.add(id.name);
    await prefs.setStringList(_key, list);
    return true; // Newly unlocked
  }

  static Future<void> checkAchievements({
    required int enemiesKilled,
    required int currentFloor,
    required int totalGold,
    required bool bossDefeated,
    required double hpPercent,
  }) async {
    if (enemiesKilled >= 1) await unlock(AchievementId.firstBlood);
    if (currentFloor >= 5) await unlock(AchievementId.floorFive);
    if (currentFloor >= 10) await unlock(AchievementId.floorTen);
    if (currentFloor >= 20) await unlock(AchievementId.floorTwenty);
    if (bossDefeated) await unlock(AchievementId.bossSlayer);
    if (totalGold >= 1000) await unlock(AchievementId.goldHoarder);
    if (hpPercent < 0.1 && hpPercent > 0) await unlock(AchievementId.survivor);
  }
}
