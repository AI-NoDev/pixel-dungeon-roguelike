# 16 — 史莱姆全家族图鉴

> "史莱姆是这个世界最古老、最适应、最不能小看的生物。"

游戏的招牌怪物体系。前 5 层是史莱姆王国（Slime Realm），但史莱姆作为彩蛋存在贯穿整个游戏。

## 设计原则

1. **每只史莱姆都是一个故事** — 颜色 + 形状 + 属性 + 死亡效果都讲究
2. **可视化即玩法** — 看一眼就知道怎么打
3. **死亡后机制** — 死亡才是开始（爆炸、分裂、毒池、复活等）
4. **变异机制** — 同一种史莱姆可以变异成强化版
5. **美术 prompt 全部预设** — 直接喂给 AI 出图

## 颜色与属性映射

```
🟢 绿色   —  基础 / 物理
🟡 黄色   —  雷电 / 暴击
🔵 蓝色   —  冰冻 / 减速
🔴 红色   —  火焰 / 爆炸
🟣 紫色   —  毒性 / 腐蚀
🟠 橙色   —  野性 / 高速
⚪ 白色   —  治疗 / 圣光
⚫ 黑色   —  虚空 / 深渊
🌈 彩色   —  变异 / 稀有
🤍 透明   —  幽灵 / 隐形
🥇 金色   —  Boss / 金币奖励
```

---

## 一阶史莱姆 — 普通家族（10 种）

### S01. Green Slime（草绿史莱姆）— 经典

```yaml
属性:
  HP: 30
  速度: 60
  伤害: 接触 10
  元素: 物理
行为: 慢速跳跃追击
特征: 圆滚滚 :) 表情，蠢萌
死亡: 普通消散，10 金币
颜色: #66BB6A
体型: 16×16
```

**Prompt**:
```
Pixel art classic green slime monster, 16x16, round bouncy body, 
two black dot eyes :) cute smile, glossy highlight on top, 
4-frame idle breathing animation, transparent background, 
16-bit retro game style, color #66BB6A primary, 
#A5D6A7 highlight, #2E7D32 shadow, no anti-aliasing
```

---

### S02. Pink Bouncer（粉红弹弹）— 高速

```yaml
属性:
  HP: 25
  速度: 100
  伤害: 接触 8
  元素: 物理
行为: 大幅度跳跃追击，墙壁反弹
特征: 弹性大、永远开心 :D
死亡: 弹跳两下消散
颜色: #F48FB1
```

**Prompt**:
```
Pixel art pink hyper bouncy slime, 16x16, super stretched mid-bounce 
shape, big happy eyes :D, sparkles around, energetic motion lines, 
hot pink #F48FB1, candy aesthetic, transparent background, retro pixel
```

---

### S03. Acid Spitter（酸液吐手）— 远程

```yaml
属性:
  HP: 20
  速度: 30
  伤害: 投射酸球 12
  元素: 毒性
行为: 站定吐酸，地面留毒池 3 秒
特征: 黄色身体，嘴角酸液
死亡: 死亡留 5 秒酸池（伤害 5/s）
颜色: #FFEE58
特殊: 持续掉血（腐蚀）
```

**Prompt**:
```
Pixel art yellow acid slime, 16x16, drooling toxic green saliva, 
puffed cheeks ready to spit, sour expression, danger warning aesthetic, 
yellow #FFEE58 body, green #4CAF50 acid drips, 
transparent background, retro pixel
```

---

### S04. Blue Frost Jelly（冰霜冻冻）— 减速

```yaml
属性:
  HP: 35
  速度: 40
  伤害: 接触 8 + 减速 50%
  元素: 冰
行为: 缓慢追击，留下冰霜地面（减速）
特征: 透明结晶身体，冷漠表情 :|
死亡: 散开变冰晶碎片（短暂减速区域）
颜色: #4FC3F7
```

