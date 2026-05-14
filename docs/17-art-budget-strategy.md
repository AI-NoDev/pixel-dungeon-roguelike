# 17 — 省钱美术策略（实战版）

> 你不需要 $100 的 Midjourney 订阅。这里有 5 种方案，从 $0 到 $30 都能搞定。

## TL;DR 推荐方案

**预算 $0-15** → 使用方案 A（程序化）+ 方案 C（Asset Pack）  
**预算 $20-30** → 加上 Pixellab.ai 月付，效率最高  
**预算 $50+** → 加 Midjourney，但只用于关键素材（Boss、Logo）

## 方案 A：纯程序化绘制（$0）⭐ 最推荐起步

不需要任何外部素材，**用 Flame 代码画出史莱姆**。已经在做的方向，直接沿用并优化。

### 优点
- 完全免费
- 改动方便（改颜色、形状、表情）
- 体积小（不增加 APK 大小）
- 性能好（GPU 加速）

### 缺点
- 看起来是色块（不是真像素画）
- 复杂动画难做

### 实施
我已经实现了 `SlimeBase` 类，可以扩展支持 23 种变体：
- 用代码画身体（圆角矩形 + 高光 + 阴影）
- 用 sin 函数实现弹跳
- 不同 slime 用不同颜色 + 装饰（皇冠用代码画）
- 死亡用粒子（已实现）

