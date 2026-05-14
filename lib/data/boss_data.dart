import 'package:flutter/material.dart';

enum BossType { skeletonKing, crystalGolem, wardenKnight, infernoLord, voidReaper }

class BossData {
  final BossType type;
  final String name;
  final double hp;
  final double contactDamage;
  final double speed;
  final double shootInterval;
  final double bulletDamage;
  final int bulletCount;
  final double bulletSpread;
  final Color color;
  final double size;
  final List<BossPhase> phases;

  const BossData({
    required this.type,
    required this.name,
    required this.hp,
    required this.contactDamage,
    required this.speed,
    required this.shootInterval,
    required this.bulletDamage,
    required this.bulletCount,
    required this.bulletSpread,
    required this.color,
    this.size = 48,
    required this.phases,
  });

  static BossData getBossForFloor(int floor) {
    final bossIndex = (floor ~/ 5) - 1;
    switch (bossIndex % 5) {
      case 0:
        return skeletonKing;
      case 1:
        return crystalGolem;
      case 2:
        return wardenKnight;
      case 3:
        return infernoLord;
      case 4:
        return voidReaper;
      default:
        return skeletonKing;
    }
  }

  // Floor 5 Boss
  static const skeletonKing = BossData(
    type: BossType.skeletonKing,
    name: 'Skeleton King',
    hp: 500,
    contactDamage: 25,
    speed: 40,
    shootInterval: 1.5,
    bulletDamage: 15,
    bulletCount: 8,
    bulletSpread: 6.28, // full circle
    color: Color(0xFFE0E0E0),
    size: 48,
    phases: [
      BossPhase(hpThreshold: 0.7, speedMultiplier: 1.0, fireRateMultiplier: 1.0),
      BossPhase(hpThreshold: 0.4, speedMultiplier: 1.3, fireRateMultiplier: 1.5),
      BossPhase(hpThreshold: 0.15, speedMultiplier: 1.6, fireRateMultiplier: 2.0),
    ],
  );

  // Floor 10 Boss
  static const crystalGolem = BossData(
    type: BossType.crystalGolem,
    name: 'Crystal Golem',
    hp: 800,
    contactDamage: 35,
    speed: 25,
    shootInterval: 2.0,
    bulletDamage: 20,
    bulletCount: 12,
    bulletSpread: 6.28,
    color: Color(0xFF80DEEA),
    size: 56,
    phases: [
      BossPhase(hpThreshold: 0.7, speedMultiplier: 1.0, fireRateMultiplier: 1.0),
      BossPhase(hpThreshold: 0.4, speedMultiplier: 1.2, fireRateMultiplier: 1.3),
      BossPhase(hpThreshold: 0.15, speedMultiplier: 1.5, fireRateMultiplier: 1.8),
    ],
  );

  // Floor 15 Boss
  static const wardenKnight = BossData(
    type: BossType.wardenKnight,
    name: 'Warden Knight',
    hp: 1200,
    contactDamage: 40,
    speed: 55,
    shootInterval: 1.0,
    bulletDamage: 18,
    bulletCount: 5,
    bulletSpread: 0.8,
    color: Color(0xFFFFB74D),
    size: 52,
    phases: [
      BossPhase(hpThreshold: 0.7, speedMultiplier: 1.0, fireRateMultiplier: 1.0),
      BossPhase(hpThreshold: 0.4, speedMultiplier: 1.5, fireRateMultiplier: 1.5),
      BossPhase(hpThreshold: 0.15, speedMultiplier: 2.0, fireRateMultiplier: 2.0),
    ],
  );

  // Floor 20 Boss
  static const infernoLord = BossData(
    type: BossType.infernoLord,
    name: 'Inferno Lord',
    hp: 1800,
    contactDamage: 50,
    speed: 45,
    shootInterval: 0.8,
    bulletDamage: 22,
    bulletCount: 16,
    bulletSpread: 6.28,
    color: Color(0xFFFF5722),
    size: 56,
    phases: [
      BossPhase(hpThreshold: 0.7, speedMultiplier: 1.0, fireRateMultiplier: 1.0),
      BossPhase(hpThreshold: 0.4, speedMultiplier: 1.3, fireRateMultiplier: 1.8),
      BossPhase(hpThreshold: 0.15, speedMultiplier: 1.6, fireRateMultiplier: 2.5),
    ],
  );

  // Floor 25 Boss
  static const voidReaper = BossData(
    type: BossType.voidReaper,
    name: 'Void Reaper',
    hp: 2500,
    contactDamage: 60,
    speed: 60,
    shootInterval: 0.6,
    bulletDamage: 25,
    bulletCount: 20,
    bulletSpread: 6.28,
    color: Color(0xFFE040FB),
    size: 60,
    phases: [
      BossPhase(hpThreshold: 0.7, speedMultiplier: 1.0, fireRateMultiplier: 1.0),
      BossPhase(hpThreshold: 0.4, speedMultiplier: 1.5, fireRateMultiplier: 2.0),
      BossPhase(hpThreshold: 0.15, speedMultiplier: 2.0, fireRateMultiplier: 3.0),
    ],
  );
}

class BossPhase {
  final double hpThreshold; // trigger when HP% drops below this
  final double speedMultiplier;
  final double fireRateMultiplier;

  const BossPhase({
    required this.hpThreshold,
    required this.speedMultiplier,
    required this.fireRateMultiplier,
  });
}
