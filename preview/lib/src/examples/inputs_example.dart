import 'package:flutter_hyper_ui/hyper_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
        HyperSegmentedControl<String>(
          selectedValue: _type,
          onChanged: (value) => setState(() => _type = value),
          options: const [
            HyperSegmentOption(
              value: 'all',
              label: '全部',
              icon: LucideIcons.inbox,
            ),
            HyperSegmentOption(
              value: 'note',
              label: '文档',
              icon: LucideIcons.fileText,
            ),
            HyperSegmentOption(
              value: 'sheet',
              label: '表格',
              icon: LucideIcons.table,
            ),
          ],
        ),
        const SizedBox(height: HyperUiSpacing.md),
        const HyperTextField(
          hintText: '输入文件名或关键词',
          prefix: Icon(LucideIcons.search),
        ),
        const SizedBox(height: HyperUiSpacing.md),
        const HyperTextField.multiline(hintText: '补充说明', rows: 3),
      ],
    );
  }
}
