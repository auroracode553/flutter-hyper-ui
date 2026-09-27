---
title: HyperTextField
description: HyperTextField 组件与公开 API
---

<ComponentDoc component-id="text-field" />

## 公开用法

普通输入用 `HyperTextField`；搜索、密码和多行输入分别用 `.search`、`.password`、`.multiline`。搜索框自带清空操作，密码框自带显隐操作；设置 `maxLength` 后自动显示计数。`prefix` 和 `suffix` 保留任意 Widget 插槽。

```dart
HyperTextField.multiline(
  maxLength: 80,
  hintText: '请输入多行内容',
)
```
