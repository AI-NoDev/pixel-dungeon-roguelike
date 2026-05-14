# 14 — 完整音频设计

## 设计哲学

1. **每个交互都要有声音** — 视觉无声会让游戏感觉"卡住"
2. **每把武器独一无二** — 提升武器收集乐趣
3. **音效叠加要清晰** — 不会因为多个声音同时播放而糊成一团
4. **手机扬声器优先** — 不依赖低音
5. **风格统一** — 8-bit chiptune 为主，少量现代 SFX 调味

## 全局音量分级

```
最大音量 1.0 (100%)
├─ 0.7 (70%) — Boss 出场、Boss 死亡（戏剧性）
├─ 0.6 (60%) — 玩家死亡、关键拾取
├─ 0.5 (50%) — 普通 SFX、武器射击
├─ 0.4 (40%) — BGM 背景音乐
├─ 0.3 (30%) — UI 反馈
└─ 0.2 (20%) — 环境氛围音
```

---

## 1. 武器射击音效（每把独立）

### 设计原则

- 每把武器**独一无二**
- 稀有度越高，音效越独特/有质感
- 元素属性叠加在基础音效上
- 持续时间 100-300ms（不影响连射）

### 16 把武器音效详细

#### 手枪类（Pistol）

**Iron Pistol**（铁制手枪 - Common）
```
sfx_iron_pistol.wav
描述：经典左轮手枪 "Pew" 短促清脆
长度：120ms
特征：中频段为主，无回响
参考：经典 8-bit 射击音效
生成方式：sfxr → "shoot" preset
```

**Flame Pistol**（火焰手枪 - Uncommon）
```
sfx_flame_pistol.wav
描述：手枪声 + 火焰呼啸尾音
长度：180ms
特征：基础 Pistol + 60ms 火焰 hiss 衰减
合成：基础枪声 + 火焰白噪声叠加
```

**Frost Revolver**（冰霜左轮 - Rare）
```
sfx_frost_revolver.wav
描述：清脆"咔啦" + 冰晶碎裂尾音
长度：220ms
特征：高频"叮"开头 + 玻璃碎片声衰减
合成：金属敲击 + 玻璃破碎采样
```

#### 霰弹枪类（Shotgun）

**Rusty Shotgun**（生锈霰弹 - Common）
```
sfx_rusty_shotgun.wav
描述：低沉"BOOM"，略带破音感
长度：280ms
特征：低频炸响 + 0.3s 后摇
```

**Thunder Scatter**（雷电散弹 - Rare）
```
sfx_thunder_scatter.wav
描述：散弹爆裂 + 电弧滋滋声
长度：320ms
特征：BOOM + 多个 zap 子弹分裂
```

**Dragon Breath**（龙息霰弹 - Epic）
```
sfx_dragon_breath.wav
描述：怒龙咆哮 + 火焰喷射
长度：400ms
特征：低吼基底 + 燃烧呼啸
```

#### 步枪类（Rifle）

**Hunter Rifle**（猎人步枪 - Common）
```
sfx_hunter_rifle.wav
描述：精准 "PEW" 中频段，有空间感
长度：200ms
特征：清亮回响，狩猎枪声
```

**Poison Rifle**（毒液步枪 - Uncommon）
```
sfx_poison_rifle.wav
描述：步枪声 + 化学气泡声
长度：260ms
特征：枪声 + "波波"气泡尾音
```

#### 冲锋枪类（SMG）

**Rapid Blaster**（连射冲锋 - Common）
```
sfx_rapid_blaster.wav
描述：极短"叮"声，专门为高射速设计
长度：60ms
特征：高频脆响，无尾音
注意：高射速使用，必须超短不重叠
```

**Lightning SMG**（闪电冲锋 - Rare）
```
sfx_lightning_smg.wav
描述：电弧"滋"声短促
长度：80ms
特征：电流嗡鸣 + 高频脆响
```

**Void Sprayer**（虚空喷射 - Epic）
```
sfx_void_sprayer.wav
描述：诡异空灵的"嗡"声
长度：100ms
特征：合成器虚空声 + 紫色能量感
```

#### 狙击枪类（Sniper）