**Prompt**:
```
Pixel art ice blue jelly slime, 16x16, semi-transparent crystal body 
with internal frost, cold deadpan expression :|, frost particles 
floating around, ice cubes embedded inside body, 
icy blue #4FC3F7 with white #FFFFFF highlights and dark blue shadow,
transparent background, frosty atmosphere, retro pixel
```

---

### S05. Lava Bubbler（熔岩泡泡）— 火焰

```yaml
属性:
  HP: 30
  速度: 50
  伤害: 接触 12 + 燃烧 DoT
  元素: 火
行为: 留下火焰轨迹（玩家踩到燃烧）
特征: 火红身体，烟雾从顶部冒出
死亡: 小爆炸（5×5 范围 15 伤害）
颜色: #FF5722
特殊: 自带燃烧光环
```

**Prompt**:
```
Pixel art red fire lava slime, 16x16, glowing molten red body 
with magma cracks, smoke puffs from top, intense fierce angry eyes, 
small flames flickering, red #FF5722 with bright orange #FFA000 cracks 
and yellow #FFEB3B inner glow, dangerous aesthetic,
transparent background, retro pixel
```

---

### S06. Thunder Jolt（雷电跳跳）— 雷电

```yaml
属性:
  HP: 25
  速度: 130
  伤害: 接触 10 + 雷电链击
  元素: 雷
行为: 极速冲撞，命中后传导到附近敌人/玩家
特征: 黄色电浆身体，电弧从外环缠绕
死亡: 电弧炸开（链击附近 3 个目标）
颜色: #FFEB3B
```

**Prompt**:
```
Pixel art yellow thunder electric slime, 16x16, body crackling with 
electricity arcs, glowing energetic body, lightning bolts circling, 
shocked excited eyes, fast motion lines, electric blue #1976D2 arcs 
on yellow #FFEB3B body, transparent background, retro pixel
```

---

### S07. Toxic Goo（剧毒黏液）— 毒

```yaml
属性:
  HP: 40
  速度: 35
  伤害: 接触 10 + 中毒 DoT 5/s
  元素: 毒
行为: 慢速但缠人，留下毒雾
特征: 紫绿色，散发毒气泡泡
死亡: 死亡时围绕毒云 4 秒（持续中毒 AoE）
颜色: #9CCC65
特殊: 中毒持续 5 秒
```

**Prompt**:
```
Pixel art toxic poison slime, 16x16, sickly purple-green body, 
bubbling poison fluid, toxic gas wisps rising, narrow evil eyes, 
hazardous aesthetic, lime green #9CCC65 with deep purple #6A1B9A 
toxic spots, transparent background, retro pixel
```

---

### S08. Mega Goo（巨型黏团）— 坦克

```yaml
属性:
  HP: 80
  速度: 25
  伤害: 接触 20
  元素: 物理
行为: 慢速但伤害高
特征: 大体型，傻乎乎表情
死亡: 分裂为 2 个 Green Slime
颜色: #4DB6AC
体型: 24×24（大）
特殊: 死后分裂
```

**Prompt**:
```
Pixel art massive teal blob slime, 24x24, oversized round body, 
dopey simple expression, slow lumbering pose, multiple chins of jelly, 
teal #4DB6AC with deep cyan #00695C shadow, 
transparent background, retro pixel
```

---

### S09. Spike Slime（尖刺史莱姆）— 反伤

```yaml
属性:
  HP: 50
  速度: 50
  伤害: 接触 15 + 反伤 5
  元素: 物理
行为: 玩家近身时戳刺反击
特征: 全身尖刺，警觉表情
死亡: 尖刺四射 8 个方向（5 伤害弹幕）
颜色: #607D8B 
特殊: 受到近战攻击反伤 50%
```

**Prompt**:
```
Pixel art spiky defensive slime, 16x16, gray-blue body covered in 
sharp triangular spikes, alert eyes, defensive posture, 
warning aesthetic, gray-blue #607D8B with steel spikes #FFD54F tips,
transparent background, retro pixel
```

