export interface ComponentEntry {
  id: string;
  name: string;
  navName: string;
  page: string;
  source: string;
  summary: string;
  demoId?: string;
  sidebar?: boolean;
}

export interface ComponentDemo {
  id: string;
  title: string;
  description?: string;
  height: number;
  source: string;
}

export interface ComponentGroup {
  id: string;
  title: string;
  navTitle: string;
  description: string;
  page: string;
  demos: ComponentDemo[];
  components: ComponentEntry[];
  conventions?: string[];
}

interface ComponentOptions {
  id?: string;
  navName?: string;
  demoId?: string;
  sidebar?: boolean;
}

function componentId(name: string) {
  return name
    .replace(/^Hy/, '')
    .replace(/([a-z0-9])([A-Z])/g, '$1-$2')
    .toLowerCase();
}

const component = (
  name: string,
  source: string,
  summary: string,
  options: ComponentOptions = {},
): ComponentEntry => {
  const navName = options.navName ?? name.split('/')[0].trim().replace(/<.*>/, '');
  const id = options.id ?? componentId(navName);
  return {
    id,
    name,
    navName,
    page: `/components/${id}`,
    source,
    summary,
    demoId: options.demoId,
    sidebar: options.sidebar ?? true,
  };
};

const demo = (
  id: string,
  title: string,
  source: string,
  height: number,
  description?: string,
): ComponentDemo => ({ id, title, source, height, description });

export const featuredDemo = demo(
  'glass-library',
  '柔性玻璃组件总览',
  'glass_library_example.dart',
  980,
  '导航、输入、菜单、反馈与加载组件的统一状态和交互。',
);

/**
 * 文档的唯一人工维护目录。
 *
 * 页面、侧栏和演示均读取这里；组件 source 必须指向真实 Dart 源文件，
 * Demo id 必须存在于 PreviewCatalog，Demo source 必须指向真实示例文件。
 */
