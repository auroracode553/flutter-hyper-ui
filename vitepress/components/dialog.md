---
title: HyperDialog
description: HyperDialog 组件与公开 API
---

<ComponentDoc component-id="dialog" />

## 表单校验

canConfirm 是可选的提交前校验回调。返回 false 时保持弹窗，可结合 FormState.validate 展示输入错误；未传入时按默认行为返回 true 并关闭。自定义正文中的键盘提交动作可以在校验通过后返回确认结果，正文控制器应在 confirm 返回后释放。

## 宽度与布局

与 Compose 共用两侧各 24 的窗口留白和 420 的面板宽度上限，实际面板不超过 min(420, 窗口可用宽度 − 48)。例如可用宽度 350 时面板不超过 302，320 时不超过 272；正文只填充面板内部。默认圆角 26、内容内边距 18。

## 交互动画

对话框在 250ms 内居中轻缩放淡入淡出，背景遮罩同步变化。系统启用“减少动态效果”时关闭缩放，仅保留 100ms 的透明度过渡。
