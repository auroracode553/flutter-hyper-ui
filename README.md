# Flutter Hyper UI

一个简约风格的 Flutter UI 组件库项目，包含：

- `ui/`：Flutter package，存放主题与 UI 组件源码。
- `preview/`：Flutter Web 预览应用，按 `?component=` 渲染组件示例，供 iframe 引入。
- `vitepress/`：VitePress 文档站，展示组件说明、使用代码与 iframe 预览。

## 设计风格

项目风格参考当前 `doc-viewer`：

- 浅灰页面背景与白色卡片。
- 细边框、低投影或无投影。
- 蓝色主色，成功、警告、错误等语义色保持清晰。
- 8 / 12 / 16 的圆角体系。
- 紧凑、克制、偏工具型的排版与交互。

## 目录说明

```text
flutter-hyper-ui/
  ui/          Flutter UI 组件库源码
  preview/     Flutter Web 组件预览应用
  vitepress/   VitePress 文档站
```

## 依赖清单

Flutter 侧：

- Flutter SDK
- Dart SDK
- `flutter_lints`
- `flutter_hyper_ui` 本地路径依赖，供 `preview` 使用

文档侧：

- Node.js
- VitePress
- Vue

## 手动预览方式

以下仅作为手动执行参考：

```bash
cd D:/my_project/flutter_project/flutter-hyper-ui/preview
flutter pub get
flutter run -d chrome --web-port 4201
```

```bash
cd D:/my_project/flutter_project/flutter-hyper-ui/vitepress
npm install
npx vitepress dev .
```

VitePress 默认 iframe 预览地址为 `http://localhost:4201`。如需调整，可在启动文档时设置 `VITE_PREVIEW_BASE`。
