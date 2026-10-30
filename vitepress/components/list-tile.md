---
title: HyperListTile
description: HyperListTile 组件与公开 API
---

<ComponentDoc component-id="list-tile" />

独立卡片形态默认无描边，使用与 HyperCard 一致的双层柔阴影，通过主题卡片底色与页面画布区分层次。选中态和高对比模式保留识别边界。组内自动模式和 plain 行不额外绘制阴影。


页面水平外边距由调用方统一提供。独立 plain 行和独立 glass 行保留左右各 14dp 的行内留白；仅在 HyperMenuGroup 或已有表面作用域中复用父表面的 plain 行不叠加水平留白。列表行保留垂直 8dp，独立表面保留垂直 3dp，菜单组保留水平 14dp、垂直 4dp。
