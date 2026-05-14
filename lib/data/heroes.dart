import 'package:flutter/material.dart';

enum HeroType { knight, ranger, mage, rogue }

class HeroData {
  final HeroType type;
  final String name;
  final String description;
  final double maxHp;
  final double speed;
  final double damage;
  final double fireRate;
  final Color color;
  final String skill;
  final String skillDescription;
  final int unlockCost; // gold needed to unlock

  const HeroData({
    required this.type,
    required this.name,
    required this.description,
    required this.maxHp,
    required this.speed,
    required this.damage,
    required this.fireRate,
    required this.color,
    required this.skill,
    required this.skillDescription,
    required this.unlockCost,
  });

  static const List<HeroData> all = [knight, ranger, mage, rogue];

  static const knight = HeroData(
    type: HeroType.knight,
    name: 'Knight',
    description: 'Balanced warrior with high HP',
    maxHp: 120,
    speed: 140,
    damage: 20,
    fireRate: 3.0,
    color: Color(0xFF4FC3F7),
    skill: 'Shield Bash',
    skillDescription: 'Knockback nearby enemies and block damage for 2s',
    unlockCost: 0, // starter hero
  );

  static const ranger = HeroData(
    type: HeroType.ranger,
    name: 'Ranger',
    description: 'Fast shooter with high fire rate',
    maxHp: 80,
    speed: 170,
    damage: 15,
    fireRate: 5.0,
    color: Color(0xFF66BB6A),
    skill: 'Arrow Rain',
    skillDescription: 'Rain arrows in an area for 3s',
    unlockCost: 200,
  );

  static const mage = HeroData(
    type: HeroType.mage,
    name: 'Mage',
    description: 'High damage, low HP, elemental attacks',
    maxHp: 70,
    speed: 130,
    damage: 35,
    fireRate: 1.8,
    color: Color(0xFFCE93D8),
    skill: 'Nova Blast',
    skillDescription: 'Explode all nearby enemies with arcane energy',
    unlockCost: 500,
  );

  static const rogue = HeroData(
    type: HeroType.rogue,
    name: 'Rogue',
    description: 'Very fast, critical hits, fragile',
    maxHp: 60,
    speed: 200,
    damage: 25,
    fireRate: 4.0,
    color: Color(0xFFFFB74D),
    skill: 'Shadow Step',
    skillDescription: 'Become invisible and gain +50% speed for 3s',
    unlockCost: 800,
  );
}
