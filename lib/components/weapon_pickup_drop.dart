import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import '../data/weapons.dart';
import '../game/pixel_dungeon_game.dart';
import '../systems/audio_system.dart';
import 'pickup_base.dart';

/// A weapon dropped on the floor. Walking near shows a prompt; pressing the
/// interaction button equips it (replacing the secondary slot, never the
/// starter pistol).
class WeaponPickupDrop extends PositionComponent
    with HasGameReference<PixelDungeonGame>
    implements InteractablePickup {
  WeaponPickupDrop({required Vector2 position, required this.weapon})
      : super(
          position: position,
          size: Vector2(28, 28),
          anchor: Anchor.center,
        );

  final WeaponData weapon;
  double _bob = 0;
  double _baseY = 0;
  bool _consumed = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _baseY = position.y;

    // Rarity glow circle behind the weapon
    add(CircleComponent(
      radius: 16,
      paint: Paint()..color = weapon.rarityColor.withValues(alpha: 0.25),
    ));

    // Try to load weapon sprite
    try {
      final image = await game.images.load('weapons/weapon_${weapon.spriteId}.png');
      add(SpriteComponent(
        sprite: Sprite(image),
        size: Vector2.all(22),
        anchor: Anchor.center,
        position: Vector2(14, 14),
      ));
    } catch (_) {
      add(RectangleComponent(
        size: Vector2(20, 6),
        position: Vector2(4, 11),
        paint: Paint()..color = weapon.color,
      ));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _bob += dt * 2.5;
    position.y = _baseY + sin(_bob) * 2.5;
  }

  @override
  String get pickupLabel => weapon.name;

  @override
  bool get isConsumed => _consumed;

  @override
  void interact() {
    if (_consumed) return;
    _consumed = true;
    AudioSystem.playPickupWeapon();
    // Drop the player's previous secondary back to the floor (so the player
    // can keep the weapon they just dropped).
    final prev = game.player.secondaryWeapon;
    final prevAmmo = game.player.secondaryAmmo;
    if (prev != null && prevAmmo > 0) {
      game.world.add(WeaponPickupDrop(
        position: position + Vector2(20, 0),
        weapon: prev,
      ).._copyAmmoFromPlayer = prevAmmo);
    }

    game.player.equipWeapon(weapon);
    if (_copyAmmoFromPlayer != null) {
      // If this drop carried inherited ammo (from swapping), preserve it.
      game.player.secondaryAmmo = _copyAmmoFromPlayer!;
      game.onStateChanged?.call();
    }
    removeFromParent();
  }

  /// When the player swaps to this weapon, this preserved ammo count is
  /// applied (so dropping a partially-used weapon doesn't reset to full).
  int? _copyAmmoFromPlayer;
}
