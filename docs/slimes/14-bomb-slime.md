# Bomb Slime（炸弹史莱姆）

> 全身缠满引线的疯狂自爆狂魔。看见就跑。

## 基本信息

| 字段 | 值 |
|------|-----|
| ID | `bomb_slime` |
| 出现楼层 | F4-F5 |
| 等级 | 变异 |
| 元素 | 火（爆炸）|
| 体型 | 16×16 |

## 数值

```yaml
HP: 30
速度: 100 px/s
接触伤害: 0（不直接伤害）
接触触发: 立即引爆 70 伤害 6×6 范围
死亡: 立即爆炸 35 伤害 5×5 范围
警告: 接近时引线越燃越亮（视觉提示）
```

## 形象设计

**红色身体被炸药引线缠满**（黑色绳索 / 黄色 TNT 标识）。顶部有冒火星的引线（持续燃烧）。眼睛**疯狂大圆眼**（`@_@` 螺旋）。

### 视觉特征
- 红色基底
- 身体上贴着 3-4 根 TNT 圆柱（黄色 + 黑条纹）
- 头顶引线（白线 + 火星粒子）
- 引线火星越来越快（接近爆炸时疯狂闪烁）
- 受伤时全身闪烁（接近爆炸警告）

## 调色板

| 用途 | Hex |
|------|-----|
| 主体 | `#FF5722` 红橙 |
| TNT | `#FFEB3B` 黄 + `#1A1A2E` 黑条 |
| 引线 | `#FFFFFF` 白 |
| 火星 | `#FFA000` 橙 |
| 眼睛 | `#000000` 螺旋 |
| 阴影 | `#BF360C` 深红 |

## 动画要点

### Idle (4 帧)
- 标准弹跳，但**疯狂**（变形剧烈）
- 引线火星每帧位置变化
- 眼睛偶尔旋转

### Move (4 帧)
**急速冲撞**（不是跳跃）：
- 直奔玩家
- 移动残影 2-3 帧

### Warning (Pre-explode, 4 帧 × 16fps)
当 HP < 30% 或接近玩家时进入**警告状态**：
- 全身红白闪烁
- 引线疯狂喷火星
- 体积膨胀 1.2 倍
- **持续 1 秒后必爆炸**

### Death (8 帧 × 12fps)
**大爆炸**：
- 帧 0: 全身白光暴涨
- 帧 1: 体积变 2 倍
- 帧 2: **大爆炸**（24×24 黄白色光球）
- 帧 3: 爆炸高潮（橙红色环扩散）
- 帧 4: 烟雾上升
- 帧 5: 烟雾扩散
- 帧 6: 残余火苗
- 帧 7: 焦黑地面（持续 5s）

## AI Prompt

```
Pixel art kamikaze bomb slime monster, 16x16 pixels,
red explosive slime body wrapped in TNT dynamite sticks,
yellow #FFEB3B TNT sticks with black stripes attached to body,
glowing white burning fuse on top with bright orange spark particles,
crazy maniacal spiral @_@ eyes, manic dangerous about-to-explode aesthetic,
warning danger feeling, hostile suicide bomber creature,
6-color palette: #FF5722 red-orange main, #FFEB3B yellow TNT,
#1A1A2E black stripes/eyes, #FFFFFF white fuse,
#FFA000 orange sparks, #BF360C dark crimson shadow,
transparent background, retro 16-bit pixel art, --niji 6 --ar 1:1
```

### Massive Explosion Death

```
Pixel art massive explosion sequence, 8 frames horizontal,
frame 1: bright white-yellow flash 16x16,
frame 2: expanding fireball 24x24,
frame 3: peak explosion 32x32 with shockwave ring,
frame 4: dispersing flames 28x28,
frame 5: smoke cloud 24x24,
frame 6: debris and embers 20x20,
frame 7: smoke trail 16x16,
frame 8: charred ground residue 16x16,
explosion palette orange-yellow-red-black, transparent background,
retro pixel art --ar 8:1
```

### Pre-Explode Warning

```
Pixel art bomb slime warning state, 4 frames,
pulsing red-white flashing animation, fuse sparking intensely,
body expanded 1.2x normal size, danger warning aesthetic,
transparent background, retro pixel art --ar 4:1
```

## 特效

- **引线火星**：顶部持续 2-3 个橙色粒子
- **警告闪烁**：HP 低或接近玩家时全身红白闪烁
- **爆炸冲击波**：圆形橙色波浪 + 屏幕震动 0.3s
- **烟雾**：爆炸后白灰色烟雾向上飘
- **焦黑地面**：爆炸点留 5s 黑色焦痕

## 音效

| 事件 | 描述 |
|------|------|
| Idle | "嘶嘶嘶" 引线燃烧持续 |
| 移动 | "咚咚咚" 急促心跳 + 跳跃 |
| 警告 | "哔哔哔" 警报声加速 |
| 爆炸 | "BOOM!" 大爆炸（最响）|
| 烟雾 | 持续 1s 燃烧声 |

## 实现要点

```dart
class BombSlime extends SlimeBase {
  bool isWarning = false;
  
  @override
  void onCollisionWithPlayer() {
    explode();
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    if (hp < maxHp * 0.3 || _distanceToPlayer < 50) {
      isWarning = true;
      // 1 秒后自爆
    }
  }
  
  @override
  void onSlimeDeath() {
    explode();
  }
  
  void explode() {
    final radius = 40;
    final damage = 35;
    if (game.player.position.distanceTo(position) < radius) {
      game.player.takeDamage(damage);
    }
    spawnExplosion(position, radius: radius);
    spawnScreenShake(0.3);
    removeFromParent();
  }
}
```
