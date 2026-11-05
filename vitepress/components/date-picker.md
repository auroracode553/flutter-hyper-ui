---
title: HyperDatePicker
description: HyperDatePicker 组件与公开 API
---

<ComponentDoc component-id="date-picker" />

## 固定玻璃与动效

底部面板复用 [Dialog 高遮蔽玻璃](dialog.md#液态面板)，浅/深色模糊 16/8 逻辑像素，折射边缘/位移 24/48 逻辑像素、阴影 16 逻辑像素。圆角 30 逻辑像素、内边距 16 逻辑像素，显隐用时 250ms。月份切换、边界禁用和临时日期选择沿用月历逻辑。确定后通过 Navigator.pop 返回选择值，路由退出结束后 Future 完成，取消返回 null。
