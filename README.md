# Pixel Dungeon Survivors

A 2D pixel-art Roguelike dungeon crawler built with Flutter + Flame engine. Inspired by Soul Knight and Gunfire Reborn.

## 🎮 Gameplay

- **Twin-stick shooter** — Move with left joystick, aim/shoot with right joystick
- **Procedural dungeons** — Random room layouts, enemies, and loot every run
- **Roguelike progression** — Die, learn, upgrade, repeat
- **Element reactions** — Combine fire, ice, lightning, and poison for devastating combos

## ✨ Features

### Core Systems
- 4 playable heroes with unique active skills
- 16+ weapons across 6 types (pistol, shotgun, rifle, SMG, sniper, magic)
- 5 weapon rarity tiers with floor-based drop rates
- 13 talent upgrades (choose 1 of 3 after each room)
- Weapon modifier system (piercing, explosive, vampiric, etc.)

### Dungeon Structure
- 5 themed biomes (Crypt → Cave → Fortress → Inferno → Void)
- 6 room types: Combat, Elite, Treasure, Shop, Rest, Boss
- 5 unique bosses with multi-phase AI and attack patterns
- Difficulty scaling per floor

### Combat
- 6 enemy types with distinct behaviors
- 4 elements with 6 elemental reactions
- Particle effects on hits, deaths, and reactions
- Item drops (health, gold, temporary buffs)

### Meta Progression
- Persistent gold and stats across runs
- Hero unlock system
- 10 achievements
- Daily challenge mode with random modifiers
- High score tracking

## 🛠 Tech Stack

- **Flutter 3.41.9** + **Dart 3.11.5**
- **Flame 1.37.0** — Game engine
- **Flame Audio** — Sound effects and BGM
- **SharedPreferences** — Save data persistence

## 📱 Platforms

- iOS (primary target)
- Android
- Web (experimental)

## 🚀 Build & Run

```bash
flutter pub get
flutter run
```

## 🏗 CI/CD

Automated builds via [Codemagic](https://codemagic.io):
- Push to `main` → Auto build debug
- Manual trigger → Release build → TestFlight

## 📁 Project Structure

```
lib/
├── main.dart              # App entry point
├── game/                  # Core game logic
│   └── pixel_dungeon_game.dart
├── components/            # Game entities
│   ├── player.dart
│   ├── enemy_spawner.dart
│   ├── boss.dart
│   ├── bullet.dart
│   ├── dungeon_room.dart
│   └── item_drop.dart
├── systems/               # Game systems
│   ├── combat_system.dart
│   ├── input_system.dart
│   ├── skill_system.dart
│   ├── element_system.dart
│   ├── particle_system.dart
│   ├── audio_system.dart
│   └── save_system.dart
├── data/                  # Game data/config
│   ├── weapons.dart
│   ├── weapon_modifiers.dart
│   ├── talents.dart
│   ├── heroes.dart
│   ├── boss_data.dart
│   ├── items.dart
│   ├── dungeon_theme.dart
│   ├── floor_config.dart
│   ├── achievements.dart
│   ├── daily_challenge.dart
│   └── game_state.dart
└── ui/                    # Flutter UI overlays
    ├── main_menu.dart
    ├── game_overlay.dart
    ├── hud_widget.dart
    ├── joystick_widget.dart
    ├── skill_button.dart
    ├── talent_picker.dart
    ├── weapon_pickup.dart
    ├── shop_widget.dart
    ├── minimap_widget.dart
    └── settings_widget.dart
```

## 📋 Roadmap

- [ ] Pixel art sprites (replace color blocks)
- [ ] Sound effects and background music
- [ ] More weapons and enemies
- [ ] Weapon upgrade/fusion system
- [ ] Leaderboard (Game Center)
- [ ] Localization (EN/CN)
- [ ] App Store release
