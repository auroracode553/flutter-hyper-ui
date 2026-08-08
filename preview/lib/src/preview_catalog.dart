import 'package:flutter/widgets.dart';

import 'examples/buttons_example.dart';
import 'examples/cards_example.dart';
import 'examples/data_example.dart';
import 'examples/feedback_example.dart';
import 'examples/inputs_example.dart';
import 'examples/navigation_example.dart';
import 'examples/overview_example.dart';

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

  static final List<PreviewItem> items = [
    PreviewItem(
      id: 'overview',
      title: '组件概览',
      description: 'Doc UI 的基础控件组合。',
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

  static PreviewItem byId(String id) {
    return items.firstWhere(
      (item) => item.id == id,
      orElse: () => items.first,
    );
  }
}
