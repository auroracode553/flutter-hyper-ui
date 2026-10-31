---
title: HyperLoading
description: 通过 type 选择十款原生加载动画，固定 2× 节奏
---

<ComponentDoc component-id="loading" />

## 使用

从 package:flutter_hyper_ui/hyper_ui.dart 导入。

```dart
// 默认随机
const HyperLoading()

// 固定样式
const HyperLoading(
  type: HyperLoadingType.wovenSignal,
  label: '加载中',
)
```

业务按加载状态决定是否渲染组件：

```dart
if (isLoading) const HyperLoading(type: HyperLoadingType.wovenSignal)
```

未指定 type（null）时，每个组件实例从十款动画中等概率随机选择一款，父级重建或 label 变化时保持当前形态。显式指定 type 时固定使用该样式；切回 null 时使用该实例保存的随机选择。组件移除后重新创建会重新随机，可能再次选中同一款。

## HyperLoadingType

```dart
enum HyperLoadingType {
  travelingPulse, wovenSignal, ribbonDuet, threeBody,
  cometExchange, photonRelay, elasticSpark, goldenHourglass,
  frequencyFins, flexRaster,
}
```

尺寸单位为 Flutter 逻辑像素，不包含可选文字。

| type | 显示样式 | 图形尺寸 | 固定 2× 周期 |
| --- | --- | --- | --- |
| travelingPulse | 行波脉冲 | 108 × 80 | 1.4 秒 |
| wovenSignal | 双弦错织 | 108 × 84 | 1.5 秒 |
| ribbonDuet | 弧带换向 | 82 × 68 | 1.6 秒 |
| threeBody | 三体协奏 | 80 × 80 | 1.7 秒 |
| cometExchange | 双彗交汇 | 104 × 84 | 1.5 秒 |
| photonRelay | 光子穿梭 | 86 × 64 | 0.825 秒 |
| elasticSpark | 磁光星芒 | 92 × 92 | 1.4 秒 |
| goldenHourglass | 流金沙漏 | 100 × 100 | 6 秒，两次翻转 |
| frequencyFins | 变频鳍片 | 82 × 66 | 1.2 秒 |
| flexRaster | 柔波光栅 | 108 × 80 | 1.3 秒 |

## 状态与绘制

每种 type 只有一套默认规格，label 位于图形下方 12 个逻辑单位。十款动画采用各自固定原始配色。所有动画固定以原网页节奏的 2× 播放。

组件只负责不确定加载动画的呈现，不发起任务、不表示实际百分比。业务通过条件渲染控制显示和移除；确定进度使用 HyperProgress。切换 type 从该形态起点播放，移除组件释放动画时钟，再次创建从起点播放。

路径与弧长测量按组件缓存，动画只更新画布，不逐帧触发布局；采用原生 Canvas 绘制，不依赖网页、图片或视频。沙漏通过固定沙面关键帧和双组交接完成沙堆增长、流束缩短及容器翻转。图形保持平面风格。

TickerMode 关闭或 MediaQuery.disableAnimations 开启时停止推进并保留可见画面，重新启用时继续；这是宿主动画生命周期行为。内部使用 Ticker，dispose 时释放，不在 build 中重建时钟。

公开入口为 ui/lib/src/components/hyper_loading.dart；loading/ 内部分离类型、几何、普通绘制和沙漏绘制。
