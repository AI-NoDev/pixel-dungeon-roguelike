# 05 — 技术架构

## 技术栈

| 层 | 技术 | 版本 |
|----|------|------|
| 语言 | Dart | 3.11.5 |
| 框架 | Flutter | 3.41.9 |
| 游戏引擎 | Flame | 1.37.0 |
| 音频 | flame_audio | 2.12.1 |
| 持久化 | shared_preferences | 2.5.5 |
| 国际化 | flutter_localizations | SDK |
| 构建 | Gradle (Android) / Xcode (iOS) | latest |

## 整体架构

```
┌─────────────────────────────────────────────┐
│              Flutter App Shell              │
│  - main.dart (路由)                          │
│  - MaterialApp (主题/i18n)                   │
└──────────────┬──────────────────────────────┘
               ↓
┌─────────────────────────────────────────────┐
│              UI Screens (Flutter)           │
│  - LoadingScreen                             │
│  - SaveSlotScreen                            │
│  - MainMenu                                  │
│  - GameScreen (Stack: GameWidget+Overlay)    │
└──────────────┬──────────────────────────────┘
               ↓
┌─────────────────────────────────────────────┐
│         Game Layer (Flame Engine)           │
│  - PixelDungeonGame extends FlameGame        │
│  - Components (Player/Enemy/Bullet/...)      │
│  - Systems (Combat/Input/Skill/Element/...)  │
└──────────────┬──────────────────────────────┘
               ↓
┌─────────────────────────────────────────────┐
│              Data Layer                     │
│  - data/*.dart (Weapons/Talents/Heroes/...)  │
│  - SaveSystem / SaveSlotSystem               │
└─────────────────────────────────────────────┘
```

## 目录结构

```
lib/
├── main.dart                       # 应用入口、路由
├── game/
│   └── pixel_dungeon_game.dart     # FlameGame 主类
├── components/                     # 游戏内组件（Flame Component）
│   ├── player.dart
│   ├── enemy_spawner.dart
│   ├── boss.dart
│   ├── bullet.dart
│   ├── dungeon_room.dart
│   └── item_drop.dart
├── systems/                        # 游戏系统（行为逻辑）
│   ├── combat_system.dart
│   ├── input_system.dart
│   ├── skill_system.dart
│   ├── element_system.dart
│   ├── particle_system.dart
│   ├── audio_system.dart
│   ├── save_system.dart
│   └── save_slot_system.dart
├── data/                           # 静态数据/配置
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
├── ui/                             # Flutter UI 层
│   ├── loading_screen.dart
│   ├── save_slot_screen.dart
│   ├── main_menu.dart
│   ├── game_overlay.dart           # 游戏内 HUD/摇杆
│   ├── hud_widget.dart
│   ├── joystick_widget.dart
│   ├── skill_button.dart
│   ├── talent_picker.dart
│   ├── weapon_pickup.dart
│   ├── shop_widget.dart
│   ├── settings_widget.dart
│   └── minimap_widget.dart
└── i18n/
    └── app_localizations.dart      # 多语言

assets/
├── images/                         # 像素 sprite（待添加）
├── audio/                          # 音效与 BGM（待添加）
└── tiles/                          # tilesets（待添加）

docs/                               # 项目文档
android/                            # Android 平台工程
ios/                                # iOS 平台工程
test/                               # 单元测试
```

## 核心数据流

### 游戏内单帧更新

```dart
PixelDungeonGame.update(dt) {
  super.update(dt);                     // 1. Flame 内部组件更新
  combatSystem.update(dt);              // 2. 同步 input → player
  skillSystem.update(dt);               // 3. 技能冷却
  if (isCurrentRoomCleared) {           // 4. 检查房间清理
    _onRoomCleared();                   // 5. 触发奖励 UI
  }
}
```

### 输入事件流

```
Touch Event
    ↓
JoystickWidget (UI层)
    ↓
InputSystem.updateMove() / updateAim()
    ↓
CombatSystem.update() — 每帧同步给 Player
    ↓
Player.moveDirection / aimDirection
    ↓
Player._shoot() 触发子弹生成
```

