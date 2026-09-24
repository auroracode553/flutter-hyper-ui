import 'package:flutter_hyper_ui/hy_ui.dart';
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
        HySegmentedControl<String>(
          selectedValue: _type,
          onChanged: (value) => setState(() => _type = value),
          options: const [
            HySegmentOption(
              value: 'all',
              label: '全部',
              icon: Icons.all_inbox_outlined,
            ),
            HySegmentOption(
              value: 'note',
              label: '文档',
              icon: Icons.article_outlined,
            ),
            HySegmentOption(
              value: 'sheet',
              label: '表格',
              icon: Icons.table_chart_outlined,
            ),
          ],
        ),
        const SizedBox(height: HyUiSpacing.md),
        const HyTextField(
          hintText: '输入文件名或关键词',
          prefix: Icon(Icons.search_rounded),
        ),
        const SizedBox(height: HyUiSpacing.md),
        const HyTextField(
          hintText: '补充说明',
          maxLines: 3,
        ),
      ],
    );
  }
}
