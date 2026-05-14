import 'package:flutter/material.dart';
import '../data/talents.dart';
import '../game/pixel_dungeon_game.dart';

class TalentPicker extends StatelessWidget {
  final PixelDungeonGame game;
  final List<TalentData> choices;
  final VoidCallback onPicked;

  const TalentPicker({
    super.key,
    required this.game,
    required this.choices,
    required this.onPicked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'LEVEL UP!',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Choose a talent',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: choices.map((talent) => _buildTalentCard(talent)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTalentCard(TalentData talent) {
    return GestureDetector(
      onTap: () {
        game.player.applyTalent(talent);
        onPicked();
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D44),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: talent.color, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(talent.icon, color: talent.color, size: 36),
            const SizedBox(height: 8),
            Text(
              talent.name,
              style: TextStyle(
                color: talent.color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              talent.description,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
