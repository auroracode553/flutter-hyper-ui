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

单项模式仅显示 `icon`，`label` 保留为导航项定义。多项模式使用默认的 `type: 'multiple'`，支持点击和横向拖动选择。选中块以 160 毫秒移动到目标项；不执行水珠膨胀、弹簧回弹或矩阵折射绘制。

## 多项布局

多项底栏按内容收缩，外部使用 Align 或 Center 居中。每项默认占宽 76 逻辑像素，长标签和大字体按文字宽度加 32 逻辑像素留白扩展；总宽超出父级时服从可用宽度。底栏高度至少 56 逻辑像素，内边距为 4，选中区域随所在项宽度变化。两个短标签的底栏内容宽度为 160 逻辑像素，不再横向铺满手机屏幕。