---

### S10. Tar Slime（焦油史莱姆）— 黏滞

```yaml
属性:
  HP: 50
  速度: 25
  伤害: 接触 8 + 黏住玩家 1.5s
  元素: 物理
行为: 缓慢追击，命中粘住玩家
特征: 黑色油亮，深邃眼睛
死亡: 留下大滩黑油（玩家踩入减速 70%）
颜色: #424242
特殊: 命中黏滞玩家
```

**Prompt**:
```
Pixel art black tar slime, 16x16, oily glossy black body, 
sticky drippy texture, evil glowing yellow eyes, 
predatory aesthetic, deep black #424242 with oily highlights #FFFFFF, 
transparent background, retro pixel
```

---

## 二阶史莱姆 — 变异家族（8 种）

变异史莱姆是**普通史莱姆受到特定条件触发的强化版**。出现概率较低，但收益更高。

### M01. Mutant Slime（变异史莱姆）— 随机变种

```yaml
HP: 50 | 速度: 70 | 伤害: 15
特征: 颜色随机变化（动画），形状抽搐
机制: 每 3 秒切换属性（火/冰/雷/毒）
死亡: 5 个不同色弹幕
颜色: 彩虹渐变
```

**Prompt**:
```
Pixel art mutant rainbow slime, 16x16, body shifting between colors 
with glitch effect, multiple eyes asymmetric, deformed body, 
unstable aesthetic, prismatic palette, animated color shift,
chaotic energy aura, transparent background, retro pixel
```

---

### M02. Crystalline Slime（结晶史莱姆）

```yaml
HP: 100 | 速度: 30 | 伤害: 20
特征: 半透明水晶质地，反射光
机制: 高物理护甲（伤害 -30%），但被冰元素打中变脆（-50% 防御）
死亡: 破碎成水晶（掉落 30 金币）
颜色: #B388FF
```

**Prompt**:
```
Pixel art crystalline gem slime, 16x16, prismatic translucent body, 
geometric facets, light refracting, hard expression, 
gemstone aesthetic, light purple #B388FF with rainbow inner refractions,
transparent background, retro pixel
```

---

### M03. Regenerating Slime（再生史莱姆）

```yaml
HP: 60 | 速度: 40 | 伤害: 12
特征: 绿光晕环绕，伤口愈合动画
机制: 每秒回复 5% HP（必须快速击杀，否则永生）
死亡: 必须用持续伤害（火/毒）才能彻底击杀
颜色: #69F0AE
特殊: 火焰元素禁止再生
```

**Prompt**:
```
Pixel art regenerating healing slime, 16x16, glowing green body 
with healing aura, gentle peaceful eyes, plus signs floating around, 
sparkles, alive aesthetic, bright #69F0AE green with white #FFFFFF 
glow particles, transparent background, retro pixel
```

---

### M04. Bomb Slime（炸弹史莱姆）

```yaml
HP: 30 | 速度: 100 | 伤害: 接触触发
特征: 全身缠满引线，红色滴答闪烁
机制: 接触玩家立即引爆（70 伤害 6×6 范围）
死亡: 立刻爆炸（35 伤害 5×5 范围）
颜色: #FF5722 + #FFEB3B 闪烁
```

**Prompt**:
```
Pixel art kamikaze bomb slime, 16x16, body wrapped in TNT dynamite 
sticks, glowing fuse on top with sparks, crazy maniacal eyes spiral, 
about to explode aesthetic, red-orange #FF5722 body with yellow 
#FFEB3B fuse glow, transparent background, retro pixel
```

---

### M05. Corrosive Slime（腐蚀史莱姆）

