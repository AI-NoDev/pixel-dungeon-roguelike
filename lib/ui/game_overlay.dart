import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game/pixel_dungeon_game.dart';
import '../i18n/app_localizations.dart';
import 'joystick_widget.dart';
import 'hud_widget.dart';
import 'talent_picker.dart';
import 'weapon_pickup.dart';
import 'shop_widget.dart';
import 'skill_button.dart';

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
  bool _showTalentPicker = false;
  bool _showWeaponPickup = false;
  bool _showShop = false;
  bool _showGameOver = false;

  @override
  void initState() {
    super.initState();
    _setupCallbacks();
  }

  void _setupCallbacks() {
    widget.game.onShowTalentPicker = () {
      if (mounted) setState(() => _showTalentPicker = true);
    };
    widget.game.onShowWeaponPickup = () {
      if (mounted) setState(() => _showWeaponPickup = true);
    };
    widget.game.onShowShop = () {
      if (mounted) setState(() => _showShop = true);
    };

    final originalOnStateChanged = widget.game.onStateChanged;
    widget.game.onStateChanged = () {
      originalOnStateChanged?.call();
      if (mounted) {
        setState(() {
          _showGameOver = widget.game.gameState.isGameOver;
        });
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          // HUD - always visible
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

          // Move joystick - left
          Positioned(
            bottom: 60,
            left: 120,
            child: JoystickWidget(
              size: 130,
              color: Colors.blue.withValues(alpha: 0.5),
              knobColor: Colors.lightBlueAccent,
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

          // Aim/shoot joystick - right
          Positioned(
            bottom: 60,
            right: 120,
            child: JoystickWidget(
              size: 130,
              color: Colors.red.withValues(alpha: 0.5),
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
            bottom: 80,
            right: 270,
            child: SkillButton(
              game: widget.game,
              skillSystem: widget.game.skillSystem,
            ),
          ),

          // Next room button (when room cleared)
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
                      label: Text(AppLocalizations.of(context).t('next_room')),
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

          // Talent picker overlay
          if (_showTalentPicker && widget.game.pendingTalentChoices != null)
            TalentPicker(
              game: widget.game,
              choices: widget.game.pendingTalentChoices!,
              onPicked: () {
                widget.game.onTalentPicked();
                setState(() {
                  _showTalentPicker = false;
                  if (widget.game.pendingWeapon != null) {
                    _showWeaponPickup = true;
                  }
                });
              },
            ),

          // Weapon pickup overlay
          if (_showWeaponPickup && widget.game.pendingWeapon != null)
            WeaponPickupDialog(
              game: widget.game,
              weapon: widget.game.pendingWeapon!,
              onAccept: () {
                widget.game.onWeaponAccepted();
                setState(() => _showWeaponPickup = false);
              },
              onDecline: () {
                widget.game.onWeaponDeclined();
                setState(() => _showWeaponPickup = false);
              },
            ),

          // Shop overlay
          if (_showShop)
            ShopWidget(
              game: widget.game,
              onClose: () {
                widget.game.resumeEngine();
                setState(() => _showShop = false);
              },
            ),

          // Game over overlay
          if (_showGameOver) _buildGameOverOverlay(),
        ],
      ),
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
    final t = AppLocalizations.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        title: Text(t.t('paused'), style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${t.t('floor')} ${widget.game.gameState.currentFloor}',
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
            child: Text(t.t('resume')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.onReturnToMenu();
            },
            child: Text(t.t('quit'), style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildGameOverOverlay() {
    final t = AppLocalizations.of(context);
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
              Text(
                t.t('game_over'),
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _resultRow(t.t('floor_reached'), '${widget.game.gameState.currentFloor}'),
              _resultRow(t.t('rooms_cleared'), '${widget.game.gameState.roomsCleared}'),
              _resultRow(t.t('enemies_killed'), '${widget.game.gameState.enemiesKilled}'),
              _resultRow(t.t('gold_earned'), '${widget.game.gameState.gold}'),
              const SizedBox(height: 24),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      widget.game.restartGame();
                      setState(() => _showGameOver = false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    ),
                    child: Text(t.t('retry'), style: const TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: widget.onReturnToMenu,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade800,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    ),
                    child: Text(t.t('menu'), style: const TextStyle(color: Colors.white70)),
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
