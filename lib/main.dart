import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game/pixel_dungeon_game.dart';
import 'ui/game_overlay.dart';
import 'ui/main_menu.dart';
import 'data/game_state.dart';
import 'data/heroes.dart';
import 'systems/save_system.dart';
import 'systems/audio_system.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await AudioSystem.init();

  runApp(const PixelDungeonApp());
}

class PixelDungeonApp extends StatelessWidget {
  const PixelDungeonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0D1A),
      ),
      home: const GameRoot(),
    );
  }
}

enum AppScreen { menu, game }

class GameRoot extends StatefulWidget {
  const GameRoot({super.key});

  @override
  State<GameRoot> createState() => _GameRootState();
}

class _GameRootState extends State<GameRoot> {
  AppScreen _currentScreen = AppScreen.menu;
  final GameState _persistentState = GameState();
  PixelDungeonGame? _game;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadSaveData();
  }

  Future<void> _loadSaveData() async {
    await SaveSystem.loadPersistentData(_persistentState);
    setState(() => _loaded = true);
  }

  void _startGame(HeroData hero) {
    final game = PixelDungeonGame();
    game.selectedHero = hero;

    // When game ends, sync persistent state
    game.onStateChanged = () {
      if (game.gameState.isGameOver) {
        _persistentState.totalRuns = game.gameState.totalRuns;
        _persistentState.totalGoldEarned = game.gameState.totalGoldEarned;
        if (game.gameState.currentFloor > _persistentState.bestFloor) {
          _persistentState.bestFloor = game.gameState.currentFloor;
        }
        SaveSystem.savePersistentData(_persistentState);
        SaveSystem.saveHighScore(
          game.gameState.currentFloor,
          game.gameState.enemiesKilled,
          game.gameState.gold,
        );
      }
    };

    setState(() {
      _game = game;
      _currentScreen = AppScreen.game;
    });
  }

  void _returnToMenu() {
    _game?.pauseEngine();
    setState(() {
      _currentScreen = AppScreen.menu;
      _game = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    switch (_currentScreen) {
      case AppScreen.menu:
        return MainMenu(
          gameState: _persistentState,
          onStartGame: _startGame,
        );
      case AppScreen.game:
        return Scaffold(
          body: Stack(
            children: [
              GameWidget(game: _game!),
              GameOverlay(game: _game!, onReturnToMenu: _returnToMenu),
            ],
          ),
        );
    }
  }
}
