# 15 — 完整敌人图鉴

## 设计原则

1. **每个楼层主题对应一个敌人家族** — 视觉一致，让玩家感受到"换关卡"的氛围
2. **共 5 大家族 × 6 类型 = 30+ 敌人** —足够多样不重复
3. **每家族 4 普通 + 1 精英 + 1 Boss** — 难度层次清晰
4. **跨主题混搭** — 高楼层会出现前面主题的强化版敌人

## 家族分布

| 楼层 | 主题 | 家族 | 风格关键词 |
|------|------|------|------------|
| F1-F5 | **Slime Realm** | 黏液家族 | 可爱、Q弹、蠢萌 |
| F6-F10 | **Crystal Cave** | 水晶/虫族 | 冰冷、闪光、生物 |
| F11-F15 | **Iron Fortress** | 机械/守卫 | 金属、规整、武装 |
| F16-F20 | **Inferno Depths** | 恶魔/火怪 | 暴力、燃烧、混乱 |
| F21+ | **The Void** | 虚空生物 | 诡异、抽象、未知 |

---

## 第一家族：Slime Realm（史莱姆王国 F1-F5）

### 普通敌人（4 类）

#### 1. Green Slime（绿史莱姆）— 基础
```
HP: 30 | 速度: 60 | 攻击: 接触 10
行为: 慢慢跳向玩家
特征: 经典 logo 怪物，"啵啵"跳跃
颜色: #66BB6A 主体, #2E7D32 阴影
```

#### 2. Pink Bouncer（粉弹弹）— 高速
```
HP: 25 | 速度: 100 | 攻击: 接触 8
行为: 跳跃式追击，每次跳很远
特征: 弹性大，墙壁反弹
颜色: #F48FB1 粉, #C2185B 阴影
```

#### 3. Acid Spitter（酸液吐手）— 远程
```
HP: 20 | 速度: 30 | 攻击: 投射酸球
行为: 站定吐酸，命中地面留毒池
特征: 黄色史莱姆，毒液飞溅
颜色: #FFEE58 黄, #F57F17 阴影
```

#### 4. Mega Goo（巨型黏团）— 坦克
```
HP: 80 | 速度: 25 | 攻击: 接触 20
行为: 慢速但伤害高
特征: 大体型，被打死分裂成 2 个 Green Slime
颜色: #4DB6AC 青绿, #00695C 阴影
```

### 精英敌人（1 类）

#### Slime King's Guard（史莱姆王卫）
```
HP: 150 | 速度: 60 | 攻击: 接触 25 + 喷射弹幕
行为: 巡逻+周期性圆形弹幕（4 个酸球）
特征: 戴小皇冠的紫色史莱姆
颜色: #BA68C8 紫, #6A1B9A 阴影, #FFD700 皇冠
```

### Boss

#### Slime King（史莱姆王）— F5 Boss
```
HP: 500 | 速度: 40 | 体型: 48×48
阶段一: 跳跃攻击 + 召唤 2 个 Green Slime
阶段二: 分裂成 4 个中型史莱姆
阶段三: 大爆炸 + 弹幕风暴
特征: 戴大皇冠，王者气场
颜色: #FFD54F 金色变种, #4A148C 王冠紫
```

---

## 第二家族：Crystal Hive（水晶虫巢 F6-F10）

### 普通敌人（4 类）

#### 5. Crystal Beetle（水晶甲虫）
```
HP: 40 | 速度: 70 | 攻击: 接触 12
行为: 直线冲撞
特征: 水晶背甲反射光
颜色: #80DEEA 青, #00695C 暗绿, #FFFFFF 高光
```

#### 6. Frost Wasp（冰霜蜂）— 远程
```
HP: 30 | 速度: 90 | 攻击: 投射冰刺
行为: 飞行，远程冰刺
特征: 半透明翅膀，冰晶尾针
颜色: #B3E5FC 冰蓝, #01579B 阴影
```

#### 7. Cave Mole（穴居鼹鼠）— 钻地
```
HP: 50 | 速度: 80 | 攻击: 接触 15
行为: 地下潜行，定期钻出突袭
特征: 突袭前地面有震动提示
颜色: #6D4C41 棕, #3E2723 阴影
```

