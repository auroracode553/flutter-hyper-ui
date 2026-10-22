# UI 样式与功能实现基线

Hyper UI 的“柔性玻璃”不是统一透明度的卡片皮肤，而是一组同时约束材质、层级、触控反馈、运动和排版的规则。

本文依据当前 ui/lib/src/ 实现整理，基线日期为 2026-10-21。它同时约束默认视觉、功能行为和组件复用边界，供维护者及 AI 修改前阅读。完整公开签名与参数表仍由[各组件页](../components/catalog.md)维护，本文不替代参数文档。

## 修改边界

1. 修改前一起核对本文、目标组件源码、组件页和 preview/lib/src/examples/ 中的真实示例；不能只凭截图推断实现。
2. 用户明确要求的变化按授权范围执行。确定只是多余覆盖的可以直接清理；用途不明、可能改变外观或交互的地方，先说明具体位置、当前用途、影响和建议，得到用户确认再改。
3. 不因“统一”把所有点击区域改为 HyperButton。日期格、页签、选择标记、侧滑操作区和字段内部图标有各自的布局与状态规则。
4. 不因发现灰色就删除样式。controlTrack 表达轨道和禁用背景，selection 表达选中态，mutedForeground 表达次级文字；它们不是普通按钮的装饰灰底。
5. 不在普通 HyperButton 上重复指定默认前景色、手写禁用色或添加无用途的 selection 灰底。按钮颜色覆盖还会影响描边，不能只检查图标颜色是否相同。
6. 重构必须保持默认尺寸、分组、文案、状态、回调时机和状态归属。改变这些规则需有对应授权，并同步本文、两端实现、组件页和预览。
7. 本文与源码不一致时先查明原因；不能擅自修改源码迎合文档，也不能通过改文档认可未经授权的实现变化。明确的新要求优先，并在完成后更新基线。

## 源码与职责

| 位置 | 负责内容 | 维护边界 |
| --- | --- | --- |
| ui/lib/hyper_ui.dart | 对外导出入口 | 消费项目从这里导入；内部绘制工具不随意增加为公开 API |
| ui/lib/src/theme/ | 语义颜色、材质、间距、圆角、动效 | 主题令牌集中维护；修改会影响多个组件 |
| ui/lib/src/components/ | 基础控件及组合组件 | 状态和回调通过入参传递，不读业务服务或全局业务变量 |
| ui/lib/src/utils/ | 菜单测量、进度归一化、传输格式和浮层动效 | 供组件复用，不复制到各调用方 |
| preview/lib/src/examples/ | 真实可交互调用和示例状态 | 修改组件后核对现有示例，不额外加控制项或计数 |
| preview/lib/src/preview_catalog.dart | 示例 ID 与延迟加载映射 | 与目录中的 Preview ID 对齐 |
| vitepress/.vitepress/catalog.ts | 组件路由、说明、参数说明与示例引用 | 与公开源码和组件页同步 |
| vitepress/components/ | 组件 API 与使用说明 | 保留完整签名和参数表，不能用本文替代 |

内部共用关系：HyperGlass 负责材质与裁切；HyperPressable 负责按压；hyper_progress_painters.dart 负责加载环与轨道；hyper_modal.dart 负责模态路由；hyper_anchored_surface.dart 与 hyper_anchored_layout.dart 负责锚定浮层；hyper_selection_field.dart 供 Select 与 Dropdown 共用字段；hyper_tab_controller.dart 连接 Tabs 与内容区。不要在每个组件中复制这些实现。

## 设计目标

### 清晰优先

透明度只用于表达空间关系。文本、图标和操作状态始终需要稳定的对比度；当系统请求高对比度时，组件会降低透明感并强化边界。

### 直接操作

可触控对象在按下时立即反馈。TabBar 拖动时预览目标选项，松手后提交；SlideMenu 在拖动期间连续跟手，释放时继承手势速度并使用弹簧吸附。不能把两者的状态提交方式混为一套实现。

### 通用而克制

组件只表达 UI 语义：值、状态、内容和回调。它们不包含订单、用户、商城等业务概念，也不规定应用如何路由或管理状态。

## 表面材质

`HyperUiTheme` 在主题层选择 `solid`、`soft` 或 `clear`。组件内部按用途区分轻量、常规和浮层表面，这些层级在三种材质下保持一致：

| 材质 | 行为 |
| --- | --- |
| solid | 默认值；实色背景，不执行背景模糊 |
| soft | 柔和半透明表面，使用标准模糊 |
| clear | 更清透的表面，使用更强模糊 |

`HyperMenuGroup` 绘制一次外层表面，内部 `HyperListTile` 自动只绘制状态；其他分组表面内可用 `HyperListTile(type: 'plain', ...)`。

材质来自 theme/hyper_glass_theme.dart：solid 的 surface、surfaceStrong、surfaceSubtle 不透明，blur 与 blurStrong 为 0；soft 使用对应亮暗基础令牌，模糊为 20 / 28；clear 三档表面的 alpha 为 118 / 153 / 77，模糊为 32 / 40。语义颜色来自 HyperUiThemeTokens，材质层级不承担业务含义。

