---
title: HyperUpdateDialog
description: 检查更新、版本日志、下载与安装的柔光对话框
---

<ComponentDoc component-id="update-dialog" />

### 状态与交互

与 Compose HyperUI 保持相同默认布局：标识块 40、图标 20、加载环 30；checking 隐藏版本，其他状态的版本信息直接排版，不嵌套卡片。error 仅保留页头、错误原因、重试和关闭，不显示状态图标、大标题、版本区域或操作区分隔线。次操作省略 type，使用默认描边按钮；主操作显式使用 filled 与 colorStyle = primary。

面板最大宽 420、圆角 28、内容边距 24。show 在系统安全区内保留四边 20 外间距，弹层宽度为 min(420, 安全区宽度 − 40)，350 宽安全区内为 310；内嵌预览跟随父级宽度，页面边距 16。正文滚动、底部操作固定，正文与分隔线之间保留 24，分隔线与按钮间距 20，两个按钮间距 8。

标题 24 / 1.2、说明 14 / 1.55、日志 13 / 1.5、进度 28 / 1.2、版本标签 12 / 1.2，其余文字继承主题 1.4 行高，12 对应 16.8、13 对应 18.2。主按钮高 38，关闭按钮 32、图标 18。版本箭头只在当前与新版本同时存在时显示；完成态缺少 release 时仍显示 currentVersion。下载量下方的速度与剩余时间以 12 间距分别排版并允许换行。

两端预览使用相同的“更新流程 / 状态预览”、十种状态标签、强制更新与总大小未知开关，默认内嵌展示 2.7.3 → 2.8.0、2026.10.10、48.6 MB 和三条更新日志。点击“检查更新”打开弹层；状态标签用于静止观察，关闭弹层后页面模拟下载继续。

| 状态 | 用途 | 主操作 | 可选次操作 |
| --- | --- | --- | --- |
| idle | 隐藏组件，业务从外部入口开始检查 | — | — |
| checking | 正在请求版本信息 | 加载标识 | 取消 → onCancel |
| available | 展示新版本、发布日期、大小与更新日志 | 立即更新 → onDownload | 稍后再说 → onLater |
| upToDate | 当前已是最新版本 | 再次检查 → onCheck | 关闭 → onClose |
| downloadQueued | 系统下载排队，展示不定进度 | 等待系统下载 | 取消 → onCancel；关闭 → onClose |
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

downloadProgress 在 downloadQueued / downloading 阶段使用，并优先于 progress。总大小未知时传 null、0 或系统返回的负值，组件继续显示已下载量和可用速度，进度条改为不定进度，不显示百分比与预计剩余时间。安装阶段始终使用 progress，不会复用下载完成的 100%。字节单位按 1000 换算；速度由业务按相邻快照的字节差和时间差提供，等待网络时可以省略速度。

与系统下载管理器接入时，将已下载字节与总字节映射到 downloadProgress；下载完成再切换到 readyToInstall。Android 通过系统下载列表安装 APK 时，可将 primaryLabel 设置为“打开系统下载”，onInstall 打开系统下载列表，并覆盖 message 提示用户点击 APK。仅在业务确认安装开始或版本已更新后切换 installing / completed，组件不假定系统安装已经完成。

版本状态与数据字段见 [HyperUpdateStatus / HyperUpdateRelease](./update-status)，字节快照见 [HyperUpdateDownloadProgress](./update-download-progress)。本次功能无需新增依赖。
