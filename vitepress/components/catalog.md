---
title: 组件总览
description: Hyper UI 通用 Flutter 组件目录与实时交互预览
---

<CatalogOverview />

点击操作使用 HyperButton、HyperCard 或 HyperListTile 等公开组件的 onPressed。共用按压反馈仅由库内部维护；自定义 Popover 触发内容可通过 Flutter 手势组件打开浮层，示例见 [HyperPopover](popover.md)。

Switch 保留 52×32 轨道和 28 可见圆形滑块，使用内部源码实现按压高光、高光与弹簧切换；尺寸、标签行和点击提交规则保持稳定。

Button、TabBar、Slider、Switch、Dialog 内置固定玻璃与稳定尺寸，TabBar 外缘描边与高光按 Kotlin 对齐；TabBar 栏内支持 2–5 项、栏外最多另放一个独立入口、默认左右留白 12、镜片默认可见高 48、组合间距 8，并支持整栏舒展、镜片弹性回弹与拖动回正，保留连续跟手、按压高光和弹簧吸附；弹窗保留原有内容与操作布局。完整参数表和交互示例见对应组件页。
Switch 的弹性扩张、Ambient 与拖动规则见 [HyperSwitch](switch.md)，默认测量尺寸保持 52×32/28、内侧留白 2。

Checkbox、Radio、DatePicker、Tabs、Drawer、Dropdown、Toast、Progress 与 UpdateDialog 按角色复用内部固定玻璃，尺寸与状态归属保持稳定；Tabs 与确定进度采用临界阻尼弹簧，Toast 保留退出绘制。参数与平台回退见各组件页。