### 实际效果
对照参考：[Vampire Survivors](https://store.steampowered.com/app/1794680/) 早期版本就是色块，照样卖了百万份。

## 方案 B：免费 AI 工具（$0）

### 1. Pollinations.ai（完全免费）

**网址**：https://pollinations.ai/

**优点**：
- 完全免费，无限次
- API 直接调用
- 质量比 SD 略低但够用

**用法**：
```
直接访问：https://image.pollinations.ai/prompt/[YOUR_PROMPT]
不需要注册，直接给 URL
```

**示例**：
```
https://image.pollinations.ai/prompt/pixel%20art%20green%20slime%20monster%2016x16%20pixels
```

### 2. Leonardo.ai（每天免费 150 token）

**网址**：https://leonardo.ai/

**优点**：
- 每天 150 免费 token（约 30 张图）
- 有"Pixel Art" 风格预设
- 质量比 Pollinations 好

**用法**：
- 注册账号
- 选 "Pixel Art" model
- 一天能做 30 张
- 23 个史莱姆参考图 = 1 天搞定

### 3. Bing Image Creator（DALL-E 3 免费）

**网址**：https://www.bing.com/create

**优点**：
- 免费用 DALL-E 3
- 每天 15 张快速 + 无限慢速
- 质量很高

**缺点**：
- 像素风需要明确写 prompt
- 出图较大需要后处理

### 4. Tencent Hunyuan（国内可用）

**网址**：https://hunyuan.tencent.com/bot/chat

**优点**：
- 中国可直接访问
- 完全免费
- 支持中文 prompt

## 方案 C：买 Asset Pack（$5-30）⭐ 性价比之王

直接买现成的像素 sprite 包，几美元解决一切。

### 推荐资源（按性价比排序）

#### 1. itch.io 上的便宜 Pack

**[Sprout Lands](https://cupnooble.itch.io/sprout-lands-asset-pack)** — $0+（自定价）
- 包含可爱像素角色
- 风格清新

**[0x72 16×16 Dungeon Tileset](https://0x72.itch.io/16x16-dungeon-tileset)** — $0+
- 完整的地牢素材包
- 包含怪物、武器、UI

**[Pixel Slimes Asset Pack](https://akarmesher.itch.io/free-slime-character-asset-pack)** — $0
- **专门的史莱姆包！**
- 多种颜色和动画

**[Pixel Adventure 1](https://pixelfrog-assets.itch.io/pixel-adventure-1)** — Free
- 通用平台游戏包

#### 2. OpenGameArt.org（完全免费）

**网址**：https://opengameart.org/

搜索关键词：
- `slime sprite`
- `pixel rpg enemy`
- `2d dungeon character`

License 多为 CC0 / CC-BY，可商用。

#### 3. Kenney Game Assets（完全免费）

**网址**：https://kenney.nl/assets

- 免费 + 高质量
- CC0 license（完全自由）
- 已下载 1000+ 资源包
- 推荐 [Tiny Battle](https://kenney.nl/assets/tiny-battle) 风格

#### 4. Game Dev Market

**网址**：https://www.gamedevmarket.net/category/2d/

- 价格 $5-30
- 单包数百精灵

### 直接购买建议

**$15 预算搞定所有美术**：
```
1. 史莱姆包      — itch.io $5
2. 地牢 tileset  — 0x72 $5
3. 武器图标包    — itch.io $5
合计：$15，全部商业可用
```

## 方案 D：混合策略（$20）⭐ 我的实际推荐

**用 $20 高质量搞定整套美术**：

```
1. Pixellab.ai 订阅 1 个月          — $9
   → 把 AI 图转换成像素艺术
   → 23 只史莱姆，每只 1 张参考图

2. Leonardo.ai 每天 150 token       — $0
   → 生成参考图（输入到 Pixellab）

3. itch.io 史莱姆包                 — $5
   → 备选方案

4. Aseprite                         — $20（或免费用 LibreSprite）
   → 调整 AI 生成的图

可选：
5. Suno AI 1 个月                   — $10
   → 生成 BGM
```

**实际工作流**：
1. Leonardo.ai 生成参考图（"green slime sprite"）
2. Pixellab.ai 转换为像素风
3. Aseprite 整理 + 减色 + 做动画帧
4. 导出 PNG，丢到 assets/images/

每只史莱姆约 30-60 分钟。23 只 ≈ 12-23 小时。

## 方案 E：分阶段策略

### 阶段 1（第 1 周）— $0
**只做核心 5 只史莱姆**：
- Green Slime
- Pink Bouncer
- Acid Spitter
- Mega Goo
- Slime King（Boss）

剩下 18 只**用程序化绘制临时占位**。

### 阶段 2（首发后）— $20
游戏发布后有了收入，再用 $20 把剩余 18 只完善。

### 阶段 3（v1.1+）— 按需投入
玩家反馈喜欢哪只，就先升级哪只的美术。

## 实战工具链对比

| 工具 | 价格 | 像素风质量 | 速度 |
|------|------|-----------|------|
| **Midjourney** | $30/月 | ⭐⭐⭐⭐ | 慢 |
| **Leonardo.ai** | $0-12/月 | ⭐⭐⭐ | 中 |
| **Pollinations** | $0 | ⭐⭐ | 中 |
| **DALL-E (Bing)** | $0 | ⭐⭐⭐⭐ | 快 |
| **Pixellab.ai** | $9/月 | ⭐⭐⭐⭐⭐ | 快 |
| **Stable Diffusion 本地** | $0 | ⭐⭐⭐⭐ | 慢（需 GPU）|
| **Aseprite 手画** | $20 一次 | ⭐⭐⭐⭐⭐ | 极慢 |

## 最优选择决策树

```
你有空学习吗？
├─ 有大量时间 → Aseprite 自己画（$20 一次买断）
└─ 没时间
    ├─ 预算 $0    → 程序化代码 + Pollinations 免费 AI
    ├─ 预算 $5    → 买 itch.io Asset Pack
    ├─ 预算 $20   → Pixellab.ai + Leonardo（推荐）
    └─ 预算 $50+  → 加 Midjourney 做 Boss 和 Logo
```

## Pollinations.ai 实战脚本

我可以给你写个一键批量生成脚本，调用 Pollinations 免费 API：

```bash
# 创建文件 generate_slimes.sh
for i in {1..23}; do
  # 读取每个 slime 的 prompt
  PROMPT=$(grep -A 1 "Master Prompt" docs/slimes/0$i-*.md | tail -1)
  ENCODED=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$PROMPT'))")
  
  curl -o "assets/images/slime_$i.png" \
    "https://image.pollinations.ai/prompt/$ENCODED?width=512&height=512"
  
  echo "Generated $i"
done
```

## 我推荐的最终方案

**给你的实际建议（基于你说"额度不够"）：**

### 第一步（今天就做）：$0
1. 我把现在的程序化 SlimeBase 扩展，给 23 只都做出代码版本
2. **游戏立刻能玩**，所有功能完整
3. 美术是色块但有动画

### 第二步（这周）：$0
1. 用 Pollinations 或 Leonardo 免费生成 23 张参考图
2. 替换最显眼的 5 只（Green、Pink、Boss 等）
3. 其他保持色块

### 第三步（之后）：$20
1. 游戏上架前，用 Pixellab.ai 一个月把所有 sprite 升级
2. 替换全部色块
3. 加几张 Boss 高质量图

## 我现在就能帮你做的

要不要我立刻：

1. **扩展 SlimeBase**，把所有 23 只史莱姆都用代码实现（$0 方案）— **强烈推荐先做这个**
2. **写个 Pollinations 批量生成脚本**，自动调用免费 AI
3. **改写 docs/11 的 prompt** 为 Pollinations 友好格式

哪个先来？我建议先做 1，让游戏立刻能玩起来。
