---
title: HyperButton
description: Hyper UI 按钮组件
---

<ComponentDoc component-id="button" />

## 默认样式

交互预览仅保留一个禁用文字按钮，不重复展示禁用后外观相同的配色。

省略 type 时采用描边按钮，主操作显式使用 filled 与 colorStyle = primary；另一种显示类型为 icon；语义配色由 colorStyle 指定 primary、success、info、warning、danger。关闭和取消不需要传 type。

```dart
HyperButton(label: '关闭', onPressed: onClose)
HyperButton(colorStyle: 'primary', type: 'filled', label: '重试', onPressed: onRetry)
HyperButton(type: 'icon', icon: LucideIcons.x, onPressed: onClose)
```

colorStyle 支持 primary、success、info、warning、danger，默认不指定配色；color 自定义基色优先。type 与配色独立，所有参数省略时保持白色描边和中性文字，深色模式随主题。