#### 8. Spore Fungus（孢子蘑菇）— 范围
```
HP: 60 | 速度: 0（不动） | 攻击: 周期 AoE 孢子
行为: 静止，定时释放孢子云
特征: 大型蘑菇，孢子自动追踪玩家
颜色: #AED581 绿, #558B2F 阴影, #FF8A65 顶冠
```

### 精英

#### Crystal Sentinel（水晶哨兵）
```
HP: 200 | 速度: 50 | 攻击: 高伤害激光
行为: 充能 → 发射穿透激光
特征: 巨型水晶能量塔
颜色: #80DEEA 主, #1A237E 充能, #FFFFFF 激光
```

### Boss

#### Crystal Hive Queen（水晶蜂后）— F10 Boss
```
HP: 800 | 速度: 60 | 体型: 56×56
阶段一: 飞行射击冰刺
阶段二: 召唤小水晶蜂群（4 只 Frost Wasp）
阶段三: 全屏冰雾 + 高速冲撞
特征: 巨大半透明蜂后，水晶腹部
颜色: #80DEEA 主, #1A237E 王室紫, #FFD700 王冠
```

---

## 第三家族：Iron Legion（钢铁军团 F11-F15）

### 普通敌人（4 类）

#### 9. Iron Sentinel（铁制哨兵）— 标准
```
HP: 60 | 速度: 50 | 攻击: 长矛戳刺 18
行为: 列队推进，盾防正面
特征: 全身铠甲，面具兵
颜色: #78909C 灰, #455A64 阴影, #FFD54F 装饰
```

#### 10. Crossbow Guard（弩箭兵）— 远程
```
HP: 45 | 速度: 40 | 攻击: 弩箭 25
行为: 后排远程
特征: 沉重弩箭，速度慢但伤害高
颜色: #607D8B 主, #FFB74D 木制弩
```

#### 11. War Hound（战犬）— 高速
```
HP: 35 | 速度: 130 | 攻击: 撕咬 20
行为: 极速突袭
特征: 机械义肢狗，红眼
颜色: #424242 黑, #BF360C 红眼, #FFC107 金属
```

#### 12. Siege Mortar（攻城臼炮）— 重型
```
HP: 80 | 速度: 0 | 攻击: 抛物线炮弹（区域）
行为: 静止，发射地面爆炸炮弹
特征: 履带式自走炮，落点有标记
颜色: #4E342E 棕, #FFD54F 黄铜, #BF360C 火光
```

### 精英

#### Captain of the Watch（守卫队长）
```
HP: 250 | 速度: 80 | 攻击: 旋风斩 + 突进
行为: 突进 + 周身旋转斩
特征: 红披风，双手剑
颜色: #BF360C 红, #FFC107 金, #2D2D44 阴影
```

### Boss

#### Warden Knight（守望骑士）— F15 Boss
```
（已在 boss_data.dart 定义，保持不变）
HP: 1200 | 体型: 52×52
特征: 金色铠甲 + 火焰大剑
```

---

## 第四家族：Inferno Horde（炼狱军团 F16-F20）

### 普通敌人（4 类）

#### 13. Imp（小恶魔）— 标准
```
HP: 40 | 速度: 90 | 攻击: 火球 15
行为: 飞行追击 + 投射火球
特征: 红色小恶魔，蝙蝠翅膀
颜色: #D32F2F 红, #4A148C 阴影, #FFEB3B 火光
```

#### 14. Hellhound（地狱犬）— 高速
```
HP: 50 | 速度: 140 | 攻击: 接触 25 + 燃烧 DoT
行为: 极速冲撞 + 留下火焰轨迹
特征: 燃烧的双头犬
颜色: #BF360C 主, #FF6F00 火, #1B0000 黑
```

#### 15. Flame Mage（火焰法师）— 远程
```
HP: 50 | 速度: 35 | 攻击: 火墙 / 火球阵
行为: 召唤火墙阻挡 + 投火
特征: 红袍兜帽，骷髅头
颜色: #B71C1C 红, #FFEB3B 火, #1A1A2E 阴影
```

