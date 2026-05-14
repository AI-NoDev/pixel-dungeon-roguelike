# Regenerating Slime（再生史莱姆）

> 持续回血的烦人史莱姆。必须用持续伤害打才能彻底击杀。

## 基本信息

| 字段 | 值 |
|------|-----|
| ID | `regenerating_slime` |
| 出现楼层 | F4-F5 |
| 等级 | 变异 |
| 元素 | 治疗（绿光）|
| 体型 | 16×16 |

## 数值

```yaml
HP: 60
速度: 40
接触伤害: 12
特殊: 每秒回 5% HP（3/s）
弱点: 火/毒元素**禁止再生**（持续 3s）
死亡: 治疗光环（玩家治疗 20 HP，鼓励击杀）
```

## 形象设计

**翠绿发光**身体，比 Green Slime 更亮，外圈持续散发**治疗光圈**（白绿色）。表情温柔友善（`^_^`），头顶飘 `+` 加号粒子。

### 视觉特征
- 主色比 Green Slime 更鲜亮
- **持续白色发光光环**（再生效果可视化）
- 头顶环绕 2-3 个 `+` 加号粒子（治愈感）
- 受伤时光环短暂消失，但很快恢复
- 整体气氛"和平"（让玩家觉得"杀它有点不忍心"）

## 调色板

| 用途 | Hex |
|------|-----|
| 主体 | `#69F0AE` 翠绿亮 |
| 高光 | `#FFFFFF` |
| 治愈光 | `#A5D6A7` 淡绿 30% alpha |
| 阴影 | `#1B5E20` 深绿 |
| 加号粒子 | `#FFFFFF` + `#69F0AE` |
| 眼睛 | `#1B5E20` |

## 动画要点

### Idle (4 帧)
- 标准弹跳
- 治愈光环扩缩 1Hz 频率
- 加号粒子环绕头顶旋转

### Hurt (3 帧 — 比普通多 1)
- 帧 0: 白闪
- 帧 1: 痛苦
- 帧 2: **治愈瞬间**（绿光闪烁，提示在回血）

### Burning Hurt (持续 3s)
被火/毒元素打中时**回血禁止**：
- 持续显示红色 X 图标在头顶
- 光环消失（黑色烟雾代替）
- 整体颜色暗淡

### Death (6 帧)
**治愈爆发**：
- 帧 0: 白闪 + 大膨胀
- 帧 1: 全身发亮变白
- 帧 2: **绿色治愈光波**向外扩散（玩家被治疗）
- 帧 3-4: 光波继续扩散
- 帧 5: 残骸消散，留下闪光

## AI Prompt

```
Pixel art healing regenerating slime monster, 16x16 pixels,
bright vivid emerald green body with healing aura glow,
soft white-green halo radiating outward, peaceful gentle eyes ^_^,
plus sign + healing particles floating around head,
benevolent friendly creature aesthetic, life essence vibrant,
sparkles and white particles around body,
6-color palette: #69F0AE bright vibrant green main,
#FFFFFF white particles, #A5D6A7 light green halo,
#1B5E20 dark green shadow, transparent background,
healing creature retro 16-bit pixel art, kawaii style,
--niji 6 --ar 1:1
```

### Healing Aura Effect

```
Pixel art healing aura glow effect, 32x32 pixels,
soft white-green expanding circle, plus sign particles,
4-frame breathing animation, transparent background semi-transparent,
retro pixel art holy aesthetic
```

### Death Healing Burst

```
Pixel art death healing burst effect, 6 frames,
expanding white-green wave from center outward,
plus signs scattering, gentle peaceful aesthetic,
transparent background, retro pixel art --ar 6:1
```

## 特效

- **持续光环**：始终有微弱白绿色光圈
- **治疗 +号**：环绕头顶 3 颗加号粒子旋转
- **回血提示**：每秒出现绿色 +5 数字向上飘
- **抗回血状态**：火毒命中时显示"无法治疗"图标
- **死亡治疗**：玩家受到治疗时显示绿色 +20 数字

## 音效

| 事件 | 描述 |
|------|------|
| Idle | 温柔铃铛声循环 |
| 回血 | 每秒轻 "叮" 声 |
| 受击 | 心碎音 |
| 受火毒 | "嘶!" 反应 |
| 死亡 | 神圣合唱声 + 玩家治疗 chime |

## 实现要点

```dart
class RegeneratingSlime extends SlimeBase {
  Timer regenTimer = Timer(1.0);
  bool canRegenerate = true;
  Timer noRegenTimer = Timer(3.0)..pause();
  
  @override
  void update(double dt) {
    super.update(dt);
    regenTimer.update(dt);
    noRegenTimer.update(dt);
    
    if (regenTimer.finished && canRegenerate) {
      hp = (hp + maxHp * 0.05).clamp(0, maxHp);
      regenTimer.reset();
      // 显示 +5 数字
    }
  }
  
  @override
  void onElementHit(ElementType element) {
    if (element == ElementType.fire || element == ElementType.poison) {
      canRegenerate = false;
      noRegenTimer.start();
    }
  }
  
  @override
  void onSlimeDeath() {
    // 治疗玩家
    game.player.heal(20);
    spawnHealingBurst(position);
  }
}
```