**Long Bow**（长弓 - Uncommon）
```
sfx_long_bow.wav
描述：弓弦"嗖"+ 箭飞过的破空声
长度：350ms
特征：拉弦响 + 破空哨音
```

**Ice Piercer**（冰刺穿弓 - Epic）
```
sfx_ice_piercer.wav
描述：弓弦释放 + 冰刺破空 + 命中冻结
长度：450ms
特征：3 段式：拉弓-飞行-冻结
```

#### 法杖类（Magic）

**Arcane Staff**（奥术法杖 - Uncommon）
```
sfx_arcane_staff.wav
描述：神秘魔法吟唱 + 能量释放
长度：300ms
特征：合成器 swell + 闪光"叮"
```

**Inferno Wand**（炼狱之杖 - Rare）
```
sfx_inferno_wand.wav
描述：火球凝聚 + 喷射呼啸
长度：380ms
特征：能量充能 + 火焰投射
```

**Staff of Eternity**（永恒之杖 - Legendary）
```
sfx_staff_of_eternity.wav
描述：神圣合唱 + 能量爆发
长度：500ms
特征：戏剧性最强：合唱 + 雷霆 + 闪光
```

---

## 2. 近战武器（待加入 P1 内容）

### 近战武器规划

考虑到玩家需求，规划 **6 把近战武器**作为 v1.1 内容：

| 武器 | 类型 | 攻速 | 特点 |
|------|------|------|------|
| **Iron Sword** | 剑（标准） | 1.5/s | 基础挥砍 |
| **Battle Axe** | 斧（重） | 0.8/s | 高伤慢速 |
| **Rapier** | 刺剑（快） | 3.0/s | 快速突刺 |
| **Frost Hammer** | 锤（冰） | 1.0/s | 群体减速 |
| **Flaming Spear** | 矛（火） | 2.0/s | 长距离戳 |
| **Soul Reaper** | 镰（毒） | 1.5/s | 范围吸血 |

### 近战武器音效

```
sfx_sword_swing.wav        — 剑挥动呼啸
sfx_sword_hit.wav          — 剑命中肉响
sfx_sword_block.wav        — 剑击中墙壁
sfx_axe_swing.wav          — 斧重量感 woosh
sfx_axe_hit.wav            — 斧劈砍重击
sfx_rapier_thrust.wav      — 突刺刺破空
sfx_hammer_swing.wav       — 锤挥动空气感
sfx_hammer_hit.wav         — 锤砸击地面
sfx_spear_thrust.wav       — 矛戳穿
sfx_scythe_swing.wav       — 镰大弧线
sfx_scythe_hit.wav         — 镰收割声
```

### 近战通用规则

- **挥动音**：武器经过空气的破空音（200-300ms）
- **命中音**：根据目标材质区分（敌人血肉 vs 墙壁石块）
- **暴击音**：命中音 + 高频强调（"叮"）

---

## 3. 元素反应音效（共 6 个）

```
sfx_reaction_vaporize.wav  — 蒸发：火+冰 → "嘶嘶嘶"+爆炸
sfx_reaction_overload.wav  — 超载：雷+火 → 大爆炸
sfx_reaction_freeze.wav    — 冻结：冰+雷 → 冰碎裂"啪嚓"
sfx_reaction_toxic.wav     — 剧毒：毒+火 → 化学反应"咝"
sfx_reaction_corrode.wav   — 腐蚀：毒+冰 → 腐蚀"滋"
sfx_reaction_chain.wav     — 传导：雷+毒 → 电流连锁
```

每个反应音效应该**有标志性**，让玩家听到就知道触发了什么。

---

## 4. 角色音效

### 玩家音效（4 英雄）

#### Knight（骑士）
```
sfx_knight_hurt.wav        — "唔！"低沉
sfx_knight_death.wav       — 倒下铠甲哐当声
sfx_knight_skill.wav       — 盾击：金属碰撞 + 战吼
sfx_knight_dash.wav        — 重型冲刺
```

#### Ranger（游侠）
```
sfx_ranger_hurt.wav        — "啊！"清亮
sfx_ranger_death.wav       — 轻倒下
sfx_ranger_skill.wav       — 箭雨：多次嗖嗖
sfx_ranger_dash.wav        — 轻盈跳跃
```

