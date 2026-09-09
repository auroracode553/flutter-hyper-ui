# Hy UI · Flutter Hyper UI

面向移动端的柔光玻璃组件库。所有组件使用 `Hy` 前缀，文件使用 `hy_` 命名，入口为 `package:flutter_hyper_ui/hy_ui.dart`。

视觉参考 fast-buy-flutter 的悬浮 TabBar 和设置菜单：半透明材质、柔和高光、低饱和背景、16 / 24 / 28 dp 圆角与轻阴影。提供明暗主题、导航选中动效及减少动画适配。

## 源码结构

- `ui/lib/hy_ui.dart`：公共导出入口。
- `ui/lib/src/theme/`：色彩、主题令牌、间距和圆角。
- `ui/lib/src/components/`：基础、布局、表单、反馈、导航、列表与业务组件；按功能拆分文件。
- `ui/lib/src/utils/`：屏幕适配、路由、键盘、安全区与主题控制器。
- `preview/lib/src/examples/`：可交互示例，含模拟上传与分页失败重试。
- `vitepress/components/catalog.md`：完整组件映射、使用约定、适配接口与手动验收说明。

依赖关系：应用 → 公共入口 → 组件 / 工具 → 主题。上传适配器通过构造参数注入，不包含业务 API 或全局状态。

## 运行方式

仓库分三部分：`ui/` 是组件库本身（作为依赖被引用，无需单独运行），`preview/` 是 Flutter Web 预览应用，`vitepress/` 是文档站。文档页通过 iframe 内嵌预览应用，因此本地开发需要**同时启动下面两个服务**。

环境要求：Flutter >= 3.32（Dart >= 3.8）、Node.js >= 18（含 npm）。

### 1. 启动 Flutter 预览应用

```bash
cd preview
flutter pub get
flutter run -d chrome --web-port 4201
```

启动后访问 http://localhost:4201 ，用 `?component=` 切换示例：

- 综合示例：`atoms` 基础原子、`layout` 布局容器、`forms` 完整表单、`overlays` 反馈弹层、`full-navigation` 导航与列表、`business` 业务组件
- 单项示例：`overview` 组件概览、`buttons`、`cards`、`inputs`、`data`、`feedback`、`navigation`

例如 http://localhost:4201/?component=forms 。不带参数时默认 `atoms`；独立预览右上角可切换明暗主题。若未安装 Chrome，可改用 `flutter run -d web-server --web-port 4201` 后用浏览器打开。

### 2. 启动 VitePress 文档站

另开一个终端：

```bash
cd vitepress
npm install
npm run docs:dev
```

启动后打开终端输出的本地地址（VitePress 默认 http://localhost:5173）。文档中的 DemoBlock 在开发模式下默认内嵌 `http://localhost:4201`，请**先启动第 1 步的预览应用**，页面里的实时示例才能加载。

如需替换预览地址，可用环境变量覆盖：

```bash
# Windows PowerShell
$env:VITE_PREVIEW_BASE="http://localhost:4201"; npm run docs:dev
# macOS / Linux
VITE_PREVIEW_BASE=http://localhost:4201 npm run docs:dev
```

### 3. 生产构建（文档与预览一体）

先把 Flutter Web 构建产物放进文档静态目录，再构建 VitePress：

```bash
cd preview
flutter build web --release --base-href "/preview/"
# 将 build/web 整体拷贝到 ../vitepress/public/preview（目录不存在则新建）

cd ../vitepress
npm run docs:build      # 产物在 .vitepress/dist
npm run docs:preview    # 本地预览构建产物
```

> 拷贝目录：Windows 可用资源管理器把 `preview/build/web` 的内容复制到 `vitepress/public/preview/`；macOS / Linux 可用 `mkdir -p ../vitepress/public/preview && cp -R build/web/. ../vitepress/public/preview/`。

推送到 `main` 分支后，GitHub Actions（[.github/workflows/docs-pages.yml](.github/workflows/docs-pages.yml)）会自动完成上述构建并部署到 GitHub Pages。

### 在自己的应用中使用

```yaml
dependencies:
  flutter_hyper_ui:
    path: ../ui   # 指向本仓库的 ui/ 目录
```

```dart
import 'package:flutter_hyper_ui/hy_ui.dart';

MaterialApp(
  theme: HyUiTheme.light(),
  darkTheme: HyUiTheme.dark(),
  home: const App(),
);
```

## 组件与示例

覆盖基础原子、布局容器、表单、反馈、导航、列表、业务组件和工具八类需求。完整列表见 [组件文档](vitepress/components/catalog.md)。

预览入口支持 `?component=atoms`、`layout`、`forms`、`overlays`、`full-navigation`、`business`，以及原有按钮、卡片等示例。独立预览右上角可切换明暗主题。

## 依赖清单

核心库：Flutter >= 3.32、Dart >= 3.8；没有新增第三方运行时依赖。

现有开发依赖：flutter_test、flutter_lints。文档使用 Node.js、VitePress、Vue。

可选平台能力：由应用选择相册 / 摄像头 / 文件选择插件及 HTTP 客户端，通过 `HyFilePicker` 和 `HyFileUpload` 接入；本次没有安装依赖或修改系统权限配置。图片默认使用 Flutter 内存缓存，持久缓存可注入 ImageProvider。

## 验证状态

按项目约束仅编辑源码和文档，未运行、编译、打包、部署项目，未执行 Flutter 分析器或测试。已进行源码引用、命名、文件长度与分隔符静态检查。视觉与平台交互仍需使用者手动验证。

上传示例为显式标记的模拟适配器，核心库已实现选择入口、预览、删除、进度、重试和取消信号；实际相册权限、拍照与服务器上传由应用适配器实现。