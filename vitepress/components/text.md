---
title: HyperText
description: HyperText 组件与公开 API
---

<ComponentDoc component-id="text" />

独立使用为 14 号文字、行高 1.4；在按钮、导航等插槽中继承宿主字号、行高、字重与颜色。显式 color、fontWeight 优先，不提供尺寸档位。

```dart
const HyperText('默认文字');
const HyperText('大号文字');
HyperText('品牌色', color: HyperUiThemeTokens.of(context).primary);
HyperButton(onPressed: () {}, content: const HyperText('继承按钮排版'));
```
