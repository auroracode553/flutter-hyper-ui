---
title: HyperTextField
description: HyperTextField 组件与公开 API
---

<ComponentDoc component-id="text-field" />

## 公开用法

统一通过 `type` 选择输入形态：`text`（默认）、`search`、`password`、`textarea`，以及使用对应键盘的 `email`、`url`、`number`、`tel`。旧的 `.search`、`.password`、`.multiline` 命名构造器已移除。

`textarea` 使用 `rows` 设置可见行数；搜索框通过 `clearable` 显示清空操作，密码框通过 `showPasswordToggle` 显示显隐操作。`maxLength` 始终限制长度，仅设置 `showWordLimit: true` 时显示计数。`prefix` 和 `suffix` 接受任意 Widget。

```dart
HyperTextField(
  type: 'textarea',
  rows: 3,
  maxLength: 80,
  showWordLimit: true,
  hintText: '请输入多行内容',
)
```
