---
title: HyperDatePicker
description: HyperDatePicker 组件与公开 API
---

<ComponentDoc component-id="date-picker" />

日期和日期区间使用月历点选。顶部箭头逐月切换，点击年月标题可快速切换年份和月份；超出 `firstDate`、`lastDate` 的日期不可选。时间选择保留时间滚轮。

时间值使用 `HyperTimeOfDay`，可直接调用 `format()` 得到 24 小时时间文字；日期区间使用带 `start`、`end` 字段的 `HyperDateRange`。返回值可直接用于下一次选择的初始值。
