import 'package:shared_preferences/shared_preferences.dart';
import '../data/game_state.dart';

/// Handles persistent data storage
class SaveSystem {
  static const _keyTotalRuns = 'total_runs';
  static const _keyBestFloor = 'best_floor';
  static const _keyTotalGold = 'total_gold';
  static const _keyUnlockedHeroes = 'unlocked_heroes';
  static const _keyHighScores = 'high_scores';

  /// Load persistent game data
  static Future<void> loadPersistentData(GameState state) async {
    final prefs = await SharedPreferences.getInstance();
    state.totalRuns = prefs.getInt(_keyTotalRuns) ?? 0;
    state.bestFloor = prefs.getInt(_keyBestFloor) ?? 0;
    state.totalGoldEarned = prefs.getInt(_keyTotalGold) ?? 0;
  }

  /// Save persistent game data
  static Future<void> savePersistentData(GameState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyTotalRuns, state.totalRuns);
    await prefs.setInt(_keyBestFloor, state.bestFloor);
    await prefs.setInt(_keyTotalGold, state.totalGoldEarned);
  }

  /// Get unlocked hero indices
  static Future<List<int>> getUnlockedHeroes() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyUnlockedHeroes) ?? ['0'];
    return list.map((s) => int.parse(s)).toList();
  }

  /// Unlock a hero
  static Future<void> unlockHero(int heroIndex) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyUnlockedHeroes) ?? ['0'];
    if (!list.contains(heroIndex.toString())) {
      list.add(heroIndex.toString());
      await prefs.setStringList(_keyUnlockedHeroes, list);
    }
  }

  /// Save a high score entry
  static Future<void> saveHighScore(int floor, int kills, int gold) async {
    final prefs = await SharedPreferences.getInstance();
    final scores = prefs.getStringList(_keyHighScores) ?? [];
    scores.add('$floor|$kills|$gold');
    // Keep top 10
    if (scores.length > 10) {
      scores.sort((a, b) {
        final aFloor = int.parse(a.split('|')[0]);
        final bFloor = int.parse(b.split('|')[0]);
        return bFloor.compareTo(aFloor);
      });
      scores.removeRange(10, scores.length);
    }
    await prefs.setStringList(_keyHighScores, scores);
  }

  /// Get high scores
  static Future<List<HighScoreEntry>> getHighScores() async {
    final prefs = await SharedPreferences.getInstance();
    final scores = prefs.getStringList(_keyHighScores) ?? [];
    return scores.map((s) {
      final parts = s.split('|');
      return HighScoreEntry(
        floor: int.parse(parts[0]),
        kills: int.parse(parts[1]),
        gold: int.parse(parts[2]),
      );
    }).toList()
      ..sort((a, b) => b.floor.compareTo(a.floor));
  }
}

class HighScoreEntry {
  final int floor;
  final int kills;
  final int gold;

  const HighScoreEntry({
    required this.floor,
    required this.kills,
    required this.gold,
  });
}
