<script setup>
import IconGallery from '../.vitepress/theme/components/IconGallery.vue';
</script>

---
title: HyperIcon
description: HyperIcon 组件、图标体系与 Lucide 图标集合
---

<ComponentDoc component-id="icon" />

## 在 Hyper 组件中使用

```dart
HyperButton(
  icon: LucideIcons.download,
  onPressed: () {},
)
```

## 常用图标速查

| 场景 | 图标 |
| --- | --- |
| 首页 / 导航 | `LucideIcons.house`、`LucideIcons.compass`、`LucideIcons.user` |
| 操作 | `LucideIcons.plus`、`LucideIcons.trash`、`LucideIcons.pencil`、`LucideIcons.copy` |
| 反馈 | `LucideIcons.check`、`LucideIcons.x`、`LucideIcons.circleAlert`、`LucideIcons.triangleAlert` |
| 数据 | `LucideIcons.fileText`、`LucideIcons.table`、`LucideIcons.layoutDashboard`、`LucideIcons.listChecks` |
| 系统 | `LucideIcons.settings`、`LucideIcons.bell`、`LucideIcons.search`、`LucideIcons.sun` |

## 图标集合

```dart
import 'package:lucide_icons_flutter/lucide_icons.dart';

Icon(LucideIcons.house, size: 24)
```

<IconGallery />
