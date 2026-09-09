import 'package:flutter/widgets.dart';

import 'examples/actions_example.dart';
import 'examples/buttons_example.dart';
import 'examples/cards_example.dart';
import 'examples/data_example.dart';
import 'examples/feedback_example.dart';
import 'examples/inputs_example.dart';
import 'examples/navigation_example.dart';
import 'examples/overview_example.dart';
import 'examples/complete_examples.dart';
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

class PreviewCatalog {
  const PreviewCatalog._();

  static const defaultId = 'overview';

  static final List<PreviewItem> items = [
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
  ];

  static bool contains(String id) => items.any((item) => item.id == id);

  static PreviewItem byId(String id) {
    return items.firstWhere(
      (item) => item.id == id,
      orElse: () => items.firstWhere((item) => item.id == defaultId),
    );
  }
}
