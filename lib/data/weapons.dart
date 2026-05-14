import 'dart:math';
import 'package:flutter/material.dart';

enum WeaponRarity { common, uncommon, rare, epic, legendary }

enum WeaponType {
  pistol,
  shotgun,
  rifle,
  smg,
  sniper,
  magic,
  laser,      // 激光枪 - 持续光束
  rocket,     // 火箭弹 - 爆炸AoE
  knife,      // 飞刀 - 高速旋转
  bow,        // 弓箭 - 高暴击
  crossbow,   // 弩 - 强穿透
}

enum ElementType { none, fire, ice, lightning, poison, holy, dark }

class WeaponData {
  final String name;
  final WeaponType type;
  final WeaponRarity rarity;
  final ElementType element;
  final double damage;
  final double fireRate; // shots per second
  final double bulletSpeed;
  final int bulletsPerShot;
  final double spread; // angle in radians
  final double range;
  final Color color;
  final String spriteId;  // matches assets/images/weapons/weapon_<id>.png

  const WeaponData({
    required this.name,
    required this.type,
    required this.rarity,
    this.element = ElementType.none,
    required this.damage,
    required this.fireRate,
    required this.bulletSpeed,
    this.bulletsPerShot = 1,
    this.spread = 0,
    this.range = 3.0,
    required this.color,
    required this.spriteId,
  });

  double get attackInterval => 1.0 / fireRate;

  Color get rarityColor {
    switch (rarity) {
      case WeaponRarity.common:
        return const Color(0xFFBDBDBD);
      case WeaponRarity.uncommon:
        return const Color(0xFF66BB6A);
      case WeaponRarity.rare:
        return const Color(0xFF42A5F5);
      case WeaponRarity.epic:
        return const Color(0xFFAB47BC);
      case WeaponRarity.legendary:
        return const Color(0xFFFFD54F);
    }
  }

  String get rarityName {
    switch (rarity) {
      case WeaponRarity.common:
        return 'Common';
      case WeaponRarity.uncommon:
        return 'Uncommon';
      case WeaponRarity.rare:
        return 'Rare';
      case WeaponRarity.epic:
        return 'Epic';
      case WeaponRarity.legendary:
        return 'Legendary';
    }
  }
}

/// Weapon pool for random drops
class WeaponPool {
  static final Random _random = Random();

