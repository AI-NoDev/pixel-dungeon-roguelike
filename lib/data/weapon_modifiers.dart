import 'dart:math';
import 'package:flutter/material.dart';

/// Weapon modifiers (affixes) that add special effects
enum ModifierType {
  piercing,     // Bullets pass through enemies
  bouncing,     // Bullets bounce off walls
  explosive,    // Bullets explode on hit
  vampiric,     // Heal on hit
  critical,     // Chance for 2x damage
  homing,       // Bullets slightly track enemies
  splitShot,    // Bullets split into 2 on hit
  chainHit,     // Damage chains to nearby enemy
}

class WeaponModifier {
  final ModifierType type;
  final String name;
  final String description;
  final Color color;
  final double value;

  const WeaponModifier({
    required this.type,
    required this.name,
    required this.description,
    required this.color,
    required this.value,
  });

  static const List<WeaponModifier> all = [
    WeaponModifier(
      type: ModifierType.piercing,
      name: 'Piercing',
      description: 'Bullets pass through 1 enemy',
      color: Color(0xFF90CAF9),
      value: 1,
    ),
    WeaponModifier(
      type: ModifierType.bouncing,
      name: 'Bouncing',
      description: 'Bullets bounce off walls once',
      color: Color(0xFFA5D6A7),
      value: 1,
    ),
    WeaponModifier(
      type: ModifierType.explosive,
      name: 'Explosive',
      description: 'Bullets deal 50% AoE damage',
      color: Color(0xFFFF8A65),
      value: 0.5,
    ),
    WeaponModifier(
      type: ModifierType.vampiric,
      name: 'Vampiric',
      description: 'Heal 5% of damage dealt',
      color: Color(0xFFEF5350),
      value: 0.05,
    ),
    WeaponModifier(
      type: ModifierType.critical,
      name: 'Critical',
      description: '20% chance for 2x damage',
      color: Color(0xFFFFD54F),
      value: 0.2,
    ),
    WeaponModifier(
      type: ModifierType.homing,
      name: 'Homing',
      description: 'Bullets slightly track enemies',
      color: Color(0xFFCE93D8),
      value: 0.3,
    ),
    WeaponModifier(
      type: ModifierType.splitShot,
      name: 'Split Shot',
      description: 'Bullets split into 2 on hit',
      color: Color(0xFF80DEEA),
      value: 2,
    ),
    WeaponModifier(
      type: ModifierType.chainHit,
      name: 'Chain Hit',
      description: '60% damage chains to nearby enemy',
      color: Color(0xFFFFEB3B),
      value: 0.6,
    ),
  ];

  static WeaponModifier getRandomModifier() {
    return all[Random().nextInt(all.length)];
  }

  /// Higher floors have chance for modifiers on dropped weapons
  static WeaponModifier? rollModifier(int floor) {
    final chance = (floor * 0.05).clamp(0, 0.4); // Max 40% at floor 8+
    if (Random().nextDouble() < chance) {
      return getRandomModifier();
    }
    return null;
  }
}
