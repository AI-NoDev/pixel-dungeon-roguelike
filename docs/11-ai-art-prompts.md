# 11 — AI 美术生成 Prompts

完整的 AI 图像生成 prompt 集合，可直接喂给：
- **Midjourney**（推荐，质量最高）
- **DALL-E 3**（OpenAI / ChatGPT）
- **Stable Diffusion + PixelLab**（专业像素）
- **Leonardo.ai**（性价比高）

## 全局风格基调（每个 prompt 都加）

```
modern pixel art, 16-bit retro game style, clean limited palette, 
no anti-aliasing, sharp pixels, transparent background, 
inspired by Hyper Light Drifter and Eastward, 
high contrast lighting, single object centered
```

**Midjourney 通用参数**：
```
--style raw --niji 6 --ar 1:1 --quality 2 --stylize 100
```

**Stable Diffusion 通用参数**：
```
Negative: photorealistic, 3D render, blurry, smooth, anti-aliased, 
gradient, watercolor, oil painting, low quality, watermark
Sampler: DPM++ 2M Karras, Steps: 30, CFG: 7
```

---

## 1. App Icon（1024×1024）

```
A heroic pixel art knight character standing in front of a 
glowing dungeon entrance, wearing blue armor and holding a 
golden sword, surrounded by magical sparks, dark gothic background 
with mysterious purple light. App icon design, centered composition, 
bold silhouette, vibrant colors, 16-bit pixel art style, 
clean rounded edges suitable for iOS icon, glowing border effect.
```

**变体（备选）**：
```
A pixel art treasure chest opening with golden light bursting out, 
revealing a magical sword, dungeon stones around, blue purple 
mystical glow, app icon design, square 1:1 aspect ratio
```

---

## 2. Splash Screen / Loading Screen（横屏 1920×1080）

```
A wide cinematic pixel art scene of a heroic warrior approaching 
a massive ancient dungeon entrance, glowing torches on the walls, 
mysterious blue-purple mist rising from the ground, distant 
silhouettes of monsters in the dark, 16-bit pixel art style, 
dramatic lighting, deep atmospheric mood, landscape orientation, 
loading screen composition with center focus
```

---

## 3. 英雄 Sprites（每个 16×16，多帧动画）

### Knight（骑士）

```
Pixel art knight character sprite sheet, 16x16 pixels, 
4-direction walking animation (4 frames each direction = 16 sprites), 
front view facing camera, blue plate armor with silver trim, 
shoulder pauldrons, holding longsword and shield, 
calm heroic expression, transparent background, 
clean pixel edges, no anti-aliasing, 
soulslike RPG character, color palette: 
#4FC3F7 armor, #FFD54F gold trim, #2D2D44 outline
```

### Ranger（游侠）

```
Pixel art ranger character sprite, 16x16 pixels, 
hooded green cloak, leather armor, holding bow, 
agile pose, female or androgynous figure, 
forest scout aesthetic, walking animation 4 frames per direction, 
transparent background, modern pixel art style,
color palette: #66BB6A green, #5D4037 leather brown, #2E3B2E shadow
```

### Mage（法师）

```
Pixel art mage character sprite, 16x16 pixels, 
purple wizard robe with star patterns, pointed hat, 
holding glowing magic staff, mystical aura, 
walking animation 4 frames per direction, 
transparent background, fantasy RPG character,
color palette: #CE93D8 robe, #E040FB magic glow, #4A148C dark trim
```

### Rogue（盗贼）

```
Pixel art rogue assassin character sprite, 16x16 pixels, 
dark hooded cloak, twin daggers, agile crouching pose, 
yellow glowing eyes, sneaky stealthy aesthetic, 
walking animation 4 frames per direction, 
transparent background,
color palette: #FFB74D yellow accent, #4E342E dark cloak, #1A1A2E shadow
```

---

## 4. 普通敌人 Sprites（16×16）

### Slime（史莱姆）

