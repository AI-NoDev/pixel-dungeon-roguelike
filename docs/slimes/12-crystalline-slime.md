# Crystalline Slime（结晶史莱姆）

> 半透明的晶体史莱姆，身体内部有几何切面。难打但怕冰。

## 基本信息

| 字段 | 值 |
|------|-----|
| ID | `crystalline_slime` |
| 出现楼层 | F4-F5 |
| 等级 | 变异（防御）|
| 元素 | 物理（晶体）|
| 体型 | 16×16 |

## 数值

```yaml
HP: 100
速度: 30
接触伤害: 20
物理护甲: 减少 30% 物理伤害
弱点: 冰元素 -50% 防御（变脆）
死亡: 30 金币 + 必掉宝石道具
```

## 形象设计

**半透明紫水晶质地**，身体内部能看到几何切面（菱形、三角形）。表面有规整的晶体反光线。整体像一颗有生命的宝石。

### 视觉特征
- 半透明（70% 不透明）
- 内部 3-5 个**几何切面**（呈现内部反光线）
- 表面**规则的高光线条**（区别于其他 slime 的不规则）
- 受击时切面变明显（充能感）

## 调色板

| 用途 | Hex |
|------|-----|
| 主体 | `#B388FF` 紫晶 70% alpha |
| 内部切面 | `#FFFFFF` 白 |
| 高光线 | `#E040FB` 亮紫 |
| 阴影 | `#311B92` 深紫 |
| 反光 | `#FFD700` 金（偶尔）|
| 眼睛 | `#1A1A2E` |

## 动画要点

### Idle (4 帧)
- 整体几乎不动
- 内部切面随帧数缓慢旋转/折射
- 高光线条扫过

### Move (4 帧)
- 整体跳跃
- 切面位置保持不变（错觉感）
- 移动时反光更强烈

### Hurt (2 帧)
- 帧 0: 切面线条全亮
- 帧 1: 出现裂纹

### Hurt By Ice (特殊 2 帧)
被冰元素击中时**变脆**：
- 帧 0: 全身蓝白色
- 帧 1: 大量裂纹（视觉提示防御降低）

### Death (8 帧 — 比普通多 2 帧)
**碎裂动画**：
- 帧 0: 白闪 + 全身亮起
- 帧 1: 大裂纹出现
- 帧 2: 沿切面分裂
- 帧 3: **碎裂成 6 块**水晶
- 帧 4: 水晶向外飞
- 帧 5: 水晶在地面散落
- 帧 6: 水晶发光（金币掉落提示）
- 帧 7: 残光消失

## AI Prompt

```
Pixel art crystalline gem slime monster, 16x16 pixels,
semi-transparent prismatic purple crystal body 70% opacity,
visible internal geometric facets and refractions,
regular crystalline highlight lines on surface,
mystical magical gemstone aesthetic, hard armored feeling,
sharp angular crystal patterns inside, glassy transparent finish,
6-color palette: #B388FF translucent purple crystal main,
#FFFFFF white internal facets, #E040FB bright purple highlights,
#311B92 deep purple shadow, #FFD700 occasional gold sparkle,
#1A1A2E small dark eyes, transparent background,
gemstone monster retro 16-bit pixel art, --niji 6 --ar 1:1
```

### Crystal Shatter Death

```
Pixel art crystal shattering death effect, 8 frames horizontal,
frame 1: intact crystal slime, frame 2: bright flash,
frame 3: cracks appearing along facets, frame 4: full fracture,
frame 5-7: 6 crystal shards flying outward,
frame 8: shards landing on ground glittering,
purple-white crystal palette, transparent background, retro pixel art --ar 8:1
```

### Frozen State

```
Pixel art crystalline slime frozen by ice, 16x16,
purple crystal body covered in white frost layer,
visible cracks all over, weakened brittle aesthetic,
ice-blue highlights on edges, transparent background, retro pixel art
```

## 特效

- **持续反光**：身体内部每 1.5s 闪烁一次（折射感）
- **物理护甲**：被普通子弹击中时火花特效（减伤反馈）
- **冰元素弱点**：被冰击中时白色裂纹效果
- **死亡碎裂**：6 块水晶向外飞 + 金币掉落

## 音效

| 事件 | 描述 |
|------|------|
| Idle | 微弱 "叮" 声循环 |
| 移动 | "咔嚓咔嚓" 玻璃移动声 |
| 受击 | "锵!" 玻璃敲击 |
| 受冰击 | "咔嚓!" 强裂纹声 |
| 死亡 | "哗啦!" 大量水晶碎裂 + 钱币声 |

## 实现要点

```dart
class CrystallineSlime extends SlimeBase {
  @override
  void takeDamage(double damage) {
    final reduced = damage * 0.7;  // 30% 物理减伤
    super.takeDamage(reduced);
  }
  
  @override
  void onElementHit(ElementType element) {
    if (element == ElementType.ice) {
      // 变脆：50% 额外伤害（即去掉护甲再扣一半）
      takeDamage(currentHp * 0.5);
    }
  }
  
  @override
  void onSlimeDeath() {
    // 必掉金币和宝石
    for (int i = 0; i < 6; i++) {
      spawnCrystalShard(position, randomDirection());
    }
    spawnCoinDrop(position, amount: 30);
  }
}
```