### 房间生命周期

```
1. _spawnForCurrentRoom()
     ↓
2. Player 战斗 → Enemy.takeDamage → 死亡
     ↓
3. update() 检测 isCleared = true
     ↓
4. _onRoomCleared()
   - 暂停引擎
   - 通知 UI 显示天赋选择
     ↓
5. 玩家选完天赋
   - applyTalent() 修改 Player 属性
   - 恢复引擎
     ↓
6. 玩家点击 "Next Room"
     ↓
7. moveToNextRoom() / _moveToNextFloor()
   - 清理旧房间
   - regenerate() 重建房间
   - 生成新敌人
```

## 关键设计决策

### 为什么用 Flutter + Flame 而非 Unity？

| 维度 | Flutter + Flame | Unity |
|------|----------------|-------|
| 包体大小 | 30-50 MB | 60-100 MB |
| 启动速度 | < 2s | 3-5s |
| 学习曲线 | 已熟悉 Flutter | 需学 C# 和 Unity |
| 2D 性能 | 够用 | 过剩 |
| 商业授权 | 完全免费 | 需付费/分成 |
| 单人开发 | 适合 | 项目大反而拖累 |

### 为什么 UI 用 Flutter widget 而非 Flame Component？

- **触控响应**：Flutter widget 处理手势更稳定（已踩坑验证）
- **本地化**：Flutter 原生支持
- **可访问性**：Talkback / VoiceOver 自动支持
- **维护性**：Flutter UI 工具链成熟
- **Flame 只做游戏画面渲染，UI 完全交给 Flutter**

### 为什么不用 Provider/Riverpod 等状态管理？

- 游戏状态由 `PixelDungeonGame` 实例统一持有
- 跨页面状态用 `ValueNotifier`（i18n、设置）
- UI ↔ Game 通过回调函数通信（onShowTalentPicker 等）
- 引入框架反而增加复杂度

## 数据持久化方案

### 三类数据

| 类型 | 存储 | 示例 |
|------|------|------|
| **静态配置** | 代码常量 | 武器属性、Boss 数据 |
| **存档数据** | SharedPreferences (JSON) | 楼层进度、金币、英雄解锁 |
| **运行时状态** | 内存（GameState） | 当前 HP、当前武器、临时 buff |

### 存档键命名

```
save_slot_0 / save_slot_1 / save_slot_2  → 三个存档槽
total_runs                                → 全局统计
high_scores                                → 历史最高记录（最多 10 条）
achievements_unlocked                      → 成就列表
sound_enabled / music_enabled              → 设置项
```

## 性能优化策略

### 已采用

- 子弹超出屏幕自动销毁（`_lifetime > 3s`）
- 死亡敌人立即移除
- 敌人受击 flash 用延迟回调而非每帧检查
- 粒子使用对象池模式（auto-remove）

### 待优化

- 子弹对象池（替代频繁 add/remove）
- 离屏组件 cull（不绘制）
- 房间切换时 dispose 旧组件
- 主题资源懒加载

## 测试策略

### 单元测试（Dart）
- 数据层：weapons、talents 等数据结构
- 系统层：combat、element 计算逻辑
- 不测试 UI 渲染（Flame 难测）

### 集成测试
- 主流程：启动 → 选英雄 → 战斗 → 死亡 → 重启
- 存档流程：写入 → 读取 → 验证

### 手动测试
- iOS / Android 真机各 1 部
- 每次发版前 30 分钟 playtest

## CI/CD

### 当前
- 本地构建（macOS）
- GitHub Actions 暂未启用

### 未来计划
- GitHub Actions 自动 lint + analyze
- 发版前手动构建 release

## 安全与合规

### 隐私
- 不收集 PII
- 不发送任何网络请求
- 不接入第三方 SDK（Analytics 也不要）
- 符合 GDPR 默认无追踪条款

### 代码审计
- 不引入未知 npm/pub 包
- 依赖固定版本号
- 定期 `flutter pub outdated` 检查 CVE
