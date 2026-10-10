---
title: HyperUpdateDialog
description: 检查更新、版本日志、下载与安装的柔光对话框
---

<ComponentDoc component-id="update-dialog" />

### 状态与交互

| 状态 | 用途 | 主操作 | 可选次操作 |
| --- | --- | --- | --- |
| idle | 等待用户检查更新 | 检查更新 → onCheck | 关闭 → onClose |
| checking | 正在请求版本信息 | 加载标识 | 取消 → onCancel |
| available | 展示新版本、发布日期、大小与更新日志 | 立即更新 → onUpdate | 稍后再说 → onLater |
| upToDate | 当前已是最新版本 | 再次检查 → onCheck | 关闭 → onClose |
| downloading | 展示下载比例、字节下载量、速度与预计剩余时间 | 确定或不定进度 | 取消 → onCancel；关闭只移除弹窗 → onClose |
| readyToInstall | 下载完成，等待安装 | 立即安装 → onInstall | 稍后再说 → onLater |
| installing | 应用新版本 | 确定或不定进度 | 安装期间阻止关闭和返回 |
| completed | 展示更新结果 | 开始使用 → onClose | 关闭 → onClose |
| error | 展示失败原因 | 重试 → onRetry | 关闭 → onClose |

### 接入方式

| show 参数 | 作用 | 必填 | 默认值 |
| --- | --- | --- | --- |
| context | 提供 Navigator 与当前 Hyper 主题的上下文 | 是 | — |
| builder | 弹层内容构建器，接收弹层内部上下文；可返回维护业务状态的 Widget | 是 | — |

使用 HyperUpdateDialog.show(context, builder: …) 打开弹层，builder 内返回 StatefulWidget 或 ValueListenableBuilder，再将状态传给 HyperUpdateDialog。检查、下载和安装由业务服务执行；服务回传状态和进度后重建组件，无须反复打开弹层。

回调不会自动关闭路由。稍后或关闭操作中使用 Navigator.pop 返回结果；onCancel 调用业务取消接口，onClose 只移除弹层时下载可以继续。控制器由页面或业务服务持有，重新打开弹层继续订阅同一个控制器，不把下载任务放到弹层的生命周期中。重试操作需要根据失败阶段恢复检查、下载或安装。message 可展示服务返回的错误说明，primaryLabel / secondaryLabel 可调整按钮文案，例如安装后需要重启时使用“重启应用”。

mandatory 为 true 时，完成前隐藏关闭、稍后与取消入口，并阻止系统返回；completed / upToDate 恢复关闭。installing 始终阻止返回。背景点击始终不关闭弹层。业务主动调用 Navigator.pop 仍可关闭路由。

未传操作回调时，主按钮禁用，可选次按钮和关闭按钮隐藏。progress 为 null 时展示不定进度，适合尚未获取文件大小或安装比例的阶段。窄屏、长日志与大字号使用正文滚动布局，底部操作区固定，用户可以直接更新或取消。

### 字节下载进度

```dart
HyperUpdateDialog(
  status: HyperUpdateStatus.downloading,
  downloadProgress: HyperUpdateDownloadProgress(
    downloadedBytes: downloadedBytes,
    totalBytes: totalBytes,
    bytesPerSecond: bytesPerSecond,
  ),
  progressText: waitingForNetwork ? '等待网络恢复，下载任务已保留' : null,
  onCancel: cancelDownload,
  onClose: closeDialog,
)
```

downloadProgress 只在下载阶段使用，并优先于 progress。总大小未知时传 null、0 或系统返回的负值，组件继续显示已下载量和可用速度，进度条改为不定进度，不显示百分比与预计剩余时间。安装阶段始终使用 progress，不会复用下载完成的 100%。字节单位按 1000 换算；速度由业务按相邻快照的字节差和时间差提供，等待网络时可以省略速度。

与系统下载管理器接入时，将已下载字节与总字节映射到 downloadProgress；下载完成再切换到 readyToInstall。Android 通过系统下载列表安装 APK 时，可将 primaryLabel 设置为“打开系统下载”，onInstall 打开系统下载列表，并覆盖 message 提示用户点击 APK。仅在业务确认安装开始或版本已更新后切换 installing / completed，组件不假定系统安装已经完成。

版本状态与数据字段见 [HyperUpdateStatus / HyperUpdateRelease](./update-status)，字节快照见 [HyperUpdateDownloadProgress](./update-download-progress)。本次功能无需新增依赖。
