# 组件库全局密度收紧计划（约 15% 紧凑化）

## Context

用户反馈全库组件视觉偏大（高度、部分宽度），要求缩小变美观。经盘点，偏大来源集中在组件默认高度（Button md 42、输入类 minHeight 52、TabBar 54、NavBar 60/72、Tag 36）与弹层内边距（Dialog 22、Loading 26、Drawer 宽 360）。

用户已确认偏好：**明显紧凑（约 15%，接近 shadcn 密度）**；**正文字号 15→14 同步微调**；**圆角不动**（保持玻璃拟态设计语言）；间距令牌骨架（HyUiSpacing 4/8/12/16/20/24/32）与圆角令牌（16/24/28）不改，保证布局稳定。

触控底线：所有可点目标高度 ≥32。

## 改动清单（全部在 ui/lib/src/）

### 1. 按钮 hy_button.dart
- `_HyButtonMetrics`（约 L186-218）：sm 34→32 / minWidth 58→52 / horizontal 12→10；md 42→38 / 76→68 / 16→14；lg 50→44 / 92→82 / 20→18
- 各档字号同步 -1（执行时核对现值，如 16→15、15→14、14→13）
- 图标 IconTheme size 18→17（L126）

### 2. 输入框 hy_text_field.dart
- fontSize 15→14；contentPadding horizontal 16→14、vertical 14→11（L172-232）
- 图标 20→18（L223、L312）、内嵌清空图标 19→18（L346）
- 同步检查 hy_ui_theme.dart 的 inputDecorationTheme.contentPadding（L51-139），保持与组件一致

### 3. 选择/下拉 hy_select.dart、hy_dropdown.dart
- Select：minHeight 52→44（L61）、vertical 9→8（L63）、值字号 15→14
- Dropdown：trigger minHeight 52→44（L104）、vertical 11→9；菜单项 vertical 11→9（L189）、菜单容器 all(18)→all(16)（L67）

### 4. 分段控制 hy_segmented_control.dart
- 单项高度 34→32（L85-124），icon 16 / 字号 13 保持

### 5. 导航 hy_navigation.dart + hy_top_bar.dart
- TabBar：height 54→50、margin (20,8,20,12)→(16,8,16,10)、barHeight 公式 +38→+34、pillWidth 上限 68→60、图标 19→18（L447）
- NavBar preferredSize：60→56 / 72→68（hy_top_bar.dart L32-62）
- Steps 圆点与间距按约 10% 收（L543+，执行时核对具体值）

### 6. 列表 hy_list_tile.dart、hy_lists.dart
- HyListTile：minHeight 52→46（L52）、vertical 10→8（L53）、图标 20→18（L117、L162）；leading 容器同步缩 2-4
- hy_ui_theme.dart：listTileTheme.minVerticalPadding 12→10

### 7. 基础展示类
- hy_tag.dart：height 36→30（L42）、h-padding 保持 12、字号 13 保持
- hy_image.dart HyAvatar：size 44→40（L133）
- hy_notice_bar.dart：vertical 10→8（L67）
- hy_empty_state.dart：图标 34→30（L38）

### 8. 弹层反馈类 hy_feedback.dart、hy_bottom_sheet.dart、hy_drawer.dart、hy_popover.dart
- Dialog：all(22)→all(18)（L108）、标题间距 12→10（L117）、22→18（L120）
- Loading.during 玻璃容器：all(26)→all(20)（L197）
- Toast：all(14)→all(12)、图标 21→18、间距 12→10（L241-245）；L8-74 主 Toast 图标 30x30 容器同步核对缩小
- ActionSheet 项高度执行时核对（~52→46）
- BottomSheet：all(20)→all(16)（L33）
- Drawer：width 360→320、all(20)→all(16)（L21、L46）
- Popover：all(16)→all(14)（L25）

### 9. 滚轮/上传 hy_picker.dart、hy_uploader.dart
- Picker：内容高 220→200、itemExtent 44→40
- Uploader：文件项宽 112→104

### 10. 排版 hy_typography.dart（关键联动）
- body 15→14（L30）
- **必须同步**修改颜色判断 `size < 15`→`size < 14`（L44），否则正文会错误变成 mutedForeground 灰色

### 11. 业务组件 hy_business.dart
- SearchBar 基于 HyTextField 自动收紧
- Collapse / Timeline / CountDown 内边距执行时核对，明显处 -2~-4

## 不改的内容
- HyUiSpacing / HyUiRadii 全部令牌（骨架稳定）
- preview 示例文件与 catalog.ts 高度（组件变矮后预留高度只会留少量空白，无害；本轮控制范围）

## 执行顺序
按钮 → 输入/选择 → 导航/列表 → 基础展示 → 弹层反馈 → 排版联动 → 业务核对

## 验证
1. `flutter analyze --no-pub` 于 ui/ 与 preview/ 两包（D:\app\flutter_sdk\flutter\bin\flutter.bat）
2. 用户 preview 热重载抽查：localhost:4201 `?component=buttons`、`text-field`、`select`、`dropdown`、`nav-bar`、`tab-bar`、`toast`、`dialog`、`tag`、`avatar`
3. 明暗主题下检查正文颜色未被误置灰（验证第 10 项联动）
4. 检查触控目标均 ≥32（按钮 sm 32、分段项 32 为底线）
