import 'package:flutter/material.dart';
import '../game/pixel_dungeon_game.dart';

/// Minimal HUD: HP bar (top-left) + ammo + gold (top-right corner).
/// No minimap, no room progress, no theme name — keeps the screen clean
/// so the dungeon explores via vision alone.
class HudWidget extends StatelessWidget {
  final PixelDungeonGame game;

  const HudWidget({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<void>(
      stream: Stream.periodic(const Duration(milliseconds: 100)),
      builder: (context, _) {
        return Row(
          children: [
            _buildHpBar(),
            const SizedBox(width: 10),
            _buildAmmoBadge(),
            const Spacer(),
            _buildGoldDisplay(),
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
      width: 160,
      height: 22,
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: Colors.white24),
      ),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: hpPercent.clamp(0, 1),
            child: Container(
              decoration: BoxDecoration(
                color: hpColor,
                borderRadius: BorderRadius.circular(11),
              ),
            ),
          ),
          Center(
            child: Text(
              '${game.player.hp.toInt()}/${game.player.maxHp.toInt()}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmmoBadge() {
    if (!game.isLoaded) return const SizedBox.shrink();
    final p = game.player;
    final w = p.activeWeapon;
    final isStarter = p.secondaryWeapon == null;
    final ammoText = isStarter ? '∞' : '${p.secondaryAmmo}';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: w.rarityColor.withValues(alpha: 0.6), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_iconForWeapon(w.spriteId), color: w.color, size: 14),
          const SizedBox(width: 4),
          Text(
            ammoText,
            style: TextStyle(
              color: isStarter ? Colors.amber : Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForWeapon(String spriteId) {
    if (spriteId.contains('rocket') || spriteId.contains('cluster')) {
      return Icons.flight_takeoff;
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.monetization_on, color: Colors.amber, size: 14),
          const SizedBox(width: 4),
          Text(
            '${game.gameState.gold}',
            style: const TextStyle(
              color: Colors.amber,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
