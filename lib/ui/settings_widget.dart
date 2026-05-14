import 'package:flutter/material.dart';
import '../systems/audio_system.dart';

class SettingsWidget extends StatefulWidget {
  final VoidCallback onClose;

  const SettingsWidget({super.key, required this.onClose});

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1a1a2e),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24, width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'SETTINGS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 24),
              _buildToggle(
                'Sound Effects',
                AudioSystem.sfxEnabled,
                Icons.volume_up,
                (val) {
                  setState(() => AudioSystem.toggleSfx());
                },
              ),
              const SizedBox(height: 12),
              _buildToggle(
                'Background Music',
                AudioSystem.bgmEnabled,
                Icons.music_note,
                (val) {
                  setState(() => AudioSystem.toggleBgm());
                },
              ),
              const SizedBox(height: 12),
              _buildSlider(
                'SFX Volume',
                AudioSystem.sfxVolume,
                (val) {
                  setState(() => AudioSystem.sfxVolume = val);
                },
              ),
              const SizedBox(height: 12),
              _buildSlider(
                'BGM Volume',
                AudioSystem.bgmVolume,
                (val) {
                  setState(() => AudioSystem.bgmVolume = val);
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: widget.onClose,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade800,
                ),
                child: const Text('Close', style: TextStyle(color: Colors.white70)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggle(String label, bool value, IconData icon, ValueChanged<bool> onChanged) {
    return Row(
      children: [
        Icon(icon, color: Colors.white54, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeTrackColor: Colors.amber,
          thumbColor: WidgetStatePropertyAll(Colors.amber),
        ),
      ],
    );
  }

  Widget _buildSlider(String label, double value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: Colors.amber,
            inactiveTrackColor: Colors.white12,
            thumbColor: Colors.amber,
            overlayColor: Colors.amber.withValues(alpha: 0.2),
          ),
          child: Slider(
            value: value,
            min: 0,
            max: 1,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
