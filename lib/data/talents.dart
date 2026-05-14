import 'dart:math';
import 'package:flutter/material.dart';

enum TalentCategory { offense, defense, utility }

class TalentData {
  final String id;
  final String name;
  final String description;
  final TalentCategory category;
  final Color color;
  final IconData icon;

  // Stat modifiers
  final double damageMultiplier;
  final double fireRateMultiplier;
  final double speedMultiplier;
  final double maxHpBonus;
  final double healAmount;
  final double bulletSpeedMultiplier;
  final int extraBullets;
  final double spreadReduction;

  const TalentData({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.color,
    required this.icon,
    this.damageMultiplier = 1.0,
    this.fireRateMultiplier = 1.0,
    this.speedMultiplier = 1.0,
    this.maxHpBonus = 0,
    this.healAmount = 0,
    this.bulletSpeedMultiplier = 1.0,
    this.extraBullets = 0,
    this.spreadReduction = 0,
  });
}

class TalentPool {
  static final Random _random = Random();

  static const List<TalentData> _allTalents = [
    // === OFFENSE ===
    TalentData(
      id: 'power_shot',
      name: 'Power Shot',
      description: 'Damage +25%',
      category: TalentCategory.offense,
      color: Color(0xFFEF5350),
      icon: Icons.local_fire_department,
      damageMultiplier: 1.25,
    ),
    TalentData(
      id: 'rapid_fire',
      name: 'Rapid Fire',
      description: 'Fire rate +30%',
      category: TalentCategory.offense,
      color: Color(0xFFFF7043),
      icon: Icons.speed,
      fireRateMultiplier: 1.3,
    ),
    TalentData(
      id: 'sniper_focus',
      name: 'Sniper Focus',
      description: 'Bullet speed +40%, Damage +15%',
      category: TalentCategory.offense,
      color: Color(0xFF7E57C2),
      icon: Icons.gps_fixed,
      bulletSpeedMultiplier: 1.4,
      damageMultiplier: 1.15,
    ),
    TalentData(
      id: 'multi_shot',
      name: 'Multi Shot',
      description: '+2 bullets per shot',
      category: TalentCategory.offense,
      color: Color(0xFFFFB300),
      icon: Icons.scatter_plot,
      extraBullets: 2,
    ),
    TalentData(
      id: 'precision',
      name: 'Precision',
      description: 'Reduce spread by 50%, Damage +10%',
      category: TalentCategory.offense,
      color: Color(0xFF26C6DA),
      icon: Icons.center_focus_strong,
      spreadReduction: 0.5,
      damageMultiplier: 1.1,
    ),
    TalentData(
      id: 'berserker',
      name: 'Berserker',
      description: 'Damage +50%, but Max HP -20',
      category: TalentCategory.offense,
      color: Color(0xFFD32F2F),
      icon: Icons.whatshot,
      damageMultiplier: 1.5,
      maxHpBonus: -20,
    ),

    // === DEFENSE ===
    TalentData(
      id: 'iron_skin',
      name: 'Iron Skin',
      description: 'Max HP +30',
      category: TalentCategory.defense,
      color: Color(0xFF78909C),
      icon: Icons.shield,
      maxHpBonus: 30,
    ),
    TalentData(
      id: 'regeneration',
      name: 'Regeneration',
      description: 'Heal 30 HP now',
      category: TalentCategory.defense,
      color: Color(0xFF66BB6A),
      icon: Icons.favorite,
      healAmount: 30,
    ),
    TalentData(
      id: 'vitality',
      name: 'Vitality',
      description: 'Max HP +50, Heal to full',
      category: TalentCategory.defense,
      color: Color(0xFF43A047),
      icon: Icons.health_and_safety,
      maxHpBonus: 50,
      healAmount: 999,
    ),
    TalentData(
      id: 'dodge_master',
      name: 'Dodge Master',
      description: 'Move speed +35%',
      category: TalentCategory.defense,
      color: Color(0xFF29B6F6),
      icon: Icons.directions_run,
      speedMultiplier: 1.35,
    ),

    // === UTILITY ===
    TalentData(
      id: 'swift_feet',
      name: 'Swift Feet',
      description: 'Move speed +20%',
      category: TalentCategory.utility,
      color: Color(0xFF26A69A),
      icon: Icons.directions_walk,
      speedMultiplier: 1.2,
    ),
    TalentData(
      id: 'bullet_storm',
      name: 'Bullet Storm',
      description: 'Fire rate +20%, Bullet speed +20%',
      category: TalentCategory.utility,
      color: Color(0xFF5C6BC0),
      icon: Icons.grain,
      fireRateMultiplier: 1.2,
      bulletSpeedMultiplier: 1.2,
    ),
    TalentData(
      id: 'all_rounder',
      name: 'All Rounder',
      description: 'Damage +10%, Speed +10%, HP +15',
      category: TalentCategory.utility,
      color: Color(0xFFFFCA28),
      icon: Icons.stars,
      damageMultiplier: 1.1,
      speedMultiplier: 1.1,
      maxHpBonus: 15,
    ),
  ];

  /// Get 3 random talents for player to choose from
  static List<TalentData> getRandomChoices({int count = 3}) {
    final shuffled = List<TalentData>.from(_allTalents)..shuffle(_random);
    return shuffled.take(count).toList();
  }
}
