# Slime Knight（史莱姆骑士）— 精英

> 戴铠甲、持小剑的史莱姆。比普通强很多。

## 基本信息

| 字段 | 值 |
|------|-----|
| ID | `slime_knight` |
| 出现楼层 | F4-F5 精英房间 |
| 等级 | 精英 |
| 元素 | 物理 |
| 体型 | **24×24（大）** |

## 数值

```yaml
HP: 200
速度: 60
接触伤害: 25
特殊: 物理护盾减伤 50%
特殊: 死亡召唤 2 个 Mega Goo
```

## 形象设计

**深红色史莱姆穿铠甲**，戴尖头骑士盔，手持迷你长剑和小盾牌。表情严肃英勇（`>:|`）。整体像"小型BOSS"。

### 视觉特征
- 体型大（24×24）
- 银色铠甲（胸甲、肩甲）
- 红色披风（小，但很显眼）
- 头戴尖顶骑士盔（金色翎毛）
- 持小剑（10 像素长）
- 持小盾（圆形）

## 调色板

| 用途 | Hex |
|------|-----|
| 主体 | `#C2185B` 深红 |
| 高光 | `#E91E63` 亮粉红 |
| 阴影 | `#880E4F` 深酒红 |
| 银铠甲 | `#BDBDBD` |
| 金饰 | `#FFD700` |
| 红披风 | `#B71C1C` |
| 剑刃 | `#E0E0E0` |
| 眼睛 | `#FFFFFF` 决心 |

## 动画要点

### Idle (4 帧)
- 微微弹跳（不像普通 slime 大跳）
- 披风微微飘动
- 偶尔挥剑亮相

### Move (4 帧)
- 重型跳跃（披风明显甩动）
- 着陆时铠甲叮当声

### Attack (4 帧 × 12fps)
**挥剑**：
- 帧 0: 举剑（剑垂直）
- 帧 1: 蓄力（背靠后）
- 帧 2: **挥砍**（剑划弧线，伴随剑光）
- 帧 3: 收剑

### Hurt (2 帧)
- 帧 0: 全身闪白（铠甲反光）
- 帧 1: 略微后仰

### Death (10 帧 × 8fps)
**英勇牺牲**：
- 帧 0-1: 中剑大伤害 + 铠甲剥落
- 帧 2-3: 跪倒
- 帧 4-5: 剑掉落
- 帧 6-7: 倒地
- 帧 8: **召唤 2 个 Mega Goo**（从地面升起）
- 帧 9: 完全消散

## AI Prompt

```
Pixel art armored slime knight elite enemy, 24x24 pixels,
deep crimson red slime body wearing silver plate armor,
gold-trimmed knight helmet with feather crest,
holding tiny silver sword and round shield, red cape flowing,
brave heroic determined expression, valiant guardian aesthetic,
fantasy RPG elite enemy feel,
8-color palette: #C2185B crimson red main, #E91E63 light red highlight,
#880E4F dark wine shadow, #BDBDBD silver armor, #FFD700 gold trim,
#B71C1C red cape, #E0E0E0 sword blade, #FFFFFF determined eyes,
transparent background, retro 16-bit pixel art,
fantasy slime knight character sprite, --niji 6 --ar 1:1 --quality 2
```

### Sword Swing Attack

```
Pixel art slime knight sword swing animation, 4 frames,
slime knight raising sword, charging back,
swinging in arc with trailing slash effect,
recovery position, transparent background,
retro pixel art --ar 4:1
```

### Death Summon

```
Pixel art elite slime death with summon, 10 frames,
slime knight taking fatal damage, armor cracking,
falling to knees, dropping sword, collapsing,
two large mega goo slimes rising from ground,
final dissolution effect, transparent background,
retro pixel art --ar 10:1
```

## 特效

- **铠甲反光**：身上银色部分偶尔闪烁
- **挥剑剑光**：弧形白色光迹（持续 100ms）
- **盾防火花**：被打中时盾上溅火星
- **召唤魔法阵**：死亡前地面紫色魔法阵

## 音效

| 事件 | 描述 |
|------|------|
| Idle | 铠甲叮当 + 武器声 |
| 移动 | 沉重金属步伐 |
| 挥剑 | "锵!" 出剑 + "唰!" 划空 |
| 受击 | "锵咣!" 铠甲被击 |
| 死亡 | "啊!" 英勇 + 武器掉落 + 召唤声 |

## 实现要点

```dart
class SlimeKnight extends SlimeBase {
  Timer attackTimer = Timer(2.5);
  
  @override
  void update(double dt) {
    super.update(dt);
    attackTimer.update(dt);
    if (attackTimer.finished && _distanceToPlayer < 80) {
      meleeAttack();
      attackTimer.reset();
    }
  }
  
  @override
  void takeDamage(double damage) {
    final reduced = damage * 0.5;  // 50% 物理减伤
    super.takeDamage(reduced);
  }
  
  @override
  void onSlimeDeath() {
    // 召唤 2 个 Mega Goo
    game.world.add(MegaGoo(position: position + Vector2(-20, 0)));
    game.world.add(MegaGoo(position: position + Vector2(20, 0)));
  }
}
```
