# Pink Bouncer（粉红弹弹）

> 永远开心、永远在跳的活力派。比绿史莱姆更小更圆，弹性极强。

## 基本信息

| 字段 | 值 |
|------|-----|
| ID | `pink_bouncer` |
| 出现楼层 | F1-F5（中频）|
| 等级 | 普通 |
| 元素 | 物理 |
| 体型 | 14×14 |

## 数值

```yaml
HP: 25
速度: 100 px/s
接触伤害: 8
特殊: 撞墙反弹 + 跳跃距离 +50%
```

## 形象设计

**比绿史莱姆更小更圆**，永远在大幅度蹦跳。表情夸张兴奋（`:D` 大笑），身上有星星粒子环绕。

### 视觉差异化（vs Green Slime）
- 体型小 2px（14 vs 16）
- 主色粉红，更鲜艳
- 表情更兴奋（眼睛弯成开心月牙形）
- 移动时拉伸更夸张（拉成长条形飞行）
- 周围带 2-3 个粉色星星粒子

## 调色板

| 用途 | Hex |
|------|-----|
| 主体 | `#F48FB1` 桃粉 |
| 高光 | `#FCE4EC` 浅粉 |
| 阴影 | `#C2185B` 深粉 |
| 眼睛 | `#000000` |
| 星星 | `#FFFFFF` 白 + `#FFD700` 金 |

## 动画要点

### Idle (4 帧)
比 Green Slime 弹跳幅度大 2 倍，停不下来。

### Jump (4 帧)
- 帧 1: 蹲低（高度 8px）
- 帧 2: 拉成长条飞行（高度 20px、宽度 10px）
- 帧 3: 飞行最高点（标准 14×14）
- 帧 4: 回弹着陆

### Wall Bounce (2 帧)
撞墙反弹时挤压形变（独有动画）：
- 帧 0: 撞墙挤压（变形为 8×20）
- 帧 1: 反向弹出

### Death (6 帧)
分裂为 5-6 个粉色心形粒子向外飞散（治愈系死法）。

## AI Prompt

```
Pixel art hot pink bouncy slime monster, 14x14 pixels,
small round energetic body in mid-bounce stretched pose,
huge happy crescent-shaped eyes :D big smile,
sparkle stars and white particles around body,
candy-like glossy texture with bright highlights,
hyper energetic playful aesthetic,
6-color palette: #F48FB1 hot pink main, #FCE4EC light pink highlight,
#C2185B dark pink shadow, #000000 eyes, #FFFFFF #FFD700 sparkles,
transparent background, sharp pixel edges, no anti-aliasing,
retro 16-bit game sprite, kawaii style,
--niji 6 --ar 1:1 --quality 2
```

## 特效

- **Bounce trail**: 跳跃时残留 2-3 个浅粉色淡影
- **Star particles**: 周围 3 颗小星星循环旋转
- **Death effect**: 5 个心形粒子扩散

## 音效

| 事件 | 描述 |
|------|------|
| 跳跃 | "Boing!" 弹簧声（更高音）|
| 受击 | "Squeak!" 尖叫一声 |
| 死亡 | "Pop!" 烟花式爆裂 |

## 实现要点（开发者参考）

```dart
// 速度更快，跳跃距离更远
class PinkBouncer extends SlimeBase {
  // 移动模式：长距离跳跃，每 0.8s 跳一次
  // 撞墙后反弹方向继续跳
}
```
