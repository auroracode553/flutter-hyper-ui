---
title: HyperCard
description: Hyper UI 卡片组件
---

<ComponentDoc component-id="card" />

卡片默认无描边，使用适中的双层柔阴影，与分组卡片和独立列表卡片共享主题令牌。页面画布使用 background，与卡片表面保持色阶差异。默认圆角、内边距和选中态保持一致，选中时保留主题色边框；高对比模式仍提供清晰边界。阴影强度随主题 shadow 变化，浮层使用独立的阴影层级。

卡片表面的默认材质、描边与阴影统一由内部 HyperGlass.card 管理，分组列表、独立列表项和折叠面板直接复用此入口，不在各组件重复配置。业务项目继续使用公开的 HyperCard 等组件。
