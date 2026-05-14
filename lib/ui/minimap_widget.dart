import 'package:flutter/material.dart';
import '../data/floor_config.dart';
import '../game/pixel_dungeon_game.dart';

/// Shows floor progress as a room sequence
class MinimapWidget extends StatelessWidget {
  final PixelDungeonGame game;

  const MinimapWidget({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    if (!game.isLoaded) return const SizedBox.shrink();

    final rooms = game.currentFloorRooms;
    final currentIndex = game.currentRoomIndex;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(rooms.length, (index) {
          return _buildRoomNode(rooms[index], index, currentIndex);
        }),
      ),
    );
  }

  Widget _buildRoomNode(RoomConfig room, int index, int currentIndex) {
    final isCompleted = index < currentIndex;
    final isCurrent = index == currentIndex;

    Color nodeColor;
    IconData icon;

    switch (room.type) {
      case RoomType.combat:
        nodeColor = Colors.white54;
        icon = Icons.dangerous;
        break;
      case RoomType.elite:
        nodeColor = Colors.orange;
        icon = Icons.star;
        break;
      case RoomType.treasure:
        nodeColor = Colors.amber;
        icon = Icons.card_giftcard;
        break;
      case RoomType.shop:
        nodeColor = Colors.green;
        icon = Icons.shopping_cart;
        break;
      case RoomType.rest:
        nodeColor = Colors.lightBlue;
        icon = Icons.local_fire_department;
        break;
      case RoomType.boss:
        nodeColor = Colors.red;
        icon = Icons.whatshot;
        break;
    }

    if (isCompleted) nodeColor = Colors.green.shade300;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isCurrent ? 18 : 14,
          height: isCurrent ? 18 : 14,
          decoration: BoxDecoration(
            color: isCurrent ? nodeColor : nodeColor.withValues(alpha: 0.4),
            shape: BoxShape.circle,
            border: isCurrent
                ? Border.all(color: Colors.white, width: 2)
                : null,
          ),
          child: (isCurrent || room.type != RoomType.combat)
              ? Icon(icon, size: isCurrent ? 10 : 8, color: Colors.white)
              : null,
        ),
        if (index < game.currentFloorRooms.length - 1)
          Container(
            width: 8,
            height: 2,
            color: isCompleted ? Colors.green.shade300 : Colors.white24,
          ),
      ],
    );
  }
}
