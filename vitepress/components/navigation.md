---
title: 导航与菜单
description: Navbar、可拖拽 TabBar、列表、分组菜单和侧滑操作
---

<ComponentReference group-id="navigation" />

## TabBar 状态管理

`HyTabBar` 是受控组件。拖动期间组件维护指示器的展示位置，释放后通过 `onSelected` 报告最终索引；页面内容和持久选中值仍由应用管理。

```dart
HyTabBar(
  selectedIndex: selectedIndex,
  onSelected: (index) {
    setState(() => selectedIndex = index);
  },
  items: const [
    HyTabItem(icon: Icons.home_outlined, label: '首页'),
    HyTabItem(icon: Icons.explore_outlined, label: '发现'),
    HyTabItem(icon: Icons.person_outline, label: '我的'),
  ],
)
```

## MenuList 与 SlideMenu

`HyMenuList` 适合设置页和详情菜单。`HySlideMenu` 用于列表行的快捷操作；破坏性操作仍应由业务层决定是否二次确认或提供撤销。