HyperUiTheme.app 默认跟随系统亮暗，material 默认 solid，基准文字为 14、行高 1.4，基准图标为 24。HyperGlass 的 subtle / regular / prominent / solid 是组件表面层级，不能当作应用材质枚举替换；其默认圆角为 24，subtle 不带默认阴影。高对比时该表面停用模糊并强化边框。导航栏滚动背景有独立实现，不能据此推断所有背景都使用 HyperGlass。

默认语义色如下，取自 HyperUiColors 与 HyperUiThemeTokens；表中为 ARGB 色值。业务换肤通过主题传入或 copyWith 覆盖，不修改组件内部常量。

| 令牌 | 亮色 | 深色 |
| --- | --- | --- |
| background | 0xFFF1F3F7 | 0xFF111318 |
| foreground / cardForeground | 0xFF1A1D26 | 0xFFF3F4F6 |
| card | 0xFFFFFFFF | 0xFF1B1F27 |
| primary / primaryForeground | 0xFF476FE8 / 0xFFFFFFFF | 同亮色 |
| muted | 0xFFF1F3F5 | 0xFF272C35 |
| mutedForeground | 0xFF6B7280 | 0xFFB8C0CC |
| border / input | 0x18111216 / 0xFFE5E7EB | 均为 0xFF343B47 |
| selectionBackground | 0xFFEFF6FF | 0xFF142544 |
| success / warning | 0xFF22C55E / 0xFFF59E0B | 同亮色 |
| error / info | 0xFFEF4444 / 0xFF3B82F6 | 同亮色 |

HyperUiBuildContext 的 hyperUi / hyperGlass 只提供主题读取快捷入口；HyperPalette 保存绘制用中性色。selectionBackground 是语义范围底色，HyperGlassTheme.selection 是材质选中底色，不能仅凭名字相似互换。预览手机的白色正文背景也不能用于推断主题 background 必须改为白色。

```dart
HyperUiTheme.app(
  material: HyperMaterial.soft,
  home: const AppHome(),
)
```

## 空间层级

页面从后向前分为四层：

1. 主题背景色：由页面宿主绘制。
2. 内容层：列表、正文和普通卡片。
3. 浮动功能层：Navbar、TabBar、Popover。
4. 模态层：Drawer、Dialog、BottomSheet，与 `scrim` 遮罩配合。

浮动功能层允许内容从下方经过；模态层需要把背景推到次要位置。阴影只负责层级分离，不用作装饰性发光。

## 动效与物理

### 按压

`HyperPressable` 在触摸按下时立即缩放和降低少量不透明度，松开或取消时恢复。组件不会在动画期间锁定输入。

默认 pressedScale 为 0.975，pressedOpacity 为 0.92，按下 85ms、恢复 180ms；enabled 为 false 或点击与长按回调均为空时不可交互。按住过程中被禁用会恢复按压状态。

按钮、可点击卡片、列表行和菜单项复用这一反馈。系统启用“减少动态效果”时不再缩放，仅保留 100ms 的透明度变化。

### 状态与弹层过渡

动画服务于操作反馈、状态辨识和空间关系，不给静态正文添加循环或入场装饰。

| 交互 | 动画 | 时长 |
| --- | --- | ---: |
| Dropdown / Popover / PopupMenu | 从触发器一侧以 0.96 倍缩放淡入，沿同一路径收起 | 180ms |
| Dropdown 箭头 | 开合时旋转半圈 | 180ms |
| Tooltip | 从靠近锚点的一侧以 0.97 倍缩放淡入淡出；键盘聚焦即时显示 | 125ms |
| Checkbox / Radio / Switch | 勾选标记淡入、单选圆环渐变、开关滑动与颜色过渡 | 160ms |
| SegmentedControl | 等宽时平移同一选中底板；非等宽时过渡选中背景色 | 260ms / 160ms |
| Collapse | 内容高度与透明度同步变化，箭头同步旋转 | 200ms |
| Dialog | 居中轻缩放淡入淡出，遮罩同步变化 | 250ms |
| ActionSheet / Select / Picker / DatePicker | 底部面板沿竖直方向短距离滑入滑出，遮罩同步变化 | 250ms |

时长与曲线集中定义在 HyperUiEffects；按压与浮层使用 Cubic(0.23, 1, 0.32, 1)，选中状态使用 Cubic(0.77, 0, 0.175, 1)。组件内部浮层工具负责保留退出绘制、延迟移除与快速反向操作，动画期间不重复构建玻璃内容。

浮层收起后立即停止接受操作，绘制完成后再移除。折叠内容首次展开后保留内部状态，收起时关闭焦点与点击并暂停内部持续动画。系统启用“减少动态效果”时，缩放、旋转和位移停止，颜色与透明度保留短过渡；折叠高度立即收敛。

