import 'package:flutter/material.dart';
import '../game/pixel_dungeon_game.dart';
import '../data/weapons.dart';

/// Game HUD: HP bar, ammo, weapon name, gold, wave indicator.
class HudWidget extends StatelessWidget {
  final PixelDungeonGame game;

  const HudWidget({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<void>(
      stream: Stream.periodic(const Duration(milliseconds: 200)),
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                _buildHpBar(),
                const SizedBox(width: 8),
                _buildFloorBadge(),
                const SizedBox(width: 8),
                _buildWeaponBadge(),
                const Spacer(),
                _buildGoldDisplay(),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildHpBar() {
    if (!game.isLoaded) {
      return Container(
        width: 140,
        height: 18,
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(9),
        ),
      );
    }
    final hpPercent = game.player.hp / game.player.maxHp;
    final hpColor = hpPercent > 0.5
        ? Colors.green
        : hpPercent > 0.25
            ? Colors.orange
            : Colors.red;

    return Container(
      width: 140,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: hpPercent.clamp(0, 1),
            child: Container(
              decoration: BoxDecoration(
                color: hpColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Center(
            child: Text(
              '${game.player.hp.toInt()}/${game.player.maxHp.toInt()}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloorBadge() {
    if (!game.isLoaded) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white12),
      ),
      child: Text(
        'F${game.gameState.currentFloor}',
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildWeaponBadge() {
    if (!game.isLoaded) return const SizedBox.shrink();
    final p = game.player;
    final w = p.activeWeapon;
    final isStarter = p.secondaryWeapon == null;
    final ammoText = isStarter
        ? '∞'
        : w.isMelee
            ? '${p.secondaryAmmo}⚔'
            : '${p.secondaryAmmo}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: w.rarityColor.withValues(alpha: 0.6), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Weapon type icon
          Icon(
            w.isMelee ? Icons.sports_martial_arts : _iconForWeapon(w.spriteId),
            color: w.color,
            size: 13,
          ),
          const SizedBox(width: 4),
          // Weapon name (truncated)
          Text(
            w.name.length > 10 ? '${w.name.substring(0, 9)}…' : w.name,
            style: TextStyle(
              color: w.rarityColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 6),
          // Ammo
          Text(
            ammoText,
            style: TextStyle(
              color: isStarter ? Colors.amber : Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Element chip
          if (w.element != ElementType.none) ...[
            const SizedBox(width: 4),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: _elementColor(w.element),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _elementColor(ElementType e) {
    switch (e) {
      case ElementType.fire: return const Color(0xFFFF7043);
      case ElementType.ice: return const Color(0xFF4FC3F7);
      case ElementType.lightning: return const Color(0xFFFFEB3B);
      case ElementType.poison: return const Color(0xFF9CCC65);
      case ElementType.holy: return const Color(0xFFFFF59D);
      case ElementType.dark: return const Color(0xFF7C4DFF);
      case ElementType.none: return Colors.grey;
    }
  }

  IconData _iconForWeapon(String spriteId) {
    if (spriteId.contains('rocket') || spriteId.contains('cluster')) {
      return Icons.rocket_launch;
    }
    if (spriteId.contains('laser') || spriteId.contains('plasma')) {
      return Icons.flash_on;
    }
    if (spriteId.contains('bow') || spriteId.contains('crossbow') || spriteId.contains('lance')) {
      return Icons.gps_fixed;
    }
    if (spriteId.contains('staff') || spriteId.contains('wand') || spriteId.contains('arcane')) {
      return Icons.auto_awesome;
    }
    if (spriteId.contains('knife') || spriteId.contains('dagger')) {
      return Icons.content_cut;
    }
    if (spriteId.contains('shotgun') || spriteId.contains('scatter') || spriteId.contains('breath')) {
      return Icons.scatter_plot;
    }
    return Icons.gps_fixed;
  }

  Widget _buildGoldDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.monetization_on, color: Colors.amber, size: 13),
          const SizedBox(width: 3),
          Text(
            '${game.gameState.gold}',
            style: const TextStyle(
              color: Colors.amber,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
