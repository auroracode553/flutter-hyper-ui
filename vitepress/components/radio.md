---
title: HyperRadio
description: HyperRadio 组件与公开 API
---

<ComponentDoc component-id="radio" />

## 默认布局

圆环尺寸为 21。无标签且 onChanged 非 null 的独立控件占 44 的触摸区；onChanged 为 null 时圆环只展示，不分配独立触摸区。提供 label 时使用 plain 列表行，由整行处理点击，沿用列表行的 46 最小高度与默认排版，不叠加圆环触摸留白。标签行无卡片背景、描边和阴影，基础示例不额外包裹 HyperCard。

组合 HyperListTile 时，如果点击交给整行处理，leading/trailing 中的 HyperRadio 应省略 onChanged，无需覆盖控件大小或列表行内边距。

## 交互动画

选中圆环的颜色与粗细在 160ms 内平滑变化。连续切换选项会从当前展示状态过渡到新状态，系统启用“减少动态效果”时使用 100ms 短过渡。

## 固定玻璃与动效

圆环内部复用 Compact 固定玻璃（模糊 2 逻辑像素、折射边缘/位移 3/4 逻辑像素、阴影 1 逻辑像素）；1.5→6 逻辑像素 状态圆环仍以 160ms 过渡，不叠加第二道装饰轮廓。enabled: false 使用实色轨道且不采样、不投影。
