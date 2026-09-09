<script setup lang="ts">
import { getComponentGroup } from './.vitepress/catalog';

const overview = getComponentGroup('utilities');
</script>

# Flutter Hyper UI

Flutter Hyper UI 是面向移动端的 Hy 柔光玻璃组件库：悬浮胶囊导航、半透明高光材质、柔和阴影与分组设置菜单。完整覆盖基础、布局、表单、反馈、导航、列表、业务组件和工具。

<DemoBlock
  title="组件概览"
  component="overview"
  :code="overview.example"
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
  theme: HyUiTheme.light(),
  darkTheme: HyUiTheme.dark(),
  home: const App(),
)
```


[查看完整组件与交互示例](./components/catalog.md)

文档内所有 Demo 共用一个 Flutter Web 引擎，并通过官方 multi-view API 直接渲染到各自的 DOM 容器。路由切换只增删 FlutterView，不再刷新 iframe 或重复启动引擎。
