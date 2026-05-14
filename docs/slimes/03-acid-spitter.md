# Acid Spitter（酸液吐手）

> 嘴角不停滴酸液的黄色史莱姆。会站定吐酸球，留下毒池。

## 基本信息

| 字段 | 值 |
|------|-----|
| ID | `acid_spitter` |
| 出现楼层 | F2-F5 |
| 等级 | 普通（远程）|
| 元素 | 毒 |
| 体型 | 16×16 |

## 数值

```yaml
HP: 20
速度: 30 px/s（慢）
接触伤害: 5
远程伤害: 12（吐酸球）
吐酸间隔: 1.5 秒
酸池伤害: 5/s 持续 3 秒
```

## 形象设计

**黄色身体表面坑坑洼洼**（化学侵蚀感），嘴巴大张，下巴持续滴酸液。眼睛斜视贼贼的（`>:|`），鼻孔冒绿气泡。

### 视觉特征
- 身体是黄色（#FFEE58），但有不规则绿色酸斑（#76FF03）
- 嘴部位置（下方）持续小气泡和液滴
- 周围地面有微淡的酸蚀痕迹
- 攻击时鼓起 → 吐出 → 缩回

## 调色板

| 用途 | Hex |
|------|-----|
| 主体 | `#FFEE58` 鲜黄 |
| 酸斑 | `#76FF03` 荧光绿 |
| 阴影 | `#F57F17` 深黄棕 |
| 高光 | `#FFFF8D` 浅黄 |
| 酸液 | `#69F0AE` 透明绿 |
| 眼睛 | `#1A1A2E` |

## 动画要点

### Idle (4 帧)
- 帧 0: 标准
- 帧 1: 嘴部冒泡（小气泡向上）
- 帧 2: 标准
- 帧 3: 滴一滴酸（嘴下方）

### Move (4 帧)
普通史莱姆跳跃，但更慢更短。

### Attack 吐酸（4 帧 × 12fps）
**这是它的招牌动作：**
- 帧 0: 蓄力（身体后仰，嘴部充能绿光）
- 帧 1: 嘴张大（绿光膨胀）
- 帧 2: 喷射（绿色酸液弹射出）
- 帧 3: 缩回（嘴小，余韵气泡）

### Death (6 帧)
死亡时**整个身体融化为酸池**：
- 帧 0: 白闪 + 痛苦表情
- 帧 1: 身体开始融化（顶部塌陷）
- 帧 2: 半身化为黄绿液体
- 帧 3: 几乎全融
- 帧 4: 形成酸池（圆形毒池）
- 帧 5: 酸池冒泡持续中

**特殊**：死亡后地上残留 5 秒酸池，玩家踩入受 5/s 伤害。

## AI Prompt

```
Pixel art toxic acid yellow slime monster, 16x16 pixels,
bright yellow gelatinous body with sickly green chemical spots,
mouth wide open showing dripping green corrosive saliva,
sneaky narrowed evil eyes >:),
chemical bubbles rising from body, hazardous radioactive aesthetic,
6-color palette: #FFEE58 bright yellow, #76FF03 toxic green spots,
#F57F17 dark yellow shadow, #69F0AE acid drips, #FFFF8D highlights,
#1A1A2E dark eyes, transparent background, no anti-aliasing,
retro 16-bit game sprite, biohazard aesthetic,
--niji 6 --ar 1:1 --quality 2
```

### Acid Ball Projectile

```
Pixel art glowing green acid ball projectile, 8x8 pixels,
toxic green bubbling sphere with dripping trail,
animated 4-frame rotation, transparent background,
limited palette: #76FF03 main, #B9F6CA highlight, #1B5E20 shadow,
retro pixel art, --ar 4:1 --niji 6
```

### Acid Puddle

```
Pixel art toxic acid puddle on ground, 24x12 pixels,
irregular bubbling green liquid pool, animated 4-frame bubbles,
transparent background, top-down view,
green palette #76FF03 with darker shadows, retro pixel
```

## 特效

- **充能光晕**：吐酸前嘴部 0.3s 绿色光圈
- **酸球轨迹**：飞行时下方滴 2-3 滴小绿点
- **毒池冒泡**：3-4 个气泡循环冒出
- **死亡飞溅**：8 个绿色酸滴向外飞

## 音效

| 事件 | 描述 |
|------|------|
| 充能 | "咕噜咕噜" 化学反应声 |
| 吐酸 | "噗！" 喷射声 |
| 酸球落地 | "嘶嘶嘶" 腐蚀声 |
| 受击 | 痛苦"嘶哈" |
| 死亡 | "咕..." 融化声 + 持续冒泡 |
| 酸池 | 持续轻微"咕嘟"循环 |
