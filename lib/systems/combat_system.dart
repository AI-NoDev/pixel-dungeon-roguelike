import '../game/pixel_dungeon_game.dart';

/// Manages combat logic, damage calculations, and effects
class CombatSystem {
  final PixelDungeonGame game;

  CombatSystem({required this.game});

  void update(double dt) {
    // Sync input to player
    final input = game.inputSystem;
    game.player.moveDirection = input.moveDirection;
    game.player.aimDirection = input.aimDirection;
    game.player.isShooting = input.isShooting;
  }
}