可在现有组件预览中手动检查：快速反复开合下拉、连续切换选项、下拉在屏幕底部向上展开、折叠后再次展开，以及减少动态效果和 RTL 布局。

### 拖拽

`HyperSlideMenu` 遵循以下流程：

```text
按下 → 记录抓取偏移 → 1:1 跟随 → 计算释放速度
     → 投影目标位置 → 携带速度进入弹簧 → 吸附
```

拖过边界时使用渐进阻力而非硬停止。系统启用“减少动态效果”后，弹簧与位移动画会直接收敛到目标状态。

SlideMenu 的速度投影时间为 0.09 秒，展开判断使用操作区宽度的 35%，吸附弹簧 mass / stiffness / damping 为 1 / 470 / 42。HyperTabBar 使用拖动位置计算临时索引，松手通过 onChanged 提交；单个选中块以 160ms 过渡，不能擅自给它增加速度投影或弹簧行为。

### 空间一致性

- 从右侧进入的 Drawer 从右侧退出。
- Popover 锚定触发控件，而不是从页面中心出现。
- Tab 指示器在同一条轨道内移动，不改变图标和文字尺寸。

## 圆角与间距

基础尺寸由 `HyperUiRadii` 和 `HyperUiSpacing` 提供：

| 令牌 | 默认值 | 常见用途 |
| --- | ---: | --- |
| HyperUiRadii.sm | 16 | 标签、分段项等；输入框和按钮有自己的圆角规则 |
| HyperUiRadii.md | 24 | 默认卡片；菜单组有独立圆角 18 |
| HyperUiRadii.lg | 28 | 大型弹层 |
| HyperUiSpacing.pagePadding | 16 | 移动端页面边距 |
| HyperUiSpacing.cardPadding | 12 | 卡片内部间距 |

同一容器内优先使用相邻间距级别，避免出现大量彼此无关的魔法数字。

间距 xxs / xs / sm / md / lg / xl / xxl 分别为 4 / 8 / 12 / 16 / 20 / 24 / 32；itemGap 为 8。圆角 full 为 999。这些是令牌，不要求所有控件强行使用同一个圆角；例如输入框 20、Dialog 26、ActionSheet 30、按钮高度的一半都属于现有专用规则。

### 紧凑组件的尺寸

移动端表单中的计数器和选择项应优先保持内容所需宽度。小控件使用 `subtle` 表面，嵌入卡片或菜单组时由外层统一绘制玻璃材质，避免每一行叠一张卡片。

HyperCheckbox、HyperRadio、HyperSwitch 的标签行统一使用 plain，不自动附带卡片背景、外框或阴影；基础组件预览和组件总览的选择控件分组也不加 HyperCard。保留标签、整行点击、控件自身轮廓、选中与禁用状态。

| 组件 | 默认视觉尺寸 | 使用建议 |
| --- | ---: | --- |
| HyperNumberStepper | 按钮 32、默认整体高 38 | 数值区按内容增长；边界沿用按钮默认禁用态 |
| HyperEmptyState | 图标容器 56 | 使用精简的图标、标题与说明间距 |

尺寸只约束视觉，不应通过固定高度裁切放大的文字。业务需要更醒目的入口时，使用组件已有尺寸参数或在外层提供空间。

## 排版

`HyperText` 只有 small / default / large 三档，独立使用的基准字号为 12 / 14 / 18、行高 1.4。default 在按钮、导航等插槽中继承宿主的字号、行高、字重与颜色；显式 color、fontWeight 优先。small 保留 12、w400、mutedForeground，large 保留 18、w700、foreground。HyperIcon 基准尺寸为 18 / 24 / 32，default 继承宿主图标尺寸，各档未显式指定 color 时继承宿主图标颜色。字号变化时布局应跟随 `MediaQuery.textScalerOf(context)`，不要用固定高度裁切正文。

## 反馈语义

`HyperUiTone` 将颜色与业务内容解耦：

- `neutral`：无倾向的信息。
- `primary`：品牌强调。
- `success`：操作成功或完成。
- `warning`：需要留意但尚未失败。
- `error`：失败或危险操作。
- `info`：补充信息和进行中状态。

颜色不能成为唯一线索。Toast、Alert、Badge 应同时提供文字或图标语义。

## HyperButton 默认样式与复用规则

源码：components/hyper_button.dart。常规动作使用 HyperButton；图标按钮使用 type: 'icon'。HyperPressable 只提供交互反馈，不自动拥有按钮外观。

