# Hyper UI · Flutter Hyper UI

开发文档通过一个 watcher 同时运行 Flutter Web 预览与 VitePress HMR，不需要手动编译或复制预览产物。完整说明见 `vitepress/guide/getting-started.md`。

面向移动端的柔光玻璃 Flutter 组件库。组件使用 `Hyper` 前缀，通过 `package:flutter_hyper_ui/hyper_ui.dart` 引用。

## 两端统一 API

Compose 与 Flutter 对应组件使用相同的业务参数名称和默认语义。两端共同维护：

| 用途 | 统一 API |
| --- | --- |
| 点击操作 | onPressed |
| 表单与选择 | value / onChanged；单选为 value / groupValue / onChanged |
| 页签与底部导航 | selectedIndex / onChanged，索引从 0 开始 |
| 分段选择 | options / selectedValue / onChanged |
| 滑块 | min = 0、max = 100、divisions = null；onChangeStart / onChangeEnd 回传数值 |
| 文本输入 | placeholder、prefix、suffix、maxLength、enabled、readOnly |
| 标题与插槽 | title、subtitle、leading、trailing、actions、footer、child |
| 按钮外观 | type 控制形态，colorStyle 控制预设配色，color 覆盖预设 |
| 更新弹窗 | status、currentVersion、release、downloadProgress、progress、message 与 onCheck / onDownload / onInstall / onRetry / onCancel / onLater / onClose |

业务参数和回调保持同名。框架布局与宿主参数使用原生类型：Compose 的 Modifier、Composable、Dp、Float，与 Flutter 的 key、Widget、double、Duration；Flutter 的 controller 和 Navigator 弹层宿主、Compose 的受控 visible/open 与内容 DSL 按框架保留。组件特有参数以源码签名和完整参数表为准。

默认按钮省略 type 和 colorStyle，显示白色描边；显式 type 仅 filled、tonal、icon，colorStyle 为 primary、success、info、warning、danger。

## 设计系统

Hyper UI 是独立、无业务依赖的通用组件库。视觉语言提供实色、柔和及清透三档表面材质，并使用细边缘、低对比阴影和胶囊选中态；交互遵循按下即响应、拖拽 1:1 跟手、释放速度继承、边界柔性阻尼和减少动画适配。

- `HyperUiThemeTokens`：背景、文字、品牌色和状态色等语义令牌。
- `HyperGlassTheme`：玻璃表面、边缘、阴影、控件轨道、选中态和遮罩令牌，可由应用通过 `HyperUiThemeData.copyWith` 覆盖。
- `HyperMaterial`：通过 `HyperUiTheme.app(material: ...)` 在 `solid / soft / clear` 间切换全应用材质，局部子树可用 `copyWith(material: ...)` 覆盖。
- `HyperPressable`：按钮、卡片和菜单行共享的即时按压反馈，不包含业务行为。

## 通用组件

- 导航：`HyperTabBar`、`HyperTabs`、`HyperNavBar`（type 支持 custom、backOnly、titleOnly、backWithTitle、more、edit）、`HyperDrawer`、`HyperActionSheet`。
- 操作：`HyperButton`、`HyperSlideMenu`、`HyperPopupMenu`、`HyperSegmentedControl`。
- 表单：`HyperTextField`、`HyperSwitch`、`HyperCheckbox`、`HyperRadio`、`HyperSlider`、`HyperSelect`、`HyperDropdown`。
- 数据与菜单：`HyperBadge`（type 为 status/tag/count）、`HyperProgress`、`HyperListTile`、`HyperMenuGroup`、`HyperCard`。
- 反馈：`HyperToast`、`HyperDialog`、`HyperLoading`、`HyperSkeleton`。

所有组件均为受控或回调驱动，不读取业务状态、不内置路由名称、不依赖第三方状态管理方案。

## 与 Compose 的样式同步

按钮配色与显示形态独立：`type` 仅支持 `filled`、`tonal`、`icon`，省略时默认白色描边；`colorStyle` 支持 `primary`、`success`、`info`、`warning`、`danger`，自定义 `color` 优先于预设配色。按钮预览展示尺寸、配色、图标、加载、禁用和通栏形态。

本项目与 `D:/my_project/Android-project/hyper-ui` 维护相同的默认视觉规则。按钮默认描边，省略 `type` 即可；显式类型仅有 `filled`、`tonal`、`icon`，主操作显式使用 `type = "filled"` 和 `colorStyle = "primary"`。

`HyperDropdown` 默认按最长选项或占位文字加 68 控件占位计算宽度，限制在 160–240，并服从父级空间；菜单匹配字段，显式 width 用于宽表单。`HyperPopover` 默认宽 180，width 可显式指定，maxWidth = 280 仅限制上限；`HyperPopupMenu` 按操作文案与图标占位自动取 160–240。两端 Dropdown、Popover 文档与预览同步展示紧凑默认值、显式宽度、长文案和可交互状态。