```
Pixel art green slime monster, 16x16 pixels, 
gelatinous body bouncing animation 4 frames, 
two black dot eyes, friendly menacing, 
classic dungeon monster, transparent background,
color: #66BB6A bright green with #2E7D32 darker base
```

### Skeleton（骷髅）

```
Pixel art skeleton archer enemy, 16x16 pixels, 
white bones, holding shortbow, hollow eye sockets, 
slow shuffling walk animation 4 frames, 
classic undead dungeon monster, transparent background,
color: #BDBDBD bone white, #424242 shadow
```

### Goblin（哥布林）

```
Pixel art goblin warrior, 16x16 pixels, 
green skin, ragged loincloth, small dagger, 
fast aggressive sprint animation, 
pointed ears, mischievous expression, transparent background,
color: #FF8A65 orange skin (variant: green), #4E342E dark accents
```

### Golem（石像鬼）

```
Pixel art stone golem, 16x16 pixels, 
heavy slow tank monster, brown rocky body, 
glowing red core eyes, stomping walk animation, 
ancient dungeon guardian, transparent background,
color: #8D6E63 stone brown, #BF360C glowing red core
```

### Mage Enemy（敌方法师）

```
Pixel art evil mage enemy, 16x16 pixels, 
dark purple robes, hood obscuring face, 
holding twisted staff with purple flame, 
hovering walking animation, sinister aesthetic, transparent background,
color: #CE93D8 purple, #6A1B9A dark trim
```

### Bomber（炸弹人）

```
Pixel art kamikaze bomb enemy, 16x16 pixels, 
round body wrapped in TNT explosives, fuse on top, 
red glowing eyes, fast running animation, 
crazy menacing expression, transparent background,
color: #FF5722 red orange, #4E342E dark wraps
```

---

## 5. Boss Sprites（32×32 或 48×48）

### Skeleton King（骷髅王）— Floor 5

```
Pixel art skeleton king boss, 48x48 pixels, 
massive bone king with crown of skulls, holding two-handed greatsword, 
red glowing eye sockets, tattered royal cape, 
intimidating throne pose, dark dungeon boss, transparent background,
color: #E0E0E0 bone, #FFD700 gold crown, #8B0000 cape
```

### Crystal Golem（水晶巨像）— Floor 10

```
Pixel art crystal golem boss, 56x56 pixels, 
massive stone monster covered in glowing cyan crystals, 
heavy fists, deep eye glow, mountain-like silhouette, 
ancient mineral guardian, transparent background,
color: #80DEEA crystal cyan, #4A5D4A stone, #00838F deep glow
```

### Warden Knight（守望骑士）— Floor 15

```
Pixel art warden knight boss, 52x52 pixels, 
golden armor warrior with massive shield, 
crested helmet, holding flaming sword, 
heroic-yet-corrupted pose, fortress guardian, transparent background,
color: #FFB74D gold, #FF6E40 fire, #5D4037 shadow
```

### Inferno Lord（炼狱领主）— Floor 20

```
Pixel art inferno demon lord boss, 56x56 pixels, 
hulking demonic figure wreathed in flames, 
horns, clawed hands, fire breath, 
hellish nightmare creature, glowing magma cracks on skin, transparent background,
color: #FF5722 inferno red, #BF360C lava, #1B0000 dark
```

### Void Reaper（虚空收割者）— Floor 25

```
Pixel art void reaper boss, 60x60 pixels, 
ethereal grim reaper with cosmic purple energy, 
holding scythe made of dark matter, hooded ghostly form, 
floating star particles around, ultimate boss, transparent background,
color: #E040FB cosmic purple, #7C4DFF void, #0D0D1A black
```

---

## 6. 武器图标（24×24 或 32×32）

### 通用 prompt 模板

```
Pixel art [WEAPON_TYPE] icon, 24x24 pixels, 
clean isolated weapon sprite, 3/4 view angle, 
[ELEMENT_COLOR] elemental glow effect, 
[RARITY_BORDER] colored border outline, 
inventory icon style, transparent background, 
no character, single weapon focus
```