#### Mage（法师）
```
sfx_mage_hurt.wav          — "嗯！"含糊
sfx_mage_death.wav         — 魔法消散
sfx_mage_skill.wav         — Nova：能量充能 + 大爆发
sfx_mage_dash.wav          — 闪烁瞬移
```

#### Rogue（盗贼）
```
sfx_rogue_hurt.wav         — "嘁！"短促
sfx_rogue_death.wav        — 倒下匕首掉落
sfx_rogue_skill.wav        — 影步：风声 + 隐形音
sfx_rogue_dash.wav         — 极速短促
```

### 敌人音效

#### Slime（史莱姆）
```
sfx_slime_move.wav         — "啵啵"移动跳跃
sfx_slime_hit.wav          — 软软"啪"被打中（POP! 经典声）
sfx_slime_death.wav        — "啵嗤"散开声
```

#### Skeleton（骷髅）
```
sfx_skeleton_walk.wav      — 骨头摩擦
sfx_skeleton_shoot.wav     — 拉弓声
sfx_skeleton_hit.wav       — 骨头碰撞
sfx_skeleton_death.wav     — 骨头散落"哗啦"
```

#### Goblin（哥布林）
```
sfx_goblin_growl.wav       — 怪叫
sfx_goblin_attack.wav      — 战吼
sfx_goblin_hit.wav         — 痛叫
sfx_goblin_death.wav       — 倒下嚎叫
```

#### Golem（石像鬼）
```
sfx_golem_walk.wav         — 沉重步伐
sfx_golem_attack.wav       — 石头摩擦
sfx_golem_hit.wav          — 岩石撞击
sfx_golem_death.wav        — 崩塌声
```

#### Mage Enemy（敌方法师）
```
sfx_mage_enemy_cast.wav    — 黑暗咒语
sfx_mage_enemy_hit.wav     — 法师惊呼
sfx_mage_enemy_death.wav   — 黑雾消散
```

#### Bomber（炸弹人）
```
sfx_bomber_walk.wav        — 滴答声
sfx_bomber_explode.wav     — 大爆炸（关键音效）
```

### Boss 音效（每个 Boss 独立设计）

#### Skeleton King（骷髅王）
```
sfx_skeleton_king_appear.wav  — 王者降临：低音号角 + 骨笑
sfx_skeleton_king_attack.wav  — 大剑挥砍
sfx_skeleton_king_phase.wav   — 阶段切换：愤怒咆哮
sfx_skeleton_king_death.wav   — 国王陨落：哭号 + 崩散
```

#### Crystal Golem（水晶巨像）
```
sfx_crystal_golem_appear.wav  — 水晶共鸣 + 低吼
sfx_crystal_golem_attack.wav  — 巨锤砸地
sfx_crystal_golem_phase.wav   — 水晶炸裂 + 愤怒
sfx_crystal_golem_death.wav   — 水晶大碎裂
```

#### Warden Knight（守望骑士）
```
sfx_warden_knight_appear.wav  — 战吼 + 武器出鞘
sfx_warden_knight_attack.wav  — 大剑+火焰
sfx_warden_knight_phase.wav   — 燃烧爆发
sfx_warden_knight_death.wav   — 骑士落马
```

#### Inferno Lord（炼狱领主）
```
sfx_inferno_lord_appear.wav   — 烈火咆哮
sfx_inferno_lord_attack.wav   — 火焰冲击
sfx_inferno_lord_phase.wav    — 火山爆发
sfx_inferno_lord_death.wav    — 烈焰消散
```

#### Void Reaper（虚空收割者）
```
sfx_void_reaper_appear.wav    — 诡异虚空声 + 低语
sfx_void_reaper_attack.wav    — 镰刀挥砍 + 虚空裂痕
sfx_void_reaper_phase.wav     — 维度震荡
sfx_void_reaper_death.wav     — 终极崩解 + 胜利和声
```

---

## 5. 交互音效

### UI 交互
```
sfx_ui_click.wav             — 按钮点击
sfx_ui_hover.wav             — 按钮 hover（手机不用）
sfx_ui_back.wav              — 返回按钮
sfx_ui_open.wav              — 菜单打开
sfx_ui_close.wav             — 菜单关闭
sfx_ui_error.wav             — 错误反馈（解锁失败）
sfx_ui_success.wav           — 成功反馈（购买成功）
```

