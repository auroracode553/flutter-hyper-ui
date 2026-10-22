---
title: HyperPopover
description: HyperPopover 组件与公开 API
---

<ComponentDoc component-id="popover" />

## 状态与触发

visible、onClose、child 和 content 必填。调用方持有 visible；onClose 请求调用方将其设为 false。child 只提供锚点，不再额外包一层点击区域，因此可由按钮、字段内部操作或长按决定何时打开；内容中的操作也直接更新同一个 visible。点击外部或系统返回先关闭气泡，保留当前页面。

```dart
HyperPopover(
  visible: visible,
  onClose: () => setState(() => visible = false),
  child: HyperPressable(
    onPressed: () => setState(() => visible = !visible),
    child: const HyperText('查看说明'),
  ),
  content: const HyperText('补充内容'),
)
```

## 宽度与布局

默认内容宽 180，maxWidth: 280 只限制上限；复杂内容可显式传 width: 240。最终宽度为 min(width ?? 180, maxWidth, 窗口安全区可用宽度)，短菜单不会默认撑到 280。

与 Compose 共用圆角 18、内边距 14、锚点间距 6、窗口安全边距 12 和窗口高度 40% 上限。两端预览展示补充说明、文件夹操作与较宽内容；文件夹操作使用“删除文件夹 / 详情 / 重命名”，选择后收起并显示结果。

## 交互动画

气泡从靠近锚点的一侧以 0.96 倍缩放淡入，180ms 完成；收起时沿同一路径淡出后移除。支持快速反向操作，系统启用“减少动态效果”时仅保留短淡入淡出。