### 具体武器示例

**Iron Pistol（手枪）**
```
Pixel art iron revolver pistol icon, 24x24, gray metal finish, 
brown wooden grip, no glow, common rarity, transparent background
```

**Flame Pistol（火焰手枪）**
```
Pixel art revolver pistol icon, 24x24, dark metal frame, 
flame engraving on barrel, orange-red glow effect, 
uncommon green border tint, transparent background
```

**Frost Revolver（冰霜左轮）**
```
Pixel art revolver icon, 24x24, silver and ice-blue metal, 
frost crystals on barrel, cyan glow effect, 
rare blue border tint, transparent background
```

**Rusty Shotgun（霰弹枪）**
```
Pixel art double-barrel shotgun icon, 24x24, brown wooden stock, 
rusted metal barrels, weathered look, common gray, transparent background
```

**Thunder Scatter（雷电散弹）**
```
Pixel art shotgun icon, 24x24, electric yellow accents, 
lightning runes on barrel, sparking effect, 
rare blue border, transparent background
```

**Dragon Breath（龙息霰弹）**
```
Pixel art ornate shotgun icon, 24x24, dragon engraving, 
red and gold metal, fire breath effect from barrel, 
epic purple border, transparent background
```

**Hunter Rifle（猎人步枪）**
```
Pixel art bolt-action rifle icon, 24x24, polished wood stock, 
steel barrel, scope, hunting aesthetic, common, transparent background
```

**Poison Rifle（毒液步枪）**
```
Pixel art rifle icon, 24x24, dark metal with green tubes, 
poison vial reservoir, sickly green glow, 
uncommon green border, transparent background
```

**Rapid Blaster（连射冲锋枪）**
```
Pixel art SMG submachine gun icon, 24x24, modern military grey, 
short stock, drum magazine, common, transparent background
```

**Lightning SMG（闪电冲锋枪）**
```
Pixel art SMG icon, 24x24, sleek purple metal, 
electric coils visible, sparking effect, 
rare blue border, transparent background
```

**Void Sprayer（虚空喷射器）**
```
Pixel art alien SMG icon, 24x24, dark purple organic design, 
green void energy core, sinister look, 
epic purple border, transparent background
```

**Long Bow（长弓）**
```
Pixel art elegant longbow icon, 24x24, polished dark wood, 
bowstring drawn, arrow nocked, 
uncommon green border, transparent background
```

**Ice Piercer（冰刺穿弓）**
```
Pixel art ornate ice bow icon, 24x24, frosted blue wood, 
ice arrow nocked, snowflake decorations, 
epic purple border, transparent background
```

**Arcane Staff（奥术法杖）**
```
Pixel art wizard staff icon, 24x24, dark wood with glowing 
purple crystal on top, mystical runes, 
uncommon green border, transparent background
```

**Inferno Wand（炼狱之杖）**
```
Pixel art fire wand icon, 24x24, red metal, 
flame crystal core, dragon-shaped tip, 
rare blue border, transparent background
```

**Staff of Eternity（永恒之杖）**
```
Pixel art legendary staff icon, 24x24, golden ornate design, 
multicolor gem (purple/gold/cyan), divine glow halo, 
legendary gold border, transparent background, premium look
```

---

## 7. 道具图标（12×12 或 16×16）

```
Pixel art health potion icon, 16x16, red glass bottle, 
heart symbol on label, glowing red liquid, transparent background
```

```
Pixel art big health potion, 16x16, larger red potion bottle, 
plus sign label, brighter glow, transparent background
```

```
Pixel art shield orb item, 16x16, blue floating sphere, 
shield rune inside, magical aura, transparent background
```

```
Pixel art speed boots item, 16x16, leather boots with wings, 
cyan motion lines, transparent background
```

