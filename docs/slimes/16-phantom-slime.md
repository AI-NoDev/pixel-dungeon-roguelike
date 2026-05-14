# Phantom Slime（幽灵史莱姆）

> 半透明的紫色幽灵史莱姆，会隐身、能穿墙。

## 基本信息

| 字段 | 值 |
|------|-----|
| ID | `phantom_slime` |
| 出现楼层 | F4-F5 |
| 等级 | 变异 |
| 元素 | 灵体 |
| 体型 | 16×16 |

## 数值

```yaml
HP: 40
速度: 80
接触伤害: 12
特殊: 每 3s 隐身 1.5s（隐身时玩家无法瞄准 + 免疫近战）
特殊: 可穿越障碍物
死亡: 无掉落（消散），但有彩蛋"幽灵图鉴"成就
```

## 形象设计

**半透明（40% 不透明）紫色幽灵**，飘浮在地面（不接触）。眼睛是空洞的白色光点（`O O`），永远悲伤忧郁。身后拖着幽灵尾巴（白雾）。

### 视觉特征
- 极度半透明（隐身时全透）
- 飘在地面 2-4 像素（不接触）
- 没有阴影（飘浮）
- 身后白色尾巴/雾气
- 没有清晰嘴巴（神秘感）

## 调色板

| 用途 | Hex |
|------|-----|
| 主体 | `#B39DDB` 50% alpha 紫雾 |
| 高光 | `#E1BEE7` 70% alpha 浅紫 |
| 阴影 | `#5E35B1` 70% alpha 深紫 |
| 眼睛 | `#FFFFFF` 80% alpha 白光 |
| 雾气 | `#E1BEE7` 30% alpha |

## 动画要点

### Idle (4 帧)
- **飘浮**（整体上下漂 2px）
- 透明度微弱变化（呼吸式）
- 尾巴雾气循环散逸

### Move (4 帧)
- 飘行（不是跳跃）
- 速度感（拖尾更长）

### Stealth Transition (4 帧 × 12fps，0.3s)
**进入隐身**：
- 帧 0: 标准透明度
- 帧 1: 透明度 30%
- 帧 2: 透明度 10%
- 帧 3: 完全消失（仅留淡淡轮廓）

**退出隐身**：反向播放

### Death (6 帧)
**消散**（不是爆炸）：
- 帧 0: 全身闪光
- 帧 1: 边缘开始消散
- 帧 2: 上半身溶解为雾
- 帧 3: 完全雾化
- 帧 4: 雾气向上飘
- 帧 5: 完全消失

## AI Prompt

```
Pixel art ghostly translucent phantom slime, 16x16 pixels,
semi-transparent ethereal purple ghost body 50% opacity,
hollow soul-like white glowing eyes O O, melancholic sad aesthetic,
floating off ground hovering, ghostly mist trail behind,
no clear mouth, mysterious otherworldly feeling,
ethereal smoke wisps and white particles,
6-color palette: #B39DDB translucent purple main 50% opacity,
#E1BEE7 light purple highlight, #5E35B1 deep purple shadow,
#FFFFFF white glowing eyes, mist particles,
transparent background, ghostly retro 16-bit pixel art,
spooky cute aesthetic, --niji 6 --ar 1:1
```

### Stealth Transition

```
Pixel art ghost slime fading to invisible, 4 frames,
gradual transparency from 100% to 0%, ghostly wisps trailing,
purple to white to nothing transition,
transparent background, retro pixel art --ar 4:1
```

### Dissolution Death

```
Pixel art ghost slime dissolving into mist, 6 frames,
slime body dissolving from edges to center,
purple body becoming white mist rising upward,
ethereal disappearance aesthetic, transparent background,
retro pixel art --ar 6:1
```

## 特效

- **持续雾尾**：身后 3-4 个白色雾粒子
- **悬浮**：始终离地 2-4 px
- **隐身淡入淡出**：透明度过渡 + 模糊效果
- **隐身时玩家提示**：屏幕边缘紫色微光（玩家知道还有敌人）
- **消散死亡**：白色雾气向上飘（神秘感）

## 音效

| 事件 | 描述 |
|------|------|
| Idle | 持续 "呜呜" 鬼魂呜咽 |
| 移动 | 飘行风声 |
| 隐身 | "嘶..." 消失声 |
| 现身 | "嘶啪!" 出现声 |
| 受击 | "啊!" 凄厉惊呼 |
| 死亡 | "呜..." 长长的叹息 + 雾散 |

## 实现要点

```dart
class PhantomSlime extends SlimeBase {
  bool isInvisible = false;
  Timer invisibleCycle = Timer(3.0);  // 每 3s 切换
  double currentOpacity = 1.0;
  
  @override
  void update(double dt) {
    super.update(dt);
    invisibleCycle.update(dt);
    if (invisibleCycle.finished) {
      isInvisible = !isInvisible;
      currentOpacity = isInvisible ? 0.1 : 1.0;
      invisibleCycle.reset(isInvisible ? 1.5 : 3.0);
    }
  }
  
  @override
  bool get canBeTargeted => !isInvisible;
  
  // 穿墙：忽略障碍物碰撞
  @override
  void resolveObstacleCollision() {
    // 不做任何处理，可穿墙
  }
  
  @override
  void onSlimeDeath() {
    // 消散动画，不爆炸不飞溅
    spawnDissolveEffect(position);
    // 解锁"幽灵图鉴"成就
    AchievementSystem.unlock(AchievementId.phantomEncounter);
  }
}
```
