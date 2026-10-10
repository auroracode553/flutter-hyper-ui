---
title: HyperUpdateStatus / HyperUpdateRelease
description: 更新流程状态与版本信息公开 API
---

<ComponentDoc component-id="update-status" />

### 状态值

| 名称 | 作用 | 必填 | 默认值 |
| --- | --- | --- | --- |
| idle | 等待检查 | 否 | HyperUpdateDialog 默认状态 |
| checking | 检查版本信息 | 否 | — |
| available | 已发现新版本 | 否 | — |
| upToDate | 已是最新版本 | 否 | — |
| downloading | 下载更新包 | 否 | — |
| readyToInstall | 已下载，等待安装 | 否 | — |
| installing | 正在安装 | 否 | — |
| completed | 更新成功 | 否 | — |
| error | 当前阶段失败 | 否 | — |

HyperUpdateRelease 的 version 为必填；releaseDate 和 sizeLabel 是业务格式化后的展示文字，highlights 为逐条展示的更新日志。模型只包含展示数据，版本比较、请求地址、下载路径和平台安装流程均由业务实现。