export const componentGroups: ComponentGroup[] = [
  {
    id: 'foundations',
    title: '基础组件',
    navTitle: '基础组件',
    description: '文字、图标、图片、头像和语义状态，是构成一致移动端界面的最小单元。',
    page: '/components/foundations',
    demos: [
      demo('atoms', '基础元素完整状态', 'complete_examples.dart', 740, '文字、图标、头像、图片和语义标签。'),
      demo('data', '徽标、列表与进度', 'data_example.dart', 460, '用于检查数据展示组件的常用组合。'),
    ],
    components: [
      component('HyText / HyTextStyle', 'hy_typography.dart', '统一的显示、标题、正文、说明和提示文字层级。'),
      component('HyIcon / HyIcons', 'hy_typography.dart', '带语义标签的图标组件与常用业务图标集合。'),
      component('HyImage', 'hy_image.dart', '支持 ImageProvider、网络、资源、占位、失败态与缩放预览。'),
      component('HyAvatar', 'hy_image.dart', '图片、文字或默认图标头像，支持圆形和自定义圆角。'),
      component('HyCountBadge', 'hy_image.dart', '红点、数字和最大值角标。'),
      component('HyBadge', 'hy_badge.dart', '紧凑型语义状态徽标。'),
      component('HyTag', 'hy_tag.dart', '支持语义色、选择、点击和关闭的标签。'),
      component('HyUiTone / HyUiToneResolver', 'hy_tone.dart', '跨组件共用的语义状态及其主题颜色解析扩展。', { sidebar: false }),
    ],
  },
  {
    id: 'actions',
    title: '材质与操作',
    navTitle: '材质与操作',
    description: '玻璃表面、即时按压反馈、动作层级和内容容器。',
    page: '/components/actions',
    demos: [
      demo('buttons', '按钮层级、尺寸与状态', 'buttons_example.dart', 360, '点击真实按钮，检查图标、加载态和不同尺寸。'),
      demo('cards', '卡片结构与选择状态', 'cards_example.dart', 520, '包含标题、状态、进度、标签和选中态。'),
    ],
    components: [
      component('HyButton / HyButtonVariant / HyButtonSize', 'hy_button.dart', '五种视觉层级、三种尺寸、加载、禁用、图标和通栏状态。', { demoId: 'buttons' }),
      component('HyCard', 'hy_card.dart', '具有标题、操作区、正文、底部和选中态的内容容器。', { demoId: 'cards' }),
      component('HyGlass', 'hy_glass.dart', '可配置模糊、背景、边框、阴影和点击行为的玻璃材质。', { demoId: 'cards' }),
      component('HyGlassWeight', 'hy_glass.dart', '按表面面积和层级区分轻薄、标准、突出与实色材质。', { sidebar: false }),
      component('HyPressable', 'hy_pressable.dart', '按下即响应、可适配减少动画的通用触控反馈层。'),
      component('HySoftBackground', 'hy_glass.dart', '为页面提供与明暗主题同步的柔光背景。'),
    ],
    conventions: [
      '按表面面积选择 `HyGlassWeight`：小控件用 `subtle`，普通卡片用 `regular`，模态浮层用 `prominent`。',
      '密集列表中可设置 `HyGlass.blur: 0`，保留材质外观并降低模糊绘制成本。',
      '不要在轻量玻璃表面上继续叠加轻量玻璃；选中态优先使用颜色状态而不是新增一层材质。',
    ],
  },
  {
    id: 'layout',
    title: '布局组件',
    navTitle: '布局组件',
    description: '间距、换行、网格、分割、动态骨架与空状态。',
    page: '/components/layout',
    demos: [
      demo('layout', '布局容器与占位状态', 'complete_examples.dart', 740),
    ],
    components: [
      component('HySpace', 'hy_layout.dart', '在线性方向排列子项并统一插入间距。'),
      component('HyWrap', 'hy_layout.dart', '带统一主轴和换行间距的流式布局。'),
      component('HyGrid', 'hy_layout.dart', '固定列数和宽高比的轻量网格。'),
      component('HyDivider', 'hy_layout.dart', '横向或纵向、实线或虚线分隔。'),
      component('HySkeleton', 'hy_layout.dart', '适配减少动画设置的列表或卡片扫光占位。'),
      component('HyEmptyState', 'hy_empty_state.dart', '包含图标、标题、说明和操作的空状态。'),
    ],
  },
  {
    id: 'forms',
    title: '表单组件',
    navTitle: '表单组件',
    description: '受控输入、锚定下拉、底部选择器、日期时间与注入式文件上传。',
    page: '/components/forms',
    demos: [
      demo('inputs', '基础输入与分段选择', 'inputs_example.dart', 520, '用于快速检查输入、辅助文案和受控选择。'),
      demo('forms', '完整表单交互', 'complete_examples.dart', 900, '覆盖校验、选择、评分、日期和上传入口。'),
      demo('upload', '上传状态与重试', 'upload_example.dart', 620, '模拟选择、上传进度、取消、失败和重试，不依赖平台插件。'),
    ],
    components: [
      component('HyTextField', 'hy_text_field.dart', '支持校验、多行、清除、密码显隐、错误和字数限制。', { demoId: 'inputs' }),
      component('HySegmentedControl / HySegmentOption', 'hy_segmented_control.dart', '适用于少量互斥选项的受控分段选择。', { demoId: 'inputs' }),
      component('HySelect / HyOption', 'hy_select.dart', '底部弹层单选或多选，支持禁用项。'),
      component('HyDropdown', 'hy_dropdown.dart', '锚定触发器展开、适合在选择时保持页面上下文的泛型下拉。'),
      component('HyCheckbox', 'hy_selection_controls.dart', '支持三态、禁用和标签的受控复选。'),
      component('HyRadio', 'hy_selection_controls.dart', '泛型值受控单选。'),
      component('HySwitch', 'hy_selection_controls.dart', '布尔值受控开关。'),
      component('HySlider', 'hy_selection_controls.dart', '范围、分段和结束回调可配置的滑块。'),
      component('HyRate', 'hy_selection_controls.dart', '数量、步长和图标可配置的评分。'),
      component('HyPicker', 'hy_picker.dart', '通过滚轮完成普通选项选择。'),
      component('HyDatePicker', 'hy_picker.dart', '提供日期、时间和日期区间选择入口。'),
      component('HyUploader / HyUploadSource / HyUploadStatus / HyUploadFile / HyUploadCancellation / HyUploadItem', 'hy_uploader.dart', '通过注入式适配器完成选择、上传、进度、取消、失败与重试。', { demoId: 'upload' }),
      component('HyFilePicker / HyFileUpload', 'hy_uploader.dart', '由业务层实现的文件选择与上传函数类型。', { sidebar: false }),
    ],
    conventions: [
      '`HySelect.values` 是已提交值；多选仅在确认后触发 `onChanged`。',
      '上传组件不直接依赖相册、文件系统或 HTTP 插件，平台能力通过 `HyFilePicker` 与 `HyFileUpload` 注入。',
    ],
  },
  {
    id: 'feedback',
    title: '反馈与浮层',
    navTitle: '反馈与浮层',
    description: '玻璃 Toast、对话框、加载、通知、Drawer、BottomSheet 与锚点菜单。',
    page: '/components/feedback',
    demos: [
      demo('feedback', '基础反馈状态', 'feedback_example.dart', 520, '空状态、徽标和常用反馈组合。'),
      demo('overlays', '反馈与弹层交互', 'interactive_examples.dart', 700, '可实际打开 Toast、Dialog、BottomSheet、Popover 和加载层。'),
      demo('drawer', '抽屉交互', 'drawer_example.dart', 620, '检查左右抽屉、固定底部操作和返回值。'),
    ],
    components: [
      component('HyToast', 'hy_feedback.dart', '支持语义色和可选撤销动作的玻璃轻提示。'),
      component('HyDialog', 'hy_feedback.dart', '确认、提示或自定义正文对话框。'),
      component('HyLoading', 'hy_feedback.dart', '局部加载状态与自动清理的全局任务遮罩。'),
      component('HyAlert', 'hy_feedback.dart', '可关闭的语义通知。'),
      component('HyBottomSheet', 'hy_bottom_sheet.dart', '适配安全区、键盘与最大高度的自定义底部弹层。'),
      component('HyDrawer / HyDrawerPlacement', 'hy_drawer.dart', '支持双侧弹出、RTL、自定义宽度、固定底部操作区与泛型返回结果的柔光抽屉。', { demoId: 'drawer' }),
      component('HyActionSheet / HyAction', 'hy_bottom_sheet.dart', '支持危险项与禁用项的底部操作菜单。'),
      component('HyPopover', 'hy_popover.dart', '锚定子组件的补充说明气泡。'),
      component('HyPopupMenu', 'hy_popover.dart', '基于 HyAction 的泛型弹出菜单。'),
      component('HyNoticeBar', 'hy_notice_bar.dart', '短公告静止、长公告滚动的可关闭通知条。'),
    ],
    conventions: ['`HyLoading.during` 会在 `finally` 中仅移除自己的遮罩，任务异常继续交给调用方。'],
  },
  {
    id: 'navigation',
    title: '导航与菜单',
    navTitle: '导航与菜单',
    description: 'Navbar、可拖拽 TabBar、标签、步骤、进度、列表、分组菜单与侧滑操作。',
    page: '/components/navigation',
    demos: [
      demo('navigation', '基础导航', 'navigation_example.dart', 520),
      demo('full-navigation', '导航、步骤与列表联动', 'complete_examples.dart', 860),
    ],
    components: [
      component('HyTopBar / HyNavBar', 'hy_top_bar.dart', '支持副标题、自定义前导、操作区和悬浮材质的页面顶部栏。', { id: 'nav-bar', navName: 'HyNavBar', demoId: 'navigation' }),
      component('HyTabBar / HyTabItem', 'hy_navigation.dart', '支持拖拽、速度投影、弹簧吸附、RTL 与安全区的悬浮导航。', { demoId: 'navigation' }),
      component('HyTabs / HyTabBarView', 'hy_navigation.dart', '共享 TabController 的标签与页面联动。'),
      component('HySteps / HyStep', 'hy_navigation.dart', '横向或纵向步骤状态。'),
      component('HyProgress', 'hy_navigation.dart', '线性、环形、确定或不定进度。'),
      component('HyProgressBar', 'hy_progress_bar.dart', '紧凑线性进度条。'),
      component('HyListTile', 'hy_list_tile.dart', '支持图标、头像、标签、元信息和自定义尾部的列表项。'),
      component('HyList', 'hy_lists.dart', '不绑定数据模型的轻量分隔列表。'),
      component('HyMenuList / HyMenuItem / HyMenuGroup', 'hy_lists.dart', '设置页、个人中心和详情页通用的描述式分组菜单。'),
      component('HySlideMenu / HySlideAction', 'hy_slide_menu.dart', '支持 RTL、速度投影、弹簧吸附与边界阻尼的侧滑菜单。'),
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
    title: '复合组件',
    navTitle: '复合组件',
    description: '由基础组件组合而成的搜索、倒计时、折叠面板和时间轴，仍保持业务无关。',
    page: '/components/composites',
    demos: [
      demo('business', '业务组件组合', 'interactive_examples.dart', 850, '搜索、通知、倒计时、设置菜单、折叠面板与时间轴。'),
    ],
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
    title: '主题与基础设施',
    navTitle: '主题与基础设施',
    description: '语义颜色、玻璃材质、间距、圆角、动效与平台辅助工具。',
    page: '/components/utilities',
    demos: [
      demo('overview', '主题化组件概览', 'overview_example.dart', 420, '文档明暗主题会同步到 Flutter 预览。'),
    ],
    components: [
      component('HyUiTheme', '../theme/hy_ui_theme.dart', '明暗主题的 ThemeData 构造入口。'),
      component('HyUiThemeTokens', '../theme/hy_ui_theme_tokens.dart', '组件消费的 ThemeExtension 语义令牌。'),
      component('HyGlassTheme', '../theme/hy_glass_theme.dart', '玻璃表面、边缘、阴影、选中态、控件轨道与遮罩令牌。'),
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

export interface ComponentDocumentEntry extends ComponentEntry {
  groupId: string;
  groupTitle: string;
}

export interface ComponentSidebarSection {
  id: string;
  title: string;
  components: ComponentDocumentEntry[];
}

export const componentEntries: ComponentDocumentEntry[] = componentGroups.flatMap((group) => (
  group.components.map((entry) => ({
    ...entry,
    groupId: group.id,
    groupTitle: group.title,
  }))
));

const listComponentIds = new Set([
  'list-tile', 'list', 'menu-list', 'slide-menu', 'pull-refresh', 'load-more', 'sticky',
]);
const actionComponentIds = new Set(['button', 'pressable']);

/** 侧栏只展示分类标题和组件叶子项，不再链接分类聚合页。 */
export const componentSidebarSections: ComponentSidebarSection[] = componentGroups.flatMap((group) => {
  const entries = componentEntries.filter((entry) => (
    entry.groupId === group.id && entry.sidebar !== false
  ));
  if (group.id === 'actions') {
    return [
      {
        id: 'actions',
        title: '操作组件',
        components: entries.filter((entry) => actionComponentIds.has(entry.id)),
      },
      {
        id: 'containers',
        title: '容器与材质',
        components: entries.filter((entry) => !actionComponentIds.has(entry.id)),
      },
    ];
  }
  if (group.id !== 'navigation') {
    return [{ id: group.id, title: group.title, components: entries }];
  }
  return [
    {
      id: 'navigation',
      title: '导航组件',
      components: entries.filter((entry) => !listComponentIds.has(entry.id)),
    },
    {
      id: 'lists',
      title: '列表组件',
      components: entries.filter((entry) => listComponentIds.has(entry.id)),
    },
  ];
});

export function getComponentEntry(id: string) {
  const entry = componentEntries.find((item) => item.id === id);
  if (!entry) throw new Error(`Unknown component document: ${id}`);
  return {
    entry,
    group: getComponentGroup(entry.groupId),
  };
}
