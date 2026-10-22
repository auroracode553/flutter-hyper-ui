---
title: HyperDrawer
description: HyperDrawer 组件与公开 API
---

<ComponentDoc component-id="drawer" />

## HyperDrawerPlacement

| 值 | 作用 |
| --- | --- |
| start | 默认；LTR 从左侧展开，RTL 从右侧展开 |
| end | LTR 从右侧展开，RTL 从左侧展开 |

## 默认布局与交互

抽屉是贴边、全高的模态面板，默认从 start 侧展开，RTL 自动镜像。使用主题实色背景，面板外侧没有留白、圆角、描边或卡片阴影；系统安全区和键盘避让位于背景内部。

width 默认 320，最大为窗口宽度减 56，保留遮罩点击区。contentPadding 默认零，只影响正文；正文自行提供 ListView 时设置 scrollable: false。title 与 footerBuilder 提供固定标题和页脚。

面板在 280ms 内从自身宽度之外平移进入，遮罩单独淡入。向外滑动超过宽度 30% 或释放速度达到 400 逻辑像素／秒时关闭；未达到阈值则在 180ms 内回到展开位置。遮罩、返回键和滑动分别由 dismissOnClickOutside、dismissOnBackPress、gesturesEnabled 控制。

```dart
final result = await HyperDrawer.show<String>(
  context,
  title: '导航',
  contentBuilder: (drawerContext) => HyperListTile(
    title: '首页',
    onPressed: () => Navigator.pop(drawerContext, 'home'),
  ),
);
```
