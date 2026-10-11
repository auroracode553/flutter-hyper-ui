---
title: HyperTextField
description: HyperTextField 组件与公开 API
---

<ComponentDoc component-id="text-field" />

## 公开用法

```dart
HyperTextField(
  type: 'textarea',
  rows: 3,
  maxLength: 80,
  showWordLimit: true,
  placeholder: '请输入多行内容',
)
```

与 Compose 的受控输入使用相同的 value/onChanged。传 value 时不同时传 controller 或 initialValue；value 存在且 onChanged 为 null 时只读，业务从外部修改 value 后组件同步文本与有效光标位置。Flutter 也可通过 controller 或 initialValue 使用原生文本编辑状态。
