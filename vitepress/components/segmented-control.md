---
title: HyperSegmentedControl
description: HyperSegmentedControl 组件与公开 API
---

<ComponentDoc component-id="segmented-control" />

## 交互动画

等宽布局在 260ms 内平移同一个选中底板，标签保持固定；非等宽布局使用 160ms 的背景色过渡。连续点击会从当前动画位置切换目标，RTL 布局会同步调整移动方向。系统启用“减少动态效果”时选中底板即时切换，颜色保留短过渡。
