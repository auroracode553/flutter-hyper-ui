---
title: 复合组件
description: 由基础组件组合而成、保持业务无关的常见移动端模式
---

<ComponentReference group-id="business" />

## 组合而非绑定

复合组件提供常见行为和布局，但不读取业务服务。例如 `HyCountDown` 只根据截止时间计算剩余时长，`HyTimeline` 只展示事件；订单、物流或任务状态由调用方转换为组件输入。
