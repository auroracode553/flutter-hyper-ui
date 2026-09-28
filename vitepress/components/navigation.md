---
title: 导航与菜单
description: Navbar、悬浮 TabBar、列表、分组菜单和侧滑操作
---

<ComponentReference group-id="navigation" />

## TabBar 状态管理

```dart
import 'package:lucide_icons_flutter/lucide_icons.dart';

HyperTabBar(
  selectedIndex: selectedIndex,
  onSelected: (index) {
    setState(() => selectedIndex = index);
  },
  items: const [
    HyperTabItem(icon: LucideIcons.house, label: '首页'),
    HyperTabItem(icon: LucideIcons.smartphone, label: '数码'),
    HyperTabItem(icon: LucideIcons.compass, label: '发现'),
    HyperTabItem(icon: LucideIcons.user, label: '我的'),
  ],
)
```
