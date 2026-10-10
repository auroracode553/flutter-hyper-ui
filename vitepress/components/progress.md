---
title: HyperProgress
description: HyperProgress 组件与公开 API
---

<ComponentDoc component-id="progress" />

线性进度从文字方向的起始侧填充，数值变化使用短过渡。减少动画设置启用时立即更新；未知进度保留可见的静止片段。value 为 null、NaN 或无穷值时使用不定进度，有限越界值收敛到 0–1。百分比向下取整，避免四舍五入导致提前显示 100%。
