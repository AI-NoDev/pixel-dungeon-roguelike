/// Holds all game state for the current run
class GameState {
  int currentFloor = 1;
  int roomsCleared = 0;
  int enemiesKilled = 0;
  int gold = 0;
  bool isGameOver = false;
  bool isPaused = false;

  // Player permanent upgrades (persist between runs)
  int totalGoldEarned = 0;
  int totalRuns = 0;
  int bestFloor = 0;

  void reset() {
    // Save stats before reset
    totalGoldEarned += gold;
    totalRuns++;
    if (currentFloor > bestFloor) bestFloor = currentFloor;

    // Reset run state
    currentFloor = 1;
    roomsCleared = 0;
    enemiesKilled = 0;
    gold = 0;
    isGameOver = false;
    isPaused = false;
  }
}