#### 16. Magma Giant（熔岩巨人）— 坦克
```
HP: 120 | 速度: 30 | 攻击: 砸地震击 30
行为: 缓慢追击 + 落锤 AoE
特征: 全身熔岩裂痕
颜色: #424242 岩, #FF6F00 熔岩裂缝, #FFEB3B 高光
```

### 精英

#### Demon Champion（恶魔冠军）
```
HP: 350 | 速度: 70 | 攻击: 火焰大刀 + 烈焰冲击波
行为: 挥砍 + 释放冲击波
特征: 双角恶魔，巨型大刀
颜色: #6A1B9A 紫, #FF5722 火, #1A1A2E 黑
```

### Boss

#### Inferno Lord（炼狱领主）— F20 Boss
```
（已在 boss_data.dart 定义，保持不变）
HP: 1800 | 体型: 56×56
特征: 巨型恶魔领主
```

---

## 第五家族：Void Spawn（虚空造物 F21+）

### 普通敌人（4 类）

#### 17. Void Wisp（虚空游魂）— 飘忽
```
HP: 35 | 速度: 60 | 攻击: 触摸 15 + 减速
行为: 缓慢飘移，无规律变向
特征: 紫色幽灵，半透明
颜色: #7C4DFF 紫, #E040FB 高光, #FFFFFF 核心
```

#### 18. Cosmic Scout（宇宙侦察兵）— 远程
```
HP: 45 | 速度: 80 | 攻击: 维度激光（穿透墙）
行为: 隐形 + 突然现身射击
特征: 触手生物，多眼
颜色: #1A237E 深紫, #80DEEA 触手, #E040FB 眼睛
```

#### 19. Mind Flayer（夺心魔）— 控制
```
HP: 55 | 速度: 50 | 攻击: 心灵冲击（让玩家短暂反向移动）
行为: 念力锁定 + 心智攻击
特征: 章鱼头法师
颜色: #4A148C 紫, #00BCD4 触手, #E040FB 眼
```

#### 20. Void Devourer（虚空吞噬者）— 召唤
```
HP: 100 | 速度: 40 | 攻击: 召唤小 Void Wisp + 接触 22
行为: 周期召唤其他敌人
特征: 张开大嘴，吐出虚空
颜色: #311B92 主, #E040FB 边缘, #1A1A2E 内部
```

### 精英

#### Reality Shifter（现实扭曲者）
```
HP: 400 | 速度: 90 | 攻击: 时空弹（瞬移）
行为: 瞬移 + 多重投射 + 镜像分身
特征: 浮空法师，多个分身
颜色: #BA68C8 主, #00BCD4 高光, #1A1A2E 阴影
```

### Boss

#### Void Reaper（虚空收割者）— F25 Boss
```
（已在 boss_data.dart 定义，保持不变）
HP: 2500 | 体型: 60×60
特征: 终极 Boss
```

---

## 跨家族混合（高楼层）

### F26+ 无尽模式 / 噩梦难度

混合不同家族的强化版敌人：

```
F26 - F30: 
  - Slime + Crystal 混合（结晶史莱姆）
  - Iron + Inferno 混合（地狱铠甲）
  - 全部 5 家族精英复活战
  
F31+: 
  - 全 Boss 车轮战（5 个 Boss 连续打）
  - 双倍属性的随机敌人
```

---

## 总数统计

| 类型 | 数量 |
|------|------|
| 普通敌人 | 20（4×5 家族）|
| 精英敌人 | 5（每家族 1）|
| Boss | 5 |
| **总计** | **30 个独特敌人** |

## 实施优先级

### MVP 版本（首发必须）

每个家族先做：
- **2 个普通敌人**（最有代表性的）
- **1 个 Boss**

合计：10 个普通 + 5 个 Boss = **15 个敌人**

剩下的 15 个作为 **v1.1 / DLC 内容**陆续添加。

### 当前代码状态

