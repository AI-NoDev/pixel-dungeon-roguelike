import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  static const supportedLocales = [
    Locale('en'),
    Locale('zh'),
  ];

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      // Loading
      'loading': 'Loading...',
      'loading_assets': 'Loading game assets',

      // Main menu
      'app_title': 'POP! SLIME',
      'app_subtitle': 'PIXEL ROGUELIKE',
      'select_hero': 'SELECT HERO',
      'start_dungeon': 'START DUNGEON',
      'locked': 'LOCKED',
      'unlock_cost': 'Unlock: {gold} gold',

      // Save slots
      'save_slot_title': 'SELECT SAVE',
      'save_slot': 'Slot {n}',
      'empty_slot': 'Empty',
      'new_game': 'New Game',
      'continue_game': 'Continue',
      'delete_save': 'Delete',
      'confirm_delete': 'Delete this save?',
      'cancel': 'Cancel',
      'confirm': 'Confirm',

      // Save info
      'best_floor': 'Best Floor',
      'total_runs': 'Runs',
      'total_gold': 'Gold',
      'last_played': 'Last played',

      // Settings
      'settings': 'SETTINGS',
      'language': 'Language',
      'sound_effects': 'Sound Effects',
      'background_music': 'Background Music',
      'sfx_volume': 'SFX Volume',
      'bgm_volume': 'BGM Volume',
      'auto_aim': 'Auto Aim',
      'auto_aim_range': 'Auto Aim Range',
      'close': 'Close',

      // Game UI
      'floor': 'Floor',
      'gold': 'Gold',
      'next_room': 'Next Room',
      'paused': 'Paused',
      'resume': 'Resume',
      'quit': 'Quit',
      'level_up': 'LEVEL UP!',
      'choose_talent': 'Choose a talent',

      // Game over
      'game_over': 'GAME OVER',
      'floor_reached': 'Floor Reached',
      'rooms_cleared': 'Rooms Cleared',
      'enemies_killed': 'Enemies Killed',
      'gold_earned': 'Gold Earned',
      'retry': 'Retry',
      'menu': 'Menu',

      // Heroes
      'hero_knight': 'Knight',
      'hero_knight_desc': 'Balanced warrior with high HP',
      'hero_ranger': 'Ranger',
      'hero_ranger_desc': 'Fast shooter with high fire rate',
      'hero_mage': 'Mage',
      'hero_mage_desc': 'High damage, low HP, elemental attacks',
      'hero_rogue': 'Rogue',
      'hero_rogue_desc': 'Very fast, critical hits, fragile',

      // Shop
      'shop': 'SHOP',
      'leave_shop': 'Leave Shop',
      'sold': 'SOLD',

      // Weapon
      'equip': 'Equip',
      'skip': 'Skip',
      'damage': 'Damage',
      'fire_rate': 'Fire Rate',
      'bullets': 'Bullets',
      'element': 'Element',

      // Talents
      'talent_power_shot_name': 'Power Shot',
      'talent_power_shot_desc': 'Damage +25%',
      'talent_rapid_fire_name': 'Rapid Fire',
      'talent_rapid_fire_desc': 'Fire rate +30%',
      'talent_sniper_focus_name': 'Sniper Focus',
      'talent_sniper_focus_desc': 'Bullet speed +40%, Damage +15%',
      'talent_multi_shot_name': 'Multi Shot',
      'talent_multi_shot_desc': '+2 bullets per shot',
      'talent_precision_name': 'Precision',
      'talent_precision_desc': 'Reduce spread by 50%, Damage +10%',
      'talent_berserker_name': 'Berserker',
      'talent_berserker_desc': 'Damage +50%, but Max HP -20',
      'talent_iron_skin_name': 'Iron Skin',
      'talent_iron_skin_desc': 'Max HP +30',
      'talent_regeneration_name': 'Regeneration',
      'talent_regeneration_desc': 'Heal 30 HP now',
      'talent_vitality_name': 'Vitality',
      'talent_vitality_desc': 'Max HP +50, Heal to full',
      'talent_dodge_master_name': 'Dodge Master',
      'talent_dodge_master_desc': 'Move speed +35%',
      'talent_swift_feet_name': 'Swift Feet',
      'talent_swift_feet_desc': 'Move speed +20%',
      'talent_bullet_storm_name': 'Bullet Storm',
      'talent_bullet_storm_desc': 'Fire rate +20%, Bullet speed +20%',
      'talent_all_rounder_name': 'All Rounder',
      'talent_all_rounder_desc': 'Damage +10%, Speed +10%, HP +15',

      // Themes
      'theme_crypt': 'Ancient Crypt',
      'theme_cave': 'Crystal Cave',
      'theme_fortress': 'Iron Fortress',
      'theme_inferno': 'Inferno Depths',
      'theme_void': 'The Void',

      // Room types
      'room_combat': 'Room',
      'room_elite': 'Elite Room',
      'room_treasure': 'Treasure Room',
      'room_shop': 'Shop',
      'room_rest': 'Rest Area',
      'room_boss': 'BOSS',
    },
    'zh': {
      // Loading
      'loading': '加载中...',
      'loading_assets': '正在加载游戏资源',

      // Main menu
      'app_title': '啵噗史莱姆',
      'app_subtitle': '像素 ROGUELIKE',
      'select_hero': '选择英雄',
      'start_dungeon': '进入地牢',
      'locked': '已锁定',
      'unlock_cost': '解锁需要：{gold} 金币',

      // Save slots
      'save_slot_title': '选择存档',
      'save_slot': '存档 {n}',
      'empty_slot': '空',
      'new_game': '新游戏',
      'continue_game': '继续',
      'delete_save': '删除',
      'confirm_delete': '删除此存档？',
      'cancel': '取消',
      'confirm': '确定',

      // Save info
      'best_floor': '最高楼层',
      'total_runs': '游戏次数',
      'total_gold': '金币总数',
      'last_played': '上次游玩',

      // Settings
      'settings': '设置',
      'language': '语言',
      'sound_effects': '音效',
      'background_music': '背景音乐',
      'sfx_volume': '音效音量',
      'bgm_volume': '音乐音量',
      'auto_aim': '自动瞄准',
      'auto_aim_range': '自动瞄准范围',
      'close': '关闭',

      // Game UI
      'floor': '楼层',
      'gold': '金币',
      'next_room': '下一房间',
      'paused': '已暂停',
      'resume': '继续',
      'quit': '退出',
      'level_up': '升级！',
      'choose_talent': '选择天赋',

      // Game over
      'game_over': '游戏结束',
      'floor_reached': '到达楼层',
      'rooms_cleared': '清理房间',
      'enemies_killed': '击杀敌人',
      'gold_earned': '获得金币',
      'retry': '重试',
      'menu': '主菜单',

      // Heroes
      'hero_knight': '骑士',
      'hero_knight_desc': '平衡型战士，高生命值',
      'hero_ranger': '游侠',
      'hero_ranger_desc': '快速射手，高攻速',
      'hero_mage': '法师',
      'hero_mage_desc': '高伤害，低血量，元素攻击',
      'hero_rogue': '盗贼',
      'hero_rogue_desc': '极速移动，暴击伤害，脆皮',

      // Shop
      'shop': '商店',
      'leave_shop': '离开商店',
      'sold': '已售',

      // Weapon
      'equip': '装备',
      'skip': '跳过',
      'damage': '伤害',
      'fire_rate': '射速',
      'bullets': '弹数',
      'element': '元素',

      // Talents
      'talent_power_shot_name': '强力射击',
      'talent_power_shot_desc': '伤害 +25%',
      'talent_rapid_fire_name': '快速射击',
      'talent_rapid_fire_desc': '射速 +30%',
      'talent_sniper_focus_name': '狙击专注',
      'talent_sniper_focus_desc': '子弹速度 +40%，伤害 +15%',
      'talent_multi_shot_name': '多重射击',
      'talent_multi_shot_desc': '每次射击 +2 发子弹',
      'talent_precision_name': '精准射击',
      'talent_precision_desc': '散射降低 50%，伤害 +10%',
      'talent_berserker_name': '狂战士',
      'talent_berserker_desc': '伤害 +50%，但最大生命值 -20',
      'talent_iron_skin_name': '铁皮',
      'talent_iron_skin_desc': '最大生命值 +30',
      'talent_regeneration_name': '回复',
      'talent_regeneration_desc': '立即恢复 30 生命值',
      'talent_vitality_name': '活力',
      'talent_vitality_desc': '最大生命值 +50，全额恢复',
      'talent_dodge_master_name': '闪避大师',
      'talent_dodge_master_desc': '移动速度 +35%',
      'talent_swift_feet_name': '迅捷之足',
      'talent_swift_feet_desc': '移动速度 +20%',
      'talent_bullet_storm_name': '弹幕风暴',
      'talent_bullet_storm_desc': '射速 +20%，子弹速度 +20%',
      'talent_all_rounder_name': '全能型',
      'talent_all_rounder_desc': '伤害 +10%，速度 +10%，生命 +15',

      // Themes
      'theme_crypt': '远古墓穴',
      'theme_cave': '水晶洞穴',
      'theme_fortress': '钢铁堡垒',
      'theme_inferno': '炼狱深渊',
      'theme_void': '虚空',

      // Room types
      'room_combat': '房间',
      'room_elite': '精英房间',
      'room_treasure': '宝藏房间',
      'room_shop': '商店',
      'room_rest': '休息区',
      'room_boss': 'BOSS',
    },
  };

  String t(String key, [Map<String, String>? params]) {
    final lang = _localizedValues[locale.languageCode] ?? _localizedValues['en']!;
    var value = lang[key] ?? _localizedValues['en']?[key] ?? key;
    if (params != null) {
      params.forEach((k, v) {
        value = value.replaceAll('{$k}', v);
      });
    }
    return value;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.any((l) => l.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => true;
}

/// Global locale notifier for runtime language switching
class LocaleNotifier extends ValueNotifier<Locale> {
  LocaleNotifier(super.value);

  void setLocale(Locale locale) {
    value = locale;
  }
}

final localeNotifier = LocaleNotifier(const Locale('en'));
