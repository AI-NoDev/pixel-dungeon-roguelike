# Lava Bubbler（熔岩泡泡）

> 火红的热血史莱姆，全身燃烧着熔岩，移动时留下火焰轨迹。

## 基本信息

| 字段 | 值 |
|------|-----|
| ID | `lava_bubbler` |
| 出现楼层 | F3-F5 |
| 等级 | 普通 |
| 元素 | 火 |
| 体型 | 16×16 |

## 数值

```yaml
HP: 30
速度: 50 px/s
接触伤害: 12 + 燃烧 DoT 3/s 持续 3s
火焰轨迹: 留下 2s 火焰地面（玩家踩到 2/s 持续 2s）
死亡: 小爆炸 5×5 范围 15 伤害
```

## 形象设计

**红橙色身体内有发光熔岩裂纹**，顶部冒烟雾。眼睛是燃烧的火焰（橙黄色），愤怒表情（`>:(`）。

### 视觉特征
- 身体不是均匀红，而是有**熔岩裂纹**（橙色发光线条）
- 顶部持续冒烟（灰白色烟雾）
- 移动时身后留 1-2 秒的火焰轨迹
- 受击时熔岩裂纹更亮（充能感）

## 调色板

| 用途 | Hex |
|------|-----|
| 主体 | `#FF5722` 红橙 |
| 熔岩裂纹 | `#FFA000` 橙黄发光 |
| 高光 | `#FFEB3B` 黄 |
| 阴影 | `#BF360C` 深棕红 |
| 烟雾 | `#9E9E9E` 灰 |
| 眼睛火焰 | `#FFEB3B` |

## 动画要点

### Idle (4 帧)
- 帧 0: 标准 + 熔岩裂纹微亮
- 帧 1: 顶部冒烟（小烟柱）
- 帧 2: 熔岩裂纹强亮（脉冲效果）
- 帧 3: 烟雾扩散

### Move (4 帧)
跳跃时身后留 2 个橙色火焰像素（停留 1 秒）。

### Attack 燃烧光环（被动）
不需要主动攻击动画，但全身有持续的火焰光晕（每 0.5s 闪烁）。

### Death (6 帧)
**经典爆炸**：
- 帧 0: 全身白光 + 巨大膨胀
- 帧 1: 体型变 1.5 倍 + 通体橙白
- 帧 2: **大爆炸**（24×24 黄白色光球）
- 帧 3: 爆炸扩散（橙红色环）
- 帧 4: 烟雾向上腾起
- 帧 5: 残留火焰小堆 + 烟雾

## AI Prompt

```
Pixel art glowing fire lava slime monster, 16x16 pixels,
red-orange molten body with bright glowing magma cracks pattern,
small smoke wisps rising from top, fierce angry burning fire eyes >:(,
intense aggressive aesthetic, dangerous heat radiating,
small flame flickers along body edges,
6-color palette: #FF5722 red-orange main, #FFA000 glowing magma cracks,
#FFEB3B yellow flame highlights, #BF360C dark crimson shadow,
#9E9E9E smoke gray, transparent background,
volcano monster aesthetic, retro 16-bit pixel art sprite,
--niji 6 --ar 1:1 --quality 2
```

### Fire Trail

```
Pixel art fire trail effect, 16x8 pixels per frame,
small flame patches on ground, 4-frame loop flickering animation,
orange-yellow gradient flames, transparent background,
retro pixel art game effect
```

### Death Explosion

```
Pixel art fire explosion sequence, 6 frames horizontal,
frame 1: bright white-yellow flash 16x16,
frame 2: expanding orange fireball 24x24,
frame 3: peak explosion 32x32 with debris,
frame 4: dispersing flames 28x28,
frame 5: smoke cloud rising 20x20,
frame 6: small embers and smoke residue,
transparent background, retro pixel art --ar 6:1
```

## 特效

- **持续烟雾**：顶部每 0.5s 一缕烟向上飘
- **熔岩脉冲**：身体裂纹 1Hz 频率明暗循环
- **火焰轨迹**：每跳一步留 2px×2px 橙色火苗，持续 2s
- **爆炸冲击波**：死亡时圆形橙色波浪扩散
- **残骸**：死亡后地面留 0.5s 小火堆

## 音效

| 事件 | 描述 |
|------|------|
| Idle | 持续低频"呼噜"火焰声 |
| 移动 | "嘶啪" 火焰跳跃 |
| 受击 | "嘶哈" 痛苦尖叫 |
| 死亡 | "BOOM!" 大爆炸（关键音效）|
| 火焰轨迹 | 持续轻微"哔啵" |

## 实现要点

```dart
class LavaBubbler extends SlimeBase {
  Timer fireTrailTimer = Timer(0.3);
  
  @override
  void update(double dt) {
    super.update(dt);
    fireTrailTimer.update(dt);
    if (fireTrailTimer.finished) {
      spawnFireTrail(position, duration: 2.0);
      fireTrailTimer.reset();
    }
  }
  
  @override
  void onSlimeDeath() {
    explode(radius: 40, damage: 15);
  }
}
```
