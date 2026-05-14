# Ancient Slime（远古史莱姆）— 隐藏 BOSS

> 比 Slime King 更古老的存在。只有"屠杀者"才能见到它。

## 基本信息

| 字段 | 值 |
|------|-----|
| ID | `ancient_slime` |
| 出现条件 | 在 F1-F5 期间累计**击杀 50 个史莱姆**后，地图上随机出现一个隐藏房间 |
| 等级 | **隐藏 BOSS** |
| 元素 | 远古魔法 |
| 体型 | **60×60（最大）** |

## 数值

```yaml
HP: 1500（史莱姆王 3 倍）
速度: 50
接触伤害: 50
体型: 60×60 px
攻击: 全方位巨型激光、地面震击、虚空裂缝
特殊: 免疫某些元素（随机）

死亡奖励:
  - 必掉 Legendary 武器
  - 200 金币
  - 解锁"远古图鉴"成就
  - 解锁"虚空"楼层提前
  - 留下"远古印章"道具（永久 +5% 元素伤害）
```

## 形象设计

**巨大半透明绿色史莱姆**，体内能看到**水晶心脏**（深红色脉动）。表面**布满古代符文**（白色发光）。眼睛是**双重眼**（外圈白，内圈金）。整体散发**远古、神秘、强大**的气息。

### 视觉特征
- 体型 60×60（最大）
- 半透明（60% 不透明，能看到内部）
- **体内可见水晶心脏**（红色发光，每秒脉动一次）
- **远古符文**散布全身（白色，4-6 个）
- 周围有**虚空裂缝**（黑紫色 zigzag 线条）
- 双圆眼（外白内金）
- 整体颜色偏冷（青绿）

## 调色板

| 用途 | Hex |
|------|-----|
| 主体 | `#80DEEA` 60% alpha 青绿 |
| 高光 | `#E0F7FA` |
| 阴影 | `#00838F` 深青 |
| 心脏 | `#FF5252` 鲜红 |
| 心脏脉动 | `#FFFFFF` 白光 |
| 符文 | `#FFFFFF` 白发光 |
| 虚空裂缝 | `#311B92` 深紫 + `#1A1A2E` 黑 |
| 眼睛外 | `#FFFFFF` |
| 眼睛内 | `#FFD700` |

## 动画要点

### Idle (12 帧 × 6fps — Boss 级别)
- 缓慢呼吸
- 心脏脉动（每帧亮度变化）
- 符文随机闪烁
- 周围虚空裂缝缓慢生成消失

### Move (10 帧)
**漂移移动**（不像普通跳跃，更像漂浮）：
- 整体向前流动
- 拖着虚空尾迹
- 符文位置可变

### Attack 1 - Giant Laser (10 帧)
**全方位巨型激光**：
- 帧 0-2: 蓄力（心脏发光，眼睛红光）
- 帧 3-4: 锁定玩家
- 帧 5-7: **发射巨大白色激光**（穿透墙壁）
- 帧 8-9: 收回

### Attack 2 - Ground Slam (8 帧)
**地面震击**：
- 帧 0-2: 高高跃起
- 帧 3-5: 重重落下
- 帧 6-7: **5 个圆形冲击波**向外扩散（玩家踩到 30 伤害）

### Attack 3 - Void Rifts (10 帧)
**虚空裂缝**：
- 帧 0-2: 周围出现 4-6 个紫黑色裂缝
- 帧 3-5: 裂缝扩大
- 帧 6-8: **从裂缝中射出**虚空触手 / 子弹
- 帧 9: 裂缝关闭

### Death (30 帧 × 8fps — 史诗终极死法)
**远古坍塌**：
- 帧 0-3: 受致命一击 + 全屏白光
- 帧 4-7: 体内符文全亮
- 帧 8-11: 心脏破裂（红色血浆）
- 帧 12-15: 身体开始溶解（从底部）
- 帧 16-19: 露出**水晶骨架**
- 帧 20-23: 骨架碎裂
- 帧 24-27: 大量金光与传说装备掉落
- 帧 28: **远古印章**（绿玉坠子）出现
- 帧 29: 一切归于平静

## AI Prompt

```
Pixel art ancient mystical slime hidden boss, 60x60 pixels,
gigantic transparent translucent cyan-green ethereal slime body,
visible glowing red crystal heart inside chest pulsating,
ancient white runic markings scattered across body,
purple-black void rifts emerging around body,
double-ringed mystical eyes (white outer, gold inner),
ancient cosmic horror aesthetic, eldritch power feeling,
mysterious primordial creature, ethereal and dangerous,
12-color palette: #80DEEA translucent cyan-green main 60% opacity,
#E0F7FA highlight, #00838F dark cyan shadow,
#FF5252 red crystal heart, #FFFFFF white glowing runes and outer eye,
#FFD700 gold inner eye, #311B92 purple void, #1A1A2E black void,
transparent background, mystical retro 16-bit pixel art,
hidden boss epic creature sprite, --niji 6 --ar 1:1 --quality 5
```

### Crystal Heart Detail

```
Pixel art glowing red crystal heart inside translucent body, 16x16,
pulsating red gem with white inner light, beating animation,
4-frame heartbeat pulse cycle, transparent background,
mystical retro pixel art --ar 4:1
```

### Void Rift Effect

