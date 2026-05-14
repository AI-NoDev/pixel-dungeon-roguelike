# Corrosive Slime（腐蚀史莱姆）

> 棕黑色淤泥，能腐蚀玩家防御。死后留下持续掉血的腐蚀池。

## 基本信息

| 字段 | 值 |
|------|-----|
| ID | `corrosive_slime` |
| 出现楼层 | F4-F5 |
| 等级 | 变异 |
| 元素 | 毒（特殊：腐蚀）|
| 体型 | 16×16 |

## 数值

```yaml
HP: 45
速度: 35
接触伤害: 10 + 腐蚀 8/s 持续 5s
特殊: 命中时降低玩家防御 -20% 持续 5s
死亡: 留下 32×32 腐蚀池（10/s 持续 4s）
```

## 形象设计

**深棕黑色淤泥**身体，表面有**荧光绿色腐蚀斑**（化学污染感）。眼睛是滴落的腐蚀液（垂直滴下），表情阴森危险。

### 视觉特征
- 主色深棕（不像 toxic goo 的紫色）
- 表面 4-5 个**亮绿色斑点**（毒源）
- 眼睛位置永远在滴绿色液体
- 不规则形状（淤泥质感）
- 身下持续滴绿色腐蚀液

## 调色板

| 用途 | Hex |
|------|-----|
| 主体 | `#5D4037` 深棕 |
| 腐蚀斑 | `#76FF03` 荧光绿 |
| 高光 | `#8D6E63` 浅棕 |
| 阴影 | `#3E2723` 极深棕 |
| 滴液 | `#69F0AE` 透明绿 |
| 眼睛 | `#76FF03` 荧光绿（液体）|

## 动画要点

### Idle (4 帧)
- 整体几乎不动
- 腐蚀斑闪烁（每帧一个变亮）
- 眼睛持续滴液（每秒 1 滴）

### Move (4 帧)
**淤泥蠕动**（不跳）：
- 整体向前流
- 拖着腐蚀液痕迹（持续 2s）

### Death (6 帧)
**腐蚀池形成**：
- 帧 0: 白闪 + 化学反应
- 帧 1: 表面溶解
- 帧 2: 全身液化
- 帧 3: 流到地面
- 帧 4: **形成大腐蚀池**（32×32 不规则）
- 帧 5: 池内冒泡循环

## AI Prompt

```
Pixel art corrosive acid sludge slime, 16x16 pixels,
deep dark brown sludgy mud body with toxic glowing green spots,
dripping bright green corrosive ooze from eyes and bottom,
sinister evil aesthetic, hazardous chemical waste creature,
irregular non-spherical shape like polluted sludge,
6-color palette: #5D4037 dark brown main, #76FF03 toxic green spots,
#8D6E63 light brown highlight, #3E2723 deepest brown shadow,
#69F0AE acid drips green, transparent background,
biohazard chemical creature retro 16-bit pixel art,
--niji 6 --ar 1:1
```

### Corrosion Puddle

```
Pixel art corrosive acid puddle, 32x16 pixels,
brown-black liquid with bright green toxic spots and bubbles,
4-frame animated bubbling and dripping, dangerous warning aesthetic,
top-down view, transparent background, retro pixel art
```

### Defense Down Visual

```
Pixel art defense down debuff icon, 16x16,
broken shield symbol with green corrosion spreading,
red downward arrow indicator, transparent background, retro pixel art
```

## 特效

- **腐蚀滴落**：每秒从眼睛/底部滴 1-2 滴绿液
- **腐蚀斑闪烁**：4 个斑点轮流变亮（毒源感）
- **命中防御-**：玩家被命中时显示 "DEF -20%" 红色字
- **腐蚀池冒泡**：3-4 个气泡循环
- **进入腐蚀池**：玩家踩入红色心跳警告

## 音效

| 事件 | 描述 |
|------|------|
| Idle | "嘶嘶" 化学反应声 |
| 移动 | "啪嘎啪嘎" 淤泥拖动 |
| 命中 | 玩家短促 "嘶哈" 痛叫 |
| 死亡 | "咕..." 融化 + "嘶嘶嘶" 腐蚀池形成 |
| 腐蚀池 | 持续轻微 "嘶嘶咕嘟" |

## 实现要点

```dart
class CorrosiveSlime extends SlimeBase {
  @override
  void onCollisionWithPlayer() {
    super.onCollisionWithPlayer();
    game.player.applyArmorDebuff(percent: -0.2, duration: 5.0);
    game.player.applyDoT(damage: 8, duration: 5.0);
  }
  
  @override
  void onSlimeDeath() {
    spawnCorrosionPuddle(
      position,
      size: 32,
      damagePerSecond: 10,
      duration: 4.0,
    );
  }
}
```
