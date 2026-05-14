# Toxic Goo（剧毒黏液）

> 紫绿色的有毒史莱姆。慢，但黏人，死后留下毒云。

## 基本信息

| 字段 | 值 |
|------|-----|
| ID | `toxic_goo` |
| 出现楼层 | F2-F5 |
| 等级 | 普通 |
| 元素 | 毒 |
| 体型 | 16×16 |

## 数值

```yaml
HP: 40
速度: 35
接触伤害: 10 + 中毒 DoT 5/s 持续 5s
死亡毒云: 半径 40px 持续 4s（5/s 伤害）
```

## 形象设计

**紫色基底 + 绿色毒斑**，整体偏暗。眼睛细长邪恶（`>__>`），表面持续冒紫绿色气泡。

### 视觉特征
- 不像绿史莱姆那么"水嫩"，更像浓稠淤泥
- 表面有 3-4 个**毒气泡**循环冒出爆破
- 头顶持续散发淡紫色毒雾
- 整体造型不规则（更像烂泥而非完美球形）

## 调色板

| 用途 | Hex |
|------|-----|
| 主体 | `#9CCC65` 黄绿 |
| 毒斑 | `#6A1B9A` 深紫 |
| 阴影 | `#33691E` 暗绿 |
| 高光 | `#DCEDC8` 淡绿 |
| 毒雾 | `#7B1FA2` 紫 30%透明 |
| 眼睛 | `#4A148C` 深紫 |

## 动画要点

### Idle (4 帧)
- 帧 0: 标准 + 1 个毒气泡膨胀
- 帧 1: 气泡破裂喷紫雾
- 帧 2: 标准
- 帧 3: 顶部冒大紫泡

### Move (4 帧)
缓慢蠕动式（不像跳跃，而是黏液流动）：
- 整体轻微变形
- 拖着尾巴（黏液拖痕）

### Death (6 帧)
**留下大毒云**：
- 帧 0: 白闪 + 痛苦扭曲
- 帧 1: 身体开始分解
- 帧 2: 化为大量毒气泡
- 帧 3: 气泡膨胀（约 24×24）
- 帧 4: **形成毒云**（圆形紫绿色烟雾）
- 帧 5: 毒云缓慢扩散

## AI Prompt

```
Pixel art toxic poisonous slime monster, 16x16 pixels,
sickly yellow-green sludgy body with deep purple toxic spots,
bubbling poison fluid texture, narrowed evil eyes >___>,
purple toxic gas wisps rising from top, hazardous biohazard aesthetic,
irregular non-spherical shape like oozing sludge,
6-color palette: #9CCC65 yellow-green main, #6A1B9A purple toxic spots,
#33691E dark green shadow, #DCEDC8 light highlight, 
#7B1FA2 purple gas wisps, #4A148C dark eyes,
transparent background, retro 16-bit pixel art,
chemical waste creature aesthetic, --niji 6 --ar 1:1
```

### Poison Cloud Effect

```
Pixel art toxic poison cloud, 32x32 pixels per frame,
6-frame animated expanding green-purple cloud of toxic gas,
swirling smoke texture with bubble particles,
transparent background semi-transparent fill,
retro pixel art --ar 6:1
```

### Toxic Bubble

```
Pixel art tiny toxic bubble, 6x6 pixels,
4-frame animation: small > medium > large > burst,
purple-green gradient, transparent background, retro pixel
```

## 特效

- **持续气泡**：身上 3 个气泡随机位置循环冒出
- **拖痕**：移动时在地上留 1 秒紫色拖痕
- **毒云**：死亡后圆形扩散区域持续 4s
- **气泡爆破**：每个气泡破裂时小紫雾喷溅

## 音效

| 事件 | 描述 |
|------|------|
| Idle | "咕嘟咕嘟" 毒液起泡 |
| 移动 | "啪嗒啪嗒" 黏液移动 |
| 受击 | "咕..." 痛苦低吼 |
| 死亡 | "嘶哈!" + 毒云生成"哧" |
| 毒云 | 持续轻微 "嘶嘶" 气体声 |

## 实现要点

```dart
class ToxicGoo extends SlimeBase {
  @override
  void onCollisionWithPlayer() {
    player.applyPoisonDoT(damage: 5, duration: 5.0);
  }
  
  @override
  void onSlimeDeath() {
    spawnPoisonCloud(position, radius: 40, duration: 4.0, dps: 5);
  }
}
```