### 拾取音效（按物品类型）
```
sfx_pickup_coin_small.wav    — "叮" 小金币
sfx_pickup_coin_pile.wav     — "叮咚" 大堆金币
sfx_pickup_potion.wav        — 药水"咕咚"
sfx_pickup_weapon.wav        — 武器拾取闪光
sfx_pickup_item.wav          — 通用道具拾取
```

### 房间事件
```
sfx_room_clear.wav           — 房间清空：胜利铃声
sfx_door_open.wav            — 门开启："吱呀"+ 嗡声
sfx_door_locked.wav          — 门锁定提示
sfx_floor_complete.wav       — 楼层完成：阶梯式胜利音
sfx_treasure_open.wav        — 宝箱打开
sfx_shop_enter.wav           — 商店进入：商人欢迎
sfx_shop_buy.wav             — 购买成功
sfx_rest_heal.wav             — 休息治疗：温暖治愈音
```

### 状态/反馈
```
sfx_level_up.wav             — 升级：上升旋律
sfx_talent_pick.wav          — 选择天赋：神秘音
sfx_achievement.wav          — 成就解锁
sfx_low_health.wav           — 血量危险（循环警告）
sfx_combo.wav                — 连击：渐强叮叮
sfx_critical_hit.wav         — 暴击："叮！"高频
```

### 武器词缀触发
```
sfx_modifier_pierce.wav      — 穿透
sfx_modifier_bounce.wav      — 反弹
sfx_modifier_explosive.wav   — 爆炸
sfx_modifier_vampiric.wav    — 吸血
sfx_modifier_critical.wav    — 暴击
sfx_modifier_homing.wav      — 追踪
sfx_modifier_split.wav       — 分裂
sfx_modifier_chain.wav       — 链击
```

### 子弹效果
```
sfx_bullet_wall_hit.wav      — 子弹撞墙
sfx_bullet_disappear.wav     — 子弹超时消失
```

---

## 6. BGM 列表

| 文件 | 场景 | 风格 | 时长 |
|------|------|------|------|
| `bgm_loading.ogg` | 加载页 | 神秘期待 | 30s loop |
| `bgm_save_slot.ogg` | 存档选择 | 温暖怀旧 | 1min loop |
| `bgm_main_menu.ogg` | 主菜单 | 史诗激昂 | 2min loop |
| `bgm_shop.ogg` | 商店 | 轻松愉快 | 1min loop |
| `bgm_floor_crypt.ogg` | F1-F5 墓穴 | 阴森低沉 | 2-3min loop |
| `bgm_floor_cave.ogg` | F6-F10 洞穴 | 空灵清亮 | 2-3min loop |
| `bgm_floor_fortress.ogg` | F11-F15 堡垒 | 紧张激进 | 2-3min loop |
| `bgm_floor_inferno.ogg` | F16-F20 炼狱 | 烈火咆哮 | 2-3min loop |
| `bgm_floor_void.ogg` | F21+ 虚空 | 诡异迷幻 | 2-3min loop |
| `bgm_boss_normal.ogg` | F5/10/15 Boss | 史诗战斗 | 2min loop |
| `bgm_boss_inferno.ogg` | F20 Boss | 高强度紧张 | 2min loop |
| `bgm_boss_final.ogg` | F25 Boss | 终极对决 | 2min loop |
| `bgm_game_over.ogg` | 游戏结束 | 悲壮 | 30s |
| `bgm_victory.ogg` | 通关胜利 | 凯旋 | 1min |

---

## 7. 人物动画细则

### 玩家动画状态机

```
IDLE (待机)
  ↓ 移动输入
WALKING (行走) ←→ IDLE
  ↓ 射击输入
SHOOTING (射击)（叠加状态，可与移动同时）
  ↓ 受击
HURT (受伤)（短暂状态，0.2s）
  ↓ HP=0
DEATH (死亡)
  ↓ 技能使用
SKILL (技能动画)
```

### 每个英雄的动画帧数

