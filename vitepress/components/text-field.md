---
title: HyperTextField
description: HyperTextField 组件与公开 API
---

<ComponentDoc component-id="text-field" />

## 公开用法

单行和多行输入统一使用 16 逻辑像素圆角矩形，圆角不随行数、聚焦、错误、禁用或只读状态变化。圆角沿用库内 small 圆角令牌，与选择和下拉字段保持同一轮廓体系。字号为 16、行高 1.3，水平内边距 18、垂直内边距 9；textarea 的上下内边距各为 12。普通边框宽 1，聚焦时为 1.5，错误色优先于聚焦色。

输入区使用 Flutter 文本选择手势，点击会请求键盘；Android 返回手势收起键盘而保留焦点后，再点相同位置也能重新打开。长按和拖动选择继续由框架处理；只读、受控无回调和禁用字段不唤起输入键盘。

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
