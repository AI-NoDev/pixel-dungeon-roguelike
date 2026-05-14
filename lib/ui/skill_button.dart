import 'package:flutter/material.dart';
import '../systems/skill_system.dart';
import '../game/pixel_dungeon_game.dart';

class SkillButton extends StatelessWidget {
  final PixelDungeonGame game;
  final SkillSystem skillSystem;

  const SkillButton({
    super.key,
    required this.game,
    required this.skillSystem,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<void>(
      stream: Stream.periodic(const Duration(milliseconds: 100)),
      builder: (context, _) {
        final isReady = skillSystem.isReady;
        final progress = skillSystem.cooldownProgress;

        return GestureDetector(
          onTap: isReady ? () => skillSystem.activateSkill() : null,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isReady
                  ? game.selectedHero.color.withValues(alpha: 0.8)
                  : Colors.grey.shade800,
              border: Border.all(
                color: isReady ? game.selectedHero.color : Colors.white24,
                width: 2,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Cooldown overlay
                if (!isReady)
                  SizedBox(
                    width: 52,
                    height: 52,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 3,
                      color: game.selectedHero.color,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                // Skill icon
                Icon(
                  Icons.flash_on,
                  color: isReady ? Colors.white : Colors.white38,
                  size: 24,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