```
Pixel art power crystal item, 16x16, orange jagged crystal, 
energy emanating, fire aura, transparent background
```

```
Pixel art gold coin, 16x16, classic round gold coin, 
crown stamp, slight 3D depth, transparent background
```

```
Pixel art gold pile, 16x16, stack of coins overflowing, 
gleaming bright gold, transparent background
```

---

## 8. 房间 Tilesets（每 tile 16×16）

### Crypt 主题（古墓 F1-F5）

```
Pixel art dungeon crypt tileset, 16x16 tiles, 
dark stone floor tiles (multiple variants for visual variety), 
moss-covered ancient bricks, gothic wall tiles, 
torch sconces, cracked floor variations, skull decorations, 
muted purple and gray palette, atmospheric horror aesthetic,
spritesheet layout 8x4 tiles
```

### Cave 主题（洞穴 F6-F10）

```
Pixel art crystal cave tileset, 16x16 tiles, 
natural rocky ground tiles, moss patches, 
glowing teal crystal walls, stalactites, water puddle variations, 
underground green-cyan palette, mystical aesthetic,
spritesheet layout 8x4 tiles
```

### Fortress 主题（堡垒 F11-F15）

```
Pixel art iron fortress tileset, 16x16 tiles, 
metal-plated floor tiles, polished stone walls, 
brass torches, banner decorations, military barracks aesthetic, 
gold-accented blue-grey palette, structured man-made design,
spritesheet layout 8x4 tiles
```

### Inferno 主题（炼狱 F16-F20）

```
Pixel art hellish inferno tileset, 16x16 tiles, 
cracked obsidian floor with magma cracks, 
basalt walls with glowing red veins, lava puddle variations, 
hell aesthetic, dark red and orange palette, 
sinister atmosphere, spritesheet layout 8x4 tiles
```

### Void 主题（虚空 F21+）

```
Pixel art cosmic void tileset, 16x16 tiles, 
floating fragmented platforms, deep purple starfields, 
ethereal energy patterns, glitched dimensional walls, 
purple-magenta-cyan palette, otherworldly cosmic aesthetic, 
spritesheet layout 8x4 tiles
```

---

## 9. UI 元素

### Joystick（摇杆）

```
Pixel art virtual joystick UI element, 130x130 pixels, 
circular base with subtle radial pattern, knob in center, 
semi-transparent overlay design, suitable for mobile game HUD, 
modern flat pixel style, transparent background
```

### Health Bar（血条）

```
Pixel art health bar UI, 140x18 pixels, 
clean rectangular gauge, red-to-green gradient, 
border with corner pixel details, 
top-down view game HUD style, transparent background
```

### Buttons（按钮）

```
Pixel art game UI button, "START" text, 200x60 pixels, 
beveled 3D pixel effect, golden frame, 
glowing edges, fantasy RPG style, transparent background
```

### Damage Number Effect（伤害数字）

```
Pixel art floating damage number "20", red color, 
chunky bold pixel font, motion blur trail, 
transparent background, 32x16 pixels
```

---

## 10. 元素特效

### Fire Effect（火焰）

```
Pixel art fire impact effect spritesheet, 32x32 pixels per frame, 
6-frame animation of flame burst, orange-yellow-red flames, 
radial expansion, transparent background, no character, 
just the visual effect
```

### Ice Effect（冰冻）

```
Pixel art frost impact effect spritesheet, 32x32 pixels per frame, 
6-frame animation of ice shards forming and shattering, 
cyan-white crystals, radial freeze pattern, transparent background
```

### Lightning Effect（闪电）

```
Pixel art lightning strike effect spritesheet, 32x32 pixels per frame, 
4-frame animation of branching lightning bolt, 
bright yellow with white core, electric spark particles, 
transparent background
```

### Poison Effect（毒云）

```
Pixel art poison cloud effect spritesheet, 32x32 pixels per frame, 
6-frame animation of toxic green cloud expanding, 
sickly green smoke with bubble particles, transparent background
```

