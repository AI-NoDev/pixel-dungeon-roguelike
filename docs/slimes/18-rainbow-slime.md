# Rainbow Slime（彩虹史莱姆）— 稀有

> 极稀有的传说怪物。0.5% 几率出现，必掉传说装备。

## 基本信息

| 字段 | 值 |
|------|-----|
| ID | `rainbow_slime` |
| 出现楼层 | F1-F5（任意，0.5% 几率替代普通史莱姆）|
| 等级 | 稀有彩蛋 |
| 元素 | 全免疫 |
| 体型 | 16×16 |

## 数值

```yaml
HP: 200（高）
速度: 50
接触伤害: 15
特殊: 免疫所有元素伤害（必须用基础物理子弹）
特殊: 出现时屏幕短暂彩虹闪光提示
死亡: 必掉 Legendary 武器 + 100 金币 + 解锁"传说"成就
```

## 形象设计

**全身彩虹渐变**（流动感），周围环绕**彩色星星**和粒子。眼睛是金色（贵气），表情骄傲优雅（`^_^`）。整体有"豪华金光"光晕。

### 视觉特征
- 整身**全光谱彩虹流动**（横向渐变循环）
- 周围 5-8 颗星星环绕（金/银/彩）
- 持续金色光晕
- 比普通 slime 略大，更显眼
- 移动时拖彩虹尾巴

## 调色板（动态彩虹）

```yaml
彩虹横扫：
  红: #FF0000
  橙: #FF9100
  黄: #FFEB3B
  绿: #4CAF50
  蓝: #2196F3
  靛: #3F51B5
  紫: #9C27B0

附加:
  金光晕: #FFD700
  银星: #FFFFFF
  眼睛: #FFD700 金色
```

## 动画要点

### Idle (8 帧 × 8fps — 比普通多)
- **彩虹色快速流动**（每帧颜色偏移）
- 周围星星持续旋转
- 金色光晕呼吸式扩缩

### Move (4 帧)
- 跳跃带彩虹拖尾（持续 1s）
- 着陆时金光闪
- 留下彩虹脚印

### Spawn (8 帧 × 16fps — 出场动画)
**特殊出场**：
- 帧 0: 屏幕白光闪
- 帧 1-3: 从地面/天而降
- 帧 4-5: 彩虹光柱
- 帧 6-7: 站定 + 金光环

### Death (12 帧 × 12fps — 比普通多 6 帧)
**豪华死亡**：
- 帧 0-1: 全身金光暴涨
- 帧 2-3: 体内出现星星粒子聚集
- 帧 4-5: 大爆发（彩虹光柱）
- 帧 6-7: 慢动作金币和宝石飞出
- 帧 8-9: 装备图标飘出（武器掉落）
- 帧 10-11: 金光收束消散

## AI Prompt

```
Pixel art legendary rainbow slime monster, 16x16 pixels,
glowing prismatic rainbow gradient body with full spectrum colors,
shimmering rainbow flow effect across surface,
proud regal happy expression ^_^ with golden eyes,
multiple golden stars and silver sparkles surrounding body,
luxurious magical aura golden halo glow,
premium legendary aesthetic, mystical magnificent feeling,
prismatic palette: full rainbow spectrum #FF0000 #FF9100 #FFEB3B
#4CAF50 #2196F3 #9C27B0 with #FFD700 gold halo and #FFFFFF white sparkles,
transparent background, ultra premium retro 16-bit pixel art,
shiny shimmering finish, --niji 6 --ar 1:1 --quality 5
```

### Spawn Animation

```
Pixel art legendary slime epic spawn animation, 8 frames,
white flash followed by rainbow light pillar,
slime materializing in golden glow with star particles,
falling from above with rainbow tail trail,
landing with magnificent halo expansion,
transparent background, retro pixel art --ar 8:1
```

### Loot Drop Death

```
Pixel art legendary slime death drop sequence, 12 frames,
slime bursts into golden light, treasure particles emerge,
weapon icons and gems fly out in slow-motion arcs,
coins scatter, achievement unlock effect,
final ray of light fading,
gold and rainbow palette, transparent background,
retro pixel art --ar 12:1
```

### Rainbow Trail

```
Pixel art rainbow trail effect, 16x4 pixels per frame,
prismatic gradient trail behind moving entity,
4-frame fade out animation,
transparent background, retro pixel art
```

## 特效（豪华版）

- **彩虹流动**：身体颜色每 0.1s 偏移 1 像素
- **星星环绕**：5-8 颗星星圆周旋转
- **金色光晕**：始终有金色脉冲（吸引注意）
- **彩虹脚印**：每跳一步留 1s 彩虹光斑
- **出场闪光**：屏幕短暂全屏金白色（200ms）
- **死亡装备特效**：装备图标飘出 + 金币雨
- **额外**：解锁成就提示飘屏

## 音效

| 事件 | 描述 |
|------|------|
| 出场 | 神圣合唱 + 金属铃声（魔幻提示）|
| Idle | 持续 "丁丁丁" 风铃音 |
| 移动 | "叮咚!" 跳跃音 |
| 受击 | "咯啷!" 优雅金属声 |
| 死亡 | 大型 "Ta-da!" 胜利音 + 装备拾取音 |

## 实现要点

```dart
class RainbowSlime extends SlimeBase {
  RainbowSlime({required Vector2 position}) : super(
    position: position,
    maxHp: 200,
    speed: 50,
    contactDamage: 15,
    color: Colors.yellow,  // 占位
  );
  
  @override
  void onLoad() {
    super.onLoad();
    // 出场特效
    spawnEpicSpawnEffect();
    // 屏幕提示
    showRainbowSpawnNotification();
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    // 持续彩虹色流动
    body.paint.color = _getRainbowColor(_time);
    _time += dt;
  }
  
  @override
  void onElementHit(ElementType element) {
    // 免疫所有元素，无效果
  }
  
  @override
  void onSlimeDeath() {
    // 必掉传说武器
    final legendary = WeaponPool.getLegendaryWeapon();
    spawnWeaponDrop(position, legendary);
    
    // 大量金币
    for (int i = 0; i < 10; i++) {
      spawnCoin(position + randomOffset(), 10);
    }
    
    // 解锁成就
    AchievementSystem.unlock(AchievementId.legendaryEncounter);
    
    // 全屏金光
    spawnFullScreenLuxuryEffect();
  }
}
```

## 注意事项

⚠️ **平衡设计点**：
- 出现概率必须低（0.5% 或更低）
- HP 必须高（玩家容易杀掉但要努力）
- 必须给重大奖励（值得追求）
- 视觉要"豪华"（让玩家激动）
- 出现时必须**屏幕级提示**（不能错过）
