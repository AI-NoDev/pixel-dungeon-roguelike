# Slime King（史莱姆王）— F5 BOSS

> 史莱姆王国的最终统治者。第一关 Boss，但要击败需要全力。

## 基本信息

| 字段 | 值 |
|------|-----|
| ID | `slime_king` |
| 出现楼层 | F5（Boss 房）|
| 等级 | **BOSS** |
| 元素 | 物理（多样化）|
| 体型 | **48×48（巨型）** |

## 数值（4 阶段）

```yaml
HP: 500
速度: 40
接触伤害: 30
体型: 48×48 px
4 个阶段:
  阶段一 (HP 100%-70%): 跳跃攻击 + 召唤 Green Slime × 2
  阶段二 (HP 70%-40%): 分裂为 4 个中型史莱姆
  阶段三 (HP 40%-15%): 全屏弹幕 + 高速冲撞
  阶段四 (HP 15%-0%): 召唤所有 S 系列史莱姆 (1 只 Acid + 1 只 Frost + 1 只 Lava)

死亡奖励:
  - 100 金币
  - 必掉 Epic 武器
  - 永久解锁"史莱姆英雄"角色（彩蛋）
  - 推进到 F6（解锁 Crystal Cave）
```

## 形象设计

**巨型黄金史莱姆**，戴**华丽大皇冠**（红宝石、金叶饰）。**身后有皇家斗篷**（红色 + 金线绣花）。手持**镶宝石的权杖**。眼睛威严（`O_O` 王者注视）。**底部有皇家垫毯**（坐在豪华小垫子上）。

### 视觉特征
- 体型巨大（48×48）
- 金黄色身体（不像普通 slime 鲜艳，更深沉贵气）
- 大皇冠（占头顶 1/3，红宝石中心）
- 红色长披风（拖到地面）
- 权杖在身边悬浮
- 身下豪华红色垫子（24×8）
- 周围 4 个金色光球环绕（不是攻击）

## 调色板

| 用途 | Hex |
|------|-----|
| 主体 | `#FFD54F` 金黄 |
| 高光 | `#FFE082` 浅金 |
| 阴影 | `#FF8F00` 深金 |
| 极深阴影 | `#E65100` 橙红 |
| 皇冠金 | `#FFD700` |
| 红宝石 | `#C62828` |
| 红披风 | `#B71C1C` |
| 金线绣花 | `#FFD700` |
| 权杖 | `#5D4037` |
| 眼睛 | `#1A1A2E` 威严 |
| 皇家垫毯 | `#B71C1C` + `#FFD700` 金边 |

## 动画要点

### Idle (8 帧 × 6fps — Boss 级别更精细)
- 缓慢呼吸式弹跳
- 披风飘动
- 周围 4 个金光球缓慢旋转
- 皇冠偶尔反光

### Move (8 帧 × 8fps)
**威严跳跃**：
- 帧 0-1: 蓄力下压
- 帧 2-3: 起跳（披风甩开）
- 帧 4-5: 飞行最高点
- 帧 6-7: 重重着陆（地面震动）

每次着陆触发**屏幕震动 0.3s** + 周围 4 像素半径 5 伤害（玩家不能贴脸）。

### Phase 1 - Summon (10 帧)
**召唤援军**：
- 帧 0-2: 举起权杖
- 帧 3-5: 权杖光芒充能
- 帧 6-7: **释放魔法**（紫色光柱）
- 帧 8-9: 2 个 Green Slime 从地面冒出

### Phase 2 - Split (12 帧)
**分裂动画**：
- 帧 0-2: 体积膨胀（变 1.5 倍）
- 帧 3-5: 颜色加深
- 帧 6-7: 全身白色高光
- 帧 8-10: **分裂成 4 个中型 Slime King**（每个 30×30）
- 帧 11: 4 个分身向 4 个方向飞

注意：阶段二实际上是**多个分身**轮流被击杀

### Phase 3 - Bullet Hell (持续状态)
**全屏弹幕模式**：
- Boss 中心快速旋转
- 持续向所有方向射出金色子弹（每 0.3s 一次）
- 子弹形成螺旋图案
- 玩家必须不停闪避

