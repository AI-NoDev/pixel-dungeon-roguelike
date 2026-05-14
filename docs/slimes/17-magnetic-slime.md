# Magnetic Slime（磁力史莱姆）

> 黄黑警告条纹的工业风史莱姆。能弯曲玩家子弹的轨迹。

## 基本信息

| 字段 | 值 |
|------|-----|
| ID | `magnetic_slime` |
| 出现楼层 | F4-F5 |
| 等级 | 变异 |
| 元素 | 磁力 |
| 体型 | 16×16 |

## 数值

```yaml
HP: 60
速度: 30
接触伤害: 10
特殊: 拉拽玩家（吸力 60px 半径）
特殊: 子弹经过时弹道弯曲（影响半径 80px）
死亡: 释放磁场脉冲，附近敌人短暂吸附
```

## 形象设计

**黄黑警告条纹**身体（工业风），身上有**磁极标识**（红+ 蓝-）。眼睛是齿轮形（机械感）。周围有**磁力波纹**（同心圆/曲线）。

### 视觉特征
- 黄黑斜纹（hazard pattern）
- 身体两侧 N/S 标识（红蓝磁极）
- 周围每隔 1.5s 出现磁场波纹
- 子弹靠近时弹道明显弯曲（视觉提示）

## 调色板

| 用途 | Hex |
|------|-----|
| 主体黄 | `#FF6F00` 工业黄 |
| 主体黑条 | `#1A1A2E` |
| 红极 | `#D32F2F` N极标识 |
| 蓝极 | `#1976D2` S极标识 |
| 磁场 | `#FFFFFF` 50% alpha |
| 眼睛 | `#000000` |

## 动画要点

### Idle (4 帧)
- 普通弹跳
- 磁极标识 N/S 在两侧旋转切换位置
- 每 1.5s 释放一次磁场波纹

### Magnetic Pulse (8 帧 × 12fps，每 1.5s 触发)
- 帧 0-3: 同心圆磁场扩散（白色环）
- 帧 4-7: 收缩消失

期间靠近的子弹弹道弯曲。

### Death (6 帧)
**磁场脉冲爆发**：
- 帧 0: 白闪
- 帧 1: 体型膨胀
- 帧 2: **大磁场释放**（白色圆环 80px）
- 帧 3: 磁场扩散吸引附近敌人
- 帧 4: 残骸消散
- 帧 5: 完全消失

## AI Prompt

```
Pixel art magnetic slime monster, 16x16 pixels,
yellow and black industrial hazard stripe pattern body,
visible N pole red marker and S pole blue marker on sides,
mechanical gear-like eyes, magnetic field waves emanating from body,
industrial dangerous warning aesthetic, scientific creature feel,
6-color palette: #FF6F00 industrial yellow main, #1A1A2E black stripes,
#D32F2F red N-pole marker, #1976D2 blue S-pole marker,
#FFFFFF white magnetic field lines, transparent background,
industrial monster retro 16-bit pixel art,
hazard tape aesthetic, --niji 6 --ar 1:1
```

### Magnetic Field Pulse

```
Pixel art magnetic field pulse effect, 32x32 pixels,
expanding concentric white circles emanating outward,
8-frame animated wave pattern,
transparent background semi-transparent,
sci-fi magnetic effect, retro pixel art --ar 8:1
```

### Bullet Path Curve

```
Pixel art bullet trajectory bending visual effect,
yellow bullet with curved motion trail showing magnetic deflection,
ghostly path indicator showing redirected direction,
8-frame animation of bullet curving around magnet,
transparent background, retro pixel art --ar 8:1
```

## 特效

- **磁极动画**：N/S 标识每帧切换位置（旋转感）
- **磁场波纹**：每 1.5s 一次同心圆扩散
- **子弹弯曲**：玩家子弹接近时显示曲线轨迹
- **吸引玩家**：玩家靠近时屏幕边缘"被吸"提示
- **死亡磁脉冲**：圆形大白光 + 附近敌人被拽

## 音效

| 事件 | 描述 |
|------|------|
| Idle | 持续 "嗡嗡" 磁场低音 |
| 磁场脉冲 | "嗡!" 高音爆发 |
| 子弹弯曲 | "唰" 弯曲风声 |
| 受击 | "兹啪!" 电磁干扰 |
| 死亡 | "嗡!" 大磁脉冲 + "哒哒" 吸附声 |

## 实现要点

```dart
class MagneticSlime extends SlimeBase {
  Timer pulseTimer = Timer(1.5);
  double magnetRadius = 80;
  double pullRadius = 60;
  
  @override
  void update(double dt) {
    super.update(dt);
    pulseTimer.update(dt);
    if (pulseTimer.finished) {
      spawnMagneticPulse();
      pulseTimer.reset();
    }
    
    // 拉拽玩家
    if (distanceToPlayer < pullRadius) {
      final dir = (position - game.player.position).normalized();
      game.player.position += dir * 30 * dt;
    }
    
    // 弯曲附近子弹
    for (final bullet in game.world.children.whereType<Bullet>()) {
      if (bullet.isPlayerBullet && bullet.position.distanceTo(position) < magnetRadius) {
        // 计算切线方向，让子弹绕开
        bullet.direction = _curveDirection(bullet);
      }
    }
  }
  
  @override
  void onSlimeDeath() {
    spawnMagneticPulse(scale: 2.0);
    pullNearbyEnemies(radius: 100);
  }
}
```
