---
title: HyperMenuGroup
description: HyperMenuGroup 组件与公开 API
---

<ComponentDoc component-id="menu-group" />

```dart
const HyperMenuGroup({
  Key? key,
  required List<Widget> children,
  String? title,
  String? subtitle,
});

const HyperMenuGroup.sliver({
  Key? key,
  required Widget sliver,
  String? title,
  String? subtitle,
});
```

| 参数 | 作用 | 必填 | 默认值 |
| --- | --- | --- | --- |
| key | 组件标识 | 否 | null |
| children | 普通构造的分组条目，自动插入分隔线 | 普通构造必填 | 无 |
| sliver | 懒加载构造的 SliverList 或 SliverGrid | sliver 构造必填 | 无 |
| title | 分组标题 | 否 | null |
| subtitle | 分组底部说明 | 否 | null |

长列表使用 sliver 构造，直接放入 CustomScrollView.slivers。它复用普通菜单组的圆角、阴影、高对比边框和组内留白，不创建嵌套滚动，也不提前构建全部条目。调用方负责分隔线、稳定键和列表更新后的索引映射。

```dart
HyperMenuGroup.sliver(
  sliver: SliverList.separated(
    itemCount: items.length,
    itemBuilder: (_, index) => HyperListTile(
      key: ValueKey(items[index].id),
      title: items[index].title,
    ),
    separatorBuilder: (_, _) => const HyperDivider(),
  ),
)
```

分组卡片默认无外描边，采用与 HyperCard 一致的双层柔阴影；页面画布与卡片表面沿用主题不同的色阶，高对比模式保留识别边界。组内列表行共用外层表面，不重复叠加阴影，行间分隔线继续保留。


页面水平外边距由调用方统一提供。HyperListTile 的 auto、plain 与 glass 行均保留左右各 14dp、垂直 8dp 的内容留白，选中和未选中使用相同布局。HyperMenuGroup、HyperCard、折叠面板及弹层仅复用表面绘制，不取消行内留白；分组外框统一使用四边各 4dp 留白保护行背景边缘，不能替代选中背景内部的内容留白。独立表面的额外垂直留白仍为 3dp。