`HyperDialog` 两端共用窗口两侧各 24 的留白、420 的面板宽度上限、圆角 26 和内容内边距 18；窄屏按实际可用宽度收敛。

`HyperRadio` 的标签行统一处理点击，默认最小高度 46；只展示的圆环占 21，不额外撑高列表行。无标签独立交互控件保留 44 的触摸区。两端预览直接展示单选行，不叠加行间距。

对应组件的预览以本项目为视觉基准，同步手机外框、白色背景、安全区、示例分组、文案、图标、尺寸、间距和展示状态；按钮页不添加额外分组标题、开关或点击计数。

`HyperUpdateDialog` 的标识块为 40、图标 20、加载环 30。检查中隐藏版本，其他状态的版本信息直接排版；错误状态只保留页头、具体原因、重试与关闭。关闭、取消和稍后再说使用默认描边按钮。两边的组件实现、API 文档和交互示例必须一起更新。
更新面板最大宽 420、弹层安全区外间距 20、圆角 28、内容边距 24，正文滚动且底部按钮固定。Compose 与本项目的文档和 Preview 使用相同的“更新流程 / 状态预览”、2.7.3 → 2.8.0、2026.10.10、48.6 MB 和三条更新日志，状态标签与强制更新、总大小未知开关一致；关闭弹层后模拟下载继续。

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';

HyperUiTheme.app(home: const YourPage());
```

## 接入与发布

组件库的发布物就是本仓库的 `ui/` 包（包名 `flutter_hyper_ui`），通过 `package:flutter_hyper_ui/hyper_ui.dart` 引用。支持本地调试与 Git 依赖两种接入方式。

### 本地调试（推荐开发期使用）

在消费项目（如应用 App）的 `pubspec.yaml` 中通过 path 依赖指向本仓库的 `ui` 目录：

```yaml
dependencies:
  flutter_hyper_ui:
    path: ../flutter-hyper-ui/ui   # 按消费项目与本仓库的实际相对路径调整
```

- 执行 `flutter pub get` 后即可 `import 'package:flutter_hyper_ui/hyper_ui.dart';` 使用全部 Hyper 组件。
- 修改本仓库 `ui/lib` 下的组件源码后，回到消费项目热重载 / 热重启即可即时生效，无需发布。
- 版本要求：Flutter >= 3.32、Dart >= 3.8，与消费项目 SDK 约束兼容即可。

### 发布共享（推荐团队 / 多项目使用）

将本仓库推送到 Git 远程仓库（GitHub / GitLab 私有仓库等），消费项目改用 Git 依赖，并通过 tag 锁定版本：

```yaml
dependencies:
  flutter_hyper_ui:
    git:
      url: https://github.com/<org>/flutter-hyper-ui.git
      path: ui            # 包位于仓库 ui 子目录，必须指定
      ref: v0.2.0         # 发布版本时打 tag，消费端用 ref 锁定
