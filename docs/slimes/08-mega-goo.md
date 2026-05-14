# Mega Goo（巨型黏团）

> 体型是普通史莱姆 1.5 倍的大胖子。慢、肉、死了变两只小的。

## 基本信息

| 字段 | 值 |
|------|-----|
| ID | `mega_goo` |
| 出现楼层 | F2-F5 |
| 等级 | 坦克 |
| 元素 | 物理 |
| 体型 | **24×24（大）** |

## 数值

```yaml
HP: 80
速度: 25 px/s（很慢）
接触伤害: 20
死亡: 分裂为 2 个 Green Slime（满血）
```

## 形象设计

**圆滚滚的青绿色大胖子**，体型明显大于普通史莱姆。表情呆萌（`o.o` 或 `:O`），嘴巴小小的，下巴有多层赘肉。

### 视觉特征
- 体型 24×24（vs 普通 16×16）
- 颜色比 Green Slime 更偏青色
- 多层"赘肉"质感（横向纹路）
- 移动慢，每跳一次震动地面

## 调色板

| 用途 | Hex |
|------|-----|
| 主体 | `#4DB6AC` 青绿 |
| 高光 | `#80CBC4` 浅青 |
| 阴影 | `#00695C` 深青 |
| 赘肉纹 | `#26A69A` 中青 |
| 眼睛 | `#000000` |
| 嘴巴 | `#1A1A2E` |

## 动画要点

### Idle (4 帧)
缓慢呼吸，体型变化更明显（每次膨胀 2px）。

### Move (4 帧)
**沉重跳跃**：
- 帧 0: 大蓄力压扁（高度 16）
- 帧 1: 起跳拉伸（高度 28）
- 帧 2: 飞行
- 帧 3: 重重落地（地面震动效果）

每次着陆触发屏幕轻微震动 + 灰色尘土粒子。

### Death (8 帧 — 比普通多 2 帧)
**分裂动画**：
- 帧 0: 白闪 + 大膨胀
- 帧 1: 中央出现裂痕
- 帧 2: 分裂中（大裂缝扩大）
- 帧 3: **分成两个**（左右分开）
- 帧 4: 左右两半分开飞
- 帧 5: 各自变形为新 Green Slime
- 帧 6: 新 slime 短暂闭眼
- 帧 7: 新 slime 睁眼，准备战斗

## AI Prompt

```
Pixel art massive teal blob slime monster, 24x24 pixels,
oversized round chunky body with multiple chins of jelly,
dopey simple-minded expression :O wide round eyes,
slow lumbering aesthetic, pudgy adorable feeling,
multiple horizontal jelly fold lines visible,
6-color palette: #4DB6AC teal main, #80CBC4 light teal highlight,
#00695C dark teal shadow, #26A69A medium fold lines,
#000000 round eyes, #1A1A2E small mouth,
transparent background, retro 16-bit pixel art,
fat cute slime monster --niji 6 --ar 1:1
```

### Split Animation

```
Pixel art slime splitting into two halves, 8 frames horizontal,
frame 1: large slime intact, frame 2: white flash on impact,
frame 3: vertical crack appears center, frame 4: crack widens,
frame 5: full split with two halves separating,
frame 6: two halves morph into smaller slimes,
frame 7-8: two new green slimes emerge,
transparent background, retro pixel art --ar 8:1
```

### Ground Shake Effect

```
Pixel art ground impact shockwave, 32x4 pixels per frame,
4-frame expanding circular wave on ground,
brown dust particles flying upward, transparent background, retro pixel art
```

## 特效

- **着陆冲击**：每次跳跃落地，屏幕震动 50ms + 8 个尘土粒子
- **赘肉摇晃**：移动时身体下方多层震荡
- **死亡分裂**：身体一变二，明确的"分裂感"
- **两个新 slime**：分裂后立即就能行动（不会无敌帧）

## 音效

| 事件 | 描述 |
|------|------|
| Idle | 低频 "嗯嗯" 喘气声 |
| 移动 | "蓬!" 重重落地 + 地震 |
| 受击 | "Owww!" 笨重哎哟 |
| 死亡分裂 | "Splat!" + 两声"啵啵"（小 slime 出生）|

## 实现要点

```dart
class MegaGoo extends SlimeBase {
  MegaGoo({required Vector2 position}) : super(
    size: Vector2(24, 24),  // 大体型
    ...
  );
  
  @override
  void onSlimeDeath() {
    // 生成 2 个 Green Slime
    final pos1 = position + Vector2(-12, 0);
    final pos2 = position + Vector2(12, 0);
    game.world.add(GreenSlime(position: pos1));
    game.world.add(GreenSlime(position: pos2));
  }
}
```
