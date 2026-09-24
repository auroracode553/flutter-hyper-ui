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

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyUiSpacing.xs),
    child: HyText(text, variant: HyTextStyle.caption),
  );

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _label('受控输入（onChanged / onSubmitted）'),
      HySearchBar(
        hintText: '搜索组件',
        onChanged: (value) => setState(() => _query = value),
        onSubmitted: (value) => HyToast.show(context, '提交搜索：$value'),
      ),
      const SizedBox(height: 8),
      Text(_query.isEmpty ? '输入关键词开始搜索' : '正在搜索：$_query'),
      const SizedBox(height: HyUiSpacing.lg),

      _label('禁用态（enabled: false）'),
      const HySearchBar(enabled: false, hintText: '当前不可搜索'),
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
  // 用 20 秒演示结束回调，便于在预览中观察 onFinished 触发。
  late DateTime _endTime = DateTime.now().add(const Duration(seconds: 20));
  bool _finished = false;

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyUiSpacing.xs),
    child: HyText(text, variant: HyTextStyle.caption),
  );

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _label('基础倒计时（onFinished 结束回调）'),
      HyGlass(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(child: Text(_finished ? '倒计时已结束' : '限时操作')),
            HyCountDown(
              endTime: _endTime,
              onFinished: () => setState(() => _finished = true),
            ),
            IconButton(
              tooltip: '重新开始',
              onPressed: () => setState(() {
                _endTime = DateTime.now().add(const Duration(seconds: 20));
                _finished = false;
              }),
              icon: const Icon(Icons.refresh_rounded),
            ),
          ],
        ),
      ),
      const SizedBox(height: HyUiSpacing.lg),

      _label('自定义渲染（builder 接收剩余时长）'),
      HyGlass(
        padding: const EdgeInsets.all(16),
        child: HyCountDown(
          endTime: DateTime.now().add(const Duration(hours: 2, minutes: 5)),
          builder: (context, remaining) => Text(
            '剩余 ${remaining.inHours} 小时 ${remaining.inMinutes % 60} 分',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    ],
  );
}
// end-doc-region CountDownComponentExample

// doc-region CollapseComponentExample
class CollapseComponentExample extends StatefulWidget {
  const CollapseComponentExample({super.key});

  @override
  State<CollapseComponentExample> createState() => _CollapseComponentExampleState();
}

class _CollapseComponentExampleState extends State<CollapseComponentExample> {
  String _status = '未展开';

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyUiSpacing.xs),
    child: HyText(text, variant: HyTextStyle.caption),
  );

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _label('基础用法与回调（onChanged 同步展开状态）'),
      HySpace(
        children: [
          HyCollapse(
            title: '组件何时更新？',
            initiallyExpanded: true,
            onChanged: (expanded) => setState(() => _status = expanded ? '已展开' : '已收起'),
            child: const Text('状态变化后立即更新，动画可被中断。'),
          ),
          HyCollapse(
            title: '是否支持暗色模式？',
            child: const Text('所有颜色都来自主题语义令牌。'),
          ),
        ],
      ),
      const SizedBox(height: HyUiSpacing.sm),
      Text('回调状态：$_status'),
    ],
  );
}
// end-doc-region CollapseComponentExample

// doc-region TimelineComponentExample
class TimelineComponentExample extends StatelessWidget {
  const TimelineComponentExample({super.key});

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyUiSpacing.xs),
    child: HyText(text, variant: HyTextStyle.caption),
  );

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _label('事件状态（complete 标记已完成节点）'),
      const HyTimeline(
        items: [
          HyTimelineItem(title: '需求确认', description: '范围与交互已确认', time: '09:30'),
          HyTimelineItem(title: '组件开发', description: '正在补齐独立预览', time: '11:20'),
          HyTimelineItem(title: '发布文档', description: '等待构建', time: '稍后', complete: false),
        ],
      ),
    ],
  );
}
// end-doc-region TimelineComponentExample
