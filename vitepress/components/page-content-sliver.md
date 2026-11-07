---
title: HyperPageContentSliver
description: HyperPageContentSliver 组件与公开 API
---

<ComponentDoc component-id="page-content-sliver" />

## 默认用法

页面只传内容，不逐页添加或覆写外边距。

```dart
CustomScrollView(
  slivers: [HyperPageContentSliver.sections(children: sections)],
)

CustomScrollView(
  slivers: [
    HyperPageContentSliver.list(itemCount: items.length, itemBuilder: buildItem),
  ],
)

HyperPageSection.column(children: [filterBar, searchField])
```

固定区和 ActionSheet 会在库内部标记已提供的留白，嵌套页面内容区复用父级边距，避免重复叠加。卡片、菜单和输入框的内部留白仍由各组件负责。

## 公开签名

```dart
const HyperPageSection({Key? key, required Widget child})
HyperPageSection.column({Key? key, required List<Widget> children})
const HyperPageContentSliver({Key? key, required Widget child, EdgeInsets padding = const EdgeInsets.fromLTRB(16, 12, 16, 40), double maxWidth = 800, double bottomObstruction = 0})
const HyperPageContentSliver.sliver({Key? key, required Widget sliver, EdgeInsets padding = const EdgeInsets.fromLTRB(16, 12, 16, 40), double maxWidth = 800, double bottomObstruction = 0})
HyperPageContentSliver.sections({Key? key, required List<Widget> children, double maxWidth = 800, double bottomObstruction = 0})
HyperPageContentSliver.list({Key? key, required int itemCount, required IndexedWidgetBuilder itemBuilder, double maxWidth = 800, double bottomObstruction = 0})
```

## 参数

| 参数 | 用途 | 必填 | 默认值 |
| --- | --- | --- | --- |
| key | Widget 标识 | 否 | null |
| child | 普通页面或固定内容区的主体 | 对应构造器是 | 无 |
| children | sections 页面分组或 Section.column 固定区子项 | 对应构造器是 | 无 |
| sliver | 直接接入按需构建的 sliver | sliver 构造器是 | 无 |
| itemCount | 列表条目数 | list 构造器是 | 无 |
| itemBuilder | 按条目索引构建内容 | list 构造器是 | 无 |
| padding | 普通与 sliver 构造器的内容留白；消费页面直接沿用默认值 | 否 | 左 16、上 12、右 16、下 40 |
| maxWidth | 滚动内容的宽屏最大宽度 | 否 | 800 |
| bottomObstruction | 固定业务控件造成的额外滚动末尾遮挡 | 否 | 0 |

HyperPageSection 不暴露边距覆盖参数，默认水平 16、垂直 12；column 子项间距为 8。滚动页面 sections 分组间距为 16，list 条目间距为 8。额外遮挡仅通过 bottomObstruction 表达，不能用它调整页面装饰留白。
