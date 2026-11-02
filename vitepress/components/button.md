---
title: HyperButton
description: Hyper UI 按钮组件
---

<ComponentDoc component-id="button" />

## 默认样式

交互预览按 Kotlin ButtonDemo 的分组、文案、图标和 8/16 间距展示，仅保留一个禁用文字按钮。点击默认按钮可切换“处理中”的加载状态；处理中按钮在加载时拦截点击，空闲时点击再次进入加载。

省略 type 时采用中性玻璃按钮，主操作显式使用 filled 与 colorStyle = primary；另一种显示类型为 icon；语义配色由 colorStyle 指定 primary、success、info、warning、danger。关闭和取消不需要传 type。

```dart
HyperButton(label: '关闭', onPressed: onClose)
HyperButton(colorStyle: 'primary', type: 'filled', label: '重试', onPressed: onRetry)
HyperButton(type: 'icon', icon: LucideIcons.x, onPressed: onClose)
```

colorStyle 支持 primary、success、info、warning、danger，默认不指定配色；color 自定义基色优先。type 与配色独立，所有参数省略时保持中性玻璃底面和中性文字，深色模式随主题。

自定义按钮主体使用 content，与 label 互斥。content 内的 HyperText、HyperIcon 默认继承按钮排版与图标样式。

```dart
HyperButton(onPressed: onSave, content: const HyperText('保存'))
HyperButton(type: 'icon', onPressed: onAdd, content: const HyperIcon(LucideIcons.plus))
```

## 共用玻璃绘制

默认、filled、icon 统一通过内部 hyper_button_surface.dart 接入 hyper_control_surface.dart；hyper_glass_style.dart 管理内部玻璃参数，导航与按钮共用背景取样、折射与柔和高光，不提供新旧皮肤或全局材质档位。

按钮按压时模糊 8→6、边缘深度 12→14、折射位移 16→18、阴影半径 6→4.5、高光强度 0.5→1，单位为逻辑像素；整体缩放 0.975、透明度 0.92，进入 85ms、恢复 180ms。文字与图标在采样层上方保持清晰。默认玻璃采用 0.5 的共用高光轮廓；语义色按钮的色调描边为 0.5。filled 使用原基色 alpha ×0.9，backgroundColor 显式覆盖保持原值。

禁用态保留 controlTrack、弱化前景与 1 的弱边线，不采样、不浮起、无按压反馈。loading 阻止点击并保持正常玻璃配色。按钮高度 38、最小文字宽 68、水平留白 14、文字 13、图标 20/17 均保持原规格；状态和业务回调由调用方持有。

需要背景折射时，用 HyperBackdrop 分开承载背景与组件；没有背景源时保留半透明底面及按压反馈，普通调用不需要传入新的样式参数。