### Death Explosion（死亡爆炸）

```
Pixel art explosion effect spritesheet, 32x32 pixels per frame, 
8-frame animation of dramatic explosion, 
yellow-orange-red expanding fireball with smoke, transparent background
```

---

## 11. App Store 营销图

### Hero Banner（特色图）

```
Cinematic pixel art game cover art, "Pixel Dungeon Survivors" title, 
4 hero characters (knight, ranger, mage, rogue) in dramatic 
hero pose, dungeon background with monsters silhouettes, 
glowing weapons, dynamic action composition, 
1920x1080 landscape orientation, vibrant colors, 
modern indie game cover aesthetic
```

### Screenshot Frame（截图模板）

```
Promotional pixel art game screenshot frame, showing gameplay 
with HUD elements clearly visible: dual joysticks, health bar, 
mini-map, gold counter. Player character in center fighting 
3 enemies. Mid-action explosion. Modern indie game promotional shot, 
1242x2688 portrait or landscape variants
```

### Feature Graphic（Google Play 1024×500）

```
Wide promotional banner for pixel art roguelike game, 
"Pixel Dungeon Survivors" centered title with epic glowing 
treatment, knight character on left, dungeon entrance on right, 
monsters lurking in shadow, magical weapons floating around, 
1024x500 banner format, eye-catching colors, 
mobile game store featured artwork style
```

---

## 12. 高效工作流

### 推荐工具组合

#### 方案 A：Midjourney（最简单）
```
1. 在 Discord 用 /imagine 输入 prompt
2. --niji 6 --ar 1:1 参数获得像素感
3. 选择满意的图，保存到 assets/images/
4. 用 Aseprite 微调（可选）
```

#### 方案 B：Stable Diffusion + Pixel Lab
```
1. 用 SD 生成基础图（Realistic / 2D 风格）
2. 用 PixelLab.ai 转换为像素风
3. 用 Aseprite 调整 palette 和清理
```

#### 方案 C：DALL-E 3（适合快速原型）
```
1. ChatGPT Plus 内调用 DALL-E
2. 直接给 prompt
3. 后处理用 Photoshop 减色
```

### 后处理 Pipeline

```
AI 生成 (256x256+) 
  ↓
等比缩放到目标尺寸
  ↓
Aseprite 减色到 6-8 色
  ↓
手工清理边缘像素
  ↓
导出 PNG（透明背景）
  ↓
合并成 sprite sheet（用 TexturePacker / Aseprite）
```

### 推荐工具下载

- [Aseprite](https://www.aseprite.org/)（$20，像素画神器）
- [PixelLab.ai](https://www.pixellab.ai/)（订阅制，AI 像素生成）
- [TexturePacker](https://www.codeandweb.com/texturepacker)（免费版够用）

## 13. 验收标准

每个素材必须满足：

- ✅ 透明背景
- ✅ 无锯齿（pixel-perfect 边缘）
- ✅ 调色板 ≤ 8 色
- ✅ 尺寸符合规范（见 docs/07）
- ✅ 命名规范（见 docs/07）
- ✅ License 明确（CC0 / MIT / 购买证明）

## 14. 批量生成清单

按优先级生成（节约 AI 额度）：

### Day 1（必需）
- [ ] App Icon
- [ ] 4 英雄 idle sprite（每英雄 1 帧测试）

### Day 2-3
- [ ] 4 英雄 walking 动画（4 方向 × 4 帧 = 16 帧/英雄）
- [ ] 6 敌人 sprite

### Day 4-5
- [ ] 5 Boss sprite
- [ ] 16 武器图标
- [ ] 6 道具图标

### Day 6-7
- [ ] 5 主题 tilesets
- [ ] UI 元素
- [ ] 元素特效

### Day 8
- [ ] App Store 营销图
- [ ] Splash screen
- [ ] 整理验收

预计 1 周完成全部素材，AI 生成成本 $20-50（Midjourney $30/月）。
