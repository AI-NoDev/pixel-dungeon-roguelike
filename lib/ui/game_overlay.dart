import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game/pixel_dungeon_game.dart';
import 'joystick_widget.dart';
import 'hud_widget.dart';
import 'talent_picker.dart';
import 'weapon_pickup.dart';

enum OverlayState { playing, talentPicker, weaponPickup, gameOver }

class GameOverlay extends StatefulWidget {
  final PixelDungeonGame game;

  const GameOverlay({super.key, required this.game});

  @override
  State<GameOverlay> createState() => _GameOverlayState();
}

class _GameOverlayState extends State<GameOverlay> {
  OverlayState _state = OverlayState.playing;

  @override
  void initState() {
    super.initState();
    widget.game.onShowTalentPicker = () {
      setState(() => _state = OverlayState.talentPicker);
    };
    widget.game.onShowWeaponPickup = () {
      setState(() => _state = OverlayState.weaponPickup);
    };
    widget.game.onStateChanged = () {
      setState(() {
        if (widget.game.gameState.isGameOver) {
          _state = OverlayState.gameOver;
        } else {
          _state = OverlayState.playing;
        }
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // HUD - always visible
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: HudWidget(game: widget.game),
        ),

        // Joysticks - only when playing
        if (_state == OverlayState.playing) ...[
          // Move joystick
          Positioned(
            bottom: 40,
            left: 40,
            child: JoystickWidget(
              size: 120,
              onDirectionChanged: (direction) {
                widget.game.inputSystem.updateMove(
                  Vector2(direction.dx, direction.dy),
                );
              },
              onDirectionEnd: () {
                widget.game.inputSystem.stopMove();
              },
            ),
          ),
          // Aim joystick
          Positioned(
            bottom: 40,
            right: 40,
            child: JoystickWidget(
              size: 120,
              color: Colors.red.withValues(alpha: 0.3),
              knobColor: Colors.redAccent,
              onDirectionChanged: (direction) {
                widget.game.inputSystem.updateAim(
                  Vector2(direction.dx, direction.dy),
                );
              },
              onDirectionEnd: () {
                widget.game.inputSystem.stopAim();
              },
            ),
          ),
          // Next room button
          if (widget.game.isLoaded && widget.game.currentRoom.isCleared)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: () => widget.game.moveToNextRoom(),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Next Room'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ),
            ),
        ],

        // Talent picker overlay
        if (_state == OverlayState.talentPicker &&
            widget.game.pendingTalentChoices != null)
          TalentPicker(
            game: widget.game,
            choices: widget.game.pendingTalentChoices!,
            onPicked: () {
              widget.game.onTalentPicked();
              setState(() {
                if (widget.game.pendingWeapon != null) {
                  _state = OverlayState.weaponPickup;
                } else {
                  _state = OverlayState.playing;
                }
              });
            },
          ),

        // Weapon pickup overlay
        if (_state == OverlayState.weaponPickup &&
            widget.game.pendingWeapon != null)
          WeaponPickupDialog(
            game: widget.game,
            weapon: widget.game.pendingWeapon!,
            onAccept: () {
              widget.game.onWeaponAccepted();
              setState(() => _state = OverlayState.playing);
            },
            onDecline: () {
              widget.game.onWeaponDeclined();
              setState(() => _state = OverlayState.playing);
            },
          ),

        // Game over overlay
        if (_state == OverlayState.gameOver) _buildGameOverOverlay(),
      ],
    );
  }

  Widget _buildGameOverOverlay() {
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
                'Floor: ${widget.game.gameState.currentFloor}',
                style: const TextStyle(color: Colors.white70, fontSize: 18),
              ),
              Text(
                'Enemies Killed: ${widget.game.gameState.enemiesKilled}',
                style: const TextStyle(color: Colors.white70, fontSize: 18),
              ),
              Text(
                'Gold: ${widget.game.gameState.gold}',
                style: const TextStyle(color: Colors.amber, fontSize: 18),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  widget.game.restartGame();
                  setState(() => _state = OverlayState.playing);
                },
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