```yaml
HP: 45 | 速度: 35 | 伤害: 接触 10 + 腐蚀 8/s 持续 5s
特征: 棕黑色，不断滴落腐蚀液
机制: 命中玩家防御 -20%（持续 5s）
死亡: 死亡留下腐蚀池（持续掉血 10/s）
颜色: #5D4037
特殊: 防御穿透
```

**Prompt**:
```
Pixel art corrosive acidic slime, 16x16, dark brown sludge body 
with glowing toxic green spots, dripping acidic ooze, 
menacing eyes with dripping fangs, dangerous corroding aesthetic,
brown #5D4037 with toxic green #76FF03 highlights,
transparent background, retro pixel
```

---

### M06. Phantom Slime（幽灵史莱姆）

```yaml
HP: 40 | 速度: 80 | 伤害: 接触 12
特征: 半透明，飘浮在地面
机制: 短暂隐身（每 3s 隐身 1.5s），免疫近战
死亡: 消散为白色烟雾
颜色: #B39DDB（半透明）
特殊: 隐身、穿墙
```

**Prompt**:
```
Pixel art ghostly translucent slime, 16x16, semi-transparent purple 
phantom body, hollow soul-like eyes, floating off ground, 
ghostly trail of mist, ethereal aesthetic, light purple #B39DDB 
50% transparency with white wisps, transparent background, retro pixel
```

---

### M07. Magnetic Slime（磁力史莱姆）

```yaml
HP: 60 | 速度: 30 | 伤害: 接触 10
特征: 黄黑条纹，磁极符号
机制: 拉拽玩家（吸引力效果），子弹飞行轨迹被弯曲
死亡: 释放磁场脉冲，附近敌人短暂吸附
颜色: #FF6F00 + 黑条纹
特殊: 影响子弹弹道
```

**Prompt**:
```
Pixel art magnetic slime, 16x16, yellow and black hazard stripe pattern, 
magnetic field waves emanating, plus and minus poles visible, 
yellow #FF6F00 with black #1A1A2E stripes, magnet aesthetic, 
transparent background, retro pixel
```

---

### M08. Rainbow Slime（彩虹史莱姆）— 稀有

```yaml
HP: 200 | 速度: 50 | 伤害: 接触 15
特征: 全身彩虹流动，发光强烈
机制: 免疫所有元素伤害（必须用基础物理）
死亡: 必掉传说武器 + 100 金币
颜色: 全光谱循环
出现率: 0.5%（非常罕见，提升玩家兴奋度）
```

**Prompt**:
```
Pixel art legendary rainbow slime, 16x16, glowing rainbow gradient 
body, magical sparkles all around, regal happy expression, 
luxurious aesthetic, full spectrum rainbow palette, 
star particles floating, transparent background, retro pixel,
extremely shiny premium look
```

---

## 三阶史莱姆 — Boss 与精英（5 种）

### B01. Slime Knight（史莱姆骑士）— 精英

```yaml
HP: 200 | 速度: 60 | 伤害: 接触 25
特征: 戴铠甲、持小剑的红史莱姆
机制: 物理护盾抵挡 50% 伤害
死亡: 召唤 2 个 Mega Goo
颜色: #C2185B + 银色铠甲
体型: 24×24
```

**Prompt**:
```
Pixel art armored slime knight, 24x24, dark red slime wearing 
plate armor and helmet, holding tiny sword and shield, 
heroic guardian pose, brave expression, 
crimson #C2185B body with silver #BDBDBD armor and gold #FFD700 trim,
transparent background, fantasy retro pixel
```

---

### B02. Slime Mage（史莱姆法师）— 精英

```yaml
HP: 150 | 速度: 40 | 伤害: 投射魔法弹 18
特征: 紫色史莱姆戴尖帽，悬浮法杖
机制: 召唤魔法阵（5 秒后爆发 AoE）
死亡: 释放魔法风暴
颜色: #6A1B9A + 紫色魔法
```

