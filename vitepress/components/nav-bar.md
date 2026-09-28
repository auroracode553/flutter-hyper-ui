---
title: HyperNavBar
description: 44px 透明导航栏
---

<ComponentDoc component-id="nav-bar" />

## 页面导航

`HyperNavBar` 默认高度为 **44px**（不含状态栏），默认左对齐，与正文共享 16px 起始边距。导航容器不绘制背景、模糊、边框或阴影；自定义插槽可以自行渲染所需内容。副内容不自动增加高度，需要较大字号或更高的插槽时，显式设置 `height`。

交互示例使用 Flutter 布局基底。手机安全区由预览宿主提供。

实际页面可以用 `Column` 固定导航栏，并让滚动内容占据剩余空间：

```dart
Column(
  children: <Widget>[
    const HyperNavBar(title: Text('今日灵感')),
    Expanded(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList.builder(
              itemCount: 30,
              itemBuilder: (_, index) => HyperListTile(title: '灵感 $index'),
            ),
          ),
        ],
      ),
    ),
  ],
)
```

`Expanded` 为导航栏下方的滚动内容提供剩余空间。

## 破坏性变更

- 移除 `opaque` 和 `floating`，导航栏始终透明；需要玻璃面板时由页面单独组合 `HyperGlass`。
- 原先 56px / 带副标题 68px 的高度统一改为 44px；可通过 `height` 显式增加。
- 默认返回按钮使用透明的 `HyperButton.ghost`，保持 44px 点击区域。
- `title` / `subtitle` 从字符串改为可选的 `Widget`，原先 `title: '标题'` 改为 `title: Text('标题')`。

## 自定义插槽

`leading`、`title`、`subtitle`、`trailing` 全部接受任意 `Widget`。主内容可以是搜索框、品牌标识、分段控件或多个元素的组合，不必提供文字标题。`actions` 是尾部横排列表的便捷写法，与 `trailing` 二选一；不需要自动返回按钮时设置 `automaticallyImplyLeading: false`。

```dart
HyperNavBar(
  height: 56,
  automaticallyImplyLeading: false,
  leading: const HyperAvatar(text: '林', size: 'small'),
  title: const Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text('工作空间'),
      SizedBox(width: 8),
      HyperBadge.tag(label: '个人'),
    ],
  ),
  subtitle: const Text('把想法留下来'),
  trailing: HyperButton.ghost(label: '编辑', onPressed: () {}),
)
```

组件仅为主副内容提供可覆盖的默认文字样式，不强制行数、字号、文字截断或内容类型。标题默认从起始侧排列，缺失前导插槽时不会额外预留空间；按需使用 `centerTitle: true` 开启整栏居中。

需要完全自主布局时使用 `child`，它接管导航栏内部的整行区域，不再生成标题布局和返回按钮。`child` 与其他内容插槽互斥；仍可配置 `height`、`padding` 和 `safeArea`。例如让搜索输入框占满导航栏：

```dart
HyperNavBar(
  height: 52,
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  child: HyperTextField(
    type: 'search',
    hintText: '搜索灵感',
    onChanged: (value) {},
  ),
)
```

超过默认高度的内容由页面设置合适的 `height`；完全自定义布局中的文字换行、截断与触控区域由调用方决定。