#### Knight（骑士）
```
idle_front.png         — 4 帧 @ 4fps（轻微呼吸）
idle_back.png          — 4 帧
idle_left.png          — 4 帧
idle_right.png         — 4 帧
walk_front.png         — 4 帧 @ 12fps
walk_back.png          — 4 帧
walk_left.png          — 4 帧
walk_right.png         — 4 帧
hurt.png               — 2 帧 @ 8fps（红色闪烁）
death.png              — 6 帧 @ 8fps（倒下崩散）
skill_shield_bash.png  — 8 帧 @ 12fps（盾击挥动）
shoot.png              — 2 帧 @ 16fps（射击瞬间）
```

#### Ranger（游侠）— 同样 12 套
```
+ 自定义：拉弓动画 4 帧
+ 自定义：闪避翻滚 6 帧（v1.1）
```

#### Mage（法师）
```
+ 自定义：施法手势 6 帧
+ 自定义：法袍飘动 4 帧 idle
```

#### Rogue（盗贼）
```
+ 自定义：影步消失 4 帧 + 出现 4 帧
+ 自定义：奔跑 4 帧（替代 walk，更快）
```

### 武器持握动画

每把武器都需要在玩家手上的 sprite，根据 4 个方向：

```
weapon_pistol_front.png    — 玩家面向下时手枪位置
weapon_pistol_back.png     — 面向上
weapon_pistol_left.png     — 面向左
weapon_pistol_right.png    — 面向右
```

16 把武器 × 4 方向 = **64 张武器持握 sprite**。

可优化：用代码 rotate 一张正面图（已实现），但完美主义可以画 4 方向。

### 敌人动画

```
slime_idle.png         — 4 帧呼吸（pulsing）
slime_jump.png         — 6 帧跳跃移动
slime_hurt.png         — 2 帧
slime_death.png        — 6 帧（"啵嗤"散开）
```

每个敌人按此模式 × 6 个敌人 = 24 + 个 sprite sheet。

### Boss 动画

每个 Boss 至少 6 个状态：
```
boss_idle.png          — 4 帧
boss_walk.png          — 4 帧
boss_attack_radial.png — 8 帧（径向攻击）
boss_attack_aimed.png  — 6 帧（瞄准攻击）
boss_phase_change.png  — 8 帧（阶段切换怒吼）
boss_death.png         — 12 帧（死亡崩塌）
```

5 Boss × 6 状态 = **30 个 sprite sheet**。

### 子弹动画

```
bullet_basic.png       — 静态 1 帧（默认）
bullet_fire.png        — 4 帧（火焰跳动）
bullet_ice.png         — 静态 1 帧 + 拖尾
bullet_lightning.png   — 4 帧闪烁
bullet_poison.png      — 4 帧气泡
```

### 元素反应动画

每个反应都需要 spritesheet：

```
fx_vaporize.png        — 8 帧爆发（火+冰）
fx_overload.png        — 10 帧大爆炸
fx_freeze.png          — 6 帧冰冻
fx_toxic.png           — 8 帧毒云
fx_corrode.png         — 6 帧腐蚀
fx_chain.png           — 8 帧链电
```

---

## 8. 触觉反馈（Haptic）

iOS / Android 都支持，与音效配合：

```
// 轻反馈（点击、拾取）
HapticFeedback.selectionClick()

// 中反馈（命中、伤害）
HapticFeedback.lightImpact()

// 强反馈（暴击、Boss 命中）
HapticFeedback.mediumImpact()

// 极强反馈（玩家死亡、Boss 死亡）
HapticFeedback.heavyImpact()
```

### 触发场景

```
玩家受击           → light impact
玩家死亡           → heavy impact
暴击               → medium impact
Boss 阶段切换       → heavy impact
拾取武器           → light impact
点击按钮           → selection click
元素反应触发       → medium impact
```

---

## 9. 音频实现路径

### 文件位置

```
assets/audio/
├── bgm/                  # 14 首 BGM
├── sfx/
│   ├── weapons/         # 16 把远程 + 6 把近战 = 22 个
│   ├── reactions/       # 6 个元素反应
│   ├── characters/      # 4 英雄 + 6 敌人 + 5 Boss = 15+ 集
│   ├── ui/              # ~10 个 UI 音效
│   ├── pickups/         # ~5 个拾取音效
│   ├── events/          # ~10 个房间/楼层事件
│   └── modifiers/       # 8 个词缀触发
└── voices/              # （可选）人物语音
```

