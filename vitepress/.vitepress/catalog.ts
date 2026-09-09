export interface ComponentEntry {
  name: string;
  source: string;
  summary: string;
}

export interface ComponentGroup {
  id: string;
  title: string;
  navTitle: string;
  description: string;
  page: string;
  previewId: string;
  previewTitle: string;
  previewHeight: number;
  example: string;
  components: ComponentEntry[];
  conventions?: string[];
}

const component = (name: string, source: string, summary: string): ComponentEntry => ({
  name,
  source,
  summary,
});

/**
 * 文档的唯一人工维护目录。
 *
 * 页面、侧栏和演示均读取这里；source 必须指向真实 Dart 源文件，previewId
 * 必须存在于 preview/lib/src/preview_catalog.dart。
 */
export const componentGroups: ComponentGroup[] = [
  {
    id: 'foundations',
    title: '基础元素',
    navTitle: '基础元素',
    description: '文字、图标、图片、头像、角标与语义状态，是组合其他组件的最小视觉单元。',
    page: '/components/foundations',
    previewId: 'atoms',
    previewTitle: '基础元素完整状态',
    previewHeight: 740,
    example: `HySpace(
  children: const [
    HyText('轻盈，也清晰。', variant: HyTextStyle.display),
    HyAvatar(text: 'HY', size: 56, radius: 18),
    HyTag(label: '已完成', tone: HyUiTone.success),
  ],
)`,
    components: [
      component('HyText / HyTextStyle', 'hy_typography.dart', '统一的显示、标题、正文、说明和提示文字层级。'),
      component('HyIcon / HyIcons', 'hy_typography.dart', '带语义标签的图标组件与常用业务图标集合。'),
      component('HyImage', 'hy_image.dart', '支持 ImageProvider、网络、资源、占位、失败态与缩放预览。'),
      component('HyAvatar', 'hy_image.dart', '图片、文字或默认图标头像，支持圆形和自定义圆角。'),
      component('HyCountBadge', 'hy_image.dart', '红点、数字和最大值角标。'),
      component('HyBadge', 'hy_badge.dart', '紧凑型语义状态徽标。'),
      component('HyTag', 'hy_tag.dart', '支持语义色、选择、点击和关闭的标签。'),
      component('HyUiTone / HyUiToneResolver', 'hy_tone.dart', '跨组件共用的语义状态及其主题颜色解析扩展。'),
    ],
  },
  {
    id: 'actions',
    title: '按钮与卡片',
    navTitle: '按钮与卡片',
    description: '动作入口和内容容器，覆盖按钮层级、状态、玻璃材质与卡片结构。',
    page: '/components/actions',
    previewId: 'actions',
    previewTitle: '按钮与卡片完整状态',
    previewHeight: 680,
    example: `HyButton.filled(
  label: '打开文件',
  icon: Icons.add,
  onPressed: () {},
)

HyCard(
  title: '本周活动计划',
  subtitle: '12 项活动',
  child: const Text('内容摘要'),
)`,
    components: [
      component('HyButton / HyButtonVariant / HyButtonSize', 'hy_button.dart', '五种视觉层级、三种尺寸、加载、禁用、图标和通栏状态。'),
      component('HyCard', 'hy_card.dart', '具有标题、操作区、正文、底部和选中态的内容容器。'),
      component('HyGlass', 'hy_glass.dart', '可配置模糊、背景、边框、阴影和点击行为的玻璃材质。'),
      component('HySoftBackground', 'hy_glass.dart', '为页面提供与明暗主题同步的柔光背景。'),
    ],
    conventions: ['密集列表中可设置 `HyGlass.blur: 0`，保留材质外观并降低模糊绘制成本。'],
  },
  {
    id: 'layout',
    title: '布局与占位',
    navTitle: '布局与占位',
    description: '间距、换行、网格、分割线、骨架和空状态。',
    page: '/components/layout',
    previewId: 'layout',
    previewTitle: '布局容器与占位状态',
    previewHeight: 740,
    example: `HyCard(
  title: '常用入口',
  child: HyGrid(
    columns: 3,
    children: items,
  ),
)`,
    components: [
      component('HySpace', 'hy_layout.dart', '在线性方向排列子项并统一插入间距。'),
      component('HyWrap', 'hy_layout.dart', '带统一主轴和换行间距的流式布局。'),
      component('HyGrid', 'hy_layout.dart', '固定列数和宽高比的轻量网格。'),
      component('HyDivider', 'hy_layout.dart', '横向或纵向、实线或虚线分隔。'),
      component('HySkeleton', 'hy_layout.dart', '列表或卡片加载占位。'),
      component('HyEmptyState', 'hy_empty_state.dart', '包含图标、标题、说明和操作的空状态。'),
    ],
  },
  {
    id: 'forms',
    title: '表单与选择',
    navTitle: '表单与选择',
    description: '文本输入、受控选择、选择器、日期时间与文件上传。',
    page: '/components/forms',
    previewId: 'forms',
    previewTitle: '完整表单交互',
    previewHeight: 900,
    example: `HyTextField(
  label: '称呼',
  hintText: '请输入称呼',
  validator: (value) => value?.isEmpty == true ? '请输入称呼' : null,
)

HySelect<String>(
  options: options,
  values: selectedValues,
  onChanged: (values) => setState(() => selectedValues = values),
)`,
    components: [
      component('HyTextField', 'hy_text_field.dart', '支持校验、多行、清除、密码显隐、错误和字数限制。'),
      component('HySegmentedControl / HySegmentOption', 'hy_segmented_control.dart', '适用于少量互斥选项的受控分段选择。'),
      component('HySelect / HyOption', 'hy_select.dart', '底部弹层单选或多选，支持禁用项。'),
      component('HyCheckbox', 'hy_selection_controls.dart', '支持三态、禁用和标签的受控复选。'),
      component('HyRadio', 'hy_selection_controls.dart', '泛型值受控单选。'),
      component('HySwitch', 'hy_selection_controls.dart', '布尔值受控开关。'),
      component('HySlider', 'hy_selection_controls.dart', '范围、分段和结束回调可配置的滑块。'),
      component('HyRate', 'hy_selection_controls.dart', '数量、步长和图标可配置的评分。'),
      component('HyPicker / HyDatePicker', 'hy_picker.dart', '普通选项滚轮、日期、时间和日期区间选择。'),
      component('HyUploader / HyUploadSource / HyUploadStatus / HyUploadFile / HyUploadCancellation / HyUploadItem', 'hy_uploader.dart', '通过注入式适配器完成选择、上传、进度、取消、失败与重试。'),
      component('HyFilePicker / HyFileUpload', 'hy_uploader.dart', '由业务层实现的文件选择与上传函数类型。'),
    ],
    conventions: [
      '`HySelect.values` 是已提交值；多选仅在确认后触发 `onChanged`。',
      '上传组件不直接依赖相册、文件系统或 HTTP 插件，平台能力通过 `HyFilePicker` 与 `HyFileUpload` 注入。',
    ],
  },
  {
    id: 'feedback',
    title: '反馈与弹层',
    navTitle: '反馈与弹层',
    description: '轻提示、对话框、局部或全局加载、通知、底部弹层与锚点菜单。',
    page: '/components/feedback',
    previewId: 'overlays',
    previewTitle: '反馈与弹层交互',
    previewHeight: 700,
    example: `HyToast.show(context, '保存成功', tone: HyUiTone.success);

final confirmed = await HyDialog.confirm(
  context,
  title: '保存更改？',
  message: '新的偏好将立即生效。',
);`,
    components: [
      component('HyToast', 'hy_feedback.dart', '基于 ScaffoldMessenger 的自动消失轻提示。'),
      component('HyDialog', 'hy_feedback.dart', '确认、提示或自定义正文对话框。'),
      component('HyLoading', 'hy_feedback.dart', '局部加载状态与自动清理的全局任务遮罩。'),
      component('HyAlert', 'hy_feedback.dart', '可关闭的语义通知。'),
      component('HyBottomSheet', 'hy_bottom_sheet.dart', '适配安全区、键盘与最大高度的自定义底部弹层。'),
      component('HyActionSheet / HyAction', 'hy_bottom_sheet.dart', '支持危险项与禁用项的底部操作菜单。'),
      component('HyPopover', 'hy_popover.dart', '锚定子组件的补充说明气泡。'),
      component('HyPopupMenu', 'hy_popover.dart', '基于 HyAction 的泛型弹出菜单。'),
      component('HyNoticeBar', 'hy_notice_bar.dart', '短公告静止、长公告滚动的可关闭通知条。'),
    ],
    conventions: ['`HyLoading.during` 会在 `finally` 中仅移除自己的遮罩，任务异常继续交给调用方。'],
  },
  {
    id: 'navigation',
    title: '导航、进度与列表',
    navTitle: '导航与列表',
    description: '顶部、标签、底部导航，步骤与进度，以及列表的刷新、分页和吸顶。',
    page: '/components/navigation',
    previewId: 'full-navigation',
    previewTitle: '导航、步骤与列表联动',
    previewHeight: 860,
    example: `HyTabBar(
  items: const [
    HyTabItem(icon: Icons.home_outlined, label: '首页'),
    HyTabItem(icon: Icons.person_outline, label: '我的'),
  ],
  selectedIndex: selectedIndex,
  onSelected: (value) => setState(() => selectedIndex = value),
)`,
    components: [
      component('HyTopBar', 'hy_top_bar.dart', '支持副标题、自定义前导和操作区的页面顶部栏。'),
      component('HyTabBar / HyTabItem', 'hy_navigation.dart', '带选中动效、RTL 与安全区适配的悬浮底部导航。'),
      component('HyTabs / HyTabBarView', 'hy_navigation.dart', '共享 TabController 的标签与页面联动。'),
      component('HySteps / HyStep', 'hy_navigation.dart', '横向或纵向步骤状态。'),
      component('HyProgress', 'hy_navigation.dart', '线性、环形、确定或不定进度。'),
      component('HyProgressBar', 'hy_progress_bar.dart', '紧凑线性进度条。'),
      component('HyListTile', 'hy_list_tile.dart', '支持图标、头像、标签、元信息和自定义尾部的列表项。'),
      component('HyMenuGroup', 'hy_lists.dart', '设置页风格的列表分组容器。'),
      component('HyPullRefresh', 'hy_lists.dart', '对 RefreshIndicator 的语义化封装。'),
      component('HyLoadMore', 'hy_lists.dart', '串行分页、终态与失败重试。'),
      component('HySticky', 'hy_lists.dart', '用于 CustomScrollView.slivers 的吸顶内容。'),
    ],
    conventions: [
      '`HyTabs` 与 `HyTabBarView` 应共享同一个 `TabController`，或位于同一个 `DefaultTabController`。',
      '`HyLoadMore` 需要有限高度；`onLoadMore` 必须返回完整请求 Future。',
    ],
  },
  {
    id: 'business',
    title: '业务展示',
    navTitle: '业务展示',
    description: '常见业务页需要的搜索、倒计时、折叠面板和时间轴。',
    page: '/components/business',
    previewId: 'business',
    previewTitle: '业务组件组合',
    previewHeight: 850,
    example: `HySearchBar(onChanged: onQueryChanged)

HyCountDown(endTime: deadline)

const HyTimeline(
  items: [HyTimelineItem(title: '已送达', time: '今天 14:32')],
)`,
    components: [
      component('HySearchBar', 'hy_business.dart', '包含搜索、提交和清空交互的输入入口。'),
      component('HyCountDown', 'hy_business.dart', '基于截止时间计算，并在应用恢复前台时校准。'),
      component('HyCollapse', 'hy_business.dart', '标题与正文组成的折叠内容。'),
      component('HyTimeline / HyTimelineItem', 'hy_business.dart', '订单、物流和流程事件时间轴。'),
    ],
    conventions: ['`HyCountDown.endTime` 应由 State 或业务模型持有，避免在每次 build 时重建截止时间。'],
  },
  {
    id: 'utilities',
    title: '主题与工具',
    navTitle: '主题与工具',
    description: '主题令牌、间距、圆角、动效以及屏幕、键盘、路由和安全区工具。',
    page: '/components/utilities',
    previewId: 'overview',
    previewTitle: '主题化组件概览',
    previewHeight: 380,
    example: `MaterialApp(
  theme: HyUiTheme.light(primary: Colors.indigo),
  darkTheme: HyUiTheme.dark(primary: Colors.indigo),
  home: const App(),
)`,
    components: [
      component('HyUiTheme', '../theme/hy_ui_theme.dart', '明暗主题的 ThemeData 构造入口。'),
      component('HyUiThemeTokens', '../theme/hy_ui_theme_tokens.dart', '组件消费的 ThemeExtension 语义令牌。'),
      component('HyUiColors', '../theme/hy_ui_colors.dart', '组件库基础色板。'),
      component('HyUiSpacing', '../theme/hy_ui_spacing.dart', '统一间距常量。'),
      component('HyUiRadii', '../theme/hy_ui_radii.dart', '统一圆角常量。'),
      component('HyUiEffects', '../theme/hy_ui_effects.dart', '玻璃模糊、阴影与选择动效常量。'),
      component('HyUiBuildContext', '../theme/hy_ui_context.dart', '通过 `context.hyUi` 读取主题令牌的扩展。'),
      component('HyThemeController', '../utils/hy_utils.dart', '由应用持有的主题模式与主色控制器。'),
      component('HyScreen', '../utils/hy_utils.dart', '屏幕宽度、紧凑断点、dp 与 rpx 换算。'),
      component('HyKeyboard / HyRoute / HySafeArea', '../utils/hy_utils.dart', '键盘、路由和安全区常用操作。'),
    ],
  },
];

export function getComponentGroup(id: string): ComponentGroup {
  const group = componentGroups.find((item) => item.id === id);
  if (!group) throw new Error(`Unknown component group: ${id}`);
  return group;
}
