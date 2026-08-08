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

## 手动预览

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
npx vitepress dev .
```

VitePress 的 DemoBlock 默认读取 `http://localhost:4201`。如需替换预览地址，可设置：

```bash
VITE_PREVIEW_BASE=http://localhost:4201 npx vitepress dev .
```

## 主题

```dart
import 'package:flutter_hyper_ui/doc_ui.dart';

MaterialApp(
  theme: DocUiTheme.light(),
  darkTheme: DocUiTheme.dark(),
  home: const App(),
);
```

组件内部默认从 `ThemeData.extensions` 读取 `DocUiThemeTokens`，因此可以通过 `DocUiTheme.light(primary: yourColor)` 统一替换主色。
