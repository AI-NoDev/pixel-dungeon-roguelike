import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game/pixel_dungeon_game.dart';
import 'joystick_widget.dart';
import 'hud_widget.dart';

class GameOverlay extends StatelessWidget {
  final PixelDungeonGame game;

  const GameOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // HUD - top
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: HudWidget(game: game),
        ),

        // Move joystick - bottom left
        Positioned(
          bottom: 40,
          left: 40,
          child: JoystickWidget(
            size: 120,
            onDirectionChanged: (direction) {
              game.inputSystem.updateMove(
                Vector2(direction.dx, direction.dy),
              );
            },
            onDirectionEnd: () {
              game.inputSystem.stopMove();
            },
          ),
        ),

        // Aim/Shoot joystick - bottom right
        Positioned(
          bottom: 40,
          right: 40,
          child: JoystickWidget(
            size: 120,
            color: Colors.red.withValues(alpha: 0.3),
            knobColor: Colors.redAccent,
            onDirectionChanged: (direction) {
              game.inputSystem.updateAim(
                Vector2(direction.dx, direction.dy),
              );
            },
            onDirectionEnd: () {
              game.inputSystem.stopAim();
            },
          ),
        ),

        // Next room button (shown when room is cleared)
        Positioned(
          top: 60,
          right: 16,
          child: StreamBuilder<void>(
            stream: Stream.periodic(const Duration(milliseconds: 500)),
            builder: (context, _) {
              if (game.isLoaded &&
                  game.currentRoom.isCleared &&
                  !game.gameState.isGameOver) {
                return ElevatedButton.icon(
                  onPressed: () => game.moveToNextRoom(),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Next Room'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),

        // Game Over overlay
        StreamBuilder<void>(
          stream: Stream.periodic(const Duration(milliseconds: 300)),
          builder: (context, _) {
            if (game.isLoaded && game.gameState.isGameOver) {
              return _buildGameOverOverlay(context);
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildGameOverOverlay(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF1a1a2e),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.red.shade400, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'GAME OVER',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Floor: ${game.gameState.currentFloor}',
                style: const TextStyle(color: Colors.white70, fontSize: 18),
              ),
              Text(
                'Enemies Killed: ${game.gameState.enemiesKilled}',
                style: const TextStyle(color: Colors.white70, fontSize: 18),
              ),
              Text(
                'Gold: ${game.gameState.gold}',
                style: const TextStyle(color: Colors.amber, fontSize: 18),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => game.restartGame(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text(
                  'Try Again',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