| 项目 | 当前规则 |
| --- | --- |
| type | 省略为默认描边按钮；显式值仅 filled、icon |
| colorStyle | primary / success / info / warning / danger；省略时使用默认配色 |
| color | 自定义配色，优先于 colorStyle；不是普通文字颜色参数，也会影响描边 |
| 默认描边按钮 | surfaceSubtle 背景、foreground 前景、border 描边；亮色 solid 下为白底 |
| 默认图标按钮 | surface 背景、foreground 前景、edgeHighlight 描边，圆形 |
| filled | 基色渐变、淡描边和阴影；前景按是否指定色调与亮度计算 |
| 禁用 | enabled 为 false 或 onPressed 为空；controlTrack 背景、mutedForeground 的 alpha 150、border 的 alpha 110 |
| 加载 | 阻止重复点击；图标按钮用加载环替代图标，文字按钮保留内容并显示加载环；不自动切换为禁用配色 |
| 内容 | label 与 content 互斥；type 为 icon 时不能传 label；tooltip 由 HyperTooltip 提供 |
| 宽度 | 默认随内容收缩；expanded 才通栏；图标按钮宽高相同 |
| 圆角 | 按钮高度的一半，不能改用统一方形圆角 |
| backgroundColor | 覆盖默认背景并关闭背景渐变；仅保留有明确用途的调用 |

| size | 高度 | 最小文字按钮宽度 | 水平内边距 | 字号 | 纯图标尺寸 | 带文字图标尺寸 |
| --- | --- | --- | --- | --- | --- | --- |
| small | 32 | 53 | 10 | 12 | 18 | 16 |
| default | 38 | 68 | 14 | 13 | 20 | 17 |
| large | 44 | 83 | 18 | 14 | 22 | 18 |

普通取消、关闭和次级操作保持默认描边；主操作在现有调用中显式使用 filled 与 primary；危险确认使用 filled 与 danger。这些预设表达操作用途，不属于待清理的灰色覆盖。

HyperNumberStepper 的加减、HyperPagination 的上一页和下一页只指定图标、small 尺寸及可用回调，使用 HyperButton 默认外观；只读与边界由回调为空触发按钮默认禁用态，不额外指定 color 或 backgroundColor。不要恢复 selection 灰底或重复计算正常／禁用颜色。

## 各组件的样式与功能基线

以下源码文件均位于 ui/lib/src/components/。表中的默认值是需要保留的实现基线；完整参数以链接页和源码签名核对，不能据此扩展不存在的 API。

### 基础、容器与列表

| 组件与文档 | 实现文件 | 当前样式与功能 |
| --- | --- | --- |
| [HyperText / HyperIcon / HyperIcons](../components/text.md) | hyper_typography.dart | 三档文字和图标，常用图标映射 Lucide；不要改成任意 size 字符串 |
| [HyperPressable](../components/pressable.md) | hyper_pressable.dart | 统一即时按压及长按反馈，本身不绘制背景、描边或文字 |
| [HyperImage](../components/image.md) | hyper_image.dart | provider / network / asset 三种来源；默认 cover、圆角 16；加载与错误占位；可选全屏缩放预览，范围 0.5–5；仅使用 Flutter ImageCache，不内置持久缓存 |
| [HyperAvatar](../components/avatar.md) | hyper_image.dart | 尺寸 32 / 40 / 56，默认圆形；图片失败使用文字或用户图标占位，文字最多两个字符 |
| [HyperBadge](../components/badge.md) | hyper_badge.dart | status / tag / count；tag 支持选中、点击和关闭；count 依附 child，可用 dot、max、showZero，默认 max 99 |
| [HyperDivider](../components/divider.md) | hyper_layout.dart | solid / dashed，水平或垂直，保留方向和两端缩进 |
| [HyperCard](../components/card.md) | hyper_card.dart | 默认圆角 24、内边距 12；可组合标题、说明、leading、actions、footer；footer 前使用 HyperDivider；selected 使用较实表面和主题色边框 |
| [HyperListTile](../components/list-tile.md) | hyper_list_tile.dart | auto / plain / glass；最小行高 46；auto 在 MenuGroup 或 HyperSurfaceScope 内共用外层表面；selected 保留 selection 底板 |
| [HyperMenuGroup](../components/menu-group.md) | hyper_lists.dart | 圆角 18，外层绘制一次材质，内部条目由缩进分隔线分开；标题和说明在表面外，不额外包每行卡片 |
| [HyperEmptyState](../components/empty-state.md) | hyper_empty_state.dart | 可选 56 图标容器、标题、说明和 action 插槽；不替调用方创建动作或加载业务数据 |
| [HyperSkeleton](../components/skeleton.md) | hyper_layout.dart | text / card，默认 rows 3；灰色占位和动画用于加载状态，不是按钮灰底 |
| [HyperPageContentSliver](../components/page-content-sliver.md) | hyper_page_content.dart | CustomScrollView 内容 sliver；默认 padding 为 16 / 12 / 16 / 40，居中最大宽 800，不自行管理页面导航 |

### 表单与选择

