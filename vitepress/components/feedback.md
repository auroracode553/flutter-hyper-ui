---
title: 反馈与浮层
description: Toast、Dialog、Drawer、BottomSheet、Popover 和加载状态
---

<ComponentReference group-id="feedback" />

## Drawer 返回结果

```dart
final result = await HyDrawer.show<String>(
  context,
  title: '项目详情',
  placement: HyDrawerPlacement.end,
  width: 360,
  builder: (_) => const Text('在这里放置详情、菜单或表单。'),
  footerBuilder: (drawerContext) => HyButton.filled(
    label: '完成',
    onPressed: () => Navigator.pop(drawerContext, '已完成'),
  ),
);
if (!context.mounted) return;
if (result != null) HyToast.show(context, result);
```

- `start` / `end` 跟随文字方向；中文界面分别从左 / 右侧弹出，默认 `end`。
- `width` 默认为 360 dp，窄屏受可用宽度约束。面板避让安全区及键盘。
- 正文默认滚动，标题和底部操作区固定。使用 `ListView` 等滚动组件时设置 `scrollable: false`。
- `dismissible: false` 仅禁用点击遮罩关闭；关闭按钮和系统返回键仍然有效。`showCloseButton` 可隐藏关闭按钮。
- 在 `builder` 或 `footerBuilder` 提供的上下文中调用 `Navigator.pop` 关闭并返回结果；取消返回 `null`。
- `useRootNavigator` 默认为 `true`，嵌套导航场景可设为 `false`。
- 自动适配明暗主题和系统减少动画设置。直接使用 `HyDrawer(child: ...)` 时需提供有限高度，并通过 `onClose` 注入关闭行为。

Drawer 使用突出玻璃材质与模态遮罩；如果内容只是补充信息且不应中断当前流程，优先使用 Popover 或页面内展开。
