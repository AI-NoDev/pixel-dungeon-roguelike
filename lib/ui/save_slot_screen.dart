import 'package:flutter/material.dart';
import '../i18n/app_localizations.dart';
import '../systems/save_slot_system.dart';
import 'settings_widget.dart';

class SaveSlotScreen extends StatefulWidget {
  final Function(SaveSlotData) onSlotSelected;

  const SaveSlotScreen({super.key, required this.onSlotSelected});

  @override
  State<SaveSlotScreen> createState() => _SaveSlotScreenState();
}

class _SaveSlotScreenState extends State<SaveSlotScreen> {
  List<SaveSlotData> _slots = [];
  bool _loaded = false;
  bool _showSettings = false;

  @override
  void initState() {
    super.initState();
    _loadSlots();
  }

  Future<void> _loadSlots() async {
    final slots = await SaveSlotSystem.loadAllSlots();
    if (mounted) {
      setState(() {
        _slots = slots;
        _loaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0D0D1A),
                  Color(0xFF1a1a2e),
                  Color(0xFF16213E),
                ],
              ),
            ),
            child: SafeArea(
              child: !_loaded
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        // Header
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  t.t('save_slot_title'),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 4,
                                  ),
                                ),
                              ),
                              // Settings button
                              IconButton(
                                onPressed: () =>
                                    setState(() => _showSettings = true),
                                icon: const Icon(
                                  Icons.settings,
                                  color: Colors.white70,
                                ),
                              ),
                              // Language toggle
                              IconButton(
                                onPressed: _toggleLanguage,
                                icon: const Icon(
                                  Icons.language,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Save slots
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              children: List.generate(_slots.length, (index) {
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: _buildSlotCard(_slots[index]),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
            ),
          ),
          // Settings overlay
          if (_showSettings)
            SettingsWidget(
              onClose: () => setState(() => _showSettings = false),
            ),
        ],
      ),
    );
  }

  Widget _buildSlotCard(SaveSlotData slot) {
    final t = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a2e),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: slot.exists ? const Color(0xFF4FC3F7) : Colors.white24,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Slot header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              t.t('save_slot', {'n': '${slot.slotIndex + 1}'}),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: slot.exists ? const Color(0xFF4FC3F7) : Colors.white38,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(color: Colors.white12, height: 1),
          // Slot content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: slot.exists ? _buildSlotInfo(slot) : _buildEmptySlot(),
            ),
          ),
          // Actions
          Padding(
            padding: const EdgeInsets.all(8),
            child: slot.exists
                ? Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => widget.onSlotSelected(slot),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4FC3F7),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: Text(
                            t.t('continue_game'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        onPressed: () => _confirmDelete(slot),
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                          size: 18,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                      ),
                    ],
                  )
                : ElevatedButton(
                    onPressed: () => _startNewGame(slot.slotIndex),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: Text(
                      t.t('new_game'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlotInfo(SaveSlotData slot) {
    final t = AppLocalizations.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _statRow(
          t.t('floor'),
          '${slot.currentFloor}',
          icon: Icons.stairs,
          color: Colors.lightBlue,
        ),
        _statRow(
          t.t('best_floor'),
          '${slot.bestFloor}',
          icon: Icons.flag,
          color: Colors.amber,
        ),
        _statRow(
          t.t('total_runs'),
          '${slot.totalRuns}',
          icon: Icons.replay,
          color: Colors.purpleAccent,
        ),
        _statRow(
          t.t('gold'),
          '${slot.currentGold}',
          icon: Icons.monetization_on,
          color: Colors.amber,
        ),
        if (slot.lastPlayed != null)
          Text(
            _formatDate(slot.lastPlayed!),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 9,
            ),
          ),
      ],
    );
  }

  Widget _buildEmptySlot() {
    final t = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_circle_outline,
            size: 36,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 8),
          Text(
            t.t('empty_slot'),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statRow(String label, String value,
      {required IconData icon, required Color color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 10),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 30) return '${diff.inDays}d ago';
    return '${date.year}/${date.month}/${date.day}';
  }

  void _startNewGame(int slotIndex) async {
    final newSlot = SaveSlotData(
      slotIndex: slotIndex,
      exists: true,
      currentFloor: 1,
      totalRuns: 0,
      bestFloor: 0,
      totalGold: 0,
      currentGold: 0,
      selectedHeroId: 'knight',
      lastPlayed: DateTime.now(),
    );
    await SaveSlotSystem.saveSlot(newSlot);
    SaveSlotSystem.activeSlotIndex = slotIndex;
    widget.onSlotSelected(newSlot);
  }

  void _confirmDelete(SaveSlotData slot) {
    final t = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        title: Text(
          t.t('confirm_delete'),
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t.t('cancel')),
          ),
          TextButton(
            onPressed: () async {
              await SaveSlotSystem.deleteSlot(slot.slotIndex);
              if (!ctx.mounted) return;
              Navigator.pop(ctx);
              _loadSlots();
            },
            child: Text(
              t.t('confirm'),
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleLanguage() {
    final current = localeNotifier.value.languageCode;
    localeNotifier.setLocale(
      Locale(current == 'en' ? 'zh' : 'en'),
    );
  }
}
