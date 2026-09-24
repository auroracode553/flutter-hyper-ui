# UI 组件样式修复 + 文档示例全量补全计划

## Context

上一轮修复了 `HyTextField` 轮廓不可见的问题（`edgeHighlight` 白边贴白底 → 改用 `tokens.input`）。本轮在此基础上：

1. **UI 组件同类样式问题**：审计发现 `HyButton` outline 变体、`HyCheckbox` 未选中框、`HySwitch` 轨道描边、`HyListTile` 默认 leading 容器存在同类"轮廓弱/不可见"问题。
2. **文档示例不全**：组件文档的交互示例来自 preview 应用的 `ComponentExample` 类。标杆 `TextFieldComponentExample` 用 `_label('xx')` 分组列出了 9 个功能场景，而其余约 55 个组件示例大多只有 1 个最简用法，禁用态、变体、回调、插槽等功能点未演示。

**文档链路（已确认，无需改动 Vue 层）**：
- `vitepress/.vitepress/catalog.ts` → 组件条目 `preview: demo(id, title, source, height, desc, symbol)`
- `preview/lib/src/preview_catalog.dart` → `?component=id` 路由到示例类
- `vitepress/.vitepress/theme/example-source.ts` → 按 `// doc-region Symbol` 标记提取示例代码进文档
- 嵌入式预览（iframe）内部 `SingleChildScrollView` 可滚动；fluid 模式高度取 catalog.ts 的 height 值

---

## 第一部分：UI 组件样式修复（与 HyTextField 同类问题）

| # | 文件:位置 | 现状 | 问题 | 修改 |
|---|---|---|---|---|
| 1 | `ui/lib/src/components/hy_button.dart` `_HyButtonVisual.resolve`（约 L286-290） | outline 变体 border = `glass.edgeShade`（浅色 7% 黑），背景 `surfaceSubtle`（75% 白） | outline 按钮轮廓几乎不可见 | 改 `tokens.border`；禁用态 outline（约 L249-251）同步改 `tokens.border.withAlpha(110)` |
| 2 | `ui/lib/src/components/hy_selection_controls.dart` L231 | checkbox `side: BorderSide(glass.edgeShade, 1.2)` | 未选中复选框轮廓太弱 | 改 `tokens.input` |
| 3 | 同文件 L258 | switch `trackOutlineColor: edgeShade` | 轨道描边几乎不可见 | 改 `tokens.input` |
| 4 | `ui/lib/src/components/hy_list_tile.dart` L156 | 默认 leading 容器 `Border.all(edgeHighlight)` | 90% 白高光当轮廓用，浅色下不可见 | 改玻璃合成边框 `Color.alphaBlend(glass.edgeShade, glass.edgeHighlight)`（与 HyGlass 约定一致） |

不改的（有意保留）：HyButton tonal 变体的 `edgeHighlight` 白色 rim（玻璃高光美学）、`HyGlass` 合成边框（卡片是面不是控件）。存量 lint（Radio 废弃 API 等）不在本次范围。

---

## 第二部分：示例全量补全

### 模板模式（沿用 TextField 标杆）

```dart
// doc-region XxxComponentExample
class XxxComponentExample extends StatefulWidget { ... }

class _XxxComponentExampleState extends State<XxxComponentExample> {
  // 复用 TextFieldComponentExample 的 _label() 分组小标题模式：
  // _label('基础用法') / _label('禁用态') / _label('自定义插槽') ...
  // 每组 = 小标题 + 演示组件 + HyUiSpacing.lg 间距
}
// end-doc-region XxxComponentExample
```

规则：
- 每个示例覆盖该组件**全部公开构造参数的可演示组合**（对照各组件构造函数，禁用/只读/变体/语义色/尺寸/回调/插槽逐项列出）
- 保持 `// doc-region` / `// end-doc-region` 标记完整（文档代码视图依赖它）
- 主题工具类（UiColors/Spacing/Radii 等展示型示例）只做微调，不强加场景

### 分批实施（按文件）

