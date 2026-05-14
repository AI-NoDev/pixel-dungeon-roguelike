import 'package:flutter/material.dart';
import '../data/heroes.dart';
import '../systems/save_slot_system.dart';
import '../i18n/app_localizations.dart';

class MainMenu extends StatefulWidget {
  final SaveSlotData slotData;
  final Function(HeroData) onStartGame;

  const MainMenu({
    super.key,
    required this.slotData,
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
        child: Row(
          children: [
            // Left side: Title + Stats + Start button
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTitle(),
                  const SizedBox(height: 16),
                  _buildStats(),
                  const SizedBox(height: 24),
                  _buildStartButton(),
                ],
              ),
            ),
            // Right side: Hero selection
            Expanded(
              flex: 3,
              child: _buildHeroSelection(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    final t = AppLocalizations.of(context);
    return Column(
      children: [
        // Logo image
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            'assets/images/logo.png',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.none,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          t.t('app_title'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          t.t('app_subtitle'),
          style: TextStyle(
            color: Colors.amber.shade400,
            fontSize: 12,
            fontWeight: FontWeight.w300,
            letterSpacing: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildStats() {
    final t = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            t.t('save_slot', {'n': '${widget.slotData.slotIndex + 1}'}),
            style: TextStyle(
              color: const Color(0xFF4FC3F7),
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statItem(t.t('total_runs'), '${widget.slotData.totalRuns}'),
              _statItem(t.t('best_floor'), '${widget.slotData.bestFloor}'),
              _statItem(t.t('gold'), '${widget.slotData.currentGold}'),
            ],
          ),
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
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroSelection() {
    final t = AppLocalizations.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          t.t('select_hero'),
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
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
                  widget.slotData.totalGold < hero.unlockCost;

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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isLocked
                            ? Colors.grey.shade800
                            : hero.color.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: isLocked
                          ? const Icon(Icons.lock, color: Colors.white38, size: 24)
                          : Icon(Icons.person, color: hero.color, size: 28),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getHeroName(t, hero),
                      style: TextStyle(
                        color: isLocked ? Colors.white38 : hero.color,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getHeroDesc(t, hero),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 9,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    _heroStat('HP', hero.maxHp.toInt(), 200),
                    _heroStat('SPD', hero.speed.toInt(), 250),
                    _heroStat('DMG', hero.damage.toInt(), 50),
                    _heroStat('ATK', (hero.fireRate * 10).toInt(), 60),
                    const SizedBox(height: 6),
                    Text(
                      hero.skill,
                      style: TextStyle(
                        color: hero.color.withValues(alpha: 0.8),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isLocked) ...[
                      const SizedBox(height: 4),
                      Text(
                        t.t('unlock_cost', {'gold': '${hero.unlockCost}'}),
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 9,
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

  String _getHeroName(AppLocalizations t, HeroData hero) {
    switch (hero.type) {
      case HeroType.knight:
        return t.t('hero_knight');
      case HeroType.ranger:
        return t.t('hero_ranger');
      case HeroType.mage:
        return t.t('hero_mage');
      case HeroType.rogue:
        return t.t('hero_rogue');
    }
  }

  String _getHeroDesc(AppLocalizations t, HeroData hero) {
    switch (hero.type) {
      case HeroType.knight:
        return t.t('hero_knight_desc');
      case HeroType.ranger:
        return t.t('hero_ranger_desc');
      case HeroType.mage:
        return t.t('hero_mage_desc');
      case HeroType.rogue:
        return t.t('hero_rogue_desc');
    }
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
    final t = AppLocalizations.of(context);
    final hero = HeroData.all[_selectedHeroIndex];
    final isLocked = hero.unlockCost > 0 &&
        widget.slotData.totalGold < hero.unlockCost;

    return ElevatedButton(
      onPressed: isLocked ? null : () => widget.onStartGame(hero),
      style: ElevatedButton.styleFrom(
        backgroundColor: isLocked ? Colors.grey.shade800 : hero.color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        isLocked ? t.t('locked') : t.t('start_dungeon'),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }
}
