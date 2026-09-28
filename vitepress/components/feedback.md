---
title: 反馈与浮层
description: Toast、Dialog、Drawer、BottomSheet、Popover 和加载状态
---

<ComponentReference group-id="feedback" />

## Drawer 返回结果

```dart
final result = await HyperDrawer.show<String>(
  context,
  title: '项目详情',
  placement: HyperDrawerPlacement.end,
  width: 360,
  builder: (_) => const Text('在这里放置详情、菜单或表单。'),
  footerBuilder: (drawerContext) => HyperButton(
    label: '完成',
    onPressed: () => Navigator.pop(drawerContext, '已完成'),
  ),
);
if (!context.mounted) return;
if (result != null) HyperToast.show(context, result);
```