| 组件与文档 | 实现文件 | 当前样式与功能 |
| --- | --- | --- |
| [HyperTextField](../components/text-field.md) | hyper_text_field.dart | EditableText 加自绘表面，圆角 20；字号 14 / 16 / 18；横向边距 14 / 18 / 20，纵向 7 / 9 / 11，textarea 纵向再加 3；保留错误、聚焦和禁用边框逻辑 |
| [HyperFormField](../components/form-field.md) | hyper_form_field.dart | label、必填星号、trailing、child、helperText、errorText；错误优先于说明，不代管输入值和表单提交 |
| [HyperCheckbox](../components/checkbox.md) | hyper_selection_controls.dart | 21 方框、圆角 7、1.5 描边；支持 tristate；无标签交互区 44，有标签由无卡片的 plain 列表行处理点击 |
| [HyperRadio](../components/radio.md) | hyper_selection_controls.dart | 21 圆环，未选描边 1.5、选中描边 6；value / groupValue；有标签由整行点击，无标签独立可交互时保留 44 触摸区 |
| [HyperSwitch](../components/switch.md) | hyper_selection_controls.dart | 52×32 轨道，自绘滑块；关闭背景由 controlTrack 合成；标签行与独立控件分别处理交互，不能把关闭色当按钮覆盖删除 |
| [HyperSlider](../components/slider.md) | hyper_selection_controls.dart | 6 高轨道、20 滑块、44 交互高度；默认范围 0–100；divisions 控制离散取值；点击及拖拽保留开始、变化、结束回调；RTL 反转方向 |
| [HyperNumberStepper](../components/number-stepper.md) | hyper_number_stepper.dart | 受控整数，默认 min 0、max 99、step 1；圆角 16、subtle 表面、内边距 3、数值区最小宽 36；加减使用默认 small 图标按钮，结果收敛至上下限 |
| [HyperSegmentedControl](../components/segmented-control.md) | hyper_segmented_control.dart | 默认等宽；外圆角 18、内边距 4、项高 32；等宽平移一个选中底板，非等宽过渡背景；单项与整组禁用分别保留 |
| [HyperSelect](../components/select.md) | hyper_select.dart | single / multiple；字段与 Dropdown 共用；底部选项行最小高 52，保留单选圆点／多选勾选；单选点选返回，多选按确定提交 |
| [HyperDropdown](../components/dropdown.md) | hyper_dropdown.dart | 锚定菜单；自动按最长文字加占位测宽，默认限制 160–240 并服从父级；菜单匹配字段宽，默认最大高 320；选项复用 HyperListTile |
| [HyperPicker](../components/picker.md) | hyper_picker.dart、hyper_wheel_picker.dart | 底部滚轮，筛除禁用项；默认初始索引 0，面板内滚轮高 200、项高 40；按确定返回，控制器随面板释放 |
| [HyperDatePicker](../components/date-picker.md) | hyper_date_picker.dart | date / time / range；默认日期范围 1900-01-01 至 2100-12-31；日期和区间用月历，时间用滚轮，底部宿主为 ActionSheet；临时选择按确定后返回 |
| [HyperCalendarDay / HyperCalendarItem](../components/calendar-day.md) | hyper_calendar_day.dart | 选中实心圆、今日描边、相邻月和禁用弱化、区间背景；小／默认／大基础行高 20 / 42 / 48，并按字体放大扩展；附属条目最多三行，溢出数量单独占最后一行 |
| [HyperCalendarMonth](../components/calendar-month.md) | hyper_calendar_month.dart | 固定六行七列，默认周一开始；复用日期格，支持起止日期、范围、强调日期和点击；readOnly 使用 CustomPainter 合并绘制整月，仍保留选中及今日样式 |
| [HyperUploader](../components/uploader.md) | hyper_uploader.dart | 内部管理文件项与请求生命周期；默认最多 9 个、每个 10MiB；外部注入 pick / upload；缩略项宽 104、图片 90×72，添加格 104×136；保留取消、重试和错误展示 |

### 导航与动作

