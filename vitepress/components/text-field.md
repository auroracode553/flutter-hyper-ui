---
title: HyTextField
description: HyTextField 组件与公开 API
---

<ComponentDoc component-id="text-field" />

## 公开用法

`HyTextField` 使用 `type` 选择输入形态：`text`（单行）、`search`（搜索）、`password`（密码）和 `textarea`（多行）。多行高度由 `rows` 控制，密码显隐由 `showPasswordToggle` 控制，`maxLength` 与 `showCounter` 用于字数限制和计数展示。

```dart
HyTextField(
  type: 'textarea',
  rows: 3,
  maxLength: 80,
  showCounter: true,
  hintText: '请输入多行内容',
)
```
