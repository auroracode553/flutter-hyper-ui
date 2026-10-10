---
title: HyperUpdateDownloadProgress
description: 更新下载字节进度、速度和预计剩余时间
---

<ComponentDoc component-id="update-download-progress" />

### 只读计算属性

```dart
double? get fraction;
String get sizeLabel;
String? get speedLabel;
String? get remainingLabel;
```

| 名称 | 作用 | 必填 | 默认值 |
| --- | --- | --- | --- |
| downloadedBytes | 下载服务提供的已下载字节数；负数按 0 处理 | 是 | — |
| totalBytes | 下载服务提供的总字节数；0、负数与 null 表示未知 | 否 | null |
| bytesPerSecond | 下载服务提供的字节每秒速度；非正值与非有限值视为不可用 | 否 | null |
| fraction | 根据字节数计算的 0–1 进度；超过总量时收敛到 1 | 否，只读 | 总量未知时 null |
| sizeLabel | 下载量文字；总量未知时显示“已下载”与当前下载量 | 否，只读 | 自动计算 |
| speedLabel | B / s、KB / s 等速度文字 | 否，只读 | 速度不可用时 null |
| remainingLabel | 根据剩余字节与速度计算预计剩余秒数、分钟、小时或天数 | 否，只读 | 总量或速度不可用、已下载完成时 null |

字节单位按 1000 换算，使用 B / KB / MB / GB / TB；百分比仅在总量大于 0 时计算。对话框对百分比向下取整，避免四舍五入导致提前显示 100%。速度和预计剩余时间只提供展示估算，不调度下载任务。

使用方法见 [HyperUpdateDialog](./update-dialog)。下载流、平台下载管理器或业务控制器每次回传快照后，重建字节模型并更新 UI 即可。
