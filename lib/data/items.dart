import 'dart:math';
import 'package:flutter/material.dart';

enum ItemType { healthPotion, shield, speedBoost, damageBoost, coin, key }

class ItemData {
  final ItemType type;
  final String name;
  final String description;
  final Color color;
  final IconData icon;
  final double value; // effect value

  const ItemData({
    required this.type,
    required this.name,
    required this.description,
    required this.color,
    required this.icon,
    required this.value,
  });

  static const healthPotion = ItemData(
    type: ItemType.healthPotion,
    name: 'Health Potion',
    description: 'Restore 25 HP',
    color: Color(0xFFEF5350),
    icon: Icons.favorite,
    value: 25,
  );

  static const bigHealthPotion = ItemData(
    type: ItemType.healthPotion,
    name: 'Big Health Potion',
    description: 'Restore 50 HP',
    color: Color(0xFFC62828),
    icon: Icons.favorite,
    value: 50,
  );

  static const shield = ItemData(
    type: ItemType.shield,
    name: 'Shield Orb',
    description: 'Block next hit',
    color: Color(0xFF42A5F5),
    icon: Icons.shield,
    value: 1,
  );

  static const speedBoost = ItemData(
    type: ItemType.speedBoost,
    name: 'Speed Boots',
    description: 'Speed +20% for this room',
    color: Color(0xFF26C6DA),
    icon: Icons.directions_run,
    value: 0.2,
  );

  static const damageBoost = ItemData(
    type: ItemType.damageBoost,
    name: 'Power Crystal',
    description: 'Damage +30% for this room',
    color: Color(0xFFFF7043),
    icon: Icons.bolt,
    value: 0.3,
  );

  static const coin = ItemData(
    type: ItemType.coin,
    name: 'Gold Coin',
    description: '+15 Gold',
    color: Color(0xFFFFD54F),
    icon: Icons.monetization_on,
    value: 15,
  );

  static const bigCoin = ItemData(
    type: ItemType.coin,
    name: 'Gold Pile',
    description: '+50 Gold',
    color: Color(0xFFFFA000),
    icon: Icons.monetization_on,
    value: 50,
  );

  static final Random _random = Random();

  /// Random drop from enemy death
  static ItemData? getRandomDrop({double dropChance = 0.3}) {
    if (_random.nextDouble() > dropChance) return null;

    final roll = _random.nextDouble();
    if (roll < 0.3) return coin;
    if (roll < 0.5) return healthPotion;
    if (roll < 0.65) return speedBoost;
    if (roll < 0.8) return damageBoost;
    if (roll < 0.9) return bigCoin;
    return bigHealthPotion;
  }

  /// Shop items with prices
  static List<ShopItem> getShopItems(int floor) {
    return [
      ShopItem(item: bigHealthPotion, price: 30 + floor * 5),
      ShopItem(item: shield, price: 50 + floor * 10),
      ShopItem(item: damageBoost, price: 40 + floor * 8),
    ];
  }
}

class ShopItem {
  final ItemData item;
  final int price;

  const ShopItem({required this.item, required this.price});
}
