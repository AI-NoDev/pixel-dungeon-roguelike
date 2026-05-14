import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Save slot data
class SaveSlotData {
  final int slotIndex;
  final bool exists;
  final int currentFloor;
  final int totalRuns;
  final int bestFloor;
  final int totalGold;
  final int currentGold;
  final String selectedHeroId;
  final DateTime? lastPlayed;

  const SaveSlotData({
    required this.slotIndex,
    required this.exists,
    this.currentFloor = 1,
    this.totalRuns = 0,
    this.bestFloor = 0,
    this.totalGold = 0,
    this.currentGold = 0,
    this.selectedHeroId = 'knight',
    this.lastPlayed,
  });

  factory SaveSlotData.empty(int index) =>
      SaveSlotData(slotIndex: index, exists: false);

  Map<String, dynamic> toJson() => {
        'currentFloor': currentFloor,
        'totalRuns': totalRuns,
        'bestFloor': bestFloor,
        'totalGold': totalGold,
        'currentGold': currentGold,
        'selectedHeroId': selectedHeroId,
        'lastPlayed': lastPlayed?.millisecondsSinceEpoch,
      };

  factory SaveSlotData.fromJson(int index, Map<String, dynamic> json) =>
      SaveSlotData(
        slotIndex: index,
        exists: true,
        currentFloor: json['currentFloor'] ?? 1,
        totalRuns: json['totalRuns'] ?? 0,
        bestFloor: json['bestFloor'] ?? 0,
        totalGold: json['totalGold'] ?? 0,
        currentGold: json['currentGold'] ?? 0,
        selectedHeroId: json['selectedHeroId'] ?? 'knight',
        lastPlayed: json['lastPlayed'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['lastPlayed'])
            : null,
      );

  SaveSlotData copyWith({
    int? currentFloor,
    int? totalRuns,
    int? bestFloor,
    int? totalGold,
    int? currentGold,
    String? selectedHeroId,
    DateTime? lastPlayed,
  }) {
    return SaveSlotData(
      slotIndex: slotIndex,
      exists: true,
      currentFloor: currentFloor ?? this.currentFloor,
      totalRuns: totalRuns ?? this.totalRuns,
      bestFloor: bestFloor ?? this.bestFloor,
      totalGold: totalGold ?? this.totalGold,
      currentGold: currentGold ?? this.currentGold,
      selectedHeroId: selectedHeroId ?? this.selectedHeroId,
      lastPlayed: lastPlayed ?? this.lastPlayed,
    );
  }
}

/// Save slot management (3 slots)
class SaveSlotSystem {
  static const slotCount = 3;

  static String _slotKey(int index) => 'save_slot_$index';

  static Future<List<SaveSlotData>> loadAllSlots() async {
    final prefs = await SharedPreferences.getInstance();
    final slots = <SaveSlotData>[];
    for (int i = 0; i < slotCount; i++) {
      final raw = prefs.getString(_slotKey(i));
      if (raw == null) {
        slots.add(SaveSlotData.empty(i));
      } else {
        try {
          final json = jsonDecode(raw) as Map<String, dynamic>;
          slots.add(SaveSlotData.fromJson(i, json));
        } catch (_) {
          slots.add(SaveSlotData.empty(i));
        }
      }
    }
    return slots;
  }

  static Future<SaveSlotData> loadSlot(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_slotKey(index));
    if (raw == null) return SaveSlotData.empty(index);
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return SaveSlotData.fromJson(index, json);
    } catch (_) {
      return SaveSlotData.empty(index);
    }
  }

  static Future<void> saveSlot(SaveSlotData data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_slotKey(data.slotIndex), jsonEncode(data.toJson()));
  }

  static Future<void> deleteSlot(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_slotKey(index));
  }

  /// Track active slot
  static int activeSlotIndex = 0;
}
