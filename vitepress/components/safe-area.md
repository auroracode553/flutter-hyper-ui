---
title: HyperSafeArea
description: 统一按需安全区，复用顶部和底部布局
---

<ComponentDoc component-id="safe-area" />

根画布保持全面屏，只给包裹内容留出顶部或底部安全空间。Bottom 在竖屏取系统导航区与库内最小 20 的最大值，横屏不额外撑高；不包含键盘高度，不把所有页面统一加 Padding。相同方向嵌套时只消费一次安全区与最小留白。

```dart
const HyperSafeArea(child: BottomControls())
const HyperSafeArea(edge: HyperSafeAreaEdge.top, child: CustomHeader())
```

| 参数 | 类型 | 必填 | 默认值 | 作用 |
| --- | --- | --- | --- | --- |
| edge | HyperSafeAreaEdge | 否 | bottom | 选择 top / bottom |
| child | Widget | 是 | — | 需要保护的内容 |
| key | Key? | 否 | null | 框架组件身份 |

HyperSafeAreaDefaults.minimumBottomSpacing = 20，由 UI 库维护，业务不传私有高度。顶部使用当前 MediaQuery 顶部安全区；Bottom 使用系统底部安全区与未消费的竖屏最小留白，不影响普通页面的键盘避让。

| 公开值 | 类型 | 必填 | 默认值 | 作用 |
| --- | --- | --- | --- | --- |
| top | HyperSafeAreaEdge | 否 | — | 读取可见状态栏与真实顶部缺口 |
| bottom | HyperSafeAreaEdge | 否 | — | 读取真实底部系统区；竖屏另有统一最小空间 |
| minimumBottomSpacing | double | 否 | 20 | UI 库维护的竖屏最小值，横屏不应用固定撑高 |