| 组件与文档 | 实现文件 | 当前样式与功能 |
| --- | --- | --- |
| [HyperNavBar / HyperNavBarScrollScope](../components/nav-bar.md) | hyper_nav_bar.dart 及两个同名前缀 part 文件 | 默认 custom、高 44、水平边距 16、顶部 SafeArea；固定形态使用现有返回／更多／保存；顶部透明，滚动下方内容时显示渐隐背景，不增加底部分隔线 |
| [HyperTabs](../components/tabs.md) | hyper_navigation.dart、hyper_tab_controller.dart | 默认项区高 48，加表面内边距后为 54；胶囊选中块，支持 scrollable 和页面联动；pages 默认高 180；外部 selectedIndex 与初始索引的职责分开 |
| [HyperTabBar](../components/tab-bar.md) | hyper_tab_bar.dart | single / multiple，默认 multiple，高 56；multiple 默认 margin 为 20 / 8 / 20 / 0，single 为零；自身处理底部安全区；拖动预览、松手提交，与点击共用选择出口；不提供整体或单项禁用状态 |
| [HyperPagination](../components/pagination.md) | hyper_pagination.dart | page 从 1 开始，空数据为 page 0 / pageCount 0；默认 maxVisiblePages 5；水平可滚动，首尾和省略号按范围呈现；上下页为默认 small 图标按钮，数字项保留专用选中态 |
| [HyperSlideMenu](../components/slide-menu.md) | hyper_slide_menu.dart | 逻辑 start / end 操作区，默认每项宽 64、圆角 18；保留跟手、越界阻尼、速度投影与弹簧；展开时屏蔽正文操作，点击操作先收起再通知调用方 |
| [HyperActionSheet](../components/action-sheet.md) | hyper_action_sheet.dart | show 展示自定义内容，choose 展示 HyperAction 列表；圆角 30、内边距 16、最大高为键盘避让后可用高度的 85%；选中、禁用、危险色和取消按钮分别保留 |
| [HyperDrawer](../components/drawer.md) | hyper_drawer.dart、hyper_drawer_surface.dart | show 为模态入口，正文 contentBuilder；默认 start、宽 320，窄屏最大窗口宽减 56；贴边全高、实色背景，无外侧留白／圆角／描边／卡片阴影；正文默认零间距，安全区在背景内部；固定标题／页脚、滑动关闭；自带滚动内容设 scrollable: false |
| [HyperPopover](../components/popover.md) | hyper_popover.dart | visible / onClose 由调用方控制；child 只提供锚点，由自身操作触发；默认宽 180，maxWidth 280 仅限制上限；保留锚定浮层样式 |
| [HyperPopupMenu](../components/popup-menu.md) | hyper_popover.dart | 默认更多图标按钮，enabled 控制打开；菜单自动测宽 160–240，菜单项复用 HyperListTile；危险、禁用和 selected 状态保留 |
| [HyperSteps](../components/steps.md) | hyper_navigation.dart | 默认 horizontal，支持纵向步骤；current 控制当前进度，完成线、未完成轨道和步骤标签是专用状态绘制 |

### 反馈与组合展示

| 组件与文档 | 实现文件 | 当前样式与功能 |
| --- | --- | --- |
| [HyperToast](../components/toast.md) | hyper_feedback.dart | root Overlay，默认显示 2 秒、距底 96、宽 180–420、圆角 18；色调对应图标／边缘；动作先关闭提示再回调，内部防止重复移除 |
| [HyperDialog](../components/dialog.md) | hyper_feedback.dart | confirm 返回 bool?；两侧留白 24、最大宽 420、圆角 26、内边距 18；canConfirm 为 false 保持打开；取消默认按钮，确认按普通／危险语义配色 |
| [HyperLoading](../components/loading.md) | hyper_feedback.dart | 小／默认／大加载环尺寸 18 / 24 / 32；during 通过遮罩等待外部任务，在 finally 中移除浮层，不能吞掉任务结果或异常 |
| [HyperProgress](../components/progress.md) | hyper_navigation.dart、hyper_progress_painters.dart | linear / circular；轨道高 4 / 6 / 12，圆形尺寸 48 / 64 / 80；确定进度归一化至 0–1，不定进度不显示百分比；与按钮共用自绘环／轨道 |
| [HyperTooltip](../components/tooltip.md) | hyper_tooltip.dart | 默认 hoverDelay 500ms、maxWidth 240、圆角 12；保留悬停、聚焦、触摸长按与退出生命周期，不在调用方重新写一套浮层 |
| [HyperNoticeBar](../components/notice-bar.md) | hyper_notice_bar.dart | 圆角 16、主题色浅底和边框；默认速度 28；短文字静止，长文字循环，按住或减少动画时暂停；关闭按钮保留透明底和主题色 |
| [HyperUpdateDialog](../components/update-dialog.md) | hyper_update_dialog.dart、hyper_update_dialog_content.dart、hyper_update_models.dart | 受控更新状态；最大宽 420、外边距 20、圆角 28、内边距 24；正文滚动、底部操作固定；关闭、取消、稍后使用默认按钮，主操作遵循当前状态 |
| [HyperCarousel / HyperPageIndicator](../components/carousel.md) | hyper_carousel.dart | 默认高度 180、圆角 16、初始页 0；多页时可显示指示器；自动播放需显式传间隔，触摸、滚动中或减少动画时暂停；指示点保留 7 / 18 的选中宽度变化 |
| [HyperCollapse](../components/collapse.md) | hyper_business.dart | 圆角 20，initiallyExpanded 默认 false；展开后保留子树状态，收起时关闭焦点和点击并暂停子树动画；高度和透明度同步变化 |
| [HyperTimeline](../components/timeline.md) | hyper_business.dart | 按传入 items 绘制图标、连线、标题、说明和时间；complete 决定状态色，组件不推进业务流程 |

### 工具与数据模型

HyperOption / HyperSegmentOption / HyperAction / HyperSlideAction 分别描述选项与操作；不内置业务请求。HyperUiTone 的公开值为 neutral / primary / success / warning / error / info，HyperUiToneResolver.color(tokens) 将其映射为主题色；不要与 HyperButton 的 colorStyle 值混用。

