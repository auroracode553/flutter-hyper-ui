# Hy 组件总览

所有公开组件均使用 `Hy` 前缀，统一通过 `package:flutter_hyper_ui/hy_ui.dart` 引入。
设计以参考项目的浮动导航与设置菜单为基础，采用低饱和背景、玻璃高光、24 dp 卡片圆角和轻柔阴影。

## 完整组件映射

| 分类 | API | 能力 |
| --- | --- | --- |
| 按钮 | `HyButton` | filled / tonal / outline / ghost / danger；sm / md / lg；loading、禁用、图标、radius |
| 文本与图标 | `HyText`、`HyIcon`、`HyIcons` | 六种文字层级；大小、颜色、字重；常用业务图标 |
| 图片 | `HyImage` | network / asset / ImageProvider；裁剪、圆角、占位、错误占位、内存缓存、缩放预览 |
| 头像与角标 | `HyAvatar`、`HyCountBadge`、`HyBadge` | 圆形 / 圆角 / 文字头像；红点、数字、99+；语义状态徽标 |
| 标签 | `HyTag` | 语义色、选中、点击、关闭回调 |
| 材质与卡片 | `HyGlass`、`HySoftBackground`、`HyCard` | 可控模糊、背景、边框、阴影、圆角；标题、内容、底部 |
| 布局 | `HySpace`、`HyWrap`、`HyGrid`、`HyDivider` | 横纵间距、换行、列数、比例；横纵实线 / 虚线、缩进 |
| 占位 | `HyEmptyState`、`HySkeleton` | 自定义图标、文案、操作；列表 / 卡片骨架 |
| 输入 | `HyTextField` | Form 校验、多行、清除、密码显隐、禁用、错误提示、字数限制 |
| 选择 | `HySelect<T>`、`HyOption<T>` | 底部弹窗单选、多选、禁用项、取消不提交 |
| 滚轮与日期 | `HyPicker`、`HyDatePicker` | 普通选项滚轮；日期、时间、日期区间 |
| 表单控件 | `HyCheckbox`、`HyRadio<T>`、`HySwitch`、`HySlider`、`HyRate` | 受控状态、禁用、三态复选、刻度、评分 |
| 上传 | `HyUploader` | 相册 / 拍照 / 文件接口；预览、删除、大小限制、进度、失败重试、取消令牌 |
| 反馈 | `HyToast`、`HyDialog`、`HyLoading`、`HyAlert` | 自动消失、确认 / 提示 / 自定义正文、全局与局部加载、关闭通知 |
| 弹层 | `HyBottomSheet`、`HyPopover` | 底部内容、安全区与键盘适配；锚点气泡 |
| 顶部导航 | `HyTopBar` | 返回、标题、副标题、操作按钮、安全区域 |
| 标签导航 | `HyTabs`、`HySegmentedControl<T>`、`HyTabBarView` | 固定 / 可滚动 Tab、分段控制、TabController 页面联动 |
| 底部导航 | `HyTabBar`、`HyTabItem` | 悬浮玻璃胶囊、受控选中、RTL、安全区、减少动画 |
| 流程与进度 | `HySteps`、`HyProgress`、`HyProgressBar` | 横纵步骤；线性 / 环形 / 不定进度 |
| 列表 | `HyListTile`、`HyMenuGroup` | 图标、头像、文字、标签、自定义尾部；设置页分组 |
| 滚动 | `HyPullRefresh`、`HyLoadMore`、`HySticky` | 异步刷新、串行分页、失败重试、Sliver 吸顶 |
| 搜索与计时 | `HySearchBar`、`HyCountDown` | 搜索 / 清除；截止时间计时、恢复前台校准、结束回调 |
| 业务展示 | `HyCollapse`、`HyNoticeBar`、`HyTimeline` | 折叠、长公告滚动、短公告静止、订单时间轴 |
| 操作菜单 | `HyActionSheet`、`HyPopupMenu<T>` | 底部菜单、右上角菜单、危险与禁用操作 |
| 工具 | `HyScreen`、`HyRoute`、`HyKeyboard`、`HySafeArea` | dp / rpx、导航返回、收起键盘、安全区域 |
| 主题 | `HyUiTheme`、`HyUiThemeTokens`、`HyThemeController` | 明暗模式、主色切换、颜色 / 间距 / 圆角规范 |

## 原子组件