**批次 A — 表单类 `component_form_examples.dart`（12 个示例，缺口最大）**
- SegmentedControl：受控切换、非等宽 `equalWidth: false`、带图标选项、禁用项
- Select：单选、多选、禁用项、placeholder、带 label
- Dropdown：基础、placeholder、禁用项、固定宽度、menuMaxHeight
- Checkbox：受控、三态 tristate、禁用、无标签纯控件
- Radio：互斥组、禁用项
- Switch：受控、禁用、无标签纯控件
- Slider：连续拖动、离散 divisions、min/max 范围、showValue=false、onChangeEnd 显示结果
- Rate：基础评分、只读展示、count/size 自定义
- Picker / DatePicker：补 title、initialIndex；DatePicker 若有 time 入口则补
- FilePicker：保留概念说明卡片

**批次 B — 反馈类 `component_feedback_examples.dart`（11 个示例）**
- Toast：四种 tone、带撤销操作 actionLabel、duration
- Dialog：标准确认、危险样式、无取消按钮、自定义 content
- Loading：局部加载、`HyLoading.during` 全局遮罩
- Alert：四种 tone、无标题、关闭后重建
- BottomSheet：基础、不可点外关闭、带标题
- Drawer：右例 + footer 操作 + 泛型返回值
- ActionSheet：普通/危险/禁用项
- Popover / PopupMenu：现状较全，微调
- NoticeBar：短文本静止、长文本滚动
- Skeleton：card 样式、rows 列表

**批次 C — 基础类 `component_foundation_examples.dart`（8 个）**
- Text 六层级、Icon 尺寸/无障碍、Image 占位+失败+预览、Avatar 文字/图标/圆角/尺寸、CountBadge 数字/max/dot/showZero、Badge tone×subtle、Tag 选择/关闭/语义色、Tone 色板

**批次 D — 布局+导航+复合 `component_layout/navigation/composite_examples.dart`（22 个）**
- layout：Space 方向/间距/对齐、Wrap、Grid 列数/宽高比、Divider 横纵虚实缩进、EmptyState 带 action
- navigation：NavBar 副标题/前导/操作区、TabBar 拖拽、Tabs 页面联动、Steps 横/竖、Progress 线/环/不定、ProgressBar 高度/颜色、ListTile 全状态、List 分隔、MenuList 分组、SlideMenu 双向侧滑、PullRefresh、LoadMore 终态、Sticky
- composite：SearchBar 禁用+受控、CountDown 自定义 builder、Collapse 受控回调、Timeline 事件状态
- upload_example.dart：已覆盖进度/取消/失败/重试，只补禁用态

**批次 E — 主题工具类 `component_theme_examples.dart`（11 个）**
- 展示型为主，核对后微调（如 UiThemeTokens 补全关键令牌展示）

### catalog.ts 同步

每个示例扩充后同步更新 `vitepress/.vitepress/catalog.ts` 对应条目：
- `height`：fluid 模式高度（按新增场景数估算，参考 TextField 9 场景 = 860）
- `description`：描述改为列举场景

### 不改的部分

- `ComponentDoc.vue` / `DemoBlock.vue` / `example-source.ts`（机制已满足需求）
- `preview_catalog.dart`（demo id 不变，只复用现有路由）
- `upload_example.dart` 的整体结构

---

## 验证

1. 每批次完成后跑 `flutter analyze`（ui 包 + preview 包，cwd 分别为 `ui/` 和 `preview/`）确认无新增告警
2. 用户已启动的 preview（localhost:4201）热重载后，按批次抽查 `?component=xxx` 页面场景完整性（移动端 350×680 内部可滚动，无裁剪风险）
3. VitePress（localhost:5173）抽查对应组件页：交互示例 + 展开源码（doc-region 提取）正常
4. 样式修复在浅色/深色两种主题下目视检查（预览页右上角可切换明暗）

## 执行顺序

批次 0（样式修复）→ A（表单）→ B（反馈）→ C（基础）→ D（布局导航）→ E（主题）+ catalog.ts 随各批次同步更新
