export const overviewExample = `import 'package:flutter_hyper_ui/doc_ui.dart';
import 'package:flutter/material.dart';

class OverviewPanel extends StatelessWidget {
  const OverviewPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: DocUiSpacing.sm,
      runSpacing: DocUiSpacing.sm,
      children: [
        DocButton.filled(
          label: '打开',
          onPressed: () {},
        ),
        DocBadge(label: '已同步', tone: DocUiTone.success),
        SizedBox(width: 180, child: DocProgressBar(value: 0.72)),
      ],
    );
  }
}`;

export const buttonExample = `Wrap(
  spacing: DocUiSpacing.xs,
  runSpacing: DocUiSpacing.xs,
  children: const [
    DocButton.filled(
      label: '打开文件',
      icon: Icons.add,
      onPressed: () {},
    ),
    DocButton.tonal(
      label: '同步状态',
      icon: Icons.sync,
      onPressed: () {},
    ),
    DocButton.outline(
      label: '导出',
      icon: Icons.ios_share,
      onPressed: () {},
    ),
    DocButton.ghost(
      label: '更多',
      trailingIcon: Icons.keyboard_arrow_down,
      onPressed: () {},
    ),
    DocButton.danger(
      label: '删除',
      icon: Icons.delete_outline,
      onPressed: () {},
    ),
  ],
)`;

export const cardExample = `DocCard(
  title: '季度文档归档',
  subtitle: '12 个文件 · 最近更新 09:42',
  leading: Icon(Icons.folder_open_outlined),
  actions: const [
    DocBadge(label: '同步中', tone: DocUiTone.info),
  ],
  footer: const Row(
    children: [
      Expanded(child: DocProgressBar(value: 0.68)),
      SizedBox(width: DocUiSpacing.sm),
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
        DocSegmentedControl<String>(
          selectedValue: type,
          onChanged: (value) => setState(() => type = value),
          options: const [
            DocSegmentOption(value: 'all', label: '全部'),
            DocSegmentOption(value: 'doc', label: '文档'),
            DocSegmentOption(value: 'sheet', label: '表格'),
          ],
        ),
        const SizedBox(height: DocUiSpacing.md),
        const DocTextField(
          label: '搜索',
          hintText: '输入文件名或关键词',
          prefixIcon: Icons.search,
        ),
      ],
    );
  }
}`;

export const dataExample = `Column(
  children: const [
    Wrap(
      spacing: DocUiSpacing.xs,
      children: [
        DocBadge(label: 'PDF', tone: DocUiTone.error),
        DocBadge(label: 'Word', tone: DocUiTone.primary),
        DocBadge(label: '表格', tone: DocUiTone.success),
      ],
    ),
    SizedBox(height: DocUiSpacing.md),
    DocListTile(
      title: '产品需求说明.pdf',
      subtitle: 'PDF 文档 · 最近打开 08:30',
      meta: '12.6 MB',
      leadingIcon: Icons.picture_as_pdf_outlined,
    ),
    SizedBox(height: DocUiSpacing.md),
    DocProgressBar(value: 0.42),
  ],
)`;

export const feedbackExample = `const DocEmptyState(
  icon: Icons.folder_off_outlined,
  title: '暂无最近文档',
  message: '打开文件后，最近访问记录会显示在这里。',
  action: DocButton.filled(
    label: '选择文件',
    icon: Icons.add,
    onPressed: () {},
  ),
)`;

export const navigationExample = `DocTopBar(
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
