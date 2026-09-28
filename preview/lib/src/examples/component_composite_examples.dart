import 'package:flutter/widgets.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';

// doc-region CollapseComponentExample
class CollapseComponentExample extends StatefulWidget {
  const CollapseComponentExample({super.key});

  @override
  State<CollapseComponentExample> createState() =>
      _CollapseComponentExampleState();
}

class _CollapseComponentExampleState extends State<CollapseComponentExample> {
  String _status = '未展开';

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyperUiSpacing.xs),
    child: HyperText(text, size: 'small'),
  );

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _label('基础用法与回调（onChanged 同步展开状态）'),
      Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          HyperCollapse(
            title: '组件何时更新？',
            initiallyExpanded: true,
            onChanged: (expanded) =>
                setState(() => _status = expanded ? '已展开' : '已收起'),
            child: const Text('状态变化后立即更新，动画可被中断。'),
          ),
          HyperCollapse(
            title: '是否支持暗色模式？',
            child: const Text('所有颜色都来自主题语义令牌。'),
          ),
        ],
      ),
      const SizedBox(height: HyperUiSpacing.sm),
      Text('回调状态：$_status'),
    ],
  );
}
// end-doc-region CollapseComponentExample

// doc-region TimelineComponentExample
class TimelineComponentExample extends StatelessWidget {
  const TimelineComponentExample({super.key});

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyperUiSpacing.xs),
    child: HyperText(text, size: 'small'),
  );

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _label('事件状态（complete 标记已完成节点）'),
      const HyperTimeline(
        items: [
          HyperTimelineItem(
            title: '需求确认',
            description: '范围与交互已确认',
            time: '09:30',
          ),
          HyperTimelineItem(
            title: '组件开发',
            description: '正在补齐独立预览',
            time: '11:20',
          ),
          HyperTimelineItem(
            title: '发布文档',
            description: '等待构建',
            time: '稍后',
            complete: false,
          ),
        ],
      ),
    ],
  );
}
// end-doc-region TimelineComponentExample
