# 07 — 美术与音频规范

## 美术规范

### 整体风格

- **风格**：现代简约像素（Modern Pixel Art）
- **参考**：Hyper Light Drifter / Eastward / Stardew Valley
- **不参考**：极致 8-bit 复古风（太硬核）

### 像素规格

| 元素 | 像素尺寸 | 显示尺寸 |
|------|---------|---------|
| 玩家 | 16×16 | 32×32（2x scale） |
| 普通敌人 | 16×16 | 24×24 |
| Boss | 32×32 | 48-60×48-60 |
| 子弹 | 4×4 | 8×8 |
| 武器图标 | 24×24 | 48×48 |
| 房间 tile | 16×16 | 40×40 |
| 道具 | 12×12 | 16×16 |

### 动画规范

- 玩家行走：4 帧 @ 12 fps
- 敌人行走：4 帧 @ 8 fps
- Boss 攻击：6-8 帧
- 死亡特效：6 帧 @ 12 fps
- 子弹：静态或 2 帧旋转

### 配色规范

每个主题严格限制 6-8 色调：

#### Ancient Crypt（墓穴）
```
#1a1a2e  深紫黑（背景）
#2D2D44  墓穴地板
#4A4A6A  石墙
#6A6A8A  墙面装饰
#5C5C7A  障碍物
#8B4513  门
```

#### Crystal Cave（洞穴）
```
#1B2B1B  深绿黑
#2E3B2E  洞穴地板
#4A5D4A  石壁
#80CBC4  水晶高光
#3E5C3E  岩石
#6D4C41  门
```

（其他主题见 `lib/data/dungeon_theme.dart`）

### 命名规范

```
assets/images/
├── heroes/
│   ├── knight_idle_0.png
│   ├── knight_idle_1.png
│   ├── knight_walk_0.png
│   └── ...
├── enemies/
│   ├── slime_walk_0.png
│   └── ...
├── bosses/
│   ├── skeleton_king_idle_0.png
│   └── ...
├── weapons/
│   ├── pistol_iron.png
│   └── ...
├── items/
│   └── potion_health.png
├── tiles/
│   ├── crypt_floor.png
│   ├── crypt_wall.png
│   └── ...
└── ui/
    ├── icon_skill.png
    └── ...
```

### 资源采集策略

#### 选项 A：Asset Pack（推荐 MVP）
- 使用 itch.io / OpenGameArt 上的免费/廉价像素包
- 推荐：[0x72 16×16 Pixel Pack](https://0x72.itch.io/16x16-dungeon-tileset)（约 $5）
- 优点：快速、风格统一
- 缺点：可能与其他游戏撞素材

#### 选项 B：AI 生成 + 修改
- 使用 PixelLab.ai / Sprite-Diffusion 等工具
- 然后用 Aseprite 微调
- 优点：完全原创，独特
- 缺点：耗时

#### 选项 C：找像素画师
- Fiverr / Gamedev.net 招独立画师
- 单价 $50-200/角色
- MVP 预算：$300-500

**MVP 阶段建议：选项 A + B 组合**

### App Icon 设计

- 尺寸：1024×1024
- 风格：突出"地牢 + 像素 + 战士"
- 不要：纯 logo / 文字
- 必须：能在小尺寸（60×60）下识别
- 工具：[App Icon Generator](https://appicon.co)

### 启动屏

- 简洁：纯背景 + 居中 logo
- 时长：≤ 2s
- 与加载页风格一致

## 音频规范

### BGM 规范

- **格式**：OGG（首选）/ MP3
- **比特率**：128kbps（节省体积）
- **时长**：1.5-3 分钟（loop）
- **响度**：-14 LUFS
- **采样率**：44.1 kHz

### SFX 规范

- **格式**：WAV（短音）/ OGG
- **比特率**：96-128kbps
- **时长**：< 1 秒
- **响度**：比 BGM 高 6 dB

### 风格指南

#### BGM
- 主菜单：神秘、期待感
- 墓穴：低沉、阴森
- 洞穴：清亮、空灵
- 堡垒：紧张、节奏感
- 炼狱：激烈、咆哮
- 虚空：诡异、迷幻
- Boss：高强度战斗鼓点

#### SFX
- 射击：清脆、有力
- 受击：低沉、闷响
- 拾取：清亮"叮"
- 升级：闪亮上升音
- 死亡：下沉、空灵

### 音频采集策略

#### 选项 A：Royalty-Free 资源库
- [Freesound.org](https://freesound.org)（免费 SFX）
- [Pixabay Music](https://pixabay.com/music/)（免费 BGM）
- 优点：完全免费
- 缺点：质量参差、需筛选

#### 选项 B：付费授权包
- [Asset Store - Pixel Game Audio](https://assetstore.unity.com)
- $30-50 整套
- 推荐：8-bit / chiptune 风格包

#### 选项 C：自己制作
- 工具：BFXR / sfxr（程序化音效）
- 工具：BoscaCeoil / LMMS（自制 BGM）

**MVP 阶段建议：选项 B 整套购买，可后续自定义**

### 资源文件结构

```
assets/audio/
├── bgm/
│   ├── menu.ogg
│   ├── crypt.ogg
│   ├── cave.ogg
│   ├── fortress.ogg
│   ├── inferno.ogg
│   ├── void.ogg
│   ├── boss.ogg
│   └── game_over.ogg
└── sfx/
    ├── shoot_pistol.wav
    ├── shoot_shotgun.wav
    ├── shoot_rifle.wav
    ├── shoot_smg.wav
    ├── shoot_magic.wav
    ├── hit_player.wav
    ├── hit_enemy.wav
    ├── death_player.wav
    ├── death_enemy.wav
    ├── pickup_coin.wav
    ├── pickup_potion.wav
    ├── pickup_weapon.wav
    ├── level_up.wav
    ├── door_open.wav
    ├── boss_appear.wav
    ├── element_vaporize.wav
    ├── element_overload.wav
    ├── element_freeze.wav
    ├── element_toxic.wav
    ├── element_corrode.wav
    ├── element_chain.wav
    ├── ui_click.wav
    └── ui_back.wav
```

### 加载策略

```dart
// 启动时预加载常用 SFX
await FlameAudio.audioCache.loadAll([
  'sfx/shoot_pistol.wav',
  'sfx/hit_enemy.wav',
  'sfx/death_enemy.wav',
  'sfx/pickup_coin.wav',
  // ...
]);

// BGM 按需加载
FlameAudio.bgm.play('bgm/crypt.ogg', volume: 0.4);
```

## 资源体积预算

| 资源 | 目标 | 单文件上限 |
|------|------|-----------|
| 图片资源总和 | < 8 MB | 100 KB / 张 |
| 音频资源总和 | < 12 MB | BGM 2MB / SFX 50KB |
| 字体（如需） | < 200 KB | - |
| **总应用大小** | **< 50 MB** | - |

## 版权与署名

- 所有外部资源必须确认 license
- 在 Settings 页面或 README 列出 credits
- 商用 license 必须保留发票/购买记录

### 推荐 license
- **CC0**：完全自由
- **CC-BY**：需署名
- **MIT**：开源
- **Royalty-Free**：商用授权

### 避免
- **CC-NC**：禁止商用
- **不明 license**：法律风险
