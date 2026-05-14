import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'game/pixel_dungeon_game.dart';
import 'ui/game_overlay.dart';
import 'ui/main_menu.dart';
import 'ui/loading_screen.dart';
import 'ui/save_slot_screen.dart';
import 'data/heroes.dart';
import 'systems/audio_system.dart';
import 'systems/save_slot_system.dart';
import 'systems/preferences.dart';
import 'i18n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  await AudioSystem.init();
  await GamePreferences.load();

  runApp(const PixelDungeonApp());
}

class PixelDungeonApp extends StatelessWidget {
  const PixelDungeonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: localeNotifier,
      builder: (context, locale, _) {
        return MaterialApp(
          key: ValueKey('app_${locale.languageCode}'),
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: const Color(0xFF0D0D1A),
          ),
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const GameRoot(),
        );
      },
    );
  }
}

enum AppScreen { loading, saveSlot, menu, game }

class GameRoot extends StatefulWidget {
  const GameRoot({super.key});

  @override
  State<GameRoot> createState() => _GameRootState();
}

class _GameRootState extends State<GameRoot> {
  AppScreen _currentScreen = AppScreen.loading;
  PixelDungeonGame? _game;
  SaveSlotData? _activeSaveSlot;

  void _onLoadingComplete() {
    if (mounted) {
      setState(() => _currentScreen = AppScreen.saveSlot);
    }
  }

  void _onSlotSelected(SaveSlotData slot) {
    SaveSlotSystem.activeSlotIndex = slot.slotIndex;
    setState(() {
      _activeSaveSlot = slot;
      _currentScreen = AppScreen.menu;
    });
  }

  void _startGame(HeroData hero) {
    final game = PixelDungeonGame();
    game.selectedHero = hero;

    if (_activeSaveSlot != null) {
      game.gameState.currentFloor = _activeSaveSlot!.currentFloor;
      game.gameState.bestFloor = _activeSaveSlot!.bestFloor;
      game.gameState.totalRuns = _activeSaveSlot!.totalRuns;
      game.gameState.totalGoldEarned = _activeSaveSlot!.totalGold;
      game.gameState.gold = _activeSaveSlot!.currentGold;
    }

    game.onStateChanged = () {
      if (game.gameState.isGameOver) {
        _saveCurrentSlot(game);
      }
    };

    setState(() {
      _game = game;
      _currentScreen = AppScreen.game;
    });
  }

  Future<void> _saveCurrentSlot(PixelDungeonGame game) async {
    if (_activeSaveSlot == null) return;
    final updated = _activeSaveSlot!.copyWith(
      currentFloor: game.gameState.currentFloor,
      totalRuns: game.gameState.totalRuns,
      bestFloor: game.gameState.currentFloor > _activeSaveSlot!.bestFloor
          ? game.gameState.currentFloor
          : _activeSaveSlot!.bestFloor,
      totalGold: game.gameState.totalGoldEarned,
      currentGold: game.gameState.gold,
      lastPlayed: DateTime.now(),
    );
    await SaveSlotSystem.saveSlot(updated);
    _activeSaveSlot = updated;
  }

  void _returnToMenu() {
    _game?.pauseEngine();
    if (_game != null) _saveCurrentSlot(_game!);
    setState(() {
      _currentScreen = AppScreen.menu;
      _game = null;
    });
  }

  void _returnToSaveSlots() {
    setState(() {
      _activeSaveSlot = null;
      _currentScreen = AppScreen.saveSlot;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentScreen) {
      case AppScreen.loading:
        return LoadingScreen(onLoaded: _onLoadingComplete);

      case AppScreen.saveSlot:
        return SaveSlotScreen(onSlotSelected: _onSlotSelected);

      case AppScreen.menu:
        return MainMenuWithBack(
          slotData: _activeSaveSlot!,
          onStartGame: _startGame,
          onBack: _returnToSaveSlots,
        );

      case AppScreen.game:
        return Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: GameWidget(game: _game!),
              ),
              Positioned.fill(
                child: GameOverlay(
                  game: _game!,
                  onReturnToMenu: _returnToMenu,
                ),
              ),
            ],
          ),
        );
    }
  }
}

class MainMenuWithBack extends StatelessWidget {
  final SaveSlotData slotData;
  final Function(HeroData) onStartGame;
  final VoidCallback onBack;

  const MainMenuWithBack({
    super.key,
    required this.slotData,
    required this.onStartGame,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MainMenu(
            slotData: slotData,
            onStartGame: onStartGame,
          ),
          Positioned(
            top: 12,
            left: 12,
            child: SafeArea(
              child: IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back, color: Colors.white70),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black38,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
