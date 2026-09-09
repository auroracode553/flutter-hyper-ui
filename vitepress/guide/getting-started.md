# 快速开始

## 安装依赖

Flutter 组件库位于 `ui/`，预览应用位于 `preview/`。文档站位于 `vitepress/`。

Flutter 项目依赖：

```yaml
dependencies:
  flutter_hyper_ui:
    path: ../ui
```

文档站依赖：

```json
{
  "devDependencies": {
    "vitepress": "^1.6.3",
    "vue": "^3.5.13"
  }
}
```

## 实时文档预览

先手动启动 Flutter Web 预览应用，使它监听 `4201` 端口：

```bash
cd D:/my_project/flutter_project/flutter-hyper-ui/preview
flutter pub get
flutter run -d chrome --web-port 4201
```

再手动启动 VitePress：

```bash
cd D:/my_project/flutter_project/flutter-hyper-ui/vitepress
npm install
npm run docs:dev
```

VitePress 的 DemoBlock 默认读取 `http://localhost:4201`。两个开发服务都支持各自的更新链路：

- 修改 Dart 组件或演示：由 Flutter 开发服务重新编译；embedded 模式能否热重载取决于所用 Flutter SDK，必要时刷新文档页重新载入产物。
- 修改 Markdown、Vue 或组件目录：VitePress HMR 立即更新文档。
- 切换文档页或滚动到另一个 Demo：通过 `addView` / `removeView` 管理 DOM 内的 FlutterView，不使用 iframe，也不重启引擎。
- 修改公开 Dart 构造签名：分类页直接以只读 raw module 导入 `ui/lib/src`，由 Vite HMR 同步 API 展示。

首次访问仍需下载和初始化一次 Flutter Web 引擎；同一标签页中的后续演示只创建视图，不再重复承担引擎成本。如需替换预览资源地址，可设置：

```bash
VITE_PREVIEW_BASE=http://localhost:4201 npm run docs:dev
```

## 目录维护规则

新增或调整 UI 组件时只需维护三处职责明确的内容：

1. 在 `ui/lib/hy_ui.dart` 导出真实组件源码。
2. 在 `preview/lib/src/preview_catalog.dart` 注册演示 ID 到 Widget builder。
3. 在 `vitepress/.vitepress/catalog.ts` 将组件归类，并引用上述演示 ID。

侧栏、组件总览、分类页、示例代码和源码入口都由 `catalog.ts` 派生，不再分别手写。分类页显示的公开签名直接来自 Dart 源文件，无需重复维护参数表。VitePress 启动时还会校验：所有公开 `Hy` API 均已进入目录、源码已从 `hy_ui.dart` 导出，并且每个文档演示 ID 均已注册。

## 主题

```dart
import 'package:flutter_hyper_ui/hy_ui.dart';

MaterialApp(
  theme: HyUiTheme.light(),
  darkTheme: HyUiTheme.dark(),
  home: const App(),
);
```

组件内部默认从 `ThemeData.extensions` 读取 `HyUiThemeTokens`，因此可以通过 `HyUiTheme.light(primary: yourColor)` 统一替换主色。
