# Slime Mage（史莱姆法师）— 精英

> 戴尖帽、漂浮的紫色法师史莱姆。会下魔法阵 AoE。

## 基本信息

| 字段 | 值 |
|------|-----|
| ID | `slime_mage` |
| 出现楼层 | F4-F5 精英房间 |
| 等级 | 精英（远程）|
| 元素 | 魔法（紫）|
| 体型 | **24×24（大）** |

## 数值

```yaml
HP: 150
速度: 40
接触伤害: 5
远程伤害: 18（魔法弹）
特殊: 在地面下魔法阵（5s 后爆发 30 伤害 30×30 范围）
死亡: 释放魔法风暴（8 个紫色弹幕）
```

## 形象设计

**紫色史莱姆戴尖顶法师帽**（带星星图案），手持悬浮**水晶法杖**（不是握，悬浮在身边）。眼睛闭合（修行感）或专注（`-_-`）。**身体悬浮 4-6 像素**（不接触地面）。

### 视觉特征
- 体型大（24×24）
- 尖顶法师帽（紫色 + 黄色星星 + 月亮）
- 法杖（水晶顶端发紫光）
- 永远悬浮（无地面阴影）
- 周围有**魔法粒子环绕**（紫色火花）

## 调色板

| 用途 | Hex |
|------|-----|
| 主体 | `#6A1B9A` 深紫 |
| 高光 | `#AB47BC` 亮紫 |
| 阴影 | `#4A148C` 极深紫 |
| 法师帽 | `#311B92` 深紫黑 |
| 帽星星 | `#FFD700` 金 |
| 法杖 | `#5D4037` 棕 |
| 水晶 | `#E040FB` 紫光 |
| 眼睛 | `#FFFFFF` |

## 动画要点

### Idle (4 帧)
- 悬浮上下漂 2px
- 法杖轻微旋转
- 周围紫色粒子环绕

### Cast Spell (8 帧 × 12fps)
**施法**：
- 帧 0-1: 抬起法杖
- 帧 2-3: 水晶充能（变亮）
- 帧 4-5: **释放魔法弹** 或 **下魔法阵**
- 帧 6-7: 收回法杖

### Magic Circle Spawn (8 帧)
**地面魔法阵**（在玩家脚下出现）：
- 帧 0-1: 紫色光点出现
- 帧 2-3: 圆形扩大到 30×30
- 帧 4-5: 文字符号填入（旋转）
- 帧 6: 充能高峰（白光闪烁）
- 帧 7: **爆发**（紫光柱冲天）

### Death (10 帧)
**魔法风暴**：
- 帧 0-1: 法杖断裂
- 帧 2-3: 帽子掉落
- 帧 4-5: 体内魔力暴走
- 帧 6-8: **8 个紫色弹幕**向 8 方向射出
- 帧 9: 消散

## AI Prompt

```
Pixel art slime wizard mage elite enemy, 24x24 pixels,
deep purple slime wearing pointy wizard hat with golden stars and moon,
holding floating crystal staff with glowing magenta orb,
levitating off ground, mystical sparkles surrounding body,
focused magical expression, ancient wise mage aesthetic,
fantasy RPG elite caster feel,
8-color palette: #6A1B9A deep purple main, #AB47BC bright purple highlight,
#4A148C darkest purple shadow, #311B92 wizard hat,
#FFD700 gold stars, #5D4037 wood staff, #E040FB crystal glow,
#FFFFFF white sparkle eyes, transparent background,
levitating wizard slime retro 16-bit pixel art,
--niji 6 --ar 1:1 --quality 2
```

### Magic Circle Effect

```
Pixel art purple magic summoning circle on ground, 32x32 pixels,
ornate runic circle pattern with glowing purple energy,
8-frame expansion and charge animation,
top-down view, transparent background,
retro pixel art mystical aesthetic --ar 8:1
```

### Magic Bullet Projectile

```
Pixel art purple magic projectile, 8x8 pixels,
glowing magenta orb with arcane runes, sparkle trail,
4-frame rotation animation, transparent background,
retro pixel art magical attack --ar 4:1
```

## 特效

- **悬浮粒子**：4 个紫色魔法粒子环绕
- **施法光芒**：水晶充能时紫光膨胀
- **魔法阵警告**：地面出现时玩家收到提示
- **风暴弹幕**：死亡时 8 个紫色魔法弹（45° 间隔）

## 音效

| 事件 | 描述 |
|------|------|
| Idle | 神秘 "嗡嗡" 魔法声 |
| 施法 | "嗡呜!" 充能 |
| 魔法阵 | "嗤呼!" 出现 + 倒计时音 |
| 阵爆发 | "BOOM!" 紫光爆炸 |
| 死亡 | "嗷..." + 8 个魔法弹 "嗖嗖嗖" |

## 实现要点

```dart
class SlimeMage extends SlimeBase {
  Timer castTimer = Timer(4.0);
  
  @override
  void update(double dt) {
    super.update(dt);
    castTimer.update(dt);
    if (castTimer.finished) {
      _castSpell();
      castTimer.reset();
    }
  }
  
  void _castSpell() {
    // 50% 概率下魔法阵，50% 概率发射魔法弹
    if (Random().nextDouble() < 0.5) {
      spawnMagicCircle(game.player.position, 
        delay: 5.0, damage: 30, radius: 30);
    } else {
      shootMagicBullet();
    }
  }
  
  @override
  void onSlimeDeath() {
    // 8 方向魔法弹
    for (int i = 0; i < 8; i++) {
      final angle = (2 * pi / 8) * i;
      spawnMagicBullet(angle, damage: 12);
    }
  }
}
```
