import 'package:flutter/material.dart';
import '../data/items.dart';
import '../game/pixel_dungeon_game.dart';
import '../i18n/app_localizations.dart';

class ShopWidget extends StatefulWidget {
  final PixelDungeonGame game;
  final VoidCallback onClose;

  const ShopWidget({super.key, required this.game, required this.onClose});

  @override
  State<ShopWidget> createState() => _ShopWidgetState();
}

class _ShopWidgetState extends State<ShopWidget> {
  late List<ShopItem> items;
  final Set<int> _purchased = {};

  @override
  void initState() {
    super.initState();
    items = ItemData.getShopItems(widget.game.gameState.currentFloor);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Container(
      color: Colors.black87,
      child: Center(
        child: Container(
          width: 360,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1a1a2e),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.amber.shade700, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                t.t('shop'),
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.monetization_on, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.game.gameState.gold}',
                    style: const TextStyle(color: Colors.amber, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ...List.generate(items.length, (index) {
                return _buildShopItem(index);
              }),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: widget.onClose,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade800,
                ),
                child: Text(t.t('leave_shop'), style: const TextStyle(color: Colors.white70)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShopItem(int index) {
    final shopItem = items[index];
    final canAfford = widget.game.gameState.gold >= shopItem.price;
    final isPurchased = _purchased.contains(index);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isPurchased
            ? Colors.green.shade900.withValues(alpha: 0.3)
            : Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isPurchased
              ? Colors.green.shade700
              : canAfford
                  ? shopItem.item.color.withValues(alpha: 0.5)
                  : Colors.white12,
        ),
      ),
      child: Row(
        children: [
          // Item icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: shopItem.item.color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(shopItem.item.icon, color: shopItem.item.color, size: 18),
          ),
          const SizedBox(width: 12),
          // Item info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shopItem.item.name,
                  style: TextStyle(
                    color: shopItem.item.color,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  shopItem.item.description,
                  style: const TextStyle(color: Colors.white54, fontSize: 10),
                ),
              ],
            ),
          ),
          // Buy button
          if (isPurchased)
            Text(AppLocalizations.of(context).t('sold'), style: const TextStyle(color: Colors.green, fontSize: 12))
          else
            GestureDetector(
              onTap: canAfford ? () => _buyItem(index) : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: canAfford ? Colors.amber.shade800 : Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.monetization_on, size: 12, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '${shopItem.price}',
                      style: TextStyle(
                        color: canAfford ? Colors.white : Colors.white38,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _buyItem(int index) {
    final shopItem = items[index];
    if (widget.game.gameState.gold < shopItem.price) return;

    setState(() {
      widget.game.gameState.gold -= shopItem.price;
      _purchased.add(index);
    });

    // Apply item effect
    switch (shopItem.item.type) {
      case ItemType.healthPotion:
        widget.game.player.heal(shopItem.item.value);
        break;
      case ItemType.shield:
        widget.game.player.heal(20);
        break;
      case ItemType.damageBoost:
        widget.game.player.damageMultiplier *= (1 + shopItem.item.value);
        break;
      case ItemType.speedBoost:
        widget.game.player.speedMultiplier *= (1 + shopItem.item.value);
        break;
      case ItemType.coin:
        widget.game.gameState.gold += shopItem.item.value.toInt();
        break;
      case ItemType.key:
        break;
    }
  }
}
