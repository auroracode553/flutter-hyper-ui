# 无障碍与自适应

Hy UI 将可访问性视为组件行为的一部分，而不是示例应用额外添加的功能。

## 减少动态效果

组件读取 `MediaQuery.disableAnimations`：

- TabBar 与 SlideMenu 直接收敛到目标位置。
- Drawer 缩短或移除位移动画。
- Skeleton 停止循环扫光并保持静态占位。
- Pressable 保留状态反馈，但不强制播放明显位移。

应用无需为这些组件分别维护“无动画”版本。

## 高对比度

`HyGlass` 读取 `MediaQuery.highContrast`。启用时会使用更实的卡片背景、移除背景模糊并加强边界，以避免内容随背景变化而失去可读性。

自定义玻璃颜色时仍需确保：

- 正文与表面有足够对比度。
- 禁用态仍然可辨认，但不会比可用态更突出。
- success、warning、error 不只依靠颜色区分。

## 文本缩放

组件应放在可伸缩布局中。Hy TabBar 会根据文字缩放计算最低高度，输入框和菜单行使用最小高度而不是固定裁切。

业务页面应避免：

```dart
// 不推荐：放大文本后可能被裁切。
SizedBox(height: 48, child: Text(longText))
```

优先使用约束和自然高度：

```dart
ConstrainedBox(
  constraints: const BoxConstraints(minHeight: 48),
  child: Padding(
    padding: const EdgeInsets.all(12),
    child: Text(longText),
  ),
)
```

## RTL

方向性组件使用逻辑方向：

- `HyDrawerPlacement.start/end` 跟随 `TextDirection`。
- `HySlideMenu.startActions/endActions` 自动镜像。
- `HyTabBar` 保持业务索引顺序，同时镜像视觉位置。
- 内边距优先使用 `EdgeInsetsDirectional`。

不要根据语言手工反转业务数据列表。

## 语义与触控区域

- Tab、Radio 和 Checkbox 提供 selected/checked 语义。
- 仅图标按钮必须提供 `tooltip`。
- 自定义操作可通过 `HyPressable.semanticLabel` 添加语义名称。
- 常用触控目标建议保持至少 44–48 dp。

## 键盘与焦点

Flutter Web 和桌面环境中，输入组件沿用 Flutter 原生焦点系统。Popover 与 Dropdown 使用 `MenuAnchor`，焦点关系由触发器锚定。业务层自定义快捷键时，不应覆盖 Tab、Escape 和方向键的常规导航行为。