```
Pixel art purple-black void rift opening, 24x16 pixels,
zigzag tear in space-time with dark energy emanating,
8-frame opening and closing animation,
transparent background, cosmic horror aesthetic,
retro pixel art --ar 8:1
```

### Giant Laser Attack

```
Pixel art massive white laser beam attack, horizontal long shape,
bright white core with cyan outer glow, screen-filling beam,
8-frame charge-up to release animation,
transparent background, sci-fi epic retro pixel art --ar 8:1
```

### Epic Death Sequence

```
Pixel art ancient creature epic death, 30 frames horizontal,
massive translucent slime taking final blow, screen flash,
runes glowing intensely, crystal heart shattering,
body dissolving from bottom up revealing crystalline skeleton,
skeleton fragmenting, epic legendary loot exploding outward,
ancient seal artifact emerging, peaceful resolution,
cyan-red-gold palette, transparent background,
boss death epic retro pixel art --ar 30:1
```

## 特效（最豪华级别）

- **心脏脉动**：每秒红光闪烁
- **符文流动**：6 个符文持续闪烁
- **虚空裂缝**：周围每 2s 出现新裂缝
- **拖尾**：移动时身后紫黑残影
- **激光警告**：发射前 1s 红色锁定线
- **地震波**：5 圈圆形扩散
- **虚空触手**：从裂缝伸出
- **史诗死亡**：屏幕级金光 + 装备雨 + 远古印章

## 音效

### BGM
**Hidden Boss BGM**：远古、神秘、混合电子和管弦乐
- 比 Slime King BGM 更奇异
- 大量低频混响和神秘音

### SFX

| 事件 | 描述 |
|------|------|
| 出场 | 远古低吼 + 虚空哨音 |
| Idle | 持续神秘"嗡嗡"低音 |
| 心跳 | 每秒"咚..."重低音 |
| 移动 | 漂浮"嘶..."声 |
| 激光蓄力 | "嗡嗡嗡!"上升音 |
| 激光发射 | "嗡轰!"巨响 |
| 地震 | "BOOM!" + 屏幕震 |
| 虚空裂缝 | "嘶啪!"撕裂音 |
| 受击 | 远古怒吼 |
| 阶段死亡 | 史诗合唱 + 大量金属/玻璃声 + 远古吟唱结束 |

## 实现要点

```dart
class AncientSlime extends SlimeBase {
  int slimesKilledTracker = 0;  // 触发条件
  Timer attackPatternTimer = Timer(4.0);
  int currentAttackPattern = 0;
  
  AncientSlime({required Vector2 position}) : super(
    position: position,
    maxHp: 1500,
    speed: 50,
    contactDamage: 50,
    color: const Color(0xFF80DEEA),
    size: Vector2(60, 60),
  );
  
  static bool checkSpawnCondition(GameState state) {
    return state.slimesKilledThisRun >= 50;
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    attackPatternTimer.update(dt);
    if (attackPatternTimer.finished) {
      _executeAttack(currentAttackPattern);
      currentAttackPattern = (currentAttackPattern + 1) % 3;
      attackPatternTimer.reset();
    }
  }
  
  void _executeAttack(int pattern) {
    switch (pattern) {
      case 0: _giantLaser(); break;
      case 1: _groundSlam(); break;
      case 2: _voidRifts(); break;
    }
  }
  
  void _giantLaser() {
    // 蓄力 1s，然后发射
    Future.delayed(const Duration(seconds: 1), () {
      final dir = (game.player.position - position).normalized();
      spawnGiantLaser(direction: dir, damage: 60);
    });
  }
  
  void _groundSlam() {
    // 跳起 → 重重落下
    // 5 个同心圆冲击波
    spawnGroundShockwaves(rings: 5, damage: 30);
  }
  
  void _voidRifts() {
    // 4-6 个紫黑裂缝出现
    for (int i = 0; i < 5; i++) {
      spawnVoidRift(
        position: randomNearPosition(),
        damage: 25,
      );
    }
  }
  
  @override
  void onSlimeDeath() {
    // 史诗死亡序列
    spawnAncientDeathSequence();
    
    // 必掉 Legendary 武器
    final legendary = WeaponPool.getLegendaryWeapon();
    spawnWeaponDrop(position, legendary);
    
    // 解锁成就
    AchievementSystem.unlock(AchievementId.ancientHunter);
    
    // 远古印章
    game.world.add(AncientSealArtifact(position: position));
    
    // 永久 buff
    GameState.persistentBuffs.add('ancient_seal_elemental_dmg_5');
  }
}
```

## 触发条件细节

```dart
// 在 game state 中追踪
class GameState {
  int slimesKilledThisRun = 0;  // 重置每次 run
  bool ancientSlimeRoomSpawned = false;
}

// 在敌人死亡时
void onSlimeKilled() {
  game.gameState.slimesKilledThisRun++;
  if (game.gameState.slimesKilledThisRun == 50 
      && !game.gameState.ancientSlimeRoomSpawned) {
    // 在下一个房间生成隐藏门
    spawnHiddenRoomDoor();
    game.gameState.ancientSlimeRoomSpawned = true;
  }
}
```

## 特殊提示（玩家发现彩蛋）

游戏内不告诉玩家触发条件。但可能有以下提示：
- 击杀第 30 只史莱姆时，屏幕短暂出现"远古之眼"图标
- Reddit / 论坛慢慢传播触发条件（社区话题）
- 游戏内 Achievement 列表有"远古图鉴"占位（提示存在）
