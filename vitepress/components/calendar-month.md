---
title: HyperCalendarMonth
description: 无卡片的受控内嵌月历
---

<ComponentDoc component-id="calendar-month" />

## 使用约定

组件只显示指定月份，固定六行，不自带卡片或月份导航。宿主持有 month 与 selectedDate，通过 onChanged 接收日期点击。默认星期一开始，weekStart 的范围为 1–7。日期边界只比较年月日，endDate 应不早于 selectedDate。

emphasizedDays 接收当前月份中需要使用主题色的日期数字集合，默认空集合；只读绘制与交互日期格使用同一规则。库不判断工作日或节假日。

日期选择器弹层也使用本组件。默认 42 高的日期行、36 直径的选中圆形与今日描边保持一致。readOnly 合并绘制整月，不创建逐日期点击或动画节点；可用于全年月份概览。expanded 要求有限高度，并在六行之间平分可用空间。

```dart
HyperCalendarMonth(
  month: focusedMonth,
  selectedDate: selectedDate,
  weekStart: 7,
  onChanged: selectDate,
)

SizedBox(
  height: 120,
  child: HyperCalendarMonth(
    month: focusedMonth,
    showWeekdays: false,
    size: 'small',
    readOnly: true,
    expanded: true,
  ),
)
```

需要附加信息的复杂月盘可由宿主组合 HyperCalendarDay；月份分页、收起与业务数据均不属于库组件状态。