HyperTimeOfDay 表示小时与分钟并提供 HH:mm 格式化；HyperDateRange 表示起止日期；HyperCalendarItem 只包含展示文字与可选颜色。HyperUpdateRelease / HyperUpdateDownloadProgress 是纯展示模型；后者总大小未知时 fraction 为 null，大小、速度和剩余时间由共用格式工具计算。

| 类型 | 当前用途和约束 |
| --- | --- |
| HyperNavBarTypes | 固定值 custom / backOnly / titleOnly / backWithTitle / more / edit；固定形态与 custom 插槽规则分开 |
| HyperTabItem | 只保存 icon 与 label；选中索引和页面内容由宿主提供 |
| HyperDrawerPlacement | start / end 逻辑方向，RTL 自动换边 |
| HyperTimelineItem / HyperStep | 时间线／步骤的展示数据，不代替业务流程状态机 |
| HyperFilePicker / HyperFileUpload | 注入文件选择和上传函数；不绑定具体平台或网络库 |
| HyperUploadSource | gallery / camera / file；Uploader 默认只展示 gallery 与 camera |
| HyperUploadStatus | ready / uploading / success / error |
| HyperUploadFile / HyperUploadItem | 文件 ID、名称、字节与文件项状态；initialItems 只作组件初始状态，不是实时受控列表 |
| HyperUploadCancellation | 取消令牌；适配器通过 isCancelled 检查取消，组件在移除和销毁时调用 cancel |
| HyperUpdateStatus | 只描述更新面板当前展示状态，具体值见后文状态约束 |

utils/hyper_utils.dart 提供 HyperScreen、HyperKeyboard、HyperSafeArea、HyperRoute、HyperThemeController。HyperScreen 默认设计宽 375，dp 缩放限制为 0.75–1.4，rpx 按宽度 / 750；其余工具分别包装键盘、SafeArea、路由和主题通知。控制器由调用方持有和释放，不引入全局可变主题。

## 已有专用样式保留清单

这张清单记录当前实现及修改边界，不是批量替换计划。明确保留的项不能因“减少自定义代码”自动改为默认按钮；待判断项维持现状，改变前向用户确认。

| 位置 | 当前独立样式或组合 | 修改边界 |
| --- | --- | --- |
| HyperNavBar 返回、更多按钮 | HyperButton 加 surfaceStrong 背景，用于固定导航样式与两端对齐 | 用户已明确要求保留 |
| HyperNoticeBar 关闭按钮 | small 图标按钮，透明背景、主题色前景 | 用户已明确要求保留；不随普通按钮一起清理 |
| HyperTextField._AffixButton | HyperPressable、6 内边距、18 图标；清空与密码可见性切换 | 用户已要求保留；直接改默认按钮会改变输入框内部布局与描边 |
| HyperToast 的 actionLabel | HyperPressable 加文字，继承提示色调 | 用户已要求保留；改默认按钮会新增背景、边框和尺寸约束 |
| HyperBadge 的关闭区 | 20 方形点击区、14 图标，跟随标签前景色 | 用户已要求保留；默认 small 图标按钮为 32，会改变标签尺寸 |
| HyperPagination 数字页码 | 最小宽 32、高 32、圆角 11，当前页使用 selection 和主题色 | 用户已要求保留；当前页是选中展示，不等价于普通按钮禁用态 |
| HyperImage 预览关闭按钮 | HyperButton 加 foreground 与 surfaceStrong，位于图片预览上方 | 当前保留；移除背景和颜色覆盖前确认 |
| HyperUploader 删除按钮 | small 图标按钮加 surfaceStrong，叠在缩略图右上方 | 当前保留；移除背景前确认 |
| HyperSelect 选项行与标记 | 自绘行、单选圆点和多选方框，非 HyperRadio / HyperCheckbox 的整项复用 | 复用候选，尚未批准替换；需要核对尺寸、点击区域与选中行为 |
| HyperUploader 添加文件格 | 104×136 HyperGlass 点击格，包含图标和文字 | 是上传网格入口；替换成按钮会改变网格，先确认 |
| HyperTabBar single 入口 | 56 的自绘浮动入口，加角标与自身安全区 | 属于底栏组件形态；不能仅因外形圆形就替换为默认图标按钮 |
| HyperCalendarDay 角标和条目 | 紧凑文字角标、最多三行条目及溢出行；条目 10 号字、1.2 行高、垂直内边距合计 2、行间距 2 | 日历布局专用；改为 HyperBadge 等组件需先确认空间与文本规则；宿主以 minimumHeight 预留容量 |
| HyperSlideMenu 操作区 | 填满侧滑区的文字／图标、危险或自定义操作色 | 不是独立胶囊按钮，不能替换导致露出背景或改变操作区宽高 |
| Tabs、SegmentedControl、PageIndicator、Slider、选择控件 | 自绘选中块、轨道、圆环、圆点和标记 | 属于组件核心视觉，按各自状态规则保留 |
| 按钮预览中的自定义 color | buttons_example.dart 的“自定义颜色覆盖”示例 | 用于演示公开 API，不当作组件内部多余覆盖删除 |