```
✅ 已实现（6 类，需要重新映射）：
   - Slime → 现 Green Slime
   - Skeleton → 暂用，将转为 Iron Legion 弩箭兵或归档
   - Goblin → 暂用，将归档
   - Golem → 转为 Iron Sentinel
   - Mage → 转为 Flame Mage 或 Mind Flayer
   - Bomber → 转为 Hellhound

❌ 待实现：
   - Pink Bouncer / Acid Spitter / Mega Goo（Slime 家族补全）
   - Crystal 家族 4 个
   - Iron Legion 4 个（部分映射）
   - Inferno 家族 4 个（部分映射）
   - Void 家族 4 个
   - 5 个精英变体
   - 1 个新 Boss（Slime King 替代之前 F5 Boss 的 Skeleton King）
```

## 代码层调整建议

### 重命名 / 新增的敌人类

```dart
// lib/components/enemies/
├── slime_realm/
│   ├── green_slime.dart       (原 SlimeEnemy)
│   ├── pink_bouncer.dart       (新)
│   ├── acid_spitter.dart       (新)
│   └── mega_goo.dart           (新)
├── crystal_hive/
│   ├── crystal_beetle.dart     (新)
│   ├── frost_wasp.dart         (新)
│   ├── cave_mole.dart          (新)
│   └── spore_fungus.dart       (新)
├── iron_legion/
│   ├── iron_sentinel.dart      (改自 GolemEnemy)
│   ├── crossbow_guard.dart     (改自 SkeletonEnemy)
│   ├── war_hound.dart          (新)
│   └── siege_mortar.dart       (新)
├── inferno_horde/
│   ├── imp.dart                (新)
│   ├── hellhound.dart          (改自 BomberEnemy)
│   ├── flame_mage.dart         (改自 MageEnemy)
│   └── magma_giant.dart        (新)
└── void_spawn/
    ├── void_wisp.dart          (新)
    ├── cosmic_scout.dart       (新)
    ├── mind_flayer.dart        (新)
    └── void_devourer.dart      (新)
```

### Spawner 改造

`enemy_spawner.dart` 根据 `currentFloorConfig.theme` 选择对应家族的敌人池：

```dart
Enemy _createRandomEnemy(Vector2 position, FloorConfig config) {
  switch (config.theme.type) {
    case DungeonThemeType.crypt:    // F1-F5
      return _createSlimeRealmEnemy(position, config.floorNumber);
    case DungeonThemeType.cave:     // F6-F10
      return _createCrystalHiveEnemy(position, config.floorNumber);
    case DungeonThemeType.fortress: // F11-F15
      return _createIronLegionEnemy(position, config.floorNumber);
    case DungeonThemeType.inferno:  // F16-F20
      return _createInfernoHordeEnemy(position, config.floorNumber);
    case DungeonThemeType.void_:    // F21+
      return _createVoidSpawnEnemy(position, config.floorNumber);
  }
}
```

注意：`DungeonThemeType.crypt` 名字保留代码不变，但视觉/敌人改为史莱姆王国主题。或者后续重命名为 `DungeonThemeType.slime_realm` 等更明确的名字。

## AI 生成 prompt 示例（新增敌人）

### Pink Bouncer
```
Pixel art pink slime monster, 16x16, bouncy round shape, 
wide cute eyes, small mouth showing tooth, mid-bounce pose, 
hot pink color #F48FB1 with darker pink shadow, 
mischievous expression, transparent background, 16-bit retro style
```

### Crystal Beetle
```
Pixel art crystal beetle insect, 16x16, hard cyan crystal carapace, 
six small legs, glowing crystal antennae, side view walking, 
cyan #80DEEA with white highlights and dark green shadows, 
transparent background, retro pixel art game style
```

### Imp
```
Pixel art tiny demon imp, 16x16, red skin, small horns, 
bat-like wings, holding fireball, mischievous grin, 
flying pose, red #D32F2F with yellow flames, transparent background, 
16-bit fantasy game enemy sprite
```

（其他敌人 prompt 可参考此模板，结合 docs/11 已有结构补充）

## 验收检查

发布前每个敌人必须：
- [ ] 有 idle / walk / hurt / death 4 套动画
- [ ] 有独立音效（移动、攻击、死亡）
- [ ] 数据（HP/速度/攻击）已平衡
- [ ] 行为 AI 与设计一致
- [ ] 出现在正确的楼层
- [ ] 死亡掉落正常
