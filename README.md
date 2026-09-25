# Hy UI · Flutter Hyper UI

开发文档通过一个 watcher 同时运行 Flutter Web 预览与 VitePress HMR，不需要手动编译或复制预览产物。完整说明见 `vitepress/guide/getting-started.md`。

面向移动端的柔光玻璃 Flutter 组件库。组件使用 `Hy` 前缀，通过 `package:flutter_hyper_ui/hy_ui.dart` 引用。

## 设计系统

Hy UI 是独立、无业务依赖的通用组件库。视觉语言以克制的半透明材质、细边缘高光、低对比阴影和胶囊选中态为核心；交互遵循按下即响应、拖拽 1:1 跟手、释放速度继承、边界柔性阻尼和减少动画适配。

- `HyUiThemeTokens`：背景、文字、品牌色和状态色等语义令牌。
- `HyGlassTheme`：玻璃表面、边缘、阴影、控件轨道、选中态和遮罩令牌，可由应用通过 `ThemeData.extensions` 覆盖。
- `HyGlass`：按 `subtle / regular / prominent / solid` 区分材质厚度；大面积浮层使用更强材质，小控件使用轻量材质。
- `HyPressable`：按钮、卡片和菜单行共享的即时按压反馈，不包含业务行为。

## 通用组件

- 导航：`HyTabBar`、`HyTabs`、`HyNavBar`、`HyDrawer`、`HyBottomSheet`。
- 操作：`HyButton`、`HySlideMenu`、`HyPopupMenu`、`HySegmentedControl`。
- 表单：`HyTextField`、`HySwitch`、`HyCheckbox`、`HyRadio`、`HySlider`、`HySelect`、`HyDropdown`。
- 数据与菜单：`HyList`、`HyListTile`、`HyMenuList`、`HyMenuGroup`、`HyCard`。
- 反馈：`HyToast`、`HyDialog`、`HyAlert`、`HyLoading`、`HySkeleton`。

所有组件均为受控或回调驱动，不读取业务状态、不内置路由名称、不依赖第三方状态管理方案。

```dart
import 'package:flutter/material.dart';
import 'package:flutter_hyper_ui/hy_ui.dart';

MaterialApp(
  theme: HyUiTheme.light(),
  darkTheme: HyUiTheme.dark(),
  home: Scaffold(
    extendBody: true,
    body: const HySoftBackground(child: YourPage()),
    bottomNavigationBar: HyTabBar(
      items: const [
        HyTabItem(icon: Icons.home_outlined, label: '首页'),
        HyTabItem(icon: Icons.person_outline, label: '我的'),
      ],
      selectedIndex: selectedIndex,
      onSelected: onSelected,
    ),
  ),
);
```

## 文档预览方案

文档采用 **VitePress + Flutter Web + 官方 DOM 多视图嵌入**。开发模式由 Vite 将 `/preview` 同源代理到 Flutter Debug 服务；默认使用 AMD 调试模块，保存 Dart 后热重启，避免 DDC 在入口阶段加载整套模块。设置 `HY_UI_PREVIEW_AMD=0` 可恢复 DDC 热重载；release 模式读取文档站自己的静态预览包。两种模式都不使用 iframe。

Dart 必须先通过 Flutter 编译。构建后的 JavaScript、CanvasKit Wasm、字体和资源可以随文档一起分发；Dart 源文件不能作为 Vue 组件直接导入。Flutter 渲染仍有首次加载成本。

## 源码结构与依赖关系

- `ui/lib/hy_ui.dart`：组件库公开入口。
- `ui/lib/hy_ui_preview_core.dart`：预览外壳所需的轻量公开入口。
- `ui/lib/src/components/`：组件实现，包括 `HyDrawer`。
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
- `tools/build-docs.mjs`：构建 release、自动同步产物并构建 VitePress，不部署。

依赖方向：文档 Demo → 视图管理 → Debug 代理或 release 静态包 → Flutter 多视图 → 按需加载的预览示例 → UI 组件。组件挂载时预热共享引擎；Flutter 外壳和真实组件各有独立首帧回调。加载界面显示当前阶段，不以固定秒数判定失败。

## 本地开发与构建

依赖由使用者自主准备。进入 `vitepress/` 后运行 `npm run dev:watch`，即可同时启动 Flutter Debug 服务与 VitePress；保存 Dart 文件会自动热重启，不生成或复制 release 产物。需要保留 DDC 热重载时，可在 Windows PowerShell 中设置 `$env:HY_UI_PREVIEW_AMD='0'` 后再运行。

最终验收时运行 `npm run build:all`。脚本自动构建 Flutter release、同步到 `vitepress/public/preview` 并构建 VitePress，不执行部署。

产物应包含 `version.json`、`flutter_bootstrap.js`、`main.dart.js`、`assets/` 和 `canvaskit/`。不要把 `preview/web/` 源码直接复制成构建产物，其中 Flutter 模板尚未展开。

部署到子路径时，Flutter 的 `--base-href` 应对应 `<文档路径>/preview/`，文档 `VITEPRESS_BASE` 应对应 `<文档路径>/`。静态资源由同一站点提供，不再使用 `VITE_PREVIEW_BASE` 或 `FLUTTER_PREVIEW_TARGET`。

开发模式下，修改 Dart 由 watcher 触发 Flutter 热重启（或通过环境变量切换为 DDC 热重载），修改 Markdown/Vue/CSS 由 Vite HMR 更新。release 静态包仅在执行 `npm run build:all` 时生成。

## 依赖清单

- 核心与预览：Flutter >= 3.32、Dart >= 3.8，预览通过本地路径依赖 `ui/`。
- 已有开发依赖：`flutter_test`、`flutter_lints`。
- 文档：Node.js 与已有 `vitepress`、`vue`，准确版本见 `vitepress/package.json`。
- watcher 与构建编排仅使用 Node.js 内置模块，未新增第三方依赖。

## 调研、使用与验收

- [成熟方案对比与重构说明](vitepress/guide/architecture.md)
- [详细手动操作与故障检查](vitepress/guide/getting-started.md)
- [组件文档](vitepress/components/catalog.md)

本地脚本必须由使用者显式启动；watcher 启动后可以自动热重载，但所有脚本都不会部署。
