---
title: HyperThemeModeDialog
description: 跟随系统、浅色、深色三选项的紧凑主题弹窗。
---

<ComponentDoc component-id="theme-mode-dialog" />

## 默认布局与状态

选项最小行高 36、垂直内边距 4、圆环 21，无额外行间距或关闭按钮。大字体自然增高，正文可滚动。null 表示跟随系统、false 浅色、true 深色。选择后先通知 onChanged，再调用 onClose；组件不存储偏好或修改全局主题。

```dart
HyperThemeModeDialog.show(context,
  value: darkTheme,
  onChanged: (value) => setState(() => darkTheme = value),
);
```

## 公开 API

```dart
const HyperThemeModeDialog({
  super.key,
  required bool? value,
  required ValueChanged<bool?> onChanged,
  required VoidCallback onClose,
  String title = '主题设置',
});
```

| 参数 | 类型 | 必填 | 默认值 | 作用 |
| --- | --- | --- | --- | --- |
| key | Key? | 否 | null | Widget 标识。 |
| value | bool? | 是 | — | null 跟随系统，false 浅色，true 深色。 |
| onChanged | ValueChanged&lt;bool?&gt; | 是 | — | 选择后通知调用方保存并应用。 |
| onClose | VoidCallback | 是 | — | 选择后请求关闭。 |
| title | String | 否 | 主题设置 | 面板标题。 |

show(context, {required value, required onChanged, title = '主题设置'}) 返回 Future&lt;void&gt;，使用库内模态宿主；选择后关闭，遮罩和返回取消，不通知 onChanged。

| show 参数 | 类型 | 必填 | 默认值 | 作用 |
| --- | --- | --- | --- | --- |
| context | BuildContext | 是 | — | 模态宿主上下文。 |
| value | bool? | 是 | — | 当前主题模式。 |
| onChanged | ValueChanged&lt;bool?&gt; | 是 | — | 保存与应用主题的回调。 |
| title | String | 否 | 主题设置 | 面板标题。 |
