import 'package:flutter/material.dart';
import '../game/pixel_dungeon_game.dart';

class HudWidget extends StatelessWidget {
  final PixelDungeonGame game;

  const HudWidget({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<void>(
      stream: Stream.periodic(const Duration(milliseconds: 100)),
      builder: (context, _) {
        if (!game.isLoaded) return const SizedBox.shrink();

        return Row(
          children: [
            // HP Bar
            _buildHpBar(),
            const SizedBox(width: 16),
            // Floor info
            _buildFloorInfo(),
            const Spacer(),
            // Gold
            _buildGoldDisplay(),
          ],
        );
      },
    );
  }

  Widget _buildHpBar() {
    final hpPercent = game.player.hp / game.player.maxHp;
    final hpColor = hpPercent > 0.5
        ? Colors.green
        : hpPercent > 0.25
            ? Colors.orange
            : Colors.red;

    return Container(
      width: 150,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24),
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
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloorInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Floor ${game.gameState.currentFloor}',
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
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
          const Icon(Icons.monetization_on, color: Colors.amber, size: 18),
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
