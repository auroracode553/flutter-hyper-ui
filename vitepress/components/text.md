---
title: HyperText
description: HyperText 组件与公开 API
---

<ComponentDoc component-id="text" />

参考 [Element Plus Text](https://element-plus.org/zh-CN/component/text) 的尺寸划分，`HyperText` 使用 `size: 'large' | 'default' | 'small'`，默认 `default`。不传 `color` 时自动读取 Hyper 主题的文字颜色，`small` 使用弱化文字色；传入 `color: Color(...)` 可直接覆盖。

```dart
const HyperText('默认文字');
const HyperText('大号文字', size: 'large');
HyperText('品牌色', color: HyperUiThemeTokens.of(context).primary);
```
