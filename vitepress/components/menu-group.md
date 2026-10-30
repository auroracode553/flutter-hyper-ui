---
title: HyperMenuGroup
description: HyperMenuGroup 组件与公开 API
---

<ComponentDoc component-id="menu-group" />

分组卡片默认无外描边，采用与 HyperCard 一致的双层柔阴影；页面画布与卡片表面沿用主题不同的色阶，高对比模式保留识别边界。组内列表行共用外层表面，不重复叠加阴影，行间分隔线继续保留。


页面水平外边距由调用方统一提供。独立 plain 行和独立 glass 行保留左右各 14dp 的行内留白；仅在 HyperMenuGroup 或已有表面作用域中复用父表面的 plain 行不叠加水平留白。列表行保留垂直 8dp，独立表面保留垂直 3dp，菜单组保留水平 14dp、垂直 4dp。
