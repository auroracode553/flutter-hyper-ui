---
title: HyperButton
description: Hyper UI 按钮组件
---

<ComponentDoc component-id="button" />

默认使用 `HyperButton(label: '保存', onPressed: save)`。外观由 `type` 选择：`filled`（默认）、`tonal`、`outline`、`ghost`、`danger`；只传 `icon` 时自动显示圆形图标按钮，例如 `HyperButton(type: 'outline', icon: HyperIcons.back, size: 'large', onPressed: onBack)`。`child` 可接管按钮内容，`trailingIcon` 是后置图标参数。`size` 可选 `small`、`default`、`large`，同时调整高度、文字和图标；`color` 可覆盖文字或图标颜色，省略时使用主题色。

`label` 与 `child` 任选其一；同时传入会报参数错误。
