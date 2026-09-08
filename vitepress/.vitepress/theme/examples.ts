export const overviewExample = `import 'package:flutter_hyper_ui/hy_ui.dart';
import 'package:flutter/material.dart';

class OverviewPanel extends StatelessWidget {
  const OverviewPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: HyUiSpacing.sm,
      runSpacing: HyUiSpacing.sm,
      children: [
        HyButton.filled(
          label: '打开',
          onPressed: () {},
        ),
        HyBadge(label: '已同步', tone: HyUiTone.success),
        SizedBox(width: 180, child: HyProgressBar(value: 0.72)),
      ],
    );
  }
}`;

export const buttonExample = `Wrap(
  spacing: HyUiSpacing.xs,
  runSpacing: HyUiSpacing.xs,
  children: [
    HyButton.filled(
      label: '打开文件',
      icon: Icons.add,
      onPressed: () {},
    ),
    HyButton.tonal(
      label: '同步状态',
      icon: Icons.sync,
      onPressed: () {},
    ),
    HyButton.outline(
      label: '导出',
      icon: Icons.ios_share,
      onPressed: () {},
    ),
    HyButton.ghost(
      label: '更多',
      trailingIcon: Icons.keyboard_arrow_down,
      onPressed: () {},
    ),
    HyButton.danger(
      label: '删除',
      icon: Icons.delete_outline,
      onPressed: () {},
    ),
  ],
)`;

export const cardExample = `HyCard(
  title: '本周活动计划',
  subtitle: '12 项活动 · 最近更新 09:42',
  leading: Icon(Icons.folder_open_outlined),
  actions: const [
    HyBadge(label: '同步中', tone: HyUiTone.info),
  ],
  footer: const Row(
    children: [
      Expanded(child: HyProgressBar(value: 0.68)),
      SizedBox(width: HyUiSpacing.sm),
      Text('68%'),
    ],
  ),
  child: const Text('用于展示内容摘要、进度与操作入口。'),
)`;

export const inputExample = `class FilterForm extends StatefulWidget {
  const FilterForm({super.key});

  @override
  State<FilterForm> createState() => _FilterFormState();
}

class _FilterFormState extends State<FilterForm> {
  String type = 'all';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HySegmentedControl<String>(
          selectedValue: type,
          onChanged: (value) => setState(() => type = value),
          options: const [
            HySegmentOption(value: 'all', label: '全部'),
            HySegmentOption(value: 'note', label: '文档'),
            HySegmentOption(value: 'sheet', label: '表格'),
          ],
        ),
        const SizedBox(height: HyUiSpacing.md),
        const HyTextField(
          label: '搜索',
          hintText: '输入文件名或关键词',
          prefixIcon: Icons.search,
        ),
      ],
    );
  }
}`;

export const dataExample = `Column(
  children: [
    Wrap(
      spacing: HyUiSpacing.xs,
      children: [
        HyBadge(label: '旅行', tone: HyUiTone.error),
        HyBadge(label: 'Word', tone: HyUiTone.primary),
        HyBadge(label: '表格', tone: HyUiTone.success),
      ],
    ),
    SizedBox(height: HyUiSpacing.md),
    HyListTile(
      title: '产品需求说明.pdf',
      subtitle: 'PDF 文档 · 最近打开 08:30',
      meta: '12.6 MB',
      leadingIcon: Icons.picture_as_pdf_outlined,
    ),
    SizedBox(height: HyUiSpacing.md),
    HyProgressBar(value: 0.42),
  ],
)`;

export const feedbackExample = `const HyEmptyState(
  icon: Icons.folder_off_outlined,
  title: '暂无最近文档',
  message: '打开文件后，最近访问记录会显示在这里。',
  action: HyButton.filled(
    label: '选择文件',
    icon: Icons.add,
    onPressed: () {},
  ),
)`;

export const navigationExample = `HyTopBar(
  title: '最近文档',
  subtitle: '共 24 个项目',
  actions: [
    IconButton(
      onPressed: () {},
      tooltip: '搜索',
      icon: const Icon(Icons.search),
    ),
    IconButton(
      onPressed: () {},
      tooltip: '选择',
      icon: const Icon(Icons.checklist),
    ),
  ],
)`;
