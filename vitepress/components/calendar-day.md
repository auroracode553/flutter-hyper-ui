---
title: HyperCalendarDay
description: 共用日期选择器样式的通用日期格
---

<ComponentDoc component-id="calendar-day" />

## 使用约定

默认日期行高 42，选中圆形直径 36，与 HyperDatePicker 共用实现。small 用于只读紧凑展示，large 可承载辅助文字；字号与最小高度随系统文字缩放。未传辅助信息时保持日期选择器原有外观。

附属条目保持 10 号文字、1.2 行高，垂直内边距合计 2、行间距 2；默认文字缩放下 large 加三行条目的最小高度为 96。宿主使用 minimumHeight 计算，不自行复制尺寸。

组件只接收数字、文字、颜色和回调，不计算农历、节日或日程。角标使用短文字，条目按剩余高度最多占三行：三项以内逐条显示，超过容量时保留前面的条目并用最后一行单独显示剩余数量，不挤占标题宽度。完全放不下时以圆点提示。expanded 要求宿主提供有限高度，条目点击回退到日期点击。

```dart
SizedBox(
  width: 80,
  height: 120,
  child: HyperCalendarDay(
    day: 21,
    size: 'large',
    expanded: true,
    subtitle: '辅助说明',
    badge: '待',
    items: const [HyperCalendarItem(label: '预约确认')],
    itemCount: 3,
    onPressed: selectDate,
    onItemsPressed: openItems,
  ),
)
```

### 宿主布局辅助方法

```dart
static double minimumHeight(
  TextScaler textScaler, {
  String size = 'default',
  bool hasSubtitle = false,
  int itemRows = 0,
})
```

| 参数 | 必填 | 默认值 | 作用 |
| --- | --- | --- | --- |
| textScaler | 是 | 无 | 当前系统文字缩放 |
| size | 否 | default | small、default、large |
| hasSubtitle | 否 | false | 是否预留辅助文字高度 |
| itemRows | 否 | 0 | 为 0–3 行附属条目预留高度，包含溢出数量行 |

### HyperCalendarItem

| 参数 | 必填 | 默认值 | 作用 |
| --- | --- | --- | --- |
| label | 是 | 无 | 条目文字 |
| color | 否 | null | 条目颜色，默认主题色 |
