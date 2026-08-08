import 'package:flutter_hyper_ui/doc_ui.dart';
import 'package:flutter/material.dart';

class InputsExample extends StatefulWidget {
  const InputsExample({super.key});

  @override
  State<InputsExample> createState() => _InputsExampleState();
}

class _InputsExampleState extends State<InputsExample> {
  String _type = 'all';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        DocSegmentedControl<String>(
          selectedValue: _type,
          onChanged: (value) => setState(() => _type = value),
          options: const [
            DocSegmentOption(
              value: 'all',
              label: '全部',
              icon: Icons.all_inbox_outlined,
            ),
            DocSegmentOption(
              value: 'doc',
              label: '文档',
              icon: Icons.article_outlined,
            ),
            DocSegmentOption(
              value: 'sheet',
              label: '表格',
              icon: Icons.table_chart_outlined,
            ),
          ],
        ),
        const SizedBox(height: DocUiSpacing.md),
        const DocTextField(
          label: '搜索',
          hintText: '输入文件名或关键词',
          prefixIcon: Icons.search,
          helperText: '可按标题、标签或正文片段搜索。',
        ),
        const SizedBox(height: DocUiSpacing.md),
        const DocTextField(
          label: '备注',
          hintText: '补充说明',
          maxLines: 3,
        ),
      ],
    );
  }
}
