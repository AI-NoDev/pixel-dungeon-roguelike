# Spike Slime（尖刺史莱姆）

> 全身长着尖刺的灰蓝色史莱姆。摸到会受伤，死了还会刺穿你。

## 基本信息

| 字段 | 值 |
|------|-----|
| ID | `spike_slime` |
| 出现楼层 | F3-F5 |
| 等级 | 普通（防御）|
| 元素 | 物理 |
| 体型 | 16×16 |

## 数值

```yaml
HP: 50
速度: 50
接触伤害: 15 + 反伤 5（玩家近战时反弹伤害）
死亡: 8 个方向射出尖刺（5 伤害弹幕）
```

## 形象设计

**灰蓝色身体表面布满尖锐三角形尖刺**（灰白色 / 银色）。眼睛警觉，左右扫视。整体造型危险锐利。

### 视觉特征
- 身体周围有 8-10 根三角形尖刺（向外辐射）
- 主体颜色冷调（灰蓝），无可爱感
- 表情警惕（眼睛细长 `>w<` 防御姿态）
- 移动时尖刺微微摆动

## 调色板

| 用途 | Hex |
|------|-----|
| 主体 | `#607D8B` 蓝灰 |
| 尖刺 | `#FFFFFF` + `#FFD54F` 白银带金尖 |
| 阴影 | `#37474F` 深蓝灰 |
| 高光 | `#B0BEC5` 浅蓝灰 |
| 眼睛 | `#FF6F00` 橙警告色 |

## 动画要点

### Idle (4 帧)
- 帧 0: 标准
- 帧 1: 尖刺竖立（防御姿态）
- 帧 2: 标准
- 帧 3: 尖刺微缩（放松）

### Move (4 帧)
跳跃时尖刺都向上聚集（流线型）。

### Hurt (2 帧)
- 帧 0: 全身尖刺竖立到最大（自动反击）
- 帧 1: 恢复 + 红色闪烁

### Death (6 帧)
**尖刺四射**：
- 帧 0: 白闪 + 全身尖刺暴涨（变 1.5 倍）
- 帧 1: 体内开始解体
- 帧 2: 尖刺脱离身体
- 帧 3: **8 个尖刺向 8 个方向发射**（成为弹幕）
- 帧 4: 残余身体散开
- 帧 5: 完全消散

## AI Prompt

```
Pixel art spiky defensive slime monster, 16x16 pixels,
cool gray-blue gelatinous body covered in sharp triangular spikes,
8-10 white-silver spikes with gold tips radiating outward,
narrow alert defensive eyes, threatening dangerous aesthetic,
metallic sharp pointed details, hostile body language,
6-color palette: #607D8B blue-gray main, #FFFFFF white spikes,
#FFD54F gold spike tips, #37474F dark shadow, #B0BEC5 highlight,
#FF6F00 orange warning eyes, transparent background,
defensive monster retro 16-bit pixel art, --niji 6 --ar 1:1
```

### Spike Projectile

```
Pixel art sharp triangular spike projectile, 6x6 pixels,
white-silver triangle with motion trail, 2-frame animation,
transparent background, retro pixel art weapon icon
```

### Death Spike Burst

```
Pixel art 8-directional spike burst death effect, 32x32 pixels,
8 spikes flying outward from center in star pattern,
white-silver with gold tips, motion blur trails,
6-frame animation, transparent background, retro pixel art --ar 6:1
```

## 特效

- **持续警告**：尖刺尖端偶尔反光闪烁
- **接触反伤**：玩家近战时短暂红色冲击波
- **死亡星形弹幕**：8 个尖刺向 8 个方向飞（45° 间隔）
- **弹幕轨迹**：每个尖刺飞行时有白色拖尾

## 音效

| 事件 | 描述 |
|------|------|
| Idle | 偶尔金属"叮"声 |
| 移动 | "唰唰" 锐利风声 |
| 受击 | "锵!" 金属碰撞声 |
| 反伤 | 玩家受伤时额外 "嗖!" |
| 死亡 | "刷拉!" 大量尖刺飞出声 |

## 实现要点

```dart
class SpikeSlime extends SlimeBase {
  @override
  void takeDamage(double damage, {bool isMelee = false}) {
    super.takeDamage(damage);
    if (isMelee) {
      game.player.takeDamage(5);  // 反伤
    }
  }
  
  @override
  void onSlimeDeath() {
    // 8 方向发射尖刺
    for (int i = 0; i < 8; i++) {
      final angle = (2 * pi / 8) * i;
      final dir = Vector2(cos(angle), sin(angle));
      game.world.add(SpikeBullet(
        position: position,
        direction: dir,
        damage: 5,
      ));
    }
  }
}
```
