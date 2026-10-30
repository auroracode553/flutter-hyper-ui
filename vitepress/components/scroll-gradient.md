---
title: HyperScrollGradient
description: 随滚动渐显的主题渐变，不采样正文或增加安全区
---

<ComponentDoc component-id="scroll-gradient" />

## 公开 API

```dart
import 'package:flutter_hyper_ui/hyper_ui.dart';

const HyperScrollGradient({
  Key? key,
  bool scrolledUnder = false,
  Widget? child,
})
```

| 参数 | 类型 | 必填 | 默认值 | 作用 |
| --- | --- | --- | --- | --- |
| key | Key? | 否 | null | Widget 标识。 |
| scrolledUnder | bool | 否 | false | true 强制显示；否则优先读取已有 HyperNavBarScrollScope，再使用 Scaffold 的主滚动观察者，无来源时透明。 |
| child | Widget? | 否 | null | 清晰的前景内容，无内容时由父级指定实际范围。 |

## 使用方式

```dart
HyperNavBarScrollScope(
  child: Stack(
    children: [
      Positioned.fill(child: mainScrollable),
      HyperScrollGradient(child: topActions),
    ],
  ),
)
```

标准页面和仅状态栏页面优先使用 [HyperNavBar](./nav-bar.md) 的 standard / simple。独立组件共用同一主滚动作用域，不为渐变复制监听或布尔缓存；分页和保留 Tab 使用 source 绑定主控制器与 active，库管理订阅和清理。

默认透明，离顶后以 160ms easeOutCubic 显示主题 background 的渐变，关闭动画时即时切换。透明度从顶部 0.96 经 55% 位置 0.94、78% 位置 0.74 降到自身底部 0，整体乘动画进度；前景保持清晰，不绘制分隔线，不拦截正文手势。

该组件不创建 BackdropFilter 或采样外部 PlatformView/WebView。没有模糊模式，不依赖外部画面的采样能力。组件不增加栏高、安全区、滚动视口或永久占位；必要操作只避让一次，首屏净空放入滚动内容。外部宿主通过已有适配传 scrolledUnder，组件不管理业务 Bridge、连接或页面生命周期。
