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

        return Column(
          children: [
            // Top row: HP, Floor, Room, Gold
            Row(
              children: [
                _buildHpBar(),
                const SizedBox(width: 12),
                _buildFloorInfo(),
                const SizedBox(width: 8),
                _buildRoomInfo(),
                const Spacer(),
                _buildGoldDisplay(),
              ],
            ),
            // Boss HP bar (if in boss room)
            if (game.currentBoss != null && !(game.currentBoss!.isDead))
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _buildBossHpBar(),
              ),
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
      width: 140,
      height: 18,
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: Colors.white24),
      ),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: hpPercent.clamp(0, 1),
            child: Container(
              decoration: BoxDecoration(
                color: hpColor,
                borderRadius: BorderRadius.circular(9),
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

  Widget _buildFloorInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'F${game.gameState.currentFloor}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            game.currentThemeName,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        game.currentRoomLabel,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
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
          const Icon(Icons.monetization_on, color: Colors.amber, size: 14),
          const SizedBox(width: 4),
          Text(
            '${game.gameState.gold}',
            style: const TextStyle(
              color: Colors.amber,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBossHpBar() {
    final boss = game.currentBoss!;
    final hpPercent = boss.hp / boss.maxHp;

    return Column(
      children: [
        Text(
          boss.data.name,
          style: const TextStyle(
            color: Colors.redAccent,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 250,
          height: 12,
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.red.shade800),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: hpPercent.clamp(0, 1),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red.shade900, Colors.red.shade400],
                ),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
