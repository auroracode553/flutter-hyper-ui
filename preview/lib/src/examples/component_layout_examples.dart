import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_hyper_ui/hy_ui.dart';

// doc-region SpaceComponentExample
class SpaceComponentExample extends StatelessWidget {
  const SpaceComponentExample({super.key});

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyUiSpacing.xs),
    child: HyText(text, variant: HyTextStyle.caption),
  );

  @override
  Widget build(BuildContext context) {
    Widget tile(String label) => HyGlass(
      blur: 0,
      padding: const EdgeInsets.all(14),
      child: Center(child: Text(label)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('垂直排列（默认，spacing: 12）'),
        HySpace(children: [tile('第一项'), tile('第二项'), tile('第三项')]),
        const SizedBox(height: HyUiSpacing.lg),

        _label('水平方向与自定义间距（spacing: 8）'),
        HySpace(
          direction: Axis.horizontal,
          spacing: HyUiSpacing.sm,
          children: [
            Expanded(child: tile('左')),
            Expanded(child: tile('中')),
            Expanded(child: tile('右')),
          ],
        ),
      ],
    );
  }
}
// end-doc-region SpaceComponentExample

// doc-region WrapComponentExample
class WrapComponentExample extends StatelessWidget {
  const WrapComponentExample({super.key});

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyUiSpacing.xs),
    child: HyText(text, variant: HyTextStyle.caption),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('自动换行（spacing 与 runSpacing 独立控制）'),
        const HyWrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            HyTag(label: '自适应'),
            HyTag(label: '流式布局'),
            HyTag(label: '统一间距'),
            HyTag(label: '内容变长后自动换行'),
            HyTag(label: '触控友好'),
          ],
        ),
      ],
    );
  }
}
// end-doc-region WrapComponentExample

// doc-region GridComponentExample
class GridComponentExample extends StatelessWidget {
  const GridComponentExample({super.key});

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyUiSpacing.xs),
    child: HyText(text, variant: HyTextStyle.caption),
  );

  @override
  Widget build(BuildContext context) {
    // 网格子项尺寸由 columns 与 childAspectRatio 决定，内部只负责内容。
    Widget tile(String label) => HyGlass(
      blur: 0,
      padding: const EdgeInsets.all(14),
      child: Center(child: Text(label)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('三列网格（默认）'),
        HyGrid(
          columns: 3,
          childAspectRatio: 1.2,
          children: [
            tile('相册'),
            tile('文件'),
            tile('收藏'),
            tile('最近'),
            tile('共享'),
            tile('更多'),
          ],
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('两列与宽高比（childAspectRatio: 2.6）'),
        HyGrid(
          columns: 2,
          childAspectRatio: 2.6,
          children: [tile('宽卡片 A'), tile('宽卡片 B')],
        ),
      ],
    );
  }
}
// end-doc-region GridComponentExample

// doc-region DividerComponentExample
class DividerComponentExample extends StatelessWidget {
  const DividerComponentExample({super.key});

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyUiSpacing.xs),
    child: HyText(text, variant: HyTextStyle.caption),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('实线与虚线'),
        const Text('实线分隔'),
        const HyDivider(),
        const Text('虚线分隔'),
        const HyDivider(dashed: true),
        const SizedBox(height: HyUiSpacing.lg),

        _label('缩进（indent: 24）'),
        const HyDivider(indent: 24, dashed: true),
        const SizedBox(height: HyUiSpacing.lg),

        _label('纵向分隔'),
        const SizedBox(
          height: 58,
          child: Row(
            children: [
              Expanded(child: Text('左侧')),
              HyDivider(axis: Axis.vertical),
              SizedBox(width: 14),
              Expanded(child: Text('右侧')),
            ],
          ),
        ),
      ],
    );
  }
}
// end-doc-region DividerComponentExample

// doc-region EmptyStateComponentExample
class EmptyStateComponentExample extends StatelessWidget {
  const EmptyStateComponentExample({super.key});

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyUiSpacing.xs),
    child: HyText(text, variant: HyTextStyle.caption),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('带恢复操作'),
        HyEmptyState(
          icon: LucideIcons.searchX,
          title: '没有找到结果',
          message: '换一个关键词，或者清除筛选条件后重试。',
          action: HyButton.tonal(label: '清除筛选', onPressed: () {}),
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('纯提示（无操作按钮）'),
        const HyEmptyState(
          icon: LucideIcons.inbox,
          title: '这里还是空的',
          message: '创建第一个项目后它会出现在这里。',
        ),
      ],
    );
  }
}
// end-doc-region EmptyStateComponentExample
