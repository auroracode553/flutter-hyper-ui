---
title: HyperCard
description: Hyper UI 卡片组件
---

<ComponentDoc component-id="card" />

```dart
const HyperCard({
  Key? key,
  Widget? child,
  String? title,
  String? subtitle,
  Widget? leading,
  List<Widget> actions = const [],
  Widget? footer,
  EdgeInsetsGeometry padding = const EdgeInsets.all(HyperUiSpacing.cardPadding),
  VoidCallback? onPressed,
  VoidCallback? onLongPressed,
  bool selected = false,
});

const HyperCard.expanded({
  Key? key,
  required Widget child,
  String? title,
  String? subtitle,
  Widget? leading,
  List<Widget> actions = const [],
  Widget? footer,
  EdgeInsetsGeometry padding = const EdgeInsets.all(HyperUiSpacing.cardPadding),
  VoidCallback? onPressed,
  VoidCallback? onLongPressed,
  bool selected = false,
});
```

| 参数 | 作用 | 必填 | 默认值 |
| --- | --- | --- | --- |
| key | 组件标识 | 否 | null |
| child | 正文，expanded 构造中占用剩余高度 | expanded 必填，普通构造可选 | 普通构造为 null |
| title | 标题 | 否 | null |
| subtitle | 副标题 | 否 | null |
| leading | 前置组件 | 否 | null |
| actions | 标题右侧操作 | 否 | 空列表 |
| footer | 固定底部内容，沿用默认分隔线 | 否 | null |
| padding | 内容内边距 | 否 | 四边 HyperUiSpacing.cardPadding（16） |
| onPressed | 点击回调 | 否 | null |
| onLongPressed | 长按回调 | 否 | null |
| selected | 选中状态 | 否 | false |

expanded 是 Flutter 的有限高度布局入口，必须放在 Expanded、具有高度的 SizedBox 或其他提供有限高度的父级中，不直接放在纵向 ListView 等无限高度区域。标题和 footer 不随正文滚动，child 可承接 ListView 或包含 Expanded 的工作区；窗口高度不足时，由业务切换为普通卡片和整体滚动布局。两种构造保持相同的默认表面与内容内边距。

```dart
Expanded(
  child: HyperCard.expanded(
    title: '设备',
    footer: HyperButton(label: '选择文件', onPressed: selectFiles),
    child: ListView.builder(
      itemCount: devices.length,
      itemBuilder: (_, index) => HyperListTile(title: devices[index].name),
    ),
  ),
)
```

卡片默认无描边，使用适中的双层柔阴影，与分组卡片和独立列表卡片共享主题令牌。页面画布使用 background，与卡片表面保持色阶差异。默认圆角、内边距和选中态保持一致，选中时保留主题色边框；高对比模式仍提供清晰边界。阴影强度随主题 shadow 变化，浮层使用独立的阴影层级。

卡片表面的默认材质、描边与阴影统一由内部 HyperGlass.card 管理，分组列表、独立列表项和折叠面板直接复用此入口，不在各组件重复配置。业务项目继续使用公开的 HyperCard 等组件。
