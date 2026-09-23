import 'package:flutter/widgets.dart';

import 'examples/actions_example.dart';
import 'examples/buttons_example.dart';
import 'examples/cards_example.dart';
import 'examples/component_action_examples.dart';
import 'examples/component_composite_examples.dart';
import 'examples/component_feedback_examples.dart';
import 'examples/component_foundation_examples.dart';
import 'examples/component_form_examples.dart';
import 'examples/component_layout_examples.dart';
import 'examples/component_navigation_examples.dart';
import 'examples/component_surface_examples.dart';
import 'examples/component_theme_examples.dart';
import 'examples/data_example.dart';
import 'examples/drawer_example.dart';
import 'examples/feedback_example.dart';
import 'examples/glass_library_example.dart';
import 'examples/inputs_example.dart';
import 'examples/navigation_example.dart';
import 'examples/overview_example.dart';
import 'examples/upload_example.dart';
import 'examples/complete_examples.dart';
import 'examples/home_hero_example.dart';
import 'examples/interactive_examples.dart';

typedef PreviewBuilder = Widget Function(BuildContext context);

class PreviewItem {
  final String id;
  final String title;
  final String description;
  final PreviewBuilder builder;

  const PreviewItem({
    required this.id,
    required this.title,
    required this.description,
    required this.builder,
  });
}

PreviewItem _componentPreview(
  String id,
  String title,
  String description,
  PreviewBuilder builder,
) => PreviewItem(id: id, title: title, description: description, builder: builder);

class PreviewCatalog {
  const PreviewCatalog._();

  static const defaultId = 'glass-library';