### Phase 4 - Final Stand (15 帧)
**最终绝命**：
- 帧 0-3: 受重伤，颜色变暗
- 帧 4-6: 召唤魔法阵（地面紫色巨阵）
- 帧 7-10: 阵中**升起 3 只稀有 Slime**（Acid + Frost + Lava）
- 帧 11-14: Boss 全力发光，准备最终爆发

### Death (20 帧 × 8fps — Boss 死法最豪华)
**史诗级死亡**：
- 帧 0-2: 受致命一击 + 屏幕短暂白光
- 帧 3-5: 跪倒（披风飘下）
- 帧 6-8: 皇冠摇晃
- 帧 9-11: **皇冠掉落**（金光闪烁）
- 帧 12-14: Boss 身体开始消散（向上飘）
- 帧 15-17: 大量金币飞溅
- 帧 18: **武器掉落**（Epic 武器旋转飞出）
- 帧 19: 完全消散，剩下垫毯和皇冠（互动彩蛋）

## AI Prompt

```
Pixel art slime king boss enemy, 48x48 pixels,
massive golden majestic slime body wearing elaborate ornate crown,
crown with red ruby gemstone center and gold leaf decorations,
flowing red royal cape with golden embroidery details,
floating jeweled scepter beside body,
sitting on luxurious red carpet with gold trim,
4 small golden orb satellites orbiting around body,
dignified imperial king pose, regal majestic eyes with intelligence,
ruler aesthetic, ultimate boss feel,
12-color palette: #FFD54F gold yellow main, #FFE082 light gold highlight,
#FF8F00 deep gold shadow, #E65100 darkest shadow,
#FFD700 crown gold, #C62828 ruby red, #B71C1C cape red,
#5D4037 scepter wood, #1A1A2E imperial eyes,
transparent background, epic boss retro 16-bit pixel art,
fantasy boss character sprite, --niji 6 --ar 1:1 --quality 5
```

### Phase Transitions

```
Pixel art slime king phase 2 split animation, 12 frames,
slime king expanding to 1.5x size, brightening to white,
splitting into 4 smaller slime kings in 4 directions,
each smaller version ready for separate combat,
gold and red palette, transparent background,
retro pixel art boss animation --ar 12:1
```

```
Pixel art slime king phase 4 final summon, 15 frames,
boss creating large purple magic circle on floor,
3 different elite slimes (acid, frost, lava) rising from circle,
boss building up to final attack, glowing intensely,
transparent background, retro pixel art --ar 15:1
```

### Epic Death Animation

```
Pixel art slime king epic death sequence, 20 frames horizontal,
frame 1-3: massive boss taking fatal damage, screen flash,
frame 4-8: kneeling, cape falling, crown wobbling,
frame 9-12: crown falling off in slow motion gold sparkle,
frame 13-16: body dissolving upward into golden particles,
frame 17-19: gold coins exploding outward, weapon pickup spinning,
frame 20: final dissipation leaving carpet and crown remnants,
gold-red royal palette throughout, transparent background,
epic boss death retro pixel art --ar 20:1
```

### Boss Bullet Hell Pattern

```
Pixel art radial bullet pattern emanating from boss, 32x32,
golden bullets in spiral pattern, multiple rotation speeds,
8-frame animated bullet hell sequence, transparent background,
classic shoot em up retro pixel art --ar 8:1
```

## 特效

- **持续皇家光环**：身体周围金色微光
- **金光球环绕**：4 个小金球绕 Boss 旋转
- **着陆震动**：每次跳跃落地屏幕震 0.3s
- **召唤魔法阵**：紫色巨型阵
- **分裂动画**：1 → 4 视觉冲击
- **弹幕海**：阶段三全屏金色子弹
- **死亡掉落**：金币雨 + 武器旋转飞出
- **皇冠彩蛋**：死亡后地面留皇冠（拾取触发解锁）

## 音效

### BGM
**Boss BGM**：高强度史诗管弦乐 + 鼓点
- 阶段切换时音乐升调
- 阶段四音乐变得更紧迫

### SFX