```

版本发布流程：组件稳定后打 tag（如 `v0.2.0`），消费项目将 `ref` 指向对应 tag；日常迭代仍建议用本地 path 依赖开发，稳定后再切回 Git 依赖。两者互不冲突，`flutter pub get` 一次即可切换。

组件库定位为私有包（`publish_to: 'none'`）。若后续需要公开到 pub.dev 或接入私有 pub 源做严格版本治理，需另行调整发布策略。

## 文档预览方案

文档采用 **VitePress + Flutter Web + 官方 DOM 多视图嵌入**。开发模式由 Vite 将 `/preview` 同源代理到 Flutter Debug 服务；默认使用 AMD 调试模块，保存 Dart 后热重启，避免 DDC 在入口阶段加载整套模块。设置 `HYPER_UI_PREVIEW_AMD=0` 可恢复 DDC 热重载；release 模式读取文档站自己的静态预览包。两种模式都不使用 iframe。

Dart 必须先通过 Flutter 编译。构建后的 JavaScript、CanvasKit Wasm、字体和资源可以随文档一起分发；Dart 源文件不能作为 Vue 组件直接导入。Flutter 渲染仍有首次加载成本。

## 源码结构与依赖关系

- `ui/lib/hyper_ui.dart`：组件库公开入口。
- `ui/lib/hyper_ui_preview_core.dart`：预览外壳所需的轻量公开入口。
- `ui/lib/src/components/`：组件实现，包括 `HyperDrawer`。
- `preview/lib/src/examples/`：真实组件交互示例。
- `preview/lib/src/preview_catalog.dart`：演示 ID 和延迟加载的 Widget 映射。
- `preview/lib/src/preview_deferred_content.dart`：按当前组件加载示例并报告组件首帧。
- `preview/web/flutter_bootstrap.js`：Debug/Release 共用的多视图启动接口与 CanvasKit 配置。
- Flutter 构建生成的 `version.json`：保留在静态产物中；启动接口校验预览协议版本。
- `vitepress/.vitepress/theme/preview/contracts.ts`：宿主与 Flutter 接口约定。
- `vitepress/.vitepress/theme/preview/bundle-loader.ts`：预览脚本和共享引擎加载，按实际阶段反馈状态。
- `vitepress/.vitepress/theme/preview/preview-view.ts`：单个视图的创建、首帧确认、主题更新和销毁。
- `vitepress/.vitepress/theme/preview-runtime.ts`：共享引擎与文档演示注册。
- `vitepress/.vitepress/catalog.ts`：组件独立路由、平铺侧栏分类、场景 Demo 与真实示例源码引用。
- `vitepress/.vitepress/theme/components/ComponentDoc.vue`：单组件文档页的示例、API、约定和同类组件结构。
- `vitepress/.vitepress/theme/example-source.ts`：从 `preview/lib/src/examples/` 读取 Demo 的真实 Dart 源码。
- `tools/dev-docs.mjs`：启动两个开发服务、监听 Dart 并触发热重启或热重载。
- `tools/flutter-dependency-check.mjs`：由开发脚本调用，只读检查 UI 与预览源码的包导入是否可解析，缺包时提示手动准备依赖。
- `tools/build-docs.mjs`：构建 release、自动同步产物并构建 VitePress，不部署。

依赖方向：文档 Demo → 视图管理 → Debug 代理或 release 静态包 → Flutter 多视图 → 按需加载的预览示例 → UI 组件。组件挂载时预热共享引擎；Flutter 外壳和真实组件各有独立首帧回调。加载界面显示当前阶段，不以固定秒数判定失败。

## 本地开发与构建

首次开发或修改 Flutter 依赖后，请先在 `preview/` 目录手动执行 `flutter pub get`，它会同时解析本地 `ui/` 包的依赖，包括 `lucide_icons_flutter`。开发脚本保留 `--no-pub`，不会自行获取依赖；若包配置缺失或源码导入无法解析，会在启动服务前停止并提示处理方式。

依赖由使用者自主准备。进入 `vitepress/` 后手动运行 `npm run dev`，即可同时启动 Flutter Debug 服务与 VitePress。保存 Dart 文件会自动热重启，不生成或复制 release 产物。需要保留 DDC 热重载时，可在 Windows PowerShell 中设置 `$env:HYPER_UI_PREVIEW_AMD='0'` 后再运行。

仅编辑文档文字时可手动运行 `npm run dev:docs`，该命令只启动 VitePress，交互预览依赖已有的 `vitepress/public/preview/` 完整 release 包。缺少预览包时，Vite 可能将启动脚本请求回退为 HTML；宿主会识别该情况并提示缺少预览资源，不再误报接口缺失。

最终验收时运行 `npm run build:all`。脚本自动构建 Flutter release、同步到 `vitepress/public/preview` 并构建 VitePress，不执行部署。

产物应包含 `version.json`、`flutter_bootstrap.js`、`main.dart.js`、`assets/` 和 `canvaskit/`。不要把 `preview/web/` 源码直接复制成构建产物，其中 Flutter 模板尚未展开。

部署到子路径时，Flutter 的 `--base-href` 应对应 `<文档路径>/preview/`，文档 `VITEPRESS_BASE` 应对应 `<文档路径>/`。静态资源由同一站点提供。

开发模式下，修改 Dart 由 watcher 触发 Flutter 热重启（或通过环境变量切换为 DDC 热重载），修改 Markdown/Vue/CSS 由 Vite HMR 更新。release 静态包仅在执行 `npm run build:all` 时生成。

## 依赖清单

- 核心与预览：Flutter >= 3.32、Dart >= 3.8，预览通过本地路径依赖 `ui/`。
- 图标：`lucide_icons_flutter: ^3.1.20`，由使用者手动获取，声明见 `ui/pubspec.yaml` 与 `preview/pubspec.yaml`。
- 文档：Node.js 与已有 `vitepress`、`vue`，准确版本见 `vitepress/package.json`。
- watcher 与构建编排仅使用 Node.js 内置模块，未新增第三方依赖。

## 调研、使用与验收

- [成熟方案对比与重构说明](vitepress/guide/architecture.md)
- [详细手动操作与故障检查](vitepress/guide/getting-started.md)
- [组件文档](vitepress/components/catalog.md)

本地脚本必须由使用者显式启动；watcher 启动后可以自动热重载，但所有脚本都不会部署。
