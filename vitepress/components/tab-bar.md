---
title: HyperTabBar
description: HyperTabBar 组件与公开 API
---

<ComponentDoc component-id="tab-bar" />

## 单项入口

`type: 'single'` 用于与底部导航并排的独立操作入口，例如通知。它绘制 56px 的圆形图标按钮，并可显示数量角标；点击时始终通过 `onSelected(0)` 通知调用方。`badgeCount` 为 0 时隐藏角标，超过 99 时显示 `99+`。

```dart
HyperTabBar(
  type: 'single',
  safeArea: false,
  margin: EdgeInsets.zero,
  items: const [HyperTabItem(icon: Icons.notifications_none_rounded, label: '通知')],
  selectedIndex: 0,
  badgeCount: unreadCount,
  onSelected: (_) => openNotifications(),
)
```

单项模式仅显示 `icon`，`label` 保留为导航项定义。多项模式仍使用默认的 `type: 'multiple'`，保留原有的拖动和吸附交互。
