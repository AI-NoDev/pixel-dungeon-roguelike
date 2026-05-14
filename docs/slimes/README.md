# 史莱姆美术资源文档索引

本目录包含 **23 只史莱姆**的完整美术规格文档，每只一个 .md 文件。

每份文档可直接喂给 AI（Midjourney / DALL-E / Stable Diffusion）批量生成素材。

## 通用规范（所有史莱姆共用）

### 像素规格
- **基础尺寸**：16×16 像素（普通史莱姆）
- **大型史莱姆**：24×24（Mega、Elite）
- **Boss 史莱姆**：48×48 或 60×60
- **缩放**：游戏内 2x 显示（实际渲染 32×32 / 48×48 / 96-120×96-120）

### 视角
- **正视图（Front View）**：玩家斜上方俯视约 45°
- 不需要侧视图（圆滚滚不区分朝向）
- 只有头部朝向（眼睛位置变化即可）

### 调色限制
- **每只史莱姆 ≤ 6 色**（不算透明）
- **共用色**：白色高光、黑色描边、阴影黑

### 动画帧规范

每只史莱姆需要的动画：

| 动画 | 帧数 | 帧率 | 用途 |
|------|------|------|------|
| **idle** | 4 帧 | 6 fps | 静止呼吸/弹跳 |
| **jump/walk** | 4 帧 | 8 fps | 移动 |
| **attack** | 4 帧 | 12 fps | 攻击瞬间（部分史莱姆） |
| **hurt** | 2 帧 | 8 fps | 被击中变色 |
| **death** | 6 帧 | 8 fps | 死亡分解动画 |

### 文件命名规范

```
slime_<species>_<animation>_<frame>.png

例如：
slime_green_idle_0.png
slime_green_idle_1.png
slime_green_idle_2.png
slime_green_idle_3.png
slime_green_jump_0.png
...
slime_green_death_5.png
```

或者打包成 sprite sheet（单文件横排）：
```
slime_green_idle.png    (16×4 = 64 pixels wide)
slime_green_jump.png    (16×4 = 64 pixels wide)
slime_green_death.png   (16×6 = 96 pixels wide)
```

### 物种文档列表

#### 普通史莱姆（10 种）
- [01-green-slime.md](./01-green-slime.md) — 草绿史莱姆（基础）
- [02-pink-bouncer.md](./02-pink-bouncer.md) — 粉红弹弹（高速）
- [03-acid-spitter.md](./03-acid-spitter.md) — 酸液吐手（远程）
- [04-blue-frost-jelly.md](./04-blue-frost-jelly.md) — 冰霜冻冻（减速）
- [05-lava-bubbler.md](./05-lava-bubbler.md) — 熔岩泡泡（火焰）
- [06-thunder-jolt.md](./06-thunder-jolt.md) — 雷电跳跳（雷电）
- [07-toxic-goo.md](./07-toxic-goo.md) — 剧毒黏液（毒）
- [08-mega-goo.md](./08-mega-goo.md) — 巨型黏团（坦克）
- [09-spike-slime.md](./09-spike-slime.md) — 尖刺史莱姆（反伤）
- [10-tar-slime.md](./10-tar-slime.md) — 焦油史莱姆（黏滞）

#### 变异史莱姆（8 种）
- [11-mutant-slime.md](./11-mutant-slime.md) — 变异史莱姆（变色）
- [12-crystalline-slime.md](./12-crystalline-slime.md) — 结晶史莱姆（护甲）
- [13-regenerating-slime.md](./13-regenerating-slime.md) — 再生史莱姆
- [14-bomb-slime.md](./14-bomb-slime.md) — 炸弹史莱姆
- [15-corrosive-slime.md](./15-corrosive-slime.md) — 腐蚀史莱姆
- [16-phantom-slime.md](./16-phantom-slime.md) — 幽灵史莱姆
- [17-magnetic-slime.md](./17-magnetic-slime.md) — 磁力史莱姆
- [18-rainbow-slime.md](./18-rainbow-slime.md) — 彩虹史莱姆（稀有）

#### 精英 / Boss（5 种）
- [19-slime-knight.md](./19-slime-knight.md) — 史莱姆骑士（精英）
- [20-slime-mage.md](./20-slime-mage.md) — 史莱姆法师（精英）
- [21-kings-guard.md](./21-kings-guard.md) — 皇家护卫（精英）
- [22-slime-king.md](./22-slime-king.md) — 史莱姆王（F5 BOSS）
- [23-ancient-slime.md](./23-ancient-slime.md) — 远古史莱姆（隐藏 BOSS）

## 批量生成建议

### Midjourney 工作流
1. 复制对应 .md 中的 `Master Prompt`
2. Discord `/imagine` 输入
3. 用 `--niji 6 --ar 1:1 --quality 2` 参数
4. 生成 4 张候选，挑最好的
5. Upscale → 下载

### Stable Diffusion 工作流
1. 用 `Master Prompt` + `Negative Prompt`
2. Sampler: DPM++ 2M Karras, Steps: 30, CFG: 7
3. 用 PixelLab.ai 或 ControlNet 转像素

### 后处理
1. Aseprite 导入，限制调色到 6 色
2. 手动清理边缘
3. 复制 idle 帧 → 修改顶部高光位置 → 生成 4 帧
4. 导出 sprite sheet

### 时间预算
- 每只史莱姆：约 1-2 小时（含 AI 生成 + Aseprite 调整）
- 23 只总计：约 30-40 小时
- 建议批次：每天做 3-5 只

## 总美术工作量

```
普通 10 × 22 帧 = 220 帧
变异 8 × 22 帧  = 176 帧
精英 3 × 30 帧  = 90 帧
Boss 2 × 50 帧  = 100 帧
─────────────────────────
总计：约 586 帧美术资源
```

加上死亡特效粒子和大约 50 张子弹/特效帧，总数 ≈ 650 帧。
