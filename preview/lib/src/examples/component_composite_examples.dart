import 'package:flutter/material.dart';
import 'package:flutter_hyper_ui/hy_ui.dart';

// doc-region SearchBarComponentExample
class SearchBarComponentExample extends StatefulWidget {
  const SearchBarComponentExample({super.key});

  @override
  State<SearchBarComponentExample> createState() => _SearchBarComponentExampleState();
}

class _SearchBarComponentExampleState extends State<SearchBarComponentExample> {
  String _query = '';

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      HySearchBar(hintText: '搜索组件', onChanged: (value) => setState(() => _query = value)),
      const SizedBox(height: 14),
      Text(_query.isEmpty ? '输入关键词开始搜索' : '正在搜索：$_query'),
    ],
  );
}
// end-doc-region SearchBarComponentExample

// doc-region CountDownComponentExample
class CountDownComponentExample extends StatefulWidget {
  const CountDownComponentExample({super.key});

  @override
  State<CountDownComponentExample> createState() => _CountDownComponentExampleState();
}

class _CountDownComponentExampleState extends State<CountDownComponentExample> {
  late DateTime _endTime = DateTime.now().add(const Duration(minutes: 12));

  @override
  Widget build(BuildContext context) => HyGlass(
    padding: const EdgeInsets.all(22),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('限时操作'),
        HyCountDown(endTime: _endTime),
        IconButton(
          tooltip: '重新开始',
          onPressed: () => setState(() => _endTime = DateTime.now().add(const Duration(minutes: 12))),
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
    ),
  );
}
// end-doc-region CountDownComponentExample

// doc-region CollapseComponentExample
class CollapseComponentExample extends StatelessWidget {
  const CollapseComponentExample({super.key});

  @override
  Widget build(BuildContext context) => const HySpace(
    children: [
      HyCollapse(title: '组件何时更新？', initiallyExpanded: true, child: Text('状态变化后立即更新，动画可被中断。')),
      HyCollapse(title: '是否支持暗色模式？', child: Text('所有颜色都来自主题语义令牌。')),
    ],
  );
}
// end-doc-region CollapseComponentExample

// doc-region TimelineComponentExample
class TimelineComponentExample extends StatelessWidget {
  const TimelineComponentExample({super.key});

  @override
  Widget build(BuildContext context) => const HyTimeline(
    items: [
      HyTimelineItem(title: '需求确认', description: '范围与交互已确认', time: '09:30'),
      HyTimelineItem(title: '组件开发', description: '正在补齐独立预览', time: '11:20'),
      HyTimelineItem(title: '发布文档', description: '等待构建', time: '稍后', complete: false),
    ],
  );
}
// end-doc-region TimelineComponentExample
