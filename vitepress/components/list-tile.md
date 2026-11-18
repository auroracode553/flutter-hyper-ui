---
title: HyperListTile
description: HyperListTile 组件与公开 API
---

<ComponentDoc component-id="list-tile" />

独立卡片形态默认无描边，使用与 HyperCard 一致的双层柔阴影，通过主题卡片底色与页面画布区分层次。选中态和高对比模式保留识别边界。组内自动模式和 plain 行不额外绘制阴影。


页面水平外边距由调用方统一提供。HyperListTile 的 auto、plain 与 glass 行均保留左右各 14dp、垂直 8dp 的内容留白，选中和未选中使用相同布局。HyperMenuGroup、HyperCard、折叠面板及弹层仅复用表面绘制，不取消行内留白；分组外框统一使用四边各 4dp 留白保护行背景边缘，不能替代选中背景内部的内容留白。独立表面的额外垂直留白仍为 3dp。
