---
title: HyperCheckbox
description: HyperCheckbox 组件与公开 API
---

<ComponentDoc component-id="checkbox" />

## 默认布局

提供 label 时使用无背景、无卡片描边和阴影的 plain 标签行，点击由整行处理；组件与基础示例不自动包裹 HyperCard。无标签时直接展示复选控件及原有触摸区。选中、三态和禁用逻辑保持一致。

## 交互动画

选中背景在 160ms 内过渡，勾选标记同步轻缩放淡入淡出；快速切换沿用当前进度。系统启用“减少动态效果”时保留颜色与透明度过渡，关闭缩放。
