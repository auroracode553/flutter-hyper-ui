export interface ComponentPropDoc {
  name: string;
  description: string;
}

export interface ComponentEntry {
  id: string;
  name: string;
  navName: string;
  page: string;
  source: string;
  summary: string;
  preview?: ComponentDemo;
  sidebar?: boolean;
  propsDocs?: ComponentPropDoc[];
}

export interface ComponentDemo {
  id: string;
  title: string;
  description?: string;
  height: number;
  source: string;
  symbol?: string;
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
  preview?: ComponentDemo;
  sidebar?: boolean;
  propsDocs?: ComponentPropDoc[];
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
    preview: options.preview,
    sidebar: options.sidebar ?? true,
    propsDocs: options.propsDocs,
  };
};

const demo = (
  id: string,
  title: string,
  source: string,
  height: number,
  description?: string,
  symbol?: string,
): ComponentDemo => ({ id, title, source, height, description, symbol });

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
      component('HyText / HyTextStyle', 'hy_typography.dart', '统一的显示、标题、正文、说明和提示文字层级。', {
        preview: demo('component-text', 'HyText 文字层级', 'component_foundation_examples.dart', 360, '逐级展示六种文字语义。', 'TextComponentExample'),
      }),
      component('HyIcon / HyIcons', 'hy_typography.dart', '带语义标签的图标组件与常用业务图标集合。', {
        preview: demo('component-icon', 'HyIcon 图标', 'component_foundation_examples.dart', 250, '展示常用语义图标与无障碍标签。', 'IconComponentExample'),
      }),
      component('HyImage', 'hy_image.dart', '支持 ImageProvider、网络、资源、占位、失败态与缩放预览。', {
        propsDocs: [
          { name: 'provider', description: '图片数据源，ImageProvider 类型' },
          { name: 'width', description: '图片宽度' },
          { name: 'height', description: '图片高度' },
          { name: 'radius', description: '圆角大小，默认 16' },
          { name: 'fit', description: '图片适配方式，默认 BoxFit.cover' },
          { name: 'placeholder', description: '加载中占位组件' },
          { name: 'errorPlaceholder', description: '加载失败占位组件' },
          { name: 'preview', description: '是否点击进入全屏预览，默认 false' },
          { name: 'semanticLabel', description: '语义化标签，用于无障碍' },
        ],
        preview: demo('component-image', 'HyImage 图片', 'component_foundation_examples.dart', 340, '点击图片进入缩放预览。', 'ImageComponentExample'),
      }),
      component('HyAvatar', 'hy_image.dart', '图片、文字或默认图标头像，支持圆形和自定义圆角。', {
        preview: demo('component-avatar', 'HyAvatar 头像', 'component_foundation_examples.dart', 250, '展示文字、默认图标与圆角头像。', 'AvatarComponentExample'),
      }),
      component('HyCountBadge', 'hy_image.dart', '红点、数字和最大值角标。', {
        preview: demo('component-count-badge', 'HyCountBadge 数字角标', 'component_foundation_examples.dart', 250, '展示数字、最大值和红点角标。', 'CountBadgeComponentExample'),
      }),
      component('HyBadge', 'hy_badge.dart', '紧凑型语义状态徽标。', {
        preview: demo('component-badge', 'HyBadge 状态徽标', 'component_foundation_examples.dart', 260, '展示不同语义色与强调层级。', 'BadgeComponentExample'),
      }),
      component('HyTag', 'hy_tag.dart', '支持语义色、选择、点击和关闭的标签。', {
        preview: demo('component-tag', 'HyTag 标签', 'component_foundation_examples.dart', 260, '点击选择或移除标签。', 'TagComponentExample'),
      }),
      component('HyUiTone / HyUiToneResolver', 'hy_tone.dart', '跨组件共用的语义状态及其主题颜色解析扩展。', {
        sidebar: false,
        preview: demo('component-ui-tone', 'HyUiTone 语义色', 'component_foundation_examples.dart', 250, '展示所有跨组件语义状态。', 'ToneComponentExample'),
      }),
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
      component('HyButton / HyButtonVariant / HyButtonSize', 'hy_button.dart', '五种视觉层级、三种尺寸、加载、禁用、图标和通栏状态。', {
        preview: demo('component-button', 'HyButton 状态', 'buttons_example.dart', 360, '只展示按钮的层级、尺寸和状态。'),
      }),
      component('HyCard', 'hy_card.dart', '具有标题、操作区、正文、底部和选中态的内容容器。', {
        preview: demo('component-card', 'HyCard 结构', 'component_surface_examples.dart', 340, '只展示卡片的标题、正文和操作区。', 'CardComponentExample'),
      }),
      component('HyGlass', 'hy_glass.dart', '可配置模糊、背景、边框、阴影和点击行为的玻璃材质。', {
        preview: demo('component-glass', 'HyGlass 材质', 'component_surface_examples.dart', 320, '只展示不同重量的玻璃表面。', 'GlassComponentExample'),
      }),
      component('HyGlassWeight', 'hy_glass.dart', '按表面面积和层级区分轻薄、标准、突出与实色材质。', {
        sidebar: false,
        preview: demo('component-glass-weight', 'HyGlassWeight 材质重量', 'component_action_examples.dart', 300, '对比四种玻璃材质重量。', 'GlassWeightComponentExample'),
      }),
      component('HyPressable', 'hy_pressable.dart', '按下即响应、可适配减少动画的通用触控反馈层。', {
        preview: demo('component-pressable', 'HyPressable 按压反馈', 'component_action_examples.dart', 280, '按住表面感受即时缩放与透明度反馈。', 'PressableComponentExample'),
      }),
      component('HySoftBackground', 'hy_glass.dart', '为页面提供与明暗主题同步的柔光背景。', {
        preview: demo('component-soft-background', 'HySoftBackground 柔光背景', 'component_action_examples.dart', 320, '展示环境色与玻璃材质的景深关系。', 'SoftBackgroundComponentExample'),
      }),
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
      component('HySpace', 'hy_layout.dart', '在线性方向排列子项并统一插入间距。', {
        preview: demo('component-space', 'HySpace 间距布局', 'component_layout_examples.dart', 340, '展示线性排列与统一间距。', 'SpaceComponentExample'),
      }),
      component('HyWrap', 'hy_layout.dart', '带统一主轴和换行间距的流式布局。', {
        preview: demo('component-wrap', 'HyWrap 流式布局', 'component_layout_examples.dart', 280, '缩放预览宽度观察自动换行。', 'WrapComponentExample'),
      }),
      component('HyGrid', 'hy_layout.dart', '固定列数和宽高比的轻量网格。', {
        preview: demo('component-grid', 'HyGrid 网格', 'component_layout_examples.dart', 380, '展示三列自适应网格。', 'GridComponentExample'),
      }),
      component('HyDivider', 'hy_layout.dart', '横向或纵向、实线或虚线分隔。', {
        preview: demo('component-divider', 'HyDivider 分割线', 'component_layout_examples.dart', 300, '展示横向、纵向、实线与虚线。', 'DividerComponentExample'),
      }),
      component('HySkeleton', 'hy_layout.dart', '适配减少动画设置的列表或卡片扫光占位。', {
        preview: demo('component-skeleton', 'HySkeleton 骨架屏', 'component_feedback_examples.dart', 360, '只展示卡片与列表骨架状态。', 'SkeletonComponentExample'),
      }),
      component('HyEmptyState', 'hy_empty_state.dart', '包含图标、标题、说明和操作的空状态。', {
        preview: demo('component-empty-state', 'HyEmptyState 空状态', 'component_layout_examples.dart', 390, '展示图标、说明和恢复操作。', 'EmptyStateComponentExample'),
      }),
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
      component('HyTextField', 'hy_text_field.dart', '支持校验、多行、清除、密码显隐、错误和字数限制。', {
        preview: demo('component-text-field', 'HyTextField 输入框', 'component_form_examples.dart', 390, '只展示输入、辅助文案和错误状态。', 'TextFieldComponentExample'),
      }),
      component('HySegmentedControl / HySegmentOption', 'hy_segmented_control.dart', '适用于少量互斥选项的受控分段选择。', {
        preview: demo('component-segmented-control', 'HySegmentedControl 分段选择', 'component_form_examples.dart', 280, '只展示受控分段选择。', 'SegmentedControlComponentExample'),
      }),
      component('HySelect / HyOption', 'hy_select.dart', '底部弹层单选或多选，支持禁用项。', {
        preview: demo('component-select', 'HySelect 底部选择', 'component_form_examples.dart', 300, '打开弹层完成多选并确认。', 'SelectComponentExample'),
      }),
      component('HyDropdown', 'hy_dropdown.dart', '锚定触发器展开、适合在选择时保持页面上下文的泛型下拉。', {
        preview: demo('component-dropdown', 'HyDropdown 下拉菜单', 'component_form_examples.dart', 320, '只展示锚定式单选下拉。', 'DropdownComponentExample'),
      }),
      component('HyCheckbox', 'hy_selection_controls.dart', '支持三态、禁用和标签的受控复选。', {
        preview: demo('component-checkbox', 'HyCheckbox 复选框', 'component_form_examples.dart', 260, '只展示受控复选状态。', 'CheckboxComponentExample'),
      }),
      component('HyRadio', 'hy_selection_controls.dart', '泛型值受控单选。', {
        preview: demo('component-radio', 'HyRadio 单选框', 'component_form_examples.dart', 300, '只展示一组互斥单选项。', 'RadioComponentExample'),
      }),
      component('HySwitch', 'hy_selection_controls.dart', '布尔值受控开关。', {
        preview: demo('component-switch', 'HySwitch 开关', 'component_form_examples.dart', 260, '只展示开关的开启、关闭与禁用状态。', 'SwitchComponentExample'),
      }),
      component('HySlider', 'hy_selection_controls.dart', '范围、分段和结束回调可配置的滑块。', {
        preview: demo('component-slider', 'HySlider 滑块', 'component_form_examples.dart', 280, '只展示可拖动的离散数值滑块。', 'SliderComponentExample'),
      }),
      component('HyRate', 'hy_selection_controls.dart', '数量、步长和图标可配置的评分。', {
        preview: demo('component-rate', 'HyRate 评分', 'component_form_examples.dart', 250, '点击星级修改当前评分。', 'RateComponentExample'),
      }),
      component('HyPicker', 'hy_picker.dart', '通过滚轮完成普通选项选择。', {
        preview: demo('component-picker', 'HyPicker 滚轮选择器', 'component_form_examples.dart', 270, '打开底部滚轮选择一个选项。', 'PickerComponentExample'),
      }),
      component('HyDatePicker', 'hy_picker.dart', '提供日期、时间和日期区间选择入口。', {
        preview: demo('component-date-picker', 'HyDatePicker 日期选择', 'component_form_examples.dart', 270, '调用平台一致的日期选择入口。', 'DatePickerComponentExample'),
      }),
      component('HyUploader / HyUploadSource / HyUploadStatus / HyUploadFile / HyUploadCancellation / HyUploadItem', 'hy_uploader.dart', '通过注入式适配器完成选择、上传、进度、取消、失败与重试。', {
        preview: demo('component-uploader', 'HyUploader 上传', 'upload_example.dart', 620, '只展示文件选择、进度、取消和重试状态。'),
      }),
      component('HyFilePicker / HyFileUpload', 'hy_uploader.dart', '由业务层实现的文件选择与上传函数类型。', {
        sidebar: false,
        preview: demo('component-file-picker', '文件能力注入', 'component_form_examples.dart', 280, '说明选择器与上传器的职责边界。', 'FilePickerComponentExample'),
      }),
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
      component('HyToast', 'hy_feedback.dart', '支持语义色和可选撤销动作的玻璃轻提示。', {
        preview: demo('component-toast', 'HyToast 轻提示', 'component_feedback_examples.dart', 280, '点击按钮查看成功、警告和错误提示。', 'ToastComponentExample'),
      }),
      component('HyDialog', 'hy_feedback.dart', '确认、提示或自定义正文对话框。', {
        preview: demo('component-dialog', 'HyDialog 对话框', 'component_feedback_examples.dart', 260, '打开玻璃确认对话框。', 'DialogComponentExample'),
      }),
      component('HyLoading', 'hy_feedback.dart', '局部加载状态与自动清理的全局任务遮罩。', {
        preview: demo('component-loading', 'HyLoading 加载', 'component_feedback_examples.dart', 280, '展示局部加载与自动清理的全局遮罩。', 'LoadingComponentExample'),
      }),
      component('HyAlert', 'hy_feedback.dart', '可关闭的语义通知。', {
        preview: demo('component-alert', 'HyAlert 通知', 'component_feedback_examples.dart', 280, '关闭并重新显示语义通知。', 'AlertComponentExample'),
      }),
      component('HyBottomSheet', 'hy_bottom_sheet.dart', '适配安全区、键盘与最大高度的自定义底部弹层。', {
        preview: demo('component-bottom-sheet', 'HyBottomSheet 底部弹层', 'component_feedback_examples.dart', 260, '打开适配安全区的自定义弹层。', 'BottomSheetComponentExample'),
      }),
      component('HyDrawer / HyDrawerPlacement', 'hy_drawer.dart', '支持双侧弹出、RTL、自定义宽度、固定底部操作区与泛型返回结果的柔光抽屉。', {
        preview: demo('component-drawer', 'HyDrawer 抽屉', 'component_feedback_examples.dart', 320, '只展示抽屉的打开、关闭和返回结果。', 'DrawerComponentExample'),
      }),
      component('HyActionSheet / HyAction', 'hy_bottom_sheet.dart', '支持危险项与禁用项的底部操作菜单。', {
        preview: demo('component-action-sheet', 'HyActionSheet 操作菜单', 'component_feedback_examples.dart', 260, '打开含普通与危险操作的底部菜单。', 'ActionSheetComponentExample'),
      }),
      component('HyPopover', 'hy_popover.dart', '锚定子组件的补充说明气泡。', {
        preview: demo('component-popover', 'HyPopover 气泡', 'component_feedback_examples.dart', 260, '点击锚点查看补充说明。', 'PopoverComponentExample'),
      }),
      component('HyPopupMenu', 'hy_popover.dart', '基于 HyAction 的泛型弹出菜单。', {
        preview: demo('component-popup-menu', 'HyPopupMenu 弹出菜单', 'component_feedback_examples.dart', 260, '选择菜单项并读取泛型返回值。', 'PopupMenuComponentExample'),
      }),
      component('HyNoticeBar', 'hy_notice_bar.dart', '短公告静止、长公告滚动的可关闭通知条。', {
        preview: demo('component-notice-bar', 'HyNoticeBar 公告栏', 'component_feedback_examples.dart', 270, '长公告自动滚动并支持关闭。', 'NoticeBarComponentExample'),
      }),
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
      component('HyTopBar / HyNavBar', 'hy_top_bar.dart', '支持副标题、自定义前导、操作区和悬浮材质的页面顶部栏。', {
        id: 'nav-bar',
        navName: 'HyNavBar',
        preview: demo('component-nav-bar', 'HyNavBar 顶部导航', 'component_navigation_examples.dart', 260, '只展示标题、副标题和操作区。', 'NavBarComponentExample'),
      }),
      component('HyTabBar / HyTabItem', 'hy_navigation.dart', '支持拖拽、速度投影、弹簧吸附、RTL 与安全区的悬浮导航。', {
        preview: demo('component-tab-bar', 'HyTabBar 底部导航', 'component_navigation_examples.dart', 320, '拖动或点击胶囊切换当前项。', 'TabBarComponentExample'),
      }),
      component('HyTabs / HyTabBarView', 'hy_navigation.dart', '共享 TabController 的标签与页面联动。', {
        preview: demo('component-tabs', 'HyTabs 标签页', 'component_navigation_examples.dart', 350, '点击标签或横向滑动页面。', 'TabsComponentExample'),
      }),
      component('HySteps / HyStep', 'hy_navigation.dart', '横向或纵向步骤状态。', {
        preview: demo('component-steps', 'HySteps 步骤', 'component_navigation_examples.dart', 300, '切换当前步骤检查完成状态。', 'StepsComponentExample'),
      }),
      component('HyProgress', 'hy_navigation.dart', '线性、环形、确定或不定进度。', {
        preview: demo('component-progress', 'HyProgress 进度', 'component_navigation_examples.dart', 330, '展示线性、环形和不定进度。', 'ProgressComponentExample'),
      }),
      component('HyProgressBar', 'hy_progress_bar.dart', '紧凑线性进度条。', {
        preview: demo('component-progress-bar', 'HyProgressBar 进度条', 'component_navigation_examples.dart', 280, '展示不同厚度的紧凑进度轨道。', 'ProgressBarComponentExample'),
      }),
      component('HyListTile', 'hy_list_tile.dart', '支持图标、头像、标签、元信息和自定义尾部的列表项。', {
        preview: demo('component-list-tile', 'HyListTile 列表项', 'component_navigation_examples.dart', 300, '只展示普通、选中和禁用列表项。', 'ListTileComponentExample'),
      }),
      component('HyList', 'hy_lists.dart', '不绑定数据模型的轻量分隔列表。', {
        preview: demo('component-list', 'HyList 列表', 'component_navigation_examples.dart', 380, '只展示列表容器的间距和分隔。', 'ListComponentExample'),
      }),
      component('HyMenuList / HyMenuItem / HyMenuGroup', 'hy_lists.dart', '设置页、个人中心和详情页通用的描述式分组菜单。', {
        preview: demo('component-menu-list', 'HyMenuList 菜单列表', 'component_navigation_examples.dart', 420, '只展示设置页式分组菜单。', 'MenuListComponentExample'),
      }),
      component('HySlideMenu / HySlideAction', 'hy_slide_menu.dart', '支持 RTL、速度投影、弹簧吸附与边界阻尼的侧滑菜单。', {
        preview: demo('component-slide-menu', 'HySlideMenu 侧滑菜单', 'component_navigation_examples.dart', 300, '左右拖动列表行查看快捷操作。', 'SlideMenuComponentExample'),
      }),
      component('HyPullRefresh', 'hy_lists.dart', '对 RefreshIndicator 的语义化封装。', {
        preview: demo('component-pull-refresh', 'HyPullRefresh 下拉刷新', 'component_navigation_examples.dart', 360, '下拉列表触发异步刷新。', 'PullRefreshComponentExample'),
      }),
      component('HyLoadMore', 'hy_lists.dart', '串行分页、终态与失败重试。', {
        preview: demo('component-load-more', 'HyLoadMore 分页加载', 'component_navigation_examples.dart', 360, '滚动到底部或点击触发下一页。', 'LoadMoreComponentExample'),
      }),
      component('HySticky', 'hy_lists.dart', '用于 CustomScrollView.slivers 的吸顶内容。', {
        preview: demo('component-sticky', 'HySticky 吸顶', 'component_navigation_examples.dart', 380, '滚动列表观察标题保持在顶部。', 'StickyComponentExample'),
      }),
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
      component('HySearchBar', 'hy_business.dart', '包含搜索、提交和清空交互的输入入口。', {
        preview: demo('component-search-bar', 'HySearchBar 搜索栏', 'component_composite_examples.dart', 300, '输入关键词观察受控搜索状态。', 'SearchBarComponentExample'),
      }),
      component('HyCountDown', 'hy_business.dart', '基于截止时间计算，并在应用恢复前台时校准。', {
        preview: demo('component-count-down', 'HyCountDown 倒计时', 'component_composite_examples.dart', 280, '基于绝对截止时间显示并校准倒计时。', 'CountDownComponentExample'),
      }),
      component('HyCollapse', 'hy_business.dart', '标题与正文组成的折叠内容。', {
        preview: demo('component-collapse', 'HyCollapse 折叠面板', 'component_composite_examples.dart', 360, '独立展开或收起内容区域。', 'CollapseComponentExample'),
      }),
      component('HyTimeline / HyTimelineItem', 'hy_business.dart', '订单、物流和流程事件时间轴。', {
        preview: demo('component-timeline', 'HyTimeline 时间轴', 'component_composite_examples.dart', 370, '展示已完成、当前和待处理事件。', 'TimelineComponentExample'),
      }),
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
      component('HyUiTheme', '../theme/hy_ui_theme.dart', '明暗主题的 ThemeData 构造入口。', {
        preview: demo('component-ui-theme', 'HyUiTheme 主题', 'component_theme_examples.dart', 290, '并排查看明暗 ThemeData 的基础表面。', 'UiThemeComponentExample'),
      }),
      component('HyUiThemeTokens', '../theme/hy_ui_theme_tokens.dart', '组件消费的 ThemeExtension 语义令牌。', {
        preview: demo('component-ui-theme-tokens', 'HyUiThemeTokens 令牌', 'component_theme_examples.dart', 300, '查看当前主题的关键语义令牌。', 'UiThemeTokensComponentExample'),
      }),
      component('HyGlassTheme', '../theme/hy_glass_theme.dart', '玻璃表面、边缘、阴影、选中态、控件轨道与遮罩令牌。', {
        preview: demo('component-glass-theme', 'HyGlassTheme 材质令牌', 'component_theme_examples.dart', 300, '查看玻璃表面与交互状态令牌。', 'GlassThemeComponentExample'),
      }),
      component('HyUiColors', '../theme/hy_ui_colors.dart', '组件库基础色板。', {
        preview: demo('component-ui-colors', 'HyUiColors 基础色', 'component_theme_examples.dart', 280, '展示组件库默认功能色。', 'UiColorsComponentExample'),
      }),
      component('HyUiSpacing', '../theme/hy_ui_spacing.dart', '统一间距常量。', {
        preview: demo('component-ui-spacing', 'HyUiSpacing 间距', 'component_theme_examples.dart', 350, '用比例条展示基础间距刻度。', 'UiSpacingComponentExample'),
      }),
      component('HyUiRadii', '../theme/hy_ui_radii.dart', '统一圆角常量。', {
        preview: demo('component-ui-radii', 'HyUiRadii 圆角', 'component_theme_examples.dart', 280, '对比四级圆角令牌。', 'UiRadiiComponentExample'),
      }),
      component('HyUiEffects', '../theme/hy_ui_effects.dart', '玻璃模糊、阴影与选择动效常量。', {
        preview: demo('component-ui-effects', 'HyUiEffects 动效与阴影', 'component_theme_examples.dart', 280, '展示统一的表面阴影与效果参数。', 'UiEffectsComponentExample'),
      }),
      component('HyUiBuildContext', '../theme/hy_ui_context.dart', '通过 `context.hyUi` 读取主题令牌的扩展。', {
        preview: demo('component-ui-build-context', 'HyUiBuildContext 扩展', 'component_theme_examples.dart', 270, '通过 BuildContext 读取主题与材质。', 'UiBuildContextComponentExample'),
      }),
      component('HyThemeController', '../utils/hy_utils.dart', '由应用持有的主题模式与主色控制器。', {
        preview: demo('component-theme-controller', 'HyThemeController 控制器', 'component_theme_examples.dart', 270, '切换并监听主题模式状态。', 'ThemeControllerComponentExample'),
      }),
      component('HyScreen', '../utils/hy_utils.dart', '屏幕宽度、紧凑断点、dp 与 rpx 换算。', {
        preview: demo('component-screen', 'HyScreen 屏幕适配', 'component_theme_examples.dart', 310, '实时读取当前预览宽度和换算结果。', 'ScreenComponentExample'),
      }),
      component('HyKeyboard / HyRoute / HySafeArea', '../utils/hy_utils.dart', '键盘、路由和安全区常用操作。', {
        preview: demo('component-keyboard', '键盘、路由与安全区', 'component_theme_examples.dart', 320, '展示键盘收起和安全区包装。', 'KeyboardComponentExample'),
      }),
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
