import 'package:flame_audio/flame_audio.dart';

/// Manages game audio (SFX and BGM)
/// Audio files should be placed in assets/audio/
class AudioSystem {
  static bool _initialized = false;
  static bool sfxEnabled = true;
  static bool bgmEnabled = true;
  static double sfxVolume = 0.7;
  static double bgmVolume = 0.4;

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    // Pre-cache common sounds when audio files are added
    // await FlameAudio.audioCache.loadAll([...]);
  }

  // === SFX ===
  static void playShoot() {
    if (!sfxEnabled) return;
    // FlameAudio.play('shoot.wav', volume: sfxVolume);
  }

  static void playHit() {
    if (!sfxEnabled) return;
    // FlameAudio.play('hit.wav', volume: sfxVolume);
  }

  static void playEnemyDeath() {
    if (!sfxEnabled) return;
    // FlameAudio.play('enemy_death.wav', volume: sfxVolume);
  }

  static void playPlayerHit() {
    if (!sfxEnabled) return;
    // FlameAudio.play('player_hit.wav', volume: sfxVolume);
  }

  static void playPickup() {
    if (!sfxEnabled) return;
    // FlameAudio.play('pickup.wav', volume: sfxVolume);
  }

  static void playLevelUp() {
    if (!sfxEnabled) return;
    // FlameAudio.play('level_up.wav', volume: sfxVolume);
  }

  static void playBossAppear() {
    if (!sfxEnabled) return;
    // FlameAudio.play('boss_appear.wav', volume: sfxVolume);
  }

  static void playDoorOpen() {
    if (!sfxEnabled) return;
    // FlameAudio.play('door_open.wav', volume: sfxVolume);
  }

  static void playGameOver() {
    if (!sfxEnabled) return;
    // FlameAudio.play('game_over.wav', volume: sfxVolume);
  }

  static void playButtonClick() {
    if (!sfxEnabled) return;
    // FlameAudio.play('click.wav', volume: sfxVolume);
  }

  // === BGM ===
  static void playMenuBgm() {
    if (!bgmEnabled) return;
    // FlameAudio.bgm.play('menu_bgm.mp3', volume: bgmVolume);
  }

  static void playDungeonBgm() {
    if (!bgmEnabled) return;
    // FlameAudio.bgm.play('dungeon_bgm.mp3', volume: bgmVolume);
  }

  static void playBossBgm() {
    if (!bgmEnabled) return;
    // FlameAudio.bgm.play('boss_bgm.mp3', volume: bgmVolume);
  }

  static void stopBgm() {
    FlameAudio.bgm.stop();
  }

  static void pauseBgm() {
    FlameAudio.bgm.pause();
  }

  static void resumeBgm() {
    FlameAudio.bgm.resume();
  }

  static void toggleSfx() {
    sfxEnabled = !sfxEnabled;
  }

  static void toggleBgm() {
    bgmEnabled = !bgmEnabled;
    if (!bgmEnabled) {
      stopBgm();
    }
  }
}