**Prompt**:
```
Pixel art slime wizard mage, 24x24, purple slime wearing pointy 
wizard hat with stars, holding floating crystal staff, 
magical aura around, focused magical expression,
purple #6A1B9A body with deep violet #4A148C hat,
sparkly magic particles, transparent background, retro pixel
```

---

### B03. Slime King's Guard（皇家护卫）— 精英

```yaml
HP: 180 | 速度: 70 | 伤害: 接触 25 + 弹幕
特征: 紫色史莱姆戴小皇冠
机制: 周期性圆形弹幕（4 个酸球）
死亡: 召唤援军（2 个 Pink Bouncer）
颜色: #9C27B0 + 金皇冠
```

**Prompt**:
```
Pixel art royal slime guardian, 24x24, regal purple slime with 
small golden crown, ornate decorations, noble proud pose, 
holding ceremonial banner, royal aesthetic, 
purple #9C27B0 with gold #FFD700 crown,
transparent background, retro pixel fantasy
```

---

### B04. Slime King（史莱姆王）— F5 BOSS

```yaml
HP: 500 | 速度: 40 | 伤害: 接触 30
体型: 48×48
特征: 巨型黄金史莱姆，戴大皇冠
阶段一 (100%-70%): 跳跃攻击 + 召唤 2 Green Slime
阶段二 (70%-40%): 分裂为 4 个中型史莱姆
阶段三 (40%-15%): 全屏弹幕 + 高速冲撞
阶段四 (15%-0%): 召唤所有 S 系列史莱姆助阵
死亡: 留下王冠（永久解锁 史莱姆英雄角色）
颜色: #FFD54F (主) + #4A148C 王冠紫
特殊: 真正的最终之王
```

**Prompt**:
```
Pixel art slime king boss, 48x48, massive golden majestic slime 
with elaborate ornate crown, royal cape, scepter, dignified king pose, 
majestic regal eyes with intelligence, ruler of all slimes,
golden yellow #FFD54F body with deep purple #4A148C cape, 
gold #FFD700 crown with red gemstone #C62828, 
transparent background, epic boss retro pixel art
```

---

### B05. Ancient Slime（远古史莱姆）— 隐藏 Boss

```yaml
HP: 1500 | 速度: 50 | 伤害: 接触 50
体型: 60×60
特征: 巨大半透明史莱姆，内有水晶心脏
触发条件: 在 F1-F5 期间击杀 50 个史莱姆后出现于隐藏房间
机制: 全方位巨型激光、地面震击、虚空裂缝
死亡: 必掉 Legendary 武器 + 史莱姆王冠彩蛋成就
颜色: #80DEEA + 心脏 #FF5252
特殊: 隐藏 Boss，挑战者证明
```

**Prompt**:
```
Pixel art ancient mystical slime boss, 60x60, gigantic transparent 
slime revealing crystal heart inside, runic markings on body, 
mystical aura, ancient power aesthetic, ethereal aged appearance, 
cyan #80DEEA translucent body with bright red #FF5252 heart core,
runes glowing white #FFFFFF, transparent background, epic retro pixel
```

---

## 死亡机制详细规范

每只史莱姆的死亡都要有视觉反馈和潜在机制：

| 类型 | 死亡效果 | 视觉 |
|------|---------|------|
| **普通消散** | 渐隐+粒子 | 8 个绿色粒子向四周飞散 |
| **爆炸** | AoE 伤害 | 中心爆光 + 烟雾 |
| **分裂** | 生成小敌人 | 一变多动画 |
| **毒池** | 持续伤害区域 | 紫色液体扩散 |
| **冰晶** | 减速区域 | 蓝色霜冻区域 |
| **火焰** | 持续燃烧区域 | 火苗持续 3-5 秒 |
| **电弧** | 链击附近 | 黄色电弧线 |
| **召唤援军** | 立即生成新敌人 | 紫色魔法阵 |

---

## 互动机制（彩蛋）

### 史莱姆之间的反应

