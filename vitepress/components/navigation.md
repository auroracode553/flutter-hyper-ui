---
title: 导航与菜单
description: Navbar、悬浮 TabBar、列表、分组菜单和侧滑操作
---

<ComponentReference group-id="navigation" />

## TabBar 状态管理

`HyperTabBar` 是受控组件。底栏使用独立的半透明悬浮材质，静止时选中项显示灰色圆角底块和绿色图文。按住后底块膨胀成透明水珠，放大其下方的图文；拖动时水珠跟手并在边缘形变，释放后按速度吸附到最近的 tab，再收回为灰色选中块。组件通过 `onSelected` 报告最终索引；页面内容和持久选中值仍由应用管理。`activeColor` 可覆盖默认绿色。

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

## MenuList 与 SlideMenu

`HyperMenuGroup` 适合设置页和详情菜单。`HyperSlideMenu` 用于列表行的快捷操作；破坏性操作仍应由业务层决定是否二次确认或提供撤销。
