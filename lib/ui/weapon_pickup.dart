import 'package:flutter/material.dart';
import '../data/weapons.dart';
import '../game/pixel_dungeon_game.dart';
import '../i18n/app_localizations.dart';

class WeaponPickupDialog extends StatelessWidget {
  final PixelDungeonGame game;
  final WeaponData weapon;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const WeaponPickupDialog({
    super.key,
    required this.game,
    required this.weapon,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          width: 280,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1a1a2e),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: weapon.rarityColor, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                weapon.rarityName,
                style: TextStyle(
                  color: weapon.rarityColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                weapon.name,
                style: TextStyle(
                  color: weapon.color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildStatRow(t.t('damage'), '${weapon.damage.toInt()}'),
              _buildStatRow(t.t('fire_rate'), '${weapon.fireRate.toStringAsFixed(1)}/s'),
              _buildStatRow(t.t('bullets'), '${weapon.bulletsPerShot}'),
              if (weapon.element != ElementType.none)
                _buildStatRow(t.t('element'), weapon.element.name.toUpperCase()),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: onDecline,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade800,
                    ),
                    child: Text(t.t('skip'), style: const TextStyle(color: Colors.white70)),
                  ),
                  ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: weapon.rarityColor.withValues(alpha: 0.8),
                    ),
                    child: Text(t.t('equip'), style: const TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 13)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 13)),
        ],
      ),
    );
  }
}
