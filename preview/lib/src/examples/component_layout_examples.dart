import 'package:flutter/material.dart';
import 'package:flutter_hyper_ui/hy_ui.dart';

// doc-region SpaceComponentExample
class SpaceComponentExample extends StatelessWidget {
  const SpaceComponentExample({super.key});
  @override
  Widget build(BuildContext context) {
    Widget tile(String label) => HyGlass(
      blur: 0,
      padding: const EdgeInsets.all(14),
      child: Center(child: Text(label)),
    );
    return HySpace(children: [tile('第一项'), tile('第二项'), tile('第三项')]);
  }
}
// end-doc-region SpaceComponentExample

// doc-region WrapComponentExample
class WrapComponentExample extends StatelessWidget {
  const WrapComponentExample({super.key});
  @override
  Widget build(BuildContext context) => const HyWrap(
    children: [
      HyTag(label: '自适应'), HyTag(label: '流式布局'), HyTag(label: '统一间距'),
      HyTag(label: '内容变长后自动换行'), HyTag(label: '触控友好'),
    ],
  );
}
// end-doc-region WrapComponentExample

// doc-region GridComponentExample
class GridComponentExample extends StatelessWidget {
  const GridComponentExample({super.key});
  @override
  Widget build(BuildContext context) {
    Widget tile(String label) => HyGlass(
      blur: 0,
      padding: const EdgeInsets.all(14),
      child: Center(child: Text(label)),
    );
    return HyGrid(
      columns: 3,
      children: [tile('相册'), tile('文件'), tile('收藏'), tile('最近'), tile('共享'), tile('更多')],
    );
  }
}
// end-doc-region GridComponentExample

// doc-region DividerComponentExample
class DividerComponentExample extends StatelessWidget {
  const DividerComponentExample({super.key});
  @override
  Widget build(BuildContext context) => const HySpace(
    children: [
      Text('实线分隔'), HyDivider(), Text('虚线分隔'), HyDivider(dashed: true),
      SizedBox(height: 58, child: Row(children: [Expanded(child: Text('左侧')), HyDivider(axis: Axis.vertical), SizedBox(width: 14), Expanded(child: Text('右侧'))])),
    ],
  );
}
// end-doc-region DividerComponentExample

// doc-region EmptyStateComponentExample
class EmptyStateComponentExample extends StatelessWidget {
  const EmptyStateComponentExample({super.key});
  @override
  Widget build(BuildContext context) => HyEmptyState(
    icon: Icons.search_off_rounded,
    title: '没有找到结果',
    message: '换一个关键词，或者清除筛选条件后重试。',
    action: HyButton.tonal(label: '清除筛选', onPressed: () {}),
  );
}
// end-doc-region EmptyStateComponentExample