  static final List<WeaponData> _weapons = [
    // === PISTOLS ===
    const WeaponData(
      name: 'Iron Pistol',
      type: WeaponType.pistol,
      rarity: WeaponRarity.common,
      damage: 15,
      fireRate: 3,
      bulletSpeed: 320,
      color: Color(0xFFBDBDBD),
      spriteId: 'iron_pistol',
    ),
    const WeaponData(
      name: 'Flame Pistol',
      type: WeaponType.pistol,
      rarity: WeaponRarity.uncommon,
      element: ElementType.fire,
      damage: 18,
      fireRate: 3,
      bulletSpeed: 320,
      color: Color(0xFFFF7043),
      spriteId: 'flame_pistol',
    ),
    const WeaponData(
      name: 'Frost Revolver',
      type: WeaponType.pistol,
      rarity: WeaponRarity.rare,
      element: ElementType.ice,
      damage: 22,
      fireRate: 2.5,
      bulletSpeed: 300,
      color: Color(0xFF4FC3F7),
      spriteId: 'frost_revolver',
    ),

    // === SHOTGUNS ===
    const WeaponData(
      name: 'Rusty Shotgun',
      type: WeaponType.shotgun,
      rarity: WeaponRarity.common,
      damage: 8,
      fireRate: 1.2,
      bulletSpeed: 280,
      bulletsPerShot: 5,
      spread: 0.4,
      range: 2.0,
      color: Color(0xFF8D6E63),
      spriteId: 'rusty_shotgun',
    ),
    const WeaponData(
      name: 'Thunder Scatter',
      type: WeaponType.shotgun,
      rarity: WeaponRarity.rare,
      element: ElementType.lightning,
      damage: 12,
      fireRate: 1.5,
      bulletSpeed: 300,
      bulletsPerShot: 7,
      spread: 0.35,
      range: 2.2,
      color: Color(0xFFFFEB3B),
      spriteId: 'thunder_scatter',
    ),
    const WeaponData(
      name: 'Dragon Breath',
      type: WeaponType.shotgun,
      rarity: WeaponRarity.epic,
      element: ElementType.fire,
      damage: 15,
      fireRate: 1.8,
      bulletSpeed: 260,
      bulletsPerShot: 9,
      spread: 0.5,
      range: 1.8,
      color: Color(0xFFFF5722),
      spriteId: 'dragon_breath',
    ),

    // === RIFLES ===
    const WeaponData(
      name: 'Hunter Rifle',
      type: WeaponType.rifle,
      rarity: WeaponRarity.common,
      damage: 25,
      fireRate: 2,
      bulletSpeed: 400,
      color: Color(0xFF795548),
      spriteId: 'hunter_rifle',
    ),
    const WeaponData(
      name: 'Poison Rifle',
      type: WeaponType.rifle,
      rarity: WeaponRarity.uncommon,
      element: ElementType.poison,
      damage: 20,
      fireRate: 2.2,
      bulletSpeed: 380,
      color: Color(0xFF9CCC65),
      spriteId: 'poison_rifle',
    ),

    // === SMG ===
    const WeaponData(
      name: 'Rapid Blaster',
      type: WeaponType.smg,
      rarity: WeaponRarity.common,
      damage: 8,
      fireRate: 8,
      bulletSpeed: 350,
      spread: 0.15,
      color: Color(0xFF78909C),
      spriteId: 'rapid_blaster',
    ),
    const WeaponData(
      name: 'Lightning SMG',
      type: WeaponType.smg,
      rarity: WeaponRarity.rare,
      element: ElementType.lightning,
      damage: 10,
      fireRate: 10,
      bulletSpeed: 380,
      spread: 0.12,
      color: Color(0xFF7C4DFF),
      spriteId: 'lightning_smg',
    ),
    const WeaponData(
      name: 'Void Sprayer',
      type: WeaponType.smg,
      rarity: WeaponRarity.epic,
      element: ElementType.poison,
      damage: 12,
      fireRate: 12,
      bulletSpeed: 360,
      spread: 0.1,
      color: Color(0xFF6A1B9A),
      spriteId: 'void_sprayer',
    ),

    // === SNIPER ===
    const WeaponData(
      name: 'Long Bow',
      type: WeaponType.sniper,
      rarity: WeaponRarity.uncommon,
      damage: 50,
      fireRate: 0.8,
      bulletSpeed: 500,
      color: Color(0xFF4E342E),
      spriteId: 'long_bow',
    ),
    const WeaponData(
      name: 'Ice Piercer',
      type: WeaponType.sniper,
      rarity: WeaponRarity.epic,
      element: ElementType.ice,
      damage: 70,
      fireRate: 0.7,
      bulletSpeed: 550,
      color: Color(0xFF00BCD4),
      spriteId: 'ice_piercer',
    ),

    // === MAGIC ===
    const WeaponData(
      name: 'Arcane Staff',
      type: WeaponType.magic,
      rarity: WeaponRarity.uncommon,
      damage: 30,
      fireRate: 1.5,
      bulletSpeed: 250,
      color: Color(0xFFE040FB),
      spriteId: 'arcane_staff',
    ),
    const WeaponData(
      name: 'Inferno Wand',
      type: WeaponType.magic,
      rarity: WeaponRarity.rare,
      element: ElementType.fire,
      damage: 35,
      fireRate: 1.8,
      bulletSpeed: 270,
      color: Color(0xFFFF6E40),
      spriteId: 'inferno_wand',
    ),
    const WeaponData(
      name: 'Staff of Eternity',
      type: WeaponType.magic,
      rarity: WeaponRarity.legendary,
      element: ElementType.lightning,
      damage: 45,
      fireRate: 2.0,
      bulletSpeed: 300,
      bulletsPerShot: 3,
      spread: 0.2,
      color: Color(0xFFFFD700),
      spriteId: 'staff_of_eternity',
    ),

    // === LASER ===
    const WeaponData(
      name: 'Laser Cutter',
      type: WeaponType.laser,
      rarity: WeaponRarity.uncommon,
      damage: 12,
      fireRate: 6,
      bulletSpeed: 600,
      color: Color(0xFFFF1744),
      spriteId: 'laser_cutter',
    ),
    const WeaponData(
      name: 'Plasma Beam',
      type: WeaponType.laser,
      rarity: WeaponRarity.rare,
      element: ElementType.lightning,
      damage: 16,
      fireRate: 8,
      bulletSpeed: 700,
      color: Color(0xFF00E5FF),
      spriteId: 'plasma_beam',
    ),

    // === ROCKET ===
    const WeaponData(
      name: 'Rocket Launcher',
      type: WeaponType.rocket,
      rarity: WeaponRarity.rare,
      element: ElementType.fire,
      damage: 60,
      fireRate: 0.6,
      bulletSpeed: 250,
      color: Color(0xFFBF360C),
      spriteId: 'rocket_launcher',
    ),
    const WeaponData(
      name: 'Cluster Bomb',
      type: WeaponType.rocket,
      rarity: WeaponRarity.epic,
      element: ElementType.fire,
      damage: 40,
      fireRate: 0.5,
      bulletSpeed: 200,
      bulletsPerShot: 3,
      spread: 0.4,
      color: Color(0xFFFF6F00),
      spriteId: 'cluster_bomb',
    ),

    // === KNIFE / THROWING ===
    const WeaponData(
      name: 'Throwing Knives',
      type: WeaponType.knife,
      rarity: WeaponRarity.common,
      damage: 10,
      fireRate: 5,
      bulletSpeed: 450,
      color: Color(0xFFB0BEC5),
      spriteId: 'throwing_knives',
    ),
    const WeaponData(
      name: 'Shadow Daggers',
      type: WeaponType.knife,
      rarity: WeaponRarity.rare,
      element: ElementType.dark,
      damage: 14,
      fireRate: 6,
      bulletSpeed: 480,
      bulletsPerShot: 2,
      spread: 0.1,
      color: Color(0xFF311B92),
      spriteId: 'shadow_daggers',
    ),

    // === BOW / CROSSBOW ===
    const WeaponData(
      name: 'Compound Bow',
      type: WeaponType.bow,
      rarity: WeaponRarity.uncommon,
      damage: 35,
      fireRate: 1.5,
      bulletSpeed: 480,
      color: Color(0xFF8D6E63),
      spriteId: 'compound_bow',
    ),
    const WeaponData(
      name: 'Heavy Crossbow',
      type: WeaponType.crossbow,
      rarity: WeaponRarity.rare,
      damage: 80,
      fireRate: 0.5,
      bulletSpeed: 600,
      color: Color(0xFF5D4037),
      spriteId: 'heavy_crossbow',
    ),
    const WeaponData(
      name: 'Holy Lance',
      type: WeaponType.crossbow,
      rarity: WeaponRarity.legendary,
      element: ElementType.holy,
      damage: 100,
      fireRate: 0.7,
      bulletSpeed: 700,
      color: Color(0xFFFFF59D),
      spriteId: 'holy_lance',
    ),
  ];

  /// Get a random weapon based on floor difficulty
  static WeaponData getRandomWeapon({int floor = 1}) {
    // Higher floors = better chance of rare weapons
    final rarityRoll = _random.nextDouble();
    WeaponRarity minRarity;

    if (floor >= 8) {
      minRarity = rarityRoll < 0.3
          ? WeaponRarity.legendary
          : rarityRoll < 0.6
              ? WeaponRarity.epic
              : WeaponRarity.rare;
    } else if (floor >= 5) {
      minRarity = rarityRoll < 0.1
          ? WeaponRarity.epic
          : rarityRoll < 0.4
              ? WeaponRarity.rare
              : WeaponRarity.uncommon;
    } else if (floor >= 3) {
      minRarity = rarityRoll < 0.2
          ? WeaponRarity.rare
          : rarityRoll < 0.5
              ? WeaponRarity.uncommon
              : WeaponRarity.common;
    } else {
      minRarity = rarityRoll < 0.1
          ? WeaponRarity.uncommon
          : WeaponRarity.common;
    }

    final eligible = _weapons
        .where((w) => w.rarity.index >= minRarity.index)
        .toList();

    if (eligible.isEmpty) return _weapons.first;
    return eligible[_random.nextInt(eligible.length)];
  }
}
