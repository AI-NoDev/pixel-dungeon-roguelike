# King's Guard（皇家护卫）— 精英

> 戴小皇冠的紫色史莱姆，会发射圆形弹幕。

## 基本信息

| 字段 | 值 |
|------|-----|
| ID | `kings_guard` |
| 出现楼层 | F4-F5 精英房间 / Boss 房间前出现 |
| 等级 | 精英 |
| 元素 | 物理 |
| 体型 | **24×24（大）** |

## 数值

```yaml
HP: 180
速度: 70
接触伤害: 25
特殊: 周期性圆形弹幕（4 个酸球 90° 间隔）每 3s 一次
死亡: 召唤援军（2 个 Pink Bouncer）+ 短暂"忠诚"光环（buff 周围史莱姆 +20%伤害）
```

## 形象设计

**深紫色史莱姆戴小金皇冠**，身上披紫色 + 金色装饰带。表情**忠诚严肃**（`O_O` 眼神坚定）。手持**皇家令牌/旗帜**。

### 视觉特征
- 紫色基底 + 金色饰边
- 头戴小金皇冠（不如 Slime King 那么大）
- 身体侧有"国王守卫"徽章
- 周围有 4 个酸球轨道（持续旋转）
- 略带优雅的姿态

## 调色板

| 用途 | Hex |
|------|-----|
| 主体 | `#9C27B0` 深紫 |
| 高光 | `#BA68C8` 浅紫 |
| 阴影 | `#4A148C` 极深紫 |
| 皇冠金 | `#FFD700` |
| 装饰带 | `#FFD700` + `#9C27B0` |
| 徽章 | `#FFFFFF` 白 |
| 酸球 | `#76FF03` 绿 |
| 眼睛 | `#FFFFFF` |

## 动画要点

### Idle (4 帧)
- 缓慢呼吸式弹跳
- 4 个酸球持续顺时针环绕
- 皇冠偶尔反光

### Move (4 帧)
- 优雅跳跃（不像普通 slime 那么蠢）
- 酸球继续环绕（即使移动也保持轨道）

### Barrage Attack (8 帧 × 12fps，每 3s 一次)
**圆形弹幕**：
- 帧 0-1: 4 个酸球加速旋转
- 帧 2-3: 酸球向外膨胀（充能）
- 帧 4-5: **同时向 4 个方向射出**
- 帧 6-7: 新的 4 个酸球生成（轨道回归）

### Death (10 帧)
**贵族死法**：
- 帧 0-1: 皇冠掉落
- 帧 2-3: 装饰带散开
- 帧 4-5: **召唤光圈**（紫色魔法阵）
- 帧 6-7: 召唤 2 个 Pink Bouncer
- 帧 8-9: 消散，地上留皇冠彩蛋（5s）

## AI Prompt

```
Pixel art royal guardian slime elite, 24x24 pixels,
regal deep purple slime with small golden crown,
gold trim sash and royal medallion, noble dignified pose,
holding ceremonial banner staff,
4 green acid orbs orbiting around body in circle,
serious loyal expression, royal aristocratic aesthetic,
fantasy elite guard creature,
8-color palette: #9C27B0 deep purple main, #BA68C8 light purple highlight,
#4A148C darkest purple shadow, #FFD700 gold crown and trim,
#FFFFFF white medallion, #76FF03 green orbiting acid orbs,
transparent background, retro 16-bit pixel art elite enemy,
--niji 6 --ar 1:1 --quality 2
```

### Orbital Acid Orbs

```
Pixel art 4 green acid orbs orbiting in circle, 24x24,
glowing toxic green spheres in 90 degree spacing,
8-frame rotation animation around center,
transparent background, retro pixel art --ar 8:1
```

### Radial Barrage Death

```
Pixel art radial acid barrage attack, 32x32 pixels,
4 acid orbs flying outward from center in 4 cardinal directions,
expanding outward with motion trails, transparent background,
retro pixel art --ar 4:1
```

## 特效

- **酸球轨道**：4 个酸球持续环绕（即使死也存在 0.5s）
- **弹幕特效**：发射时酸球膨胀变亮
- **召唤魔法阵**：死亡前紫色光圈
- **皇冠彩蛋**：死亡后留 5s 金皇冠（玩家拾取 50 金币 + 解锁成就）

## 音效

| 事件 | 描述 |
|------|------|
| Idle | 优雅低音 + 酸球"咕嘟咕嘟" |
| 移动 | 优雅"咚咚"声 |
| 弹幕 | "嗖嗖嗖嗖!" 4 连发 |
| 受击 | 高傲"哼!" |
| 死亡 | "唉..." 优雅倒下 + 召唤"嗡!" |

## 实现要点

```dart
class KingsGuard extends SlimeBase {
  List<AcidOrb> orbitalOrbs = [];
  Timer barrageTimer = Timer(3.0);
  
  @override
  void onLoad() async {
    super.onLoad();
    // 生成 4 个轨道酸球
    for (int i = 0; i < 4; i++) {
      orbitalOrbs.add(AcidOrb(parent: this, angleOffset: i * 90));
    }
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    barrageTimer.update(dt);
    if (barrageTimer.finished) {
      _fireBarrage();
      barrageTimer.reset();
    }
  }
  
  void _fireBarrage() {
    for (final orb in orbitalOrbs) {
      orb.fireOutward();
    }
    // 0.5s 后生成新轨道酸球
    Future.delayed(const Duration(milliseconds: 500), () {
      orbitalOrbs = [...]; // 重新生成
    });
  }
  
  @override
  void onSlimeDeath() {
    // 召唤 2 个 Pink Bouncer
    game.world.add(PinkBouncer(position: position + Vector2(-15, 0)));
    game.world.add(PinkBouncer(position: position + Vector2(15, 0)));
    // 留下皇冠彩蛋
    game.world.add(CrownPickup(position: position));
  }
}
```
