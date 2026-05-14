# Mutant Slime（变异史莱姆）

> 颜色不断变化的怪异史莱姆。属性也跟着变。最不可预测的敌人。

## 基本信息

| 字段 | 值 |
|------|-----|
| ID | `mutant_slime` |
| 出现楼层 | F3-F5（少见，10% 几率替代普通史莱姆）|
| 等级 | 变异 |
| 元素 | 多元素轮换 |
| 体型 | 16×16 |

## 数值

```yaml
HP: 50
速度: 70
接触伤害: 15
特殊机制: 每 3 秒切换属性（火/冰/雷/毒），属性时身体变色
死亡: 5 个不同色弹幕（每个属性各 1 个）
```

## 形象设计

**身体颜色不停变化**（彩虹流动 / 故障感），形状不规则，**多颗眼睛**（3-5 颗，位置不对称）。整体诡异不自然。

### 视觉特征
- 颜色每 3 秒切换：绿→红→蓝→黄→紫→绿循环
- 切换时有 0.5s 渐变过渡
- 体型不完全圆，有抖动变形
- 多颗眼睛大小不一
- 周围偶尔有故障/像素错位粒子

## 调色板（动态切换）

```yaml
模式 1 (绿/物理):
  主体: #66BB6A
  特效: 无
  
模式 2 (红/火):
  主体: #FF5722
  特效: 火焰光环
  
模式 3 (蓝/冰):
  主体: #4FC3F7
  特效: 冰晶
  
模式 4 (黄/雷):
  主体: #FFEB3B
  特效: 电弧
  
模式 5 (紫/毒):
  主体: #9C27B0
  特效: 毒雾
```

每个模式下行为也变（伤害类型随当前模式）。

## 动画要点

### Idle / Move (4 帧)
- 持续抖动 / 颜色 shimmer
- 多个眼睛位置每帧不同（错位感）

### Color Shift (8 帧 × 16fps，0.5s 过渡)
- 颜色平滑过渡
- 整体短暂发亮闪烁
- 切换瞬间释放当前属性的小特效

### Death (6 帧)
- 帧 0: 白闪 + 颜色快速循环
- 帧 1: 5 个属性同时显现（多色光球）
- 帧 2: 大爆炸
- 帧 3: 5 个不同颜色弹幕向 5 个方向飞
- 帧 4-5: 残骸消散

## AI Prompt

```
Pixel art mutant chaotic rainbow slime monster, 16x16 pixels,
unstable shifting body with glitchy color effect rainbow gradient,
multiple asymmetric eyes (3-5 eyes different sizes),
deformed irregular body shape with wobble effect,
chaotic energy aura with prismatic particles,
unsettling unnatural creature aesthetic,
glitching pixel art effect with color shifts,
prismatic palette: rainbow color spectrum,
transparent background, retro 16-bit pixel art,
weird mutant horror creature, --niji 6 --ar 1:1
```

### Color Transition Effect

```
Pixel art color morphing slime transition, 8 frames,
gradual color shift from green to red through full spectrum,
white flash at midpoint, glitch artifacts during transition,
maintains slime shape, transparent background, retro pixel art --ar 8:1
```

### Multi-Element Death Burst

```
Pixel art 5-element death explosion, 6 frames,
5 different colored projectiles (red fire, blue ice, yellow lightning,
purple poison, green basic) bursting from center in 5 directions,
each with element-specific particles, transparent background, retro pixel art --ar 6:1
```

## 特效

- **故障粒子**：身体周围偶尔出现错位的彩色像素方块
- **属性光环**：当前属性下身体外围有微光环（火红/冰蓝等）
- **眼睛闪烁**：多颗眼睛随机大小变化
- **死亡 5 元素弹幕**：每个属性 1 个弹丸（带各自颜色）

## 音效

| 事件 | 描述 |
|------|------|
| Idle | 持续怪异 "嗡嗡" 故障音 |
| 切换属性 | "哐!" + 故障声 |
| 移动 | 抽搐式 "啵啵啪" |
| 受击 | "刺啦!" 多频率叠加 |
| 死亡 | 5 种属性音效叠加 + 大爆炸 |

## 实现要点

```dart
class MutantSlime extends SlimeBase {
  ElementType currentElement = ElementType.fire;
  Timer mutationTimer = Timer(3.0);
  
  @override
  void update(double dt) {
    super.update(dt);
    mutationTimer.update(dt);
    if (mutationTimer.finished) {
      _switchElement();
      mutationTimer.reset();
    }
  }
  
  void _switchElement() {
    final elements = [Fire, Ice, Lightning, Poison, None];
    currentElement = elements[(currentElement.index + 1) % elements.length];
    color = _getColorForElement(currentElement);
  }
  
  @override
  void onSlimeDeath() {
    // 5 个不同属性弹幕
    for (final element in ElementType.values) {
      spawnElementBullet(element);
    }
  }
}
```
