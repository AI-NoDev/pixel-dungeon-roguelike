# Thunder Jolt（雷电跳跳）

> 黄色电浆构成的史莱姆，全身电弧缠绕。极速、电击。

## 基本信息

| 字段 | 值 |
|------|-----|
| ID | `thunder_jolt` |
| 出现楼层 | F3-F5 |
| 等级 | 普通（高速）|
| 元素 | 雷电 |
| 体型 | 16×16 |

## 数值

```yaml
HP: 25
速度: 130 px/s（极快）
接触伤害: 10 + 雷电链击附近敌人 5
死亡: 链电爆炸（链击 3 个目标）
```

## 形象设计

**黄色电浆体**，外圈电弧"嗡嗡"环绕。眼睛瞪大兴奋（`O.O`），永远像被电了一样兴奋。

### 视觉特征
- 主体亮黄色发光
- 周围 4-6 个电弧（白色/淡蓝色锯齿线条）
- 移动极快，几乎拖着电光痕迹
- 受击时电弧暴增

## 调色板

| 用途 | Hex |
|------|-----|
| 主体 | `#FFEB3B` 鲜黄 |
| 电弧 | `#FFFFFF` + `#1976D2` 白蓝 |
| 阴影 | `#FBC02D` 橙黄 |
| 高光 | `#FFFFFF` |
| 电光 | `#82B1FF` 浅蓝 |
| 眼睛 | `#1A1A2E` |

## 动画要点

### Idle (4 帧)
身体本身只微微弹跳，但**电弧动画疯狂**：
- 4 帧不同方向的电弧（每帧 6 个电弧重新生成）
- 永不静止，永远滋滋作响

### Move (2 帧 ×16fps，超快)
- 帧 0: 拉伸成长条电光（高度 8、宽度 24）
- 帧 1: 着陆压扁（电弧暴涨）

每跳一步留下电光残影 0.2s。

### Death (6 帧)
**雷电爆炸**：
- 帧 0: 白光闪烁 + 体积膨胀
- 帧 1: 全身变成纯白光
- 帧 2: **雷电大爆炸**（屏幕短暂发白）
- 帧 3: 6 条电弧向 6 个方向射出（链击）
- 帧 4: 残留电光弧形
- 帧 5: 消散，地面焦黑

## AI Prompt

```
Pixel art electric thunder yellow slime monster, 16x16 pixels,
glowing bright yellow plasma body, electricity arcs crackling all around,
bright white-blue lightning bolts encircling body,
super excited shocked O.O wide eyes, energetic crazy aesthetic,
hyperactive electric aura, dangerous high voltage feeling,
6-color palette: #FFEB3B bright yellow main, #FFFFFF white sparks,
#1976D2 blue arcs, #FBC02D orange-yellow shadow, #82B1FF light blue glow,
#1A1A2E dark eyes, transparent background,
electric monster retro 16-bit pixel art,
--niji 6 --ar 1:1 --quality 2
```

### Lightning Arc Effect

```
Pixel art lightning bolt zigzag effect, 8x16 pixels per frame,
4-frame animation of branching lightning, white core with blue outer glow,
sharp jagged shape, transparent background, retro pixel art
```

### Death Chain Lightning

```
Pixel art chain lightning death effect, sequence of 6 frames,
frame 1: white flash, frame 2: expanding electric ball,
frame 3-5: 6 lightning arcs branching outward in all directions,
frame 6: residual sparks fading,
yellow-white electricity, transparent background, retro pixel art --ar 6:1
```

## 特效

- **持续电弧**：身体周围 4 个电弧每 0.1s 重新生成（动画感强）
- **移动残影**：每跳一步留 2-3 个黄色淡影 0.2s
- **死亡链电**：3 条白色电弧从死亡点伸向最近 3 个敌人
- **冲击声光**：死亡瞬间屏幕短暂发白（150ms）

## 音效

| 事件 | 描述 |
|------|------|
| Idle | 持续 "滋滋滋" 电流声 |
| 移动 | "兹啪!" 高速电击 |
| 受击 | "哔哔!" 电子尖叫 |
| 死亡 | "轰!" 雷电爆炸 + 链击声 |
| 链电 | "哒哒哒" 连续电击 |

## 实现要点

```dart
class ThunderJolt extends SlimeBase {
  // 极速移动 + 不规则跳跃
  // 死亡时调用 ElementSystem._chainLightning
}
```
