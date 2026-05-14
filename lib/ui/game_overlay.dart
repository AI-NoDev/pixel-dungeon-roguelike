import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game/pixel_dungeon_game.dart';
import 'joystick_widget.dart';
import 'hud_widget.dart';
import 'talent_picker.dart';
import 'weapon_pickup.dart';
import 'shop_widget.dart';
import 'skill_button.dart';

enum OverlayState { playing, talentPicker, weaponPickup, shop, gameOver }

class GameOverlay extends StatefulWidget {
  final PixelDungeonGame game;
  final VoidCallback onReturnToMenu;

  const GameOverlay({
    super.key,
    required this.game,
    required this.onReturnToMenu,
  });

  @override
  State<GameOverlay> createState() => _GameOverlayState();
}

class _GameOverlayState extends State<GameOverlay> {
  OverlayState _state = OverlayState.playing;

  @override
  void initState() {
    super.initState();
    _setupCallbacks();
  }

  void _setupCallbacks() {
    widget.game.onShowTalentPicker = () {
      setState(() => _state = OverlayState.talentPicker);
    };
    widget.game.onShowWeaponPickup = () {
      setState(() => _state = OverlayState.weaponPickup);
    };
    widget.game.onShowShop = () {
      setState(() => _state = OverlayState.shop);
    };

    final originalOnStateChanged = widget.game.onStateChanged;
    widget.game.onStateChanged = () {
      originalOnStateChanged?.call();
      if (mounted) {
        setState(() {
          if (widget.game.gameState.isGameOver) {
            _state = OverlayState.gameOver;
          } else {
            _state = OverlayState.playing;
          }
        });
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // HUD
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: HudWidget(game: widget.game),
        ),

        // Pause button
        Positioned(
          top: 16,
          right: 16,
          child: _buildPauseButton(),
        ),

        // Joysticks - only when playing
        if (_state == OverlayState.playing) ...[
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
          // Skill button
          Positioned(
            bottom: 50,
            right: 180,
            child: SkillButton(
              game: widget.game,
              skillSystem: widget.game.skillSystem,
            ),
          ),
          // Next room button
          StreamBuilder<void>(
            stream: Stream.periodic(const Duration(milliseconds: 300)),
            builder: (context, _) {
              if (widget.game.isLoaded &&
                  widget.game.currentRoom.doorsOpen &&
                  !widget.game.gameState.isGameOver) {
                return Positioned(
                  top: 80,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: () => widget.game.moveToNextRoom(),
                      icon: const Icon(Icons.arrow_forward, size: 18),
                      label: const Text('Next Room'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],

        // Talent picker
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

        // Weapon pickup
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

        // Shop overlay
        if (_state == OverlayState.shop)
          ShopWidget(
            game: widget.game,
            onClose: () {
              widget.game.resumeEngine();
              setState(() => _state = OverlayState.playing);
            },
          ),

        // Game over
        if (_state == OverlayState.gameOver) _buildGameOverOverlay(),
      ],
    );
  }

  Widget _buildPauseButton() {
    return GestureDetector(
      onTap: () => _showPauseMenu(),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.pause, color: Colors.white54, size: 20),
      ),
    );
  }

  void _showPauseMenu() {
    widget.game.pauseEngine();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        title: const Text('Paused', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Floor ${widget.game.gameState.currentFloor} - ${widget.game.currentRoomLabel}',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.game.resumeEngine();
            },
            child: const Text('Resume'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.onReturnToMenu();
            },
            child: const Text('Quit', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
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
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _resultRow('Floor Reached', '${widget.game.gameState.currentFloor}'),
              _resultRow('Rooms Cleared', '${widget.game.gameState.roomsCleared}'),
              _resultRow('Enemies Killed', '${widget.game.gameState.enemiesKilled}'),
              _resultRow('Gold Earned', '${widget.game.gameState.gold}'),
              const SizedBox(height: 24),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      widget.game.restartGame();
                      setState(() => _state = OverlayState.playing);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    ),
                    child: const Text('Retry', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: widget.onReturnToMenu,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade800,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    ),
                    child: const Text('Menu', style: TextStyle(color: Colors.white70)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _resultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(color: Colors.white54, fontSize: 14)),
          ),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
