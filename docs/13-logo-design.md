# 13 — Logo 设计

## 设计概念

**主题：史莱姆被子弹击中的瞬间应激反应**

这是游戏的"记忆点画面" — 玩家对游戏的第一印象就是 "POP! 子弹打中软软的史莱姆，它惊讶地变形"。

### 情感设计

- **可爱** — 蠢萌，让人想戳
- **冲击** — "啵"的瞬间反应
- **幽默** — 反派也是萌物
- **像素风** — 与游戏风格统一

## 核心视觉元素

### 主体：应激史莱姆

```
基础：圆滚滚绿色史莱姆
状态：被击中瞬间
表情：
  - 眼睛 ☉_☉ 瞪大（震惊）
  - 嘴 :O 张开（惊呼）
  - 身体被压扁变形（被弹射）
颜色：
  - 主色：#66BB6A（明亮草绿）
  - 高光：#A5D6A7（浅绿）
  - 阴影：#2E7D32（深绿）
  - 眼白：#FFFFFF
  - 瞳孔：#1A1A2E（深黑紫）
```

### 配饰：子弹孔 + 飞溅效果

```
子弹位置：史莱姆左上角
子弹效果：
  - 黄色弹丸 #FFD54F（已穿入或穿过）
  - 黏液飞溅小液滴 × 4-6 滴
  - 速度线条（白色 #FFFFFF）
冲击波：
  - 半透明白色环
  - 小星星 ✦ × 3-4 个
```

## Logo 变体

### 变体 1：App Icon（1024×1024 主版）

```
[Midjourney Prompt]

Pixel art app icon design, a cute green slime monster getting shot 
by a yellow bullet from upper-left, exaggerated shock expression with 
huge round eyes wide open and "O" shaped mouth, body squashed and 
deformed from impact, green gel droplets splattering in all directions, 
small white star sparkles around, dark gradient purple background 
(#1A1A2E to #4A148C), centered composition, bold silhouette readable 
at small size, 16-bit retro game style, vibrant saturated colors, 
clean pixel edges no anti-aliasing, iOS app icon proportions with 
rounded corners safe-zone, --ar 1:1 --niji 6 --quality 2
```

### 变体 2：游戏内 Loading Screen Logo

```
[Midjourney Prompt]

Pixel art game logo, "POP! SLIME" text in bold chunky pixel font 
above a cute shocked slime character getting hit by yellow bullet, 
exaggerated cartoon shock expression, body deformation, splatter 
effects, "POP!" word balloon with pixel sparks, retro arcade style, 
horizontal banner layout 1920x1080, dark dungeon background with 
subtle torch glow, --ar 16:9 --niji 6
```

### 变体 3：简化版本（小尺寸 32×32）

```
小尺寸版本只保留核心：
- 简化为单色头像（绿色史莱姆 + 黑色震惊眼）
- 去掉子弹和飞溅
- 适合通知图标 / Favicon
```

### 变体 4：动画版（启动页）

```
3 帧循环动画：
帧 1 (idle):     圆滚滚史莱姆，平静微笑 :)
帧 2 (impact):   被子弹击中瞬间，挤压变形 :O
帧 3 (recover):  恢复但带飞溅效果 :|
循环速度：2 秒/轮
```

## 颜色 Palette（严格 8 色）

```
#FFD54F  ← 子弹（金黄）
#A5D6A7  ← 史莱姆高光
#66BB6A  ← 史莱姆主体（绿）
#2E7D32  ← 史莱姆阴影
#FFFFFF  ← 眼白 / 飞溅高光
#1A1A2E  ← 背景 / 瞳孔
#4A148C  ← 背景渐变深色
#FF5722  ← "POP!" 字符强调色（可选）
```

## App Icon 安全区

iOS 圆角 mask 会裁掉 ~12% 边缘，重要内容必须在中心 76% 区域内：

```
1024×1024 总画布
├── 边缘 122px 内可能被裁
└── 中心 780×780 安全区放置史莱姆主体
```

## "POP!" 文字效果

如果在 logo 中加 "POP!" 文字：

- **字体**：粗体像素 Display 字体（建议自创或用 Press Start 2P）
- **颜色**：白色填充 + 红色描边 + 黑色阴影
- **位置**：右上方贴近子弹冲击点
- **效果**：略带歪斜、爆炸星形外框
- **大小**：占画布 25%

## 备选灵感图

### 经典游戏 Logo 参考
- **Angry Birds** — 蠢萌怒鸟特写
- **Cuphead** — 卡通+震惊表情
- **Ape Out** — 极简但冲击力强
- **Dead Cells** — 角色作为主视觉

## 多场景应用

| 场景 | 尺寸 | 元素 | 用途 |
|------|------|------|------|
| iOS App Icon | 1024×1024 | 史莱姆 + 子弹 + 渐变背景 | App Store |
| Android Icon | 512×512 | 同上 | Play Store |
| 圆形 / 自适应 | 432×432 | 简化版（中心 264 安全区）| Android Adaptive |
| Favicon | 32×32 | 极简史莱姆头 | 网页 |
| Social Media | 400×400 | 史莱姆 + 文字 | Twitter / Discord |
| 启动屏 | 1920×1080 | 完整带文字 logo | 启动 |
| 横幅 | 1024×500 | 史莱姆 + 文字 + 主角 | Google Play 特色图 |

## 设计验收

- [ ] 32×32 缩略图能识别
- [ ] 圆角裁切后不丢失关键元素
- [ ] 调色板 ≤ 8 色
- [ ] 透明背景 PNG 可用
- [ ] 黑底白底都好看
- [ ] 印象深刻（5 秒过目不忘）

## 不要做什么

- ❌ 太多细节（小尺寸看不清）
- ❌ 渐变阴影（破坏像素感）
- ❌ 写实绘画（与游戏风格冲突）
- ❌ 过度复杂的文字
- ❌ 借用其他知名游戏的视觉
