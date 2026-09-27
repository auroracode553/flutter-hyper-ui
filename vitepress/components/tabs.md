---
title: HyperTabs
description: HyperTabs 组件与公开 API
---

<ComponentDoc component-id="tabs" />

`HyperTabs(tabs: [...])` 自行管理选中状态。需要联动页面时在同一构造中传 `pages: [...]`，页面区域高度可用 `pageHeight` 调整。业务要控制选中项时传 `selectedIndex` 和 `onChanged`；`tabs` 与 `pages` 都保留任意 Widget 内容。
