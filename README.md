# Hy UI · Flutter Hyper UI

本地运行：
flutter build web --release --no-web-resources-cdn --base-href /preview/ --output ../vitepress/public/preview

面向移动端的柔光玻璃 Flutter 组件库。组件使用 `Hy` 前缀，通过 `package:flutter_hyper_ui/hy_ui.dart` 引用。

## 文档预览方案

文档采用 **VitePress + Flutter Web release 静态产物 + 官方 DOM 多视图嵌入**。浏览器从文档站自己的 `/preview/` 目录加载真实 Flutter 组件；没有 iframe，也不连接 4201、Flutter 调试服务或开发代理。

Dart 必须先通过 Flutter 编译。构建后的 JavaScript、CanvasKit Wasm、字体和资源可以随文档一起分发；Dart 源文件不能作为 Vue 组件直接导入。Flutter 渲染仍有首次加载成本。

## 源码结构与依赖关系

- `ui/lib/hy_ui.dart`：组件库公开入口。
- `ui/lib/src/components/`：组件实现，包括 `HyDrawer`。
- `preview/lib/src/examples/`：真实组件交互示例。
- `preview/lib/src/preview_catalog.dart`：演示 ID 和 Widget 映射。
- `preview/web/flutter_bootstrap.js`：release 产物的启动接口与本地 CanvasKit 配置。
- `preview/web/hy-preview.json`：预览协议清单，Flutter 构建时随 web 文件一起复制。
- `vitepress/.vitepress/theme/preview/contracts.ts`：宿主与 Flutter 接口约定。
- `vitepress/.vitepress/theme/preview/bundle-loader.ts`：资源清单、脚本和引擎加载，分阶段超时。
- `vitepress/.vitepress/theme/preview/preview-view.ts`：单个视图的创建、首帧确认、主题更新和销毁。
- `vitepress/.vitepress/theme/preview-runtime.ts`：共享引擎与文档演示注册。
- `vitepress/.vitepress/catalog.ts`：文档分类和源码引用。

依赖方向：文档 Demo → 视图管理 → 静态包加载 → Flutter 多视图 → 预览示例 → UI 组件。首帧确认通过创建视图时注入的回调返回，不使用轮询或猜测延时。

## 手动准备与查看

以下是可选手动操作说明，不会自动执行，也未提供一键构建或启动脚本。

1. 确认已有 Flutter 和文档依赖。依赖清单见下方，安装由使用者自行决定。
2. 在 `preview/` 目录手动执行 `flutter build web --release --no-web-resources-cdn --base-href /preview/ --output ../vitepress/public/preview`。构建直接写入文档预览目录，无需复制。使用标准 JS release 构建，不使用 `--wasm` 或 `flutter run` 调试产物。
3. 在 `vitepress/` 目录手动执行 `npm run dev`，打开终端输出的文档地址。只需要这一个服务。
4. 在反馈文档打开抽屉演示；独立组件画廊位于文档站 `/preview/index.html?component=drawer`。

产物应包含 `hy-preview.json`、`flutter_bootstrap.js`、`main.dart.js`、`assets/` 和 `canvaskit/`。不要把 `preview/web/` 源码直接复制成构建产物，其中 Flutter 模板尚未展开。

部署到子路径时，Flutter 的 `--base-href` 应对应 `<文档路径>/preview/`，文档 `VITEPRESS_BASE` 应对应 `<文档路径>/`。静态资源由同一站点提供，不再使用 `VITE_PREVIEW_BASE` 或 `FLUTTER_PREVIEW_TARGET`。

修改 Dart 后，重新执行同一条构建指令即可更新文档预览目录，然后刷新页面；无需复制。修改 Markdown/Vue 仍使用文档自身的更新流程。静态预览不提供 Flutter 热重载。

## 依赖清单

- 核心与预览：Flutter >= 3.32、Dart >= 3.8，预览通过本地路径依赖 `ui/`。
- 已有开发依赖：`flutter_test`、`flutter_lints`。
- 文档：Node.js 与已有 `vitepress`、`vue`，准确版本见 `vitepress/package.json`。
- 本次未新增第三方依赖，未安装依赖或修改系统环境。

## 调研、使用与验收

- [成熟方案对比与重构说明](vitepress/guide/architecture.md)
- [详细手动操作与故障检查](vitepress/guide/getting-started.md)
- [组件文档](vitepress/components/catalog.md)

按项目约束，本次仅修改源码和文档并进行只读检查，未编译、运行、打包、部署或执行测试。当前尚未生成静态预览包，最终交互与视觉效果需在使用者手动构建后验证。