<DemoBlock title="文字、头像与图片" component="atoms" code="HyAvatar(text: 'HY', size: 56, radius: 18)" :height="740" />

## 布局容器

<DemoBlock title="卡片、网格与骨架" component="layout" code="HyCard(title: '正在加载', child: HySkeleton(card: true))" :height="740" />

## 表单组件

<DemoBlock title="完整表单与上传状态" component="forms" code="HyTextField(label: '备注', maxLines: 3, maxLength: 120)" :height="900" />

## 反馈与弹层

<DemoBlock title="交互反馈" component="overlays" code="HyToast.show(context, '保存成功', tone: HyUiTone.success);" :height="680" />

## 导航与列表

<DemoBlock title="浮动导航与滚动列表" component="full-navigation" code="HyProgress(value: .72, circular: true)" :height="850" />

## 业务组件

<DemoBlock title="设置菜单与时间轴" component="business" code="HyCountDown(endTime: deadline)" :height="850" />

## 状态与布局约定

- 表单控件、分段控制器和导航为受控组件：回调中更新业务状态，再传入新的 value。
- `HySelect.values` 是已提交值。多选仅在点击确定后调用 `onChanged`；点击遮罩或返回不提交。
- `HyPicker.show` 返回选中值，取消返回 null。`initialIndex` 作用于过滤禁用项后的选项列表。
- `HyTabs` 与 `HyTabBarView` 共享显式 `TabController`，或置于同一个 `DefaultTabController` 中；数量必须一致。
- `HyTabBarView` 和 `HyLoadMore` 需要有限高度，可放在 `Expanded` 或指定高度的 `SizedBox` 中。
- `HySticky` 放入 `CustomScrollView.slivers`。`HyPullRefresh` 的滚动子节点使用 `AlwaysScrollableScrollPhysics`，确保空列表也能刷新。
- `HyLoadMore.onLoadMore` 需要返回完整请求 Future；抛出异常显示重试，更新 `hasMore` 控制终态。刷新与分页之间的业务数据版本由应用管理。
- `HyMenuGroup` 内的 `HyListTile` 设置 `grouped: true`，由父组提供边框、阴影与行间分隔。
- `HyCountDown.endTime` 应由 State 或业务模型持有，避免在每次 build 中重新计算截止时间。
- `HyLoading.during` 使用 try/finally 移除自己的浮层，任务错误继续向调用方传播。
- `HyAlert.onClose`、`HyTag.onClose`、`HyNoticeBar.onClose` 通知父组件移除对应内容。
- `HyGlass.blur: 0` 保留柔光材质并关闭模糊。密集列表优先使用此设置。
- `HyImage` 使用 Flutter 内存缓存；需要磁盘缓存时注入自有 `ImageProvider`。

## 上传适配器

核心库只依赖 Flutter。相册、摄像头、文件系统权限和服务器协议属于应用适配层。
`HyUploader.pick` 返回带唯一 id、文件名、字节与 isImage 的 `HyUploadFile` 列表；取消返回空列表。
`upload` 返回服务器资源 URL，并通过回调传递 0 到 1 的进度；失败抛出异常。

```dart
HyUploader(
  pick: mediaService.pickFiles,
  upload: (file, onProgress, cancellation) async {
    return uploadService.send(
      bytes: file.bytes,
      filename: file.name,
      onProgress: onProgress,
      isCancelled: () => cancellation.isCancelled,
    );
  },
  onChanged: (items) {
    // 保存 status == HyUploadStatus.success 的项目及其 url。
  },
)
```

上述 mediaService / uploadService 是应用自行提供的接口，不是库内置服务。
删除与组件卸载会标记取消；适配器须将该信号连接至 HTTP 客户端的取消机制。
`initialItems` 只在创建时读取；需要换一组初始化内容时使用新的 Widget key。
预览页清晰标记为模拟适配器，用于体验进度、删除、失败与重试，不进行真实上传。

## 手动验收

本次开发未运行 Flutter、编译、安装或部署。使用者可按需手动完成依赖准备、分析与预览。
建议在手机上检查：窄屏与大字号、明暗模式、减少动画、输入键盘、返回取消弹层、空列表刷新、分页失败重试、上传时删除和卸载。
导航指示器使用 Flutter 平移动画、180ms 与 `Cubic(.77, 0, .175, 1)`，用于显示选中变化；系统减少动画时直接切换。实际模糊性能与动效观感需真机确认。
