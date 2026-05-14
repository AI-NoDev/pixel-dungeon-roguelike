# Blue Frost Jelly（冰霜冻冻）

> 半透明的水蓝色史莱姆，体内有微小冰晶。冷漠又孤僻。

## 基本信息

| 字段 | 值 |
|------|-----|
| ID | `blue_frost_jelly` |
| 出现楼层 | F2-F5 |
| 等级 | 普通 |
| 元素 | 冰 |
| 体型 | 16×16 |

## 数值

```yaml
HP: 35
速度: 40 px/s
接触伤害: 8
冰冻效果: 玩家被命中减速 50%（持续 2s）
死亡: 留下冰霜地面（减速 30% 持续 4s）
```

## 形象设计

**半透明（70%）水蓝色身体**，内部能看到 3-4 个小冰晶碎片。永远闭着眼或冷漠表情（`-_-`），头顶飘几片雪花。

### 视觉特征
- 身体半透明能看到内部冰晶
- 走在地上留下小冰晶轨迹
- 头部位置偶尔吐出冷气（白色雾气）
- 攻击时身体外圈结霜变白

## 调色板

| 用途 | Hex | 说明 |
|------|-----|------|
| 主体 | `#4FC3F7` 70% alpha | 半透明水蓝 |
| 高光 | `#E1F5FE` | 浅冰白 |
| 阴影 | `#01579B` | 深蓝 |
| 内部冰晶 | `#FFFFFF` | 纯白 |
| 雪花 | `#FFFFFF` | 白 |
| 眼睛 | `#0D47A1` | 深蓝（不是黑）|

## 动画要点

### Idle (4 帧)
缓慢呼吸式，比 Green Slime 慢一倍。
头顶雪花持续旋转飘落。

### Move (4 帧)
- 动作迟缓
- 每跳一次留下小冰晶在地上（持续 2s 后消失）

### Hurt (2 帧)
- 帧 0: 全身白色（结冰反应）
- 帧 1: 身体出现裂纹

### Death (6 帧)
死亡时**碎裂成冰晶**：
- 帧 0: 白闪 + 全身结冰
- 帧 1: 身体出现裂纹
- 帧 2: 大裂痕扩散
- 帧 3: **碎裂成 8 块**冰晶向外飞
- 帧 4: 冰晶碎片散落地面
- 帧 5: 形成冰霜地面（蓝白半透明圆区）

## AI Prompt

```
Pixel art icy blue frost jelly slime, 16x16 pixels,
semi-transparent crystal-clear gelatinous body 70% opacity,
visible small ice crystal shards floating inside body,
cold deadpan emotionless eyes -_-, frosty breath wisps from top,
snowflakes circling head, frost particles around body,
icy chilly aesthetic, ethereal frozen feeling,
6-color palette: #4FC3F7 ice blue main translucent, #E1F5FE light cyan highlight,
#01579B deep blue shadow, #FFFFFF white ice crystals, #0D47A1 navy eyes,
transparent background, sharp pixel edges, retro 16-bit pixel art,
--niji 6 --ar 1:1 --quality 2
```

### Frozen Floor Effect

```
Pixel art frozen icy patch on ground, 32x16 pixels,
semi-transparent blue-white frost circle, ice crystal pattern inside,
visible from top-down view, soft glow, animated subtle shimmer,
transparent background, retro pixel art
```

### Snowflake Particle

```
Pixel art tiny snowflake particle, 4x4 pixels,
white 6-pointed snowflake on transparent background,
classic retro pixel game style, 4-frame rotation animation
```

## 特效

- **环境雪花**：始终有 2-3 朵雪花在身边飘
- **冰晶轨迹**：移动时每 0.5 秒掉一颗小冰晶
- **冰冻命中**：玩家被减速时屏幕边缘冰霜效果
- **死亡碎裂**：8 块尖锐冰晶向外飞溅
- **冰霜地面**：圆形蓝白半透明区域，玩家踩入闪烁

## 音效

| 事件 | 描述 |
|------|------|
| 移动 | "吱呀" 冰面摩擦声 |
| 受击 | "咔嚓" 冰裂声 |
| 死亡 | "咔嚓嚓!" 大量冰碎声 |
| 冰霜区域 | 持续轻微 "嘶嘶" 冷气声 |

## 实现要点

```dart
class BlueFrostJelly extends SlimeBase {
  @override
  void onCollisionWithPlayer() {
    player.applySlowDebuff(50%, 2.0);
  }
  
  @override
  void onSlimeDeath() {
    spawnFrostFloor(position, radius: 40, duration: 4.0);
  }
}
```
