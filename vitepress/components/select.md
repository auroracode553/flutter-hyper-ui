---
title: HyperSelect
description: HyperSelect 组件与公开 API
---

<ComponentDoc component-id="select" />

单选直接传 `value` 和 `onChanged`；多选使用 `HyperSelect<T>(type: 'multiple', ...)`，传 `values` 与 `onMultipleChanged`。两种模式都接受 `options`、`label` 和 `placeholder`。

`single` 与 `multiple` 使用各自的值和回调参数；混用会报参数错误，避免传入的值被忽略。