- **绿+蓝 撞击 → 蓝绿混合史莱姆**（更强）
- **火+冰 接触 → 双方互相伤害（蒸发反应）**
- **酸+物 接触金属敌人（铁哨兵）→ 腐蚀消除其护甲**
- **多个 Mega Goo 撞击 → 合并成超级 Mega Goo**

### 玩家与史莱姆的反应

- **用火攻击毒史莱姆** → 触发剧毒爆炸（Toxic 反应）
- **用冰冻 Tar Slime** → 它停下，可推动当掩体
- **击杀 Regenerating 速度太慢** → 它自爆变小再生

---

## 数值平衡

每楼层史莱姆配置：

```
F1: Green Slime × 6 + Pink Bouncer × 2
F2: Green Slime × 4 + Pink Bouncer × 3 + Acid Spitter × 2
F3: Mixed × 8 + 1 个 变异（随机 M 系列）
F4: Mixed × 8 + Mega Goo × 2 + 1 精英
F5: Slime King BOSS
```

---

## 美术资源清单

| 等级 | 名字 | sprite 数量 | 优先级 |
|------|------|-------------|--------|
| **S 普通** | 10 种史莱姆 | 4 帧 idle + 4 帧 jump + 2 帧 hurt + 6 帧 death = 16 帧/只 | P0 |
| **M 变异** | 8 种变异 | 同上 = 16 帧/只 | P1 |
| **B 精英/Boss** | 5 种 | 24+ 帧/只 | P0 (Slime King), P1 (其他) |

总美术工作量：
- **23 种史莱姆 × 平均 16 帧 = 368 帧**
- 加上死亡特效和粒子动画：**~500 帧**

预计 AI 生成 + Aseprite 整理：**5-7 天**

---

## 整合到代码

### 文件结构

```
lib/components/enemies/slime_realm/
├── green_slime.dart           ✅ 已有（需重命名）
├── pink_bouncer.dart          🆕
├── acid_spitter.dart          🆕
├── blue_frost_jelly.dart      🆕
├── lava_bubbler.dart          🆕
├── thunder_jolt.dart          🆕
├── toxic_goo.dart             🆕
├── mega_goo.dart              🆕
├── spike_slime.dart           🆕
├── tar_slime.dart             🆕
├── mutants/
│   ├── mutant_slime.dart      🆕
│   ├── crystalline_slime.dart 🆕
│   ├── regenerating_slime.dart 🆕
│   ├── bomb_slime.dart        🆕
│   ├── corrosive_slime.dart   🆕
│   ├── phantom_slime.dart     🆕
│   ├── magnetic_slime.dart    🆕
│   └── rainbow_slime.dart     🆕
├── elites/
│   ├── slime_knight.dart      🆕
│   ├── slime_mage.dart        🆕
│   └── kings_guard.dart       🆕
└── bosses/
    ├── slime_king.dart        🆕（替换原 Skeleton King）
    └── ancient_slime.dart     🆕（隐藏 Boss）
```

### 通用接口

```dart
abstract class SlimeEnemy extends Enemy {
  /// 史莱姆死亡时的特殊效果
  void onSlimeDeath(PixelDungeonGame game);
  
  /// 史莱姆受到特定元素时的反应
  void onElementHit(ElementType element);
}
```

## 验收

- [ ] 23 种史莱姆 sprite 全部完成
- [ ] 每种独特死亡效果实现
- [ ] 6 种特殊机制（再生、爆炸、分裂、隐身、磁力、变色）
- [ ] 隐藏 Boss 触发条件
- [ ] 平衡测试（F5 通关率合理）
- [ ] 史莱姆王冠彩蛋

## 后续扩展（DLC）

- 第二批史莱姆主题地牢（v1.2 DLC）
- 玩家可解锁的"史莱姆英雄"（基础 HP 低，但每秒回血）
- 史莱姆图鉴系统（收集所有种类）
- 喂养史莱姆系统（饲养品种）
