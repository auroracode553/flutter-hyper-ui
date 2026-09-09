<ComponentReference group-id="feedback" />

## Drawer 抽屉

<DemoBlock
  title="侧边导航与筛选抽屉"
  component="drawer"
  :height="520"
  code="HyDrawer.show(context, title: '详情', builder: (_) => const Text('抽屉内容'));"
/>

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

依赖：仅使用现有 Flutter SDK 和库内 `HyGlass`，无新增第三方依赖。
