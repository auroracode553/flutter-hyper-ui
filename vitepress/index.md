<script setup lang="ts">
import { overviewExample } from './.vitepress/theme/examples';
</script>

# Flutter Hyper UI

Flutter Hyper UI 是一个简约风格的 Flutter UI 组件库，样式参考当前 `doc-viewer`：浅灰背景、白色卡片、细边框、蓝色主色与紧凑排版。

<DemoBlock
  title="组件概览"
  component="overview"
  :code="overviewExample"
  :height="360"
/>

## 项目结构

```text
flutter-hyper-ui/
  ui/          Flutter UI 组件库
  preview/     Flutter Web 预览应用
  vitepress/   VitePress 文档站
```

## 使用方式

在 Flutter 项目中添加本地路径依赖：

```yaml
dependencies:
  flutter_hyper_ui:
    path: ../flutter-hyper-ui/ui
```

在应用入口使用主题：

```dart
MaterialApp(
  theme: DocUiTheme.light(),
  darkTheme: DocUiTheme.dark(),
  home: const App(),
)
```
