# Green Slime（草绿史莱姆）

> 最经典最普通的史莱姆。蠢萌、Q弹、容易被打。是玩家学习游戏机制的"第一课"。

## 基本信息

| 字段 | 值 |
|------|-----|
| ID | `green_slime` |
| 中文名 | 草绿史莱姆 |
| 出现楼层 | F1-F5（高频）|
| 等级 | 普通 |
| 元素 | 物理 |
| 难度 | ⭐ |

## 数值

```yaml
HP: 30
速度: 60 px/s
接触伤害: 10
攻击间隔: 仅接触
死亡掉落: 10 金币（普通）
体型: 16×16 px
```

## 形象设计

### 整体描述
**圆滚滚一个绿色凝胶小球**，半身埋地里弹跳前进。性格憨厚天真。被攻击时会先一愣再"啊？"。

### 身体结构
```
┌─────────────┐
│   ▲▲▲       │ ← 顶部小高光（3 像素圆点）
│ ╱     ╲     │ ← 圆弧顶（有微微弹性）
││  ●  ● │   │ ← 两个黑色圆点眼睛
││   ╰╯  │   │ ← 嘴巴（小弧线，可选）
│ ╲_____╱    │ ← 底部扁平（贴地）
│  ░░░░░     │ ← 椭圆阴影（透明黑）
└─────────────┘
```

### 调色板（6 色）

| 用途 | Hex | 描述 |
|------|-----|------|
| 主体 | `#66BB6A` | 草绿（明亮饱和）|
| 高光 | `#A5D6A7` | 浅绿（顶部反光）|
| 阴影 | `#2E7D32` | 深绿（底部）|
| 眼睛 | `#000000` | 纯黑 |
| 高光闪烁 | `#FFFFFF` | 白（可选）|
| 地面阴影 | `#000000 30%` | 半透明黑 |

## 动画帧详细分解

### 1. Idle 静止（4 帧 × 6fps）

**目的**：原地呼吸式弹跳，让玩家知道它"活着"。

```
帧 0: 标准形态
  ▶ 高度 16px
  ▶ 顶部光斑居中
  ▶ 眼睛标准位置

帧 1: 微微鼓起
  ▶ 高度 17px（拉高 1px）
  ▶ 宽度 15px（变窄 1px）
  ▶ 眼睛上移 1px

帧 2: 标准形态（同帧 0）

帧 3: 微微下压
  ▶ 高度 15px（压扁 1px）
  ▶ 宽度 17px（变宽 1px）
  ▶ 眼睛下移 1px
```

文件名：`slime_green_idle_0.png` ~ `slime_green_idle_3.png`

### 2. Jump 移动（4 帧 × 8fps）

**目的**：跳跃式前进，每个循环约 0.5 秒。

```
帧 0: 蹲下蓄力
  ▶ 压扁（高度 12px，宽度 18px）
  ▶ 眼睛下移
  ▶ 底部阴影变大

帧 1: 起跳
  ▶ 拉伸（高度 18px，宽度 14px）
  ▶ 离地 4px
  ▶ 阴影缩小并变淡

帧 2: 飞行最高点
  ▶ 标准比例（高度 16px）
  ▶ 离地 8px
  ▶ 阴影最小最淡

帧 3: 着陆
  ▶ 微压扁（高度 14px，宽度 17px）
  ▶ 落回地面
  ▶ 阴影恢复
```

文件名：`slime_green_jump_0.png` ~ `slime_green_jump_3.png`

### 3. Hurt 受伤（2 帧 × 8fps）

**目的**：被击中瞬间反馈。

```
帧 0: 全身变白闪烁
  ▶ 整个身体替换为 #FFFFFF
  ▶ 眼睛保持黑色
  ▶ 略微震颤

帧 1: 恢复颜色
  ▶ 标准颜色
  ▶ 眼睛 :( 难过表情（眉毛下垂）
```

文件名：`slime_green_hurt_0.png`, `slime_green_hurt_1.png`

### 4. Death 死亡（6 帧 × 8fps）

**目的**：被击杀后散开消散。

```
帧 0: 受致命一击
  ▶ 全身白色闪光
  ▶ 眼睛 X X 圈圈（死亡符号）

帧 1: 开始分解
  ▶ 身体边缘出现裂纹
  ▶ 颜色变浅
  ▶ 出现 4 个小液滴

帧 2: 半液化
  ▶ 形状不规则
  ▶ 8 个小液滴向外飞溅
  ▶ 主体缩小到 12×12

帧 3: 大爆裂
  ▶ 12 个粒子四散
  ▶ 主体只剩 8×8 残骸
  ▶ 颜色变成 50% 透明

帧 4: 几乎消失
  ▶ 残骸变 4×4
  ▶ 30% 透明
  ▶ 飞溅粒子扩散

帧 5: 完全消散
  ▶ 仅剩 1-2 个小液滴在地上
  ▶ 渐隐
```

