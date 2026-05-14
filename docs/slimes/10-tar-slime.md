# Tar Slime（焦油史莱姆）

> 油亮的黑色史莱姆，碰到玩家会粘住。死后留下大滩黑油。

## 基本信息

| 字段 | 值 |
|------|-----|
| ID | `tar_slime` |
| 出现楼层 | F3-F5 |
| 等级 | 普通（控制）|
| 元素 | 物理（粘滞）|
| 体型 | 16×16 |

## 数值

```yaml
HP: 50
速度: 25 px/s（很慢）
接触伤害: 8 + 黏住玩家 1.5s（无法移动）
死亡: 留下 32×32 黑油池（玩家踩入减速 70% 持续 3s）
```

## 形象设计

**深黑色油亮表面**，可见高光反射。眼睛是金黄色（与黑色对比强烈），表情阴险（`>:>`）。身体下方持续滴黑油液滴。

### 视觉特征
- **油亮反光**（白色高光多，强烈对比）
- 不像其他 slime 那么 Q 弹，更像浓稠焦油
- 移动时拖着长长的黑油痕迹
- 黄色眼睛在黑色身体上很显眼

## 调色板

| 用途 | Hex |
|------|-----|
| 主体 | `#212121` 深黑 |
| 油亮高光 | `#FFFFFF` 白（多用以表现油性）|
| 中间调 | `#424242` 中灰 |
| 阴影 | `#0D0D0D` 极黑 |
| 黄眼睛 | `#FFEB3B` |
| 油滴 | `#1A1A2E` |

## 动画要点

### Idle (4 帧)
- 缓慢起伏
- 高光位置每帧变化（强调"油性"流动）
- 偶尔下方滴一滴油

### Move (4 帧)
**蠕动而非跳跃**：
- 帧 0: 整体向前流（前部拉长）
- 帧 1: 后部跟上
- 帧 2: 整合
- 帧 3: 短暂停顿
- 移动时身后留 2px 黑油痕迹（持续 1s）

### Death (6 帧)
**大油爆**：
- 帧 0: 白闪 + 全身鼓胀
- 帧 1: 表面开裂（黑油喷出）
- 帧 2: 大量油液飞溅
- 帧 3: 液体扩散到地面
- 帧 4: **形成大油池**（32×32 不规则形状）
- 帧 5: 油池稳定（轻微反光循环）

## AI Prompt

```
Pixel art black tar oil slime monster, 16x16 pixels,
deep glossy black sticky tar body with strong white highlights,
oily reflective texture, dripping black goo from bottom,
sinister evil glowing yellow eyes >:>, predatory aesthetic,
ominous dark sticky monster, multiple white shine spots,
6-color palette: #212121 deep black main, #FFFFFF bright shine highlights,
#424242 mid-gray, #0D0D0D pure black shadow, 
#FFEB3B sinister yellow eyes, transparent background,
oil monster retro 16-bit pixel art, --niji 6 --ar 1:1
```

### Tar Puddle Effect

```
Pixel art black tar puddle on ground, 32x16 pixels,
irregular shaped sticky black oil pool with white reflective highlights,
4-frame animated subtle ripples, transparent background,
top-down view, retro pixel art
```

### Tar Drip

```
Pixel art black tar droplet, 4x4 pixels,
glossy black drip with white shine, 2-frame falling animation,
transparent background, retro pixel art
```

## 特效

- **油滴**：每 0.5s 从底部滴一滴（持续 0.3s 后消失）
- **黑油轨迹**：移动时身后 2px 黑色路径（持续 1s）
- **粘住玩家**：玩家被粘时显示金色 chains 锁链效果
- **死亡油池**：32×32 不规则黑色斑块 + 偶尔气泡

## 音效

| 事件 | 描述 |
|------|------|
| Idle | 持续粘稠 "粘叽" 声 |
| 移动 | "啪嗒啪嗒" 黏着拖动 |
| 粘住玩家 | "嘶啦!" 黏住声 |
| 受击 | 油性 "啵嘎" 声 |
| 死亡 | "Splash!" 油喷溅声 |
| 油池 | 持续轻微 "咕嘟" |

## 实现要点

```dart
class TarSlime extends SlimeBase {
  @override
  void onCollisionWithPlayer() {
    super.onCollisionWithPlayer();
    game.player.applyStickyDebuff(duration: 1.5);
  }
  
  @override
  void onSlimeDeath() {
    spawnTarPuddle(position, size: 32, slowEffect: 0.7, duration: 3.0);
  }
}
```
