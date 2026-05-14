import 'package:flutter/material.dart';
import '../data/heroes.dart';
import '../data/game_state.dart';

class MainMenu extends StatefulWidget {
  final GameState gameState;
  final Function(HeroData) onStartGame;

  const MainMenu({
    super.key,
    required this.gameState,
    required this.onStartGame,
  });

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int _selectedHeroIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0D0D1A), Color(0xFF1a1a2e), Color(0xFF16213E)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Title
            _buildTitle(),
            const SizedBox(height: 20),
            // Stats
            _buildStats(),
            const SizedBox(height: 30),
            // Hero selection
            Expanded(child: _buildHeroSelection()),
            // Start button
            _buildStartButton(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        const Text(
          'PIXEL DUNGEON',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'SURVIVORS',
          style: TextStyle(
            color: Colors.amber.shade400,
            fontSize: 18,
            fontWeight: FontWeight.w300,
            letterSpacing: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem('Runs', '${widget.gameState.totalRuns}'),
          _statItem('Best Floor', '${widget.gameState.bestFloor}'),
          _statItem('Gold', '${widget.gameState.totalGoldEarned}'),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroSelection() {
    return Column(
      children: [
        const Text(
          'SELECT HERO',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: PageView.builder(
            itemCount: HeroData.all.length,
            controller: PageController(viewportFraction: 0.6, initialPage: 0),
            onPageChanged: (index) {
              setState(() => _selectedHeroIndex = index);
            },
            itemBuilder: (context, index) {
              final hero = HeroData.all[index];
              final isSelected = index == _selectedHeroIndex;
              final isLocked = hero.unlockCost > 0 &&
                  widget.gameState.totalGoldEarned < hero.unlockCost;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: isSelected ? 0 : 16,
                ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF2D2D44)
                      : const Color(0xFF1a1a2e),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? hero.color : Colors.white12,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Hero avatar
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: isLocked
                            ? Colors.grey.shade800
                            : hero.color.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: isLocked
                          ? const Icon(Icons.lock, color: Colors.white38, size: 28)
                          : Icon(Icons.person, color: hero.color, size: 32),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      hero.name,
                      style: TextStyle(
                        color: isLocked ? Colors.white38 : hero.color,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hero.description,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    // Stats
                    _heroStat('HP', hero.maxHp.toInt(), 200),
                    _heroStat('SPD', hero.speed.toInt(), 250),
                    _heroStat('DMG', hero.damage.toInt(), 50),
                    _heroStat('ATK', (hero.fireRate * 10).toInt(), 60),
                    const SizedBox(height: 8),
                    // Skill
                    Text(
                      hero.skill,
                      style: TextStyle(
                        color: hero.color.withValues(alpha: 0.8),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isLocked) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Unlock: ${hero.unlockCost} gold',
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _heroStat(String label, int value, int maxValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 9,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: (value / maxValue).clamp(0, 1),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton() {
    final hero = HeroData.all[_selectedHeroIndex];
    final isLocked = hero.unlockCost > 0 &&
        widget.gameState.totalGoldEarned < hero.unlockCost;

    return ElevatedButton(
      onPressed: isLocked ? null : () => widget.onStartGame(hero),
      style: ElevatedButton.styleFrom(
        backgroundColor: isLocked ? Colors.grey.shade800 : hero.color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        isLocked ? 'LOCKED' : 'START DUNGEON',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }
}