文件名：`slime_green_death_0.png` ~ `slime_green_death_5.png`

### 5. Spawn 出场（4 帧 × 12fps）— 可选

**目的**：从地面"啵"出现的彩蛋动画。

```
帧 0: 地面隆起
  ▶ 出现绿色小土堆（8×4 px）

帧 1: 突破地面
  ▶ 半个身体冒出（12×8 px）
  ▶ 周围土块飞溅

帧 2: 完全跃出
  ▶ 完整身体（16×16 px）
  ▶ 着陆姿势（压扁）

帧 3: 站定
  ▶ 标准 idle 帧 0
```

文件名：`slime_green_spawn_0.png` ~ `slime_green_spawn_3.png`

## AI 生成 Prompts

### Master Prompt（Midjourney 推荐）

```
Pixel art classic green slime monster, 16x16 pixels, 
round chunky bouncy gelatinous body, glossy round shape, 
two simple round black dot eyes positioned on upper body, 
small white highlight on top-left showing 3D form, 
darker green shadow on bottom, sitting on ground with subtle oval shadow,
cute friendly cheerful expression, classic RPG monster aesthetic,
limited 6-color palette: #66BB6A bright green main, #A5D6A7 light green highlight,
#2E7D32 dark green shadow, #000000 black eyes, #FFFFFF white sparkle,
transparent background, no anti-aliasing, sharp pixel edges,
inspired by Dragon Quest slime and Pokemon Ditto,
clean minimalist design, retro 16-bit game sprite,
--niji 6 --ar 1:1 --quality 2 --stylize 50
```

### Animation Frame Prompt（生成动画帧）

```
Same green slime monster as before, but in [SQUASH/STRETCH/JUMP] pose:
- frame 1: idle compressed 14 pixels tall
- frame 2: idle stretched 18 pixels tall  
- frame 3: jumping airborne with shadow below
- frame 4: landing impact squashed
maintain identical color palette and proportions,
sprite sheet format 4 frames horizontal,
transparent background, pixel-perfect, --niji 6 --ar 4:1
```

### Death Animation Prompt

```
Pixel art green slime death animation sequence, 6 frames horizontal,
frame 1: white flash on impact, frame 2: cracking apart,
frame 3: mid-explosion with droplets, frame 4: scattered fragments,
frame 5: dissolving into particles, frame 6: only puddle remains,
maintain green color palette throughout, transparent background,
16-bit pixel art, sprite sheet layout, --niji 6 --ar 6:1
```

### Stable Diffusion 备用

```
Positive: pixel art, 16x16, green slime monster, simple round body, 
two black dot eyes, bouncy gelatinous, retro game enemy, transparent bg

Negative: 3D render, photorealistic, blurry, smooth, anti-aliased,
gradient, watercolor, oil painting, low quality, watermark,
multiple subjects, text, signature

Sampler: DPM++ 2M Karras
Steps: 30
CFG: 7.5
Width: 256, Height: 256
```

## 特效（VFX）

### 跳跃尘土（jump dust）
```
小棕色 / 白色粒子从底部飞溅
3-4 个小方块 (1-2 px)
持续 0.2 秒
```

### 死亡液滴（death droplets）
```
8-12 个绿色小方块 (1-2 px)
向外辐射飞散
带重力下落
持续 0.5 秒
```

### 着陆冲击（landing impact）
```
地面波纹（半透明绿色环）
扩散后消失
持续 0.3 秒
```

## 音效需求

| 事件 | 文件名 | 描述 |
|------|--------|------|
| 移动 | `slime_green_jump.wav` | "啵啵" 弹跳声（短 100ms）|
| 受击 | `slime_green_hit.wav` | "啪嗒" 软软被打中（80ms）|
| 死亡 | `slime_green_death.wav` | "啵嗤" 散开声（200ms）|

## 参考与灵感

- **Dragon Quest** 系列的 slime（最经典）
- **Stardew Valley** 的 slime
- **Terraria** 的 Green Slime
- **Slime Rancher** 的 Pink Slime（虽然是 3D）

## 美术清单

发布前必须完成：

- [ ] idle 4 帧
- [ ] jump 4 帧
- [ ] hurt 2 帧
- [ ] death 6 帧
- [ ] (可选) spawn 4 帧
- [ ] sprite sheet 整合
- [ ] 死亡粒子精灵
- [ ] 跳跃尘土精灵

总计：**16-20 帧**

## 注意事项

⚠️ **关键设计点**：
- Green Slime 是玩家见到的第一个敌人，**必须可爱**
- 第一印象决定整个游戏感觉
- 过于恐怖反派化会让风格不统一
- 保持"它是反派但你不忍心"的违和萌感
