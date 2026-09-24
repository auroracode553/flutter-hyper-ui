---
title: 表单与选择
description: 通用输入、选择、日期和注入式上传组件
---

<ComponentReference group-id="forms" />

## Select 与 Dropdown

- `HySelect` 从底部打开选择面板，适合手机端长选项和多选任务。
- `HyDropdown` 锚定触发器展开，适合选项较少、需要保持页面上下文的场景。
- `HySegmentedControl` 适合 2–5 个互斥且文案简短的选项。

三者都只返回值，不保存业务状态。选项来自本地、网络还是缓存，由应用决定。

## 字段容器

`HyFormField` 统一排列标题、必填标记、辅助文案和错误提示，可包裹 `HyTextField`、`HyNumberStepper` 或其他输入控件。校验规则和错误状态仍由表单层管理；同一条错误文字只在字段容器或子控件中展示一次。
