<script setup>
import IconGallery from '../.vitepress/theme/components/IconGallery.vue';
</script>

---
title: HyIcon
description: HyIcon 组件、图标体系与 Lucide 图标集合
---

<ComponentDoc component-id="icon" />

## 在 Hy 组件中使用

接受图标参数的 Hy 组件统一接收 `IconData`，传入 `LucideIcons` 常量即可：

```dart
HyButton(
  icon: LucideIcons.download,
  onPressed: () {},
)
```

`HyIcon`、`HyIconButton`、`HyButton`、`HyListTile` 等组件的 `icon` / `leadingIcon` / `trailingIcon` 参数都遵循同一约定，并支持 `lucide_icons_flutter` 的可变字重变体（`LucideIcons.xxx100` ~ `xxx600`），需要更细或更粗的描边时可直接替换。

## 常用图标速查

| 场景 | 图标 |
| --- | --- |
| 首页 / 导航 | `LucideIcons.house`、`LucideIcons.compass`、`LucideIcons.user` |
| 操作 | `LucideIcons.plus`、`LucideIcons.trash`、`LucideIcons.pencil`、`LucideIcons.copy` |
| 反馈 | `LucideIcons.check`、`LucideIcons.x`、`LucideIcons.circleAlert`、`LucideIcons.triangleAlert` |
| 数据 | `LucideIcons.fileText`、`LucideIcons.table`、`LucideIcons.layoutDashboard`、`LucideIcons.listChecks` |
| 系统 | `LucideIcons.settings`、`LucideIcons.bell`、`LucideIcons.search`、`LucideIcons.sun` |

## 图标集合

Hy UI 的图标体系基于 [`lucide_icons_flutter`](https://pub.dev/packages/lucide_icons_flutter) 包（Lucide 开源图标库，线性描边、圆头端点，与玻璃拟态视觉一致）。在任意组件中直接引用：

```dart
import 'package:lucide_icons_flutter/lucide_icons.dart';

Icon(LucideIcons.house, size: 24)
```

下方目录收录当前依赖版本（Lucide 1.46，共 2096 个图标）的全部图标，可以按分类或名称筛选，点击图标复制 `LucideIcons.xxx` 引用。

<IconGallery />
