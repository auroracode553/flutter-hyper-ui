---
title: HyNavBar
description: 44px 透明导航与全面屏滚动
---

<ComponentDoc component-id="nav-bar" />

## 全面屏页面

`HyNavBar` 默认高度为 **44px**（不含状态栏），默认左对齐，与正文共享 16px 起始边距。导航容器不绘制背景、模糊、边框或阴影；自定义插槽可以自行渲染所需内容。副内容不自动增加高度，需要较大字号或更高的插槽时，显式设置 `height`。

交互示例直接占满文档的手机屏幕，没有内层设备框或演示工具栏。在手机屏幕内向上滚动，可以看到正文从导航栏下方穿过透明导航栏，延伸到灵动岛所在的顶部区域。手机安全区由预览宿主提供，页面使用正常的 `MediaQuery` 布局。

实际页面使用 [HyNavBarPage](./nav-bar-page)，把它放在 `Scaffold.body` 中：

```dart
Scaffold(
  body: HyNavBarPage(
    navBar: const HyNavBar(title: Text('今日灵感')),
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
- 默认返回按钮使用透明的 `'ghost'`，保持 44px 点击区域。
- 全面屏滚动由独立的 `HyNavBarPage` 管理，不再依赖导航栏的材质参数。
- `title` / `subtitle` 从字符串改为可选的 `Widget`，原先 `title: '标题'` 改为 `title: Text('标题')`。

## 自定义插槽

`leading`、`title`、`subtitle`、`trailing` 全部接受任意 `Widget`。主内容可以是搜索框、品牌标识、分段控件或多个元素的组合，不必提供文字标题。`actions` 是尾部横排列表的便捷写法，与 `trailing` 二选一；不需要自动返回按钮时设置 `automaticallyImplyLeading: false`。

```dart
HyNavBar(
  height: 56,
  automaticallyImplyLeading: false,
  leading: const HyAvatar(text: '林', size: 32),
  title: const Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text('工作空间'),
      SizedBox(width: 8),
      HyBadge.tag(label: '个人'),
    ],
  ),
  subtitle: const Text('把想法留下来'),
  trailing: HyButton.ghost(label: '编辑', onPressed: () {}),
)
```

组件仅为主副内容提供可覆盖的默认文字样式，不强制行数、字号、文字截断或内容类型。标题默认从起始侧排列，缺失前导插槽时不会额外预留空间；按需使用 `centerTitle: true` 开启整栏居中。

需要完全自主布局时使用 `child`，它接管导航栏内部的整行区域，不再生成标题布局和返回按钮。`child` 与其他内容插槽互斥；仍可配置 `height`、`padding` 和 `safeArea`。例如让搜索输入框占满导航栏：

```dart
HyNavBar(
  height: 52,
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  child: HyTextField(
    hintText: '搜索灵感',
    onChanged: (value) {},
  ),
)
```

`spacing`、`titleSpacing` 和 `actionSpacing` 可分别调整左右插槽、主副内容、操作列表间距。超过默认高度的内容由页面设置合适的 `height`；完全自定义布局中的文字换行、截断与触控区域也由调用方决定。
