---
title: HyperText
description: HyperText 组件与公开 API
---

<ComponentDoc component-id="text" />

独立使用时 small / default / large 的基准字号为 12 / 14 / 18，行高为 1.4。default 在按钮、导航等插槽中继承宿主的字号、行高、字重与颜色；显式 color、fontWeight 优先。small / large 保留各自的预设排版。

```dart
const HyperText('默认文字');
const HyperText('大号文字', size: 'large');
HyperText('品牌色', color: HyperUiThemeTokens.of(context).primary);
HyperButton(onPressed: () {}, content: const HyperText('继承按钮排版'));
```