## 状态与生命周期不能随样式整理改变

- 受控与内部状态分开：Stepper、Pagination、TabBar 的业务值由调用方传入；Carousel 的当前页、Collapse 的展开、Uploader 的文件项由组件维护；Tabs 支持初始值和外部选中索引。不能统一改成全受控或全内部状态。
- 共有默认行为：Checkbox 标签行的方框只占 21；Card 选中边框使用完整主题色；ListTile 的 leading 间距为 12、trailing 间距为 8；Tabs 重复点击当前项不通知值变化；Button 的主体插槽命名为 content。
- TextField 的长度限制与计数使用用户可见字符；Android 当前按 UTF-16 处理，分段对齐作为独立专项。Flutter Toast 的零时长会立即关闭，Android 的零时长保留不自动关闭语义；默认文字操作两端均先关闭提示再回调。
- HyperText 有 maxLines 时默认省略号；Android 显式 overflow 可覆盖。Android 的 Popover / SlideMenu / Tabs 保留受控宿主形式，不照搬 Flutter 内部状态或控制器；缺失组件及日期时间／区间入口只列能力缺口，不自动新增。
- Android Dropdown 在展开后被禁用或移除回调时自动收起，该行为保留；Flutter 当前没有对应自动收起分支，不据此删除 Android 的收起处理。
- 输入框可代管未传入的 controller / focusNode，只释放自己创建的对象；显式 readOnly，或 value 已传入但 onChanged 为空时，保持只读。不要为了可点击而补空回调。
- Slider 的 readOnly 保留正常展示并停止修改；按钮 onPressed 为空进入禁用态；CalendarMonth 的 readOnly 改走整月合并绘制。这些状态含义不同，不能统一成一层灰色或透明度。
- 取消选择器、日期面板或多选面板时，不提交临时选择。showHyperModal 等待退出路由完成后返回；不能提前销毁仍参与退出绘制的内容与控制器。
- Uploader 保留 ready / uploading / success / error；选择后自动调用注入的 upload，按文件 ID 防重复请求并限制数量和大小，移除及销毁时取消令牌，忽略已取消任务的后续结果。底层传输是否真正取消由适配器观察令牌实现。
- UpdateDialog 接收 idle / checking / available / upToDate / downloadQueued / downloading / readyToInstall / installing / completed / error，idle 不显示内容。检查、下载和安装由业务回调驱动；show 不允许点遮罩关闭，强制更新和安装中限制退出操作，不把预览模拟服务放进库。
- 锚定浮层退出后再移除，收起期间不继续接收操作；Drawer 使用 dismissOnClickOutside / dismissOnBackPress / gesturesEnabled 分别控制遮罩、返回键与滑动关闭；向外超过宽度 30% 或速度达 400 时关闭，否则 180ms 复位。面板以 280ms 从自身宽度之外平移，遮罩独立淡入。
- NavBarScrollScope 只跟踪 depth 为 0 的竖向主视口，滚动超过 0.5 判断正文经过导航；scrollKey 改变时重置。NavBar 将显式 scrolledUnder 与作用域状态合并，160ms 显示背景，向下延伸 56 渐隐且不占位、不拦截触摸；高对比时改为不延伸的实底，减少动画时直接切换。
- 两端导航背景均从屏幕顶部覆盖状态栏，安全区在背景内部，只有标题与按钮避让。Android 文档预览注入模拟系统 Insets，导航与正文共用同一来源；不得把模拟留白放到整个导航栏外部，也不得在正文重复累加。
- 保留现有 RTL、字体缩放、键盘焦点及减少动画处理；不为统一外观删掉这些分支。仅交互用途的 HyperPressable 不等价于自定义按钮样式。

## 两端对齐与维护验证

对应 Compose 仓库当前实际目录为 D:/my_project/android_project/hyper-ui。按对应组件同步默认布局、尺寸、按钮类型、状态展示、业务参数及回调语义；找不到对应组件时先说明，不能自动新增整套另一端实现。

预览以本仓库为视觉基准：手机外框、背景、安全区、分组顺序、文案、图标、尺寸、间距和状态一致，不额外加标题、控制项或计数。完整页面的底栏使用 Scaffold.extendBody 与 bottomNavigationBar，正文 SafeArea 显式 bottom: false；底栏边距与安全区交给 HyperTabBar，滚动末尾只取一次 Scaffold 注入的 bottom padding。示例参见[共用悬浮宿主](../components/tab-bar.md#悬浮页面宿主)与[业务接入规则](./consumer-integration.md)。

完成修改后，核对默认、禁用、只读、选中、加载、边界和取消行为中实际受影响的部分。按现有环境执行格式检查与必要静态分析；不新增单元测试或一次性报告，不自动安装依赖、启动部署或保留临时验证产物。组件页保留完整参数表，公开 API 变化同步 catalog.ts、公开入口、真实示例和本文。不能只修改预览制造“已经修复”的外观。
