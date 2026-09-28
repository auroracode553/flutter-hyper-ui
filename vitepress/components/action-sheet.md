---
title: HyperActionSheet
description: HyperActionSheet 组件与公开 API
---

<ComponentDoc component-id="action-sheet" />

自定义内容用 `HyperActionSheet.show(context, builder: ...)`；操作列表用 `HyperActionSheet.choose(context, actions: [...])`。两个入口分别约束必需参数。

操作项使用 `HyperAction(value: value, label: '删除', type: 'danger')` 标记危险操作；默认类型为 `default`。同一套 `HyperAction` 也可用于 `HyperPopupMenu`。
