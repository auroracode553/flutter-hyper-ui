---
title: 导航与菜单
description: Navbar、悬浮 TabBar、列表、分组菜单和侧滑操作
---

<ComponentReference group-id="navigation" />

## TabBar 状态管理

`HyTabBar` 是受控组件。底栏使用独立的半透明悬浮材质，静止时选中项显示灰色圆角底块和绿色图文。按住后底块膨胀成透明水珠，放大其下方的图文；拖动时水珠跟手并在边缘形变，释放后按速度吸附到最近的 tab，再收回为灰色选中块。组件通过 `onSelected` 报告最终索引；页面内容和持久选中值仍由应用管理。`activeColor` 可覆盖默认绿色。

```dart
HyTabBar(
  selectedIndex: selectedIndex,
  onSelected: (index) {
    setState(() => selectedIndex = index);
  },
  items: const [
    HyTabItem(icon: Icons.home_rounded, label: '首页'),
    HyTabItem(icon: Icons.smartphone_rounded, label: '数码'),
    HyTabItem(icon: Icons.explore_rounded, label: '发现'),
    HyTabItem(icon: Icons.person_rounded, label: '我的'),
  ],
)
```

## MenuList 与 SlideMenu

`HyMenuList` 适合设置页和详情菜单。`HySlideMenu` 用于列表行的快捷操作；破坏性操作仍应由业务层决定是否二次确认或提供撤销。