| 事件 | 描述 |
|------|------|
| 出场 | 国王登场号角 + 王者宣告 |
| Idle | 持续低音声波 + 王座坐感 |
| 跳跃 | "咚!" 重型震动 |
| 着陆 | 地震 + 屏幕震 |
| 召唤 | 神秘咒语 + 召唤铃声 |
| 分裂 | "轰!" 大爆发 + 4 个新生成"啵!" |
| 弹幕 | 持续 "嗖嗖嗖嗖!" 海量子弹 |
| 受击 | "唔!" 王者怒吼 |
| 阶段切换 | "BOOM!" + 王者咆哮 |
| 死亡 | 凄凉哀鸣 + 皇冠掉落"叮咚" + 武器获得"丁!" + 胜利乐 |

## 实现要点

```dart
class SlimeKing extends SlimeBase {
  int currentPhase = 1;
  Timer? phaseTimer;
  List<SlimeKing> splitClones = [];
  
  SlimeKing({required Vector2 position}) : super(
    position: position,
    maxHp: 500,
    speed: 40,
    contactDamage: 30,
    color: const Color(0xFFFFD54F),
    size: Vector2(48, 48),
  );
  
  @override
  void update(double dt) {
    super.update(dt);
    _updatePhase();
    _executePhaseAttack(dt);
  }
  
  void _updatePhase() {
    final hpPercent = hp / maxHp;
    final newPhase = hpPercent > 0.7 ? 1
                    : hpPercent > 0.4 ? 2
                    : hpPercent > 0.15 ? 3
                    : 4;
    if (newPhase != currentPhase) {
      _onPhaseTransition(newPhase);
      currentPhase = newPhase;
    }
  }
  
  void _onPhaseTransition(int newPhase) {
    spawnPhaseTransitionEffect();
    AudioSystem.playBossPhaseChange();
    
    switch (newPhase) {
      case 2:
        _splitIntoClones();
        break;
      case 3:
        _enterBulletHellMode();
        break;
      case 4:
        _summonRareSlimes();
        break;
    }
  }
  
  void _splitIntoClones() {
    // 创建 4 个分身
    for (int i = 0; i < 4; i++) {
      final angle = (2 * pi / 4) * i;
      final clone = SlimeKing(position: position + Vector2(cos(angle), sin(angle)) * 60);
      clone.maxHp = 100;
      clone.hp = 100;
      clone.size = Vector2(30, 30);
      game.world.add(clone);
      splitClones.add(clone);
    }
    removeFromParent();
  }
  
  @override
  void onSlimeDeath() {
    // 史诗级奖励
    AudioSystem.playBossDeath();
    spawnEpicDeathSequence();
    
    // 大量金币
    for (int i = 0; i < 20; i++) {
      spawnCoin(position + randomOffset(), 5);
    }
    
    // Epic 武器掉落
    final epicWeapon = WeaponPool.getEpicWeapon();
    spawnWeaponDrop(position, epicWeapon);
    
    // 解锁成就
    AchievementSystem.unlock(AchievementId.bossSlayer);
    AchievementSystem.unlock(AchievementId.slimeKingDefeated);
    
    // 解锁史莱姆英雄角色
    HeroUnlock.unlock('slime_hero');
    
    // 留下皇冠彩蛋
    game.world.add(CrownArtifact(position: position));
  }
}
```

## Boss 战策略提示（玩家手册）

虽然不在游戏内强制显示，但作为 wiki 内容：

```
推荐打法:
- 阶段一: 优先击杀召唤的 Green Slime，不让它围攻
- 阶段二: 4 个分身体型小，逐个击破，用 AoE 武器最有效
- 阶段三: 不停移动，用走位躲弹幕，不要贪输出
- 阶段四: Boss 即将死亡，注意躲 3 个 elite slime，集火 Boss

推荐英雄:
- Knight: 抗性最强，适合新手
- Mage: AoE 伤害最强，对分裂阶段有奇效

推荐武器:
- Shotgun 类: 阶段二最佳
- 高射速 SMG: 阶段三最佳
- 任何 Epic+ 武器: 通用
```
