---
title: HyNavBar
description: 44px 透明导航与全面屏滚动
---

<ComponentDoc component-id="nav-bar" />

## 全面屏页面

`HyNavBar` 默认高度为 **44px**（不含状态栏），始终不绘制背景、模糊、边框或阴影。副标题不再自动增加高度；需要较大字号或更高的操作区时，显式设置 `height`。

交互示例直接占满文档的手机屏幕，没有内层设备框或演示工具栏。在手机屏幕内向上滚动，可以看到正文从导航栏下方穿过透明导航栏，延伸到灵动岛所在的顶部区域。手机安全区由预览宿主提供，页面使用正常的 `MediaQuery` 布局。

实际页面使用 [HyNavBarPage](./nav-bar-page)，把它放在 `Scaffold.body` 中：

```dart
Scaffold(
  body: HyNavBarPage(
    navBar: const HyNavBar(title: '今日灵感', centerTitle: true),
    slivers: [
      SliverPadding(
        padding: const EdgeInsets.all(16),
        sliver: SliverList.builder(
          itemCount: 30,
          itemBuilder: (_, index) => HyListTile(title: '灵感 $index'),
        ),
      ),
    ],
  ),
)
```

初始顶部留白由 `HyNavBarPage` 自动添加，并随正文滚动。不要再在外层包顶部 `SafeArea`、设置 `appBar`，或在正文外添加固定的顶部 `Padding`，否则滚动视口会被限制在导航栏下方。单独将 `HyNavBar` 放入 `Scaffold.appBar` 仍可用于普通占位导航。

## 破坏性变更

- 移除 `opaque` 和 `floating`，导航栏始终透明；需要玻璃面板时由页面单独组合 `HyGlass`。
- 原先 56px / 带副标题 68px 的高度统一改为 44px；可通过 `height` 显式增加。
- 默认返回按钮使用透明的 `HyButtonVariant.ghost`，保持 44px 点击区域。
- 全面屏滚动由独立的 `HyNavBarPage` 管理，不再依赖导航栏的材质参数。
