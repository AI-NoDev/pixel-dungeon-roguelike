import 'package:flutter/material.dart';
import '../systems/audio_system.dart';
import '../i18n/app_localizations.dart';

class SettingsWidget extends StatefulWidget {
  final VoidCallback onClose;

  const SettingsWidget({super.key, required this.onClose});

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return Container(
      color: Colors.black87,
      child: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1a1a2e),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24, width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                t.t('settings'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 20),

              // Language selector
              _buildLanguageSelector(t),
              const SizedBox(height: 12),

              _buildToggle(
                t.t('sound_effects'),
                AudioSystem.sfxEnabled,
                Icons.volume_up,
                (val) {
                  setState(() => AudioSystem.toggleSfx());
                },
              ),
              const SizedBox(height: 12),
              _buildToggle(
                t.t('background_music'),
                AudioSystem.bgmEnabled,
                Icons.music_note,
                (val) {
                  setState(() => AudioSystem.toggleBgm());
                },
              ),
              const SizedBox(height: 12),
              _buildSlider(
                t.t('sfx_volume'),
                AudioSystem.sfxVolume,
                (val) {
                  setState(() => AudioSystem.sfxVolume = val);
                },
              ),
              const SizedBox(height: 8),
              _buildSlider(
                t.t('bgm_volume'),
                AudioSystem.bgmVolume,
                (val) {
                  setState(() => AudioSystem.bgmVolume = val);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: widget.onClose,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade800,
                ),
                child: Text(
                  t.t('close'),
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(AppLocalizations t) {
    return Row(
      children: [
        const Icon(Icons.language, color: Colors.white54, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            t.t('language'),
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ),
        ToggleButtons(
          isSelected: [
            localeNotifier.value.languageCode == 'en',
            localeNotifier.value.languageCode == 'zh',
          ],
          onPressed: (index) {
            setState(() {
              localeNotifier.setLocale(
                Locale(index == 0 ? 'en' : 'zh'),
              );
            });
          },
          borderRadius: BorderRadius.circular(8),
          selectedColor: Colors.white,
          fillColor: Colors.amber.shade700,
          color: Colors.white54,
          constraints: const BoxConstraints(minWidth: 50, minHeight: 32),
          children: const [
            Text('EN'),
            Text('中文'),
          ],
        ),
      ],
    );
  }

  Widget _buildToggle(
      String label, bool value, IconData icon, ValueChanged<bool> onChanged) {
    return Row(
      children: [
        Icon(icon, color: Colors.white54, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 14)),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeTrackColor: Colors.amber,
          thumbColor: const WidgetStatePropertyAll(Colors.amber),
        ),
      ],
    );
  }

  Widget _buildSlider(
      String label, double value, ValueChanged<double> onChanged) {
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