  static final List<PreviewItem> items = [
    PreviewItem(
      id: 'glass-library',
      title: '柔性玻璃组件库',
      description: '通用导航、表单、菜单、反馈与加载组件。',
      builder: (_) => const GlassLibraryExample(),
    ),
    PreviewItem(
      id: 'home-hero',
      title: '首页真机',
      description: '首页英雄区的真实组件拼合。',
      builder: (_) => const HomeHeroExample(),
    ),
    PreviewItem(
      id: 'drawer',
      title: 'Drawer 抽屉',
      description: '侧边导航、筛选与返回结果。',
      builder: (_) => const DrawerExample(),
    ),
    PreviewItem(
      id: 'actions',
      title: '按钮与卡片',
      description: '动作层级、状态与内容容器。',
      builder: (_) => const ActionsExample(),
    ),
    PreviewItem(
      id: 'atoms',
      title: '基础原子',
      description: '文字、图标、图片、头像与角标。',
      builder: (_) => const AtomsExample(),
    ),
    PreviewItem(
      id: 'layout',
      title: '布局容器',
      description: '玻璃卡片、网格、流式布局与骨架。',
      builder: (_) => const LayoutExample(),
    ),
    PreviewItem(
      id: 'forms',
      title: '完整表单',
      description: '输入、选择、评分、日期与上传。',
      builder: (_) => const FormsExample(),
    ),
    PreviewItem(
      id: 'upload',
      title: '文件上传',
      description: '选择、进度、取消、失败和重试状态。',
      builder: (_) => const UploadExample(),
    ),
    PreviewItem(
      id: 'overlays',
      title: '反馈弹层',
      description: '轻提示、弹窗、菜单与加载。',
      builder: (_) => const OverlayExample(),
    ),
    PreviewItem(
      id: 'full-navigation',
      title: '导航与列表',
      description: '悬浮导航、页面联动、刷新分页与吸顶。',
      builder: (_) => const FullNavigationExample(),
    ),
    PreviewItem(
      id: 'business',
      title: '业务组件',
      description: '设置菜单、搜索、倒计时与时间轴。',
      builder: (_) => const BusinessExample(),
    ),
    PreviewItem(
      id: 'overview',
      title: '组件概览',
      description: 'Hy UI 的基础控件组合。',
      builder: (_) => const OverviewExample(),
    ),
    PreviewItem(
      id: 'buttons',
      title: 'Button 按钮',
      description: '用于明确动作、弱动作与危险动作。',
      builder: (_) => const ButtonsExample(),
    ),
    PreviewItem(
      id: 'cards',
      title: 'Card 卡片',
      description: '用于承载列表项、状态摘要与操作区。',
      builder: (_) => const CardsExample(),
    ),
    PreviewItem(
      id: 'inputs',
      title: 'Input 输入',
      description: '输入框与分段选择的基础状态。',
      builder: (_) => const InputsExample(),
    ),
    PreviewItem(
      id: 'data',
      title: 'Data 数据展示',
      description: '列表项、标签与进度条。',
      builder: (_) => const DataExample(),
    ),
    PreviewItem(
      id: 'feedback',
      title: 'Feedback 反馈',
      description: '空状态与语义徽标。',
      builder: (_) => const FeedbackExample(),
    ),
    PreviewItem(
      id: 'navigation',
      title: 'Navigation 导航',
      description: '顶部栏与可点击列表项。',
      builder: (_) => const NavigationExample(),
    ),
    PreviewItem(
      id: 'component-button',
      title: 'HyButton',
      description: '按钮层级、尺寸与状态。',
      builder: (_) => const ButtonsExample(),
    ),
    PreviewItem(
      id: 'component-card',
      title: 'HyCard',
      description: '单一卡片的内容结构。',
      builder: (_) => const CardComponentExample(),
    ),
    PreviewItem(
      id: 'component-glass',
      title: 'HyGlass',
      description: '玻璃材质重量。',
      builder: (_) => const GlassComponentExample(),
    ),
    PreviewItem(
      id: 'component-skeleton',
      title: 'HySkeleton',
      description: '加载占位状态。',
      builder: (_) => const SkeletonComponentExample(),
    ),
    PreviewItem(
      id: 'component-text-field',
      title: 'HyTextField',
      description: '输入、辅助与错误状态。',
      builder: (_) => const TextFieldComponentExample(),
    ),
    PreviewItem(
      id: 'component-segmented-control',
      title: 'HySegmentedControl',
      description: '受控分段选择。',
      builder: (_) => const SegmentedControlComponentExample(),
    ),
    PreviewItem(
      id: 'component-dropdown',
      title: 'HyDropdown',
      description: '锚定式下拉选择。',
      builder: (_) => const DropdownComponentExample(),
    ),
    PreviewItem(
      id: 'component-checkbox',
      title: 'HyCheckbox',
      description: '受控复选状态。',
      builder: (_) => const CheckboxComponentExample(),
    ),
    PreviewItem(
      id: 'component-radio',
      title: 'HyRadio',
      description: '互斥单选状态。',
      builder: (_) => const RadioComponentExample(),
    ),
    PreviewItem(
      id: 'component-switch',
      title: 'HySwitch',
      description: '开启、关闭与禁用状态。',
      builder: (_) => const SwitchComponentExample(),
    ),
    PreviewItem(
      id: 'component-slider',
      title: 'HySlider',
      description: '连续拖动与离散数值。',
      builder: (_) => const SliderComponentExample(),
    ),
    PreviewItem(
      id: 'component-uploader',
      title: 'HyUploader',
      description: '上传进度、取消与重试。',
      builder: (_) => const UploadExample(),
    ),
    PreviewItem(
      id: 'component-toast',
      title: 'HyToast',
      description: '语义轻提示与操作。',
      builder: (_) => const ToastComponentExample(),
    ),
    PreviewItem(
      id: 'component-drawer',
      title: 'HyDrawer',
      description: '抽屉打开、关闭与返回值。',
      builder: (_) => const DrawerComponentExample(),
    ),
    PreviewItem(
      id: 'component-nav-bar',
      title: 'HyNavBar',
      description: '顶部标题、副标题与操作区。',
      builder: (_) => const NavBarComponentExample(),
    ),
    PreviewItem(
      id: 'component-tab-bar',
      title: 'HyTabBar',
      description: '可点击和拖拽的底部导航。',
      builder: (_) => const TabBarComponentExample(),
    ),
    PreviewItem(
      id: 'component-list-tile',
      title: 'HyListTile',
      description: '列表项的常见状态。',
      builder: (_) => const ListTileComponentExample(),
    ),
    PreviewItem(
      id: 'component-list',
      title: 'HyList',
      description: '轻量列表容器。',
      builder: (_) => const ListComponentExample(),
    ),
    PreviewItem(
      id: 'component-menu-list',
      title: 'HyMenuList',
      description: '设置页式分组菜单。',
      builder: (_) => const MenuListComponentExample(),
    ),
    PreviewItem(
      id: 'component-slide-menu',
      title: 'HySlideMenu',
      description: '双向拖拽快捷操作。',
      builder: (_) => const SlideMenuComponentExample(),
    ),
    _componentPreview('component-text', 'HyText', '六种语义文字层级。', (_) => const TextComponentExample()),
    _componentPreview('component-icon', 'HyIcon', '常用图标与语义标签。', (_) => const IconComponentExample()),
    _componentPreview('component-image', 'HyImage', '图片加载与缩放预览。', (_) => const ImageComponentExample()),
    _componentPreview('component-avatar', 'HyAvatar', '头像形态与尺寸。', (_) => const AvatarComponentExample()),
    _componentPreview('component-count-badge', 'HyCountBadge', '数字、最大值与红点角标。', (_) => const CountBadgeComponentExample()),
    _componentPreview('component-badge', 'HyBadge', '紧凑语义状态徽标。', (_) => const BadgeComponentExample()),
    _componentPreview('component-tag', 'HyTag', '可选择与可移除标签。', (_) => const TagComponentExample()),
    _componentPreview('component-ui-tone', 'HyUiTone', '跨组件语义状态。', (_) => const ToneComponentExample()),
    _componentPreview('component-glass-weight', 'HyGlassWeight', '四种玻璃材质重量。', (_) => const GlassWeightComponentExample()),
    _componentPreview('component-pressable', 'HyPressable', '即时按压反馈。', (_) => const PressableComponentExample()),
    _componentPreview('component-soft-background', 'HySoftBackground', '柔光环境背景。', (_) => const SoftBackgroundComponentExample()),
    _componentPreview('component-space', 'HySpace', '线性间距布局。', (_) => const SpaceComponentExample()),
    _componentPreview('component-wrap', 'HyWrap', '自适应流式布局。', (_) => const WrapComponentExample()),
    _componentPreview('component-grid', 'HyGrid', '固定列数网格。', (_) => const GridComponentExample()),
    _componentPreview('component-divider', 'HyDivider', '横纵与虚实分割线。', (_) => const DividerComponentExample()),
    _componentPreview('component-empty-state', 'HyEmptyState', '空状态与恢复操作。', (_) => const EmptyStateComponentExample()),
    _componentPreview('component-select', 'HySelect', '底部弹层选择。', (_) => const SelectComponentExample()),
    _componentPreview('component-rate', 'HyRate', '交互式星级评分。', (_) => const RateComponentExample()),
    _componentPreview('component-picker', 'HyPicker', '滚轮选择器。', (_) => const PickerComponentExample()),
    _componentPreview('component-date-picker', 'HyDatePicker', '日期选择入口。', (_) => const DatePickerComponentExample()),
    _componentPreview('component-file-picker', 'HyFilePicker', '文件能力注入边界。', (_) => const FilePickerComponentExample()),
    _componentPreview('component-dialog', 'HyDialog', '玻璃确认对话框。', (_) => const DialogComponentExample()),
    _componentPreview('component-loading', 'HyLoading', '局部与全局加载状态。', (_) => const LoadingComponentExample()),
    _componentPreview('component-alert', 'HyAlert', '可关闭语义通知。', (_) => const AlertComponentExample()),
    _componentPreview('component-bottom-sheet', 'HyBottomSheet', '安全区底部弹层。', (_) => const BottomSheetComponentExample()),
    _componentPreview('component-action-sheet', 'HyActionSheet', '底部操作菜单。', (_) => const ActionSheetComponentExample()),
    _componentPreview('component-popover', 'HyPopover', '锚定补充说明。', (_) => const PopoverComponentExample()),
    _componentPreview('component-popup-menu', 'HyPopupMenu', '泛型弹出菜单。', (_) => const PopupMenuComponentExample()),
    _componentPreview('component-notice-bar', 'HyNoticeBar', '可关闭滚动公告。', (_) => const NoticeBarComponentExample()),
    _componentPreview('component-tabs', 'HyTabs', '标签与页面联动。', (_) => const TabsComponentExample()),
    _componentPreview('component-steps', 'HySteps', '步骤状态。', (_) => const StepsComponentExample()),
    _componentPreview('component-progress', 'HyProgress', '线性与环形进度。', (_) => const ProgressComponentExample()),
    _componentPreview('component-progress-bar', 'HyProgressBar', '紧凑线性进度条。', (_) => const ProgressBarComponentExample()),
    _componentPreview('component-pull-refresh', 'HyPullRefresh', '下拉刷新。', (_) => const PullRefreshComponentExample()),
    _componentPreview('component-load-more', 'HyLoadMore', '分页加载与终态。', (_) => const LoadMoreComponentExample()),
    _componentPreview('component-sticky', 'HySticky', '吸顶内容。', (_) => const StickyComponentExample()),
    _componentPreview('component-search-bar', 'HySearchBar', '搜索输入入口。', (_) => const SearchBarComponentExample()),
    _componentPreview('component-count-down', 'HyCountDown', '绝对时间倒计时。', (_) => const CountDownComponentExample()),
    _componentPreview('component-collapse', 'HyCollapse', '折叠内容。', (_) => const CollapseComponentExample()),
    _componentPreview('component-timeline', 'HyTimeline', '流程事件时间轴。', (_) => const TimelineComponentExample()),
    _componentPreview('component-ui-theme', 'HyUiTheme', '明暗主题构造。', (_) => const UiThemeComponentExample()),
    _componentPreview('component-ui-theme-tokens', 'HyUiThemeTokens', '主题语义令牌。', (_) => const UiThemeTokensComponentExample()),
    _componentPreview('component-glass-theme', 'HyGlassTheme', '玻璃材质令牌。', (_) => const GlassThemeComponentExample()),
    _componentPreview('component-ui-colors', 'HyUiColors', '基础功能色板。', (_) => const UiColorsComponentExample()),
    _componentPreview('component-ui-spacing', 'HyUiSpacing', '统一间距刻度。', (_) => const UiSpacingComponentExample()),
    _componentPreview('component-ui-radii', 'HyUiRadii', '统一圆角刻度。', (_) => const UiRadiiComponentExample()),
    _componentPreview('component-ui-effects', 'HyUiEffects', '模糊、阴影与动效。', (_) => const UiEffectsComponentExample()),
    _componentPreview('component-ui-build-context', 'HyUiBuildContext', '上下文主题扩展。', (_) => const UiBuildContextComponentExample()),
    _componentPreview('component-theme-controller', 'HyThemeController', '主题状态控制器。', (_) => const ThemeControllerComponentExample()),
    _componentPreview('component-screen', 'HyScreen', '屏幕尺寸与单位换算。', (_) => const ScreenComponentExample()),
    _componentPreview('component-keyboard', 'HyKeyboard', '键盘、路由与安全区。', (_) => const KeyboardComponentExample()),
  ];

  static bool contains(String id) => items.any((item) => item.id == id);

  static PreviewItem byId(String id) {
    return items.firstWhere(
      (item) => item.id == id,
      orElse: () => throw StateError('未注册的预览组件：$id'),
    );
  }
}
