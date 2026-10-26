---
title: HyperSectionTitle
description: 与菜单分组共用排版的独立标题。
---

<ComponentDoc component-id="section-title" />

14 字号、w700 字重，与 HyperMenuGroup 的 title 共用实现；不自动增加页面边距或卡片。

```dart
const HyperSectionTitle('通用设置');
```

## 公开 API

```dart
const HyperSectionTitle(String text, {Key? key});
```

| 参数 | 类型 | 必填 | 默认值 | 作用 |
| --- | --- | --- | --- | --- |
| text | String | 是 | — | 分组标题。 |
| key | Key? | 否 | null | Widget 标识。 |

设置页使用 HyperMenuGroup + HyperListTile 默认样式；页面垂直留白与完整分组间距分别取 HyperUiSpacing.pageVertical（12）和 sectionVertical（16）。