### 总文件数估算

```
BGM:        14
武器射击:    22（远程 16 + 近战 6）
元素反应:    6
角色:       30+（人物动作 + 死亡）
Boss:       20（5 Boss × 4 状态）
UI/拾取:    20
房间事件:    10
词缀:       8
══════════════════
总计:      130+ 个音频文件
```

### 体积预算

```
SFX 平均 30KB × 130 = 4 MB
BGM 平均 1 MB × 14 = 14 MB（压缩到 OGG 128kbps 后约 8 MB）
总音频体积上限：12 MB
```

### 加载策略

```dart
// app 启动时（main()）：预加载常用音效
await FlameAudio.audioCache.loadAll([
  'sfx/ui/click.wav',
  'sfx/pickups/coin_small.wav',
  'sfx/weapons/iron_pistol.wav',  // 默认武器
  'sfx/characters/player_hurt.wav',
]);

// 进入楼层时：加载本层 BGM 和敌人音效
await FlameAudio.audioCache.loadAll([
  'bgm/floor_crypt.ogg',
  'sfx/characters/slime_hit.wav',
  'sfx/characters/skeleton_shoot.wav',
]);

// 装备武器时：动态加载武器音效
await FlameAudio.audioCache.load('sfx/weapons/${weaponId}.wav');
```

---

## 10. 音频生成与采集

### 推荐工具

#### 程序化生成（最快）
- **[BFXR](https://www.bfxr.net/)**（免费，浏览器版）
- **[sfxr](https://www.drpetter.se/project_sfxr.html)**（经典 8-bit）
- **[ChipTone](https://sfbgames.itch.io/chiptone)**（可视化）

#### BGM 创作
- **[BoscaCeoil](https://terrycavanagh.itch.io/bosca-ceoil)**（chiptune 神器）
- **[Bandcamp](https://bandcamp.com/)** 购买独立音乐人作品（$10-30 单曲）
- **[Pixabay Music](https://pixabay.com/music/)**（免费 royalty-free）

#### 录制 + 编辑
- **[Audacity](https://www.audacityteam.org/)**（免费多轨）
- **[Reaper](https://www.reaper.fm/)**（$60，专业 DAW）

#### AI 生成
- **[Suno AI](https://www.suno.ai/)**（生成完整曲子，$10/月）
- **[Udio](https://www.udio.com/)**（高质量 BGM）
- **[AIVA](https://www.aiva.ai/)**（chiptune 专长）

### 推荐 Asset Pack

- [Universal Sound FX](https://soniss.com/)（10000+ SFX，$30）
- [Pixel Art Game Music](https://kvgarlic.itch.io/)
- [Free Game Music](https://opengameart.org/)（OpenGameArt 社区）

## 11. 集成到 audio_system.dart

文档中的所有音效都通过 `lib/systems/audio_system.dart` 调用。代码框架已经预留接口（注释了的 `FlameAudio.play(...)` 调用），只需要：

1. 把音频文件放到 `assets/audio/` 目录
2. 在 `pubspec.yaml` 中已经配置了 assets/audio/
3. 取消 audio_system.dart 中的注释
4. 在游戏中触发对应方法

后期工作量：
- 资源采集：3-5 天
- 代码集成：1-2 天
- 平衡调整：1 天

## 12. 验收标准

### 必备
- [ ] 每把武器都有专属射击音
- [ ] 每个英雄的受击/死亡音不同
- [ ] 每个 Boss 出场有标志性音乐
- [ ] 所有 UI 操作有音效反馈
- [ ] 元素反应有专属音效

### 提升体验
- [ ] BGM 切换有渐变（fade in/out）
- [ ] 多个相同音效不会重复爆音
- [ ] 暴击/连击有音频强调
- [ ] 触觉反馈与关键音效同步

### 技术
- [ ] 音频文件 < 12 MB 总和
- [ ] 加载速度 < 1s
- [ ] 不会内存泄漏（卸载未使用资源）
