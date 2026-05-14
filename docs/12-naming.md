# 12 — 游戏命名

## 当前候选

### 主推荐：POP! Slime

- **释义**：拟声 "啵" — 子弹击中史莱姆的瞬间
- **优势**：
  - 与 logo 直接呼应（史莱姆被射应激表情）
  - 单词短，易记，App Store 搜索友好
  - 标点符号在名称里（"!"）有视觉识别度
  - 中英通用（中文可叫"啵噗史莱姆" 或直接保留英文）

### 备选清单

| 名字 | 中文 | 风格 | 备注 |
|------|------|------|------|
| **POP! Slime** | 啵噗史莱姆 | 可爱+动作 | **首选** |
| **Splat Knight** | 噗哒骑士 | 角色为主 | 强调主角 |
| **Goo Bandit** | 黏液大盗 | 西部+幻想 | 有故事感 |
| **Slime Sortie** | 史莱姆突袭 | 军事+幻想 | 偏硬派 |
| **Blob Brawler** | 黏团斗士 | 头韵 | 朗朗上口 |
| **Slimepunk** | 史莱姆朋克 | 赛博风 | 风格独特 |
| **Bouncy Doom** | 弹跳末日 | 反差萌 | 趣味性 |

## 命名规范

### App Store / Google Play

- **App 名称**：`POP! Slime`
- **副标题**：`Pixel Roguelike Dungeon`
- **关键词**：`roguelike, pixel, dungeon, action, indie, slime, twin-stick, retro, arcade, single-player`

### 包名

- **iOS Bundle ID**：`com.ainodev.popslime`
- **Android Package**：`com.ainodev.popslime`

### 仓库

- **GitHub**：`AI-NoDev/popslime`（迁移自 `pixel-dungeon-roguelike`）

### 社交媒体

- **Twitter**：`@popslimegame`
- **Discord**：`POP! Slime`
- **官网**：`popslime.app`（如可注册）

## 商标检查清单

- [ ] App Store 搜索 "Slime" 已有大量游戏 → 但 "POP! Slime" 完全空白 ✅
- [ ] Google 搜索 "POP Slime game" → 无明确同名产品 ✅
- [ ] 商标局检索（USPTO、TIPO）→ 待执行
- [ ] 中国版号申请用 "啵噗史莱姆" 或 "POP史莱姆"

## 需要更新的位置

切换名字时记得改：

- [ ] `pubspec.yaml` 的 `name`
- [ ] iOS `Info.plist` 的 `CFBundleDisplayName`
- [ ] Android `AndroidManifest.xml` 的 `android:label`
- [ ] iOS Bundle ID（com.ainodev.popslime）
- [ ] Android applicationId
- [ ] 多语言文件 `app_title` 和 `app_subtitle`
- [ ] 加载页 logo
- [ ] 主菜单标题
- [ ] App Store Connect 项目名
- [ ] GitHub 仓库 rename
- [ ] 文档中所有 "Pixel Dungeon Survivors" 引用
