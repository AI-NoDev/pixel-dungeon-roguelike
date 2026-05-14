import 'package:shared_preferences/shared_preferences.dart';

/// Global game preferences that persist between runs.
class GamePreferences {
  static bool autoAim = true;
  static double autoAimRange = 400.0;
  static bool screenShake = true;

  static const _kAutoAim = 'pref_auto_aim';
  static const _kAutoAimRange = 'pref_auto_aim_range';
  static const _kScreenShake = 'pref_screen_shake';

  /// Load preferences from disk.
  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    autoAim = prefs.getBool(_kAutoAim) ?? true;
    autoAimRange = prefs.getDouble(_kAutoAimRange) ?? 400.0;
    screenShake = prefs.getBool(_kScreenShake) ?? true;
  }

  static Future<void> setAutoAim(bool value) async {
    autoAim = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kAutoAim, value);
  }

  static Future<void> setAutoAimRange(double value) async {
    autoAimRange = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kAutoAimRange, value);
  }

  static Future<void> setScreenShake(bool value) async {
    screenShake = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kScreenShake, value);
  }
}
