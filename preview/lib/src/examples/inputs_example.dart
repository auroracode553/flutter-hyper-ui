import 'package:flutter_hyper_ui/hyper_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class InputsExample extends StatefulWidget {
  const InputsExample({super.key});

  @override
  State<InputsExample> createState() => _InputsExampleState();
}

class _InputsExampleState extends State<InputsExample> {
  int _type = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        HyperTabs<String>(
          selectedIndex: _type,
          onChanged: (value) => setState(() => _type = value),
          tabs: const [
            HyperTabsItem(value: 'all', label: '全部', icon: LucideIcons.inbox),
            HyperTabsItem(
              value: 'note',
              label: '文档',
              icon: LucideIcons.fileText,
            ),
            HyperTabsItem(value: 'sheet', label: '表格', icon: LucideIcons.table),
          ],
        ),
        const SizedBox(height: HyperUiSpacing.md),
        const HyperTextField(
          type: 'search',
          placeholder: '输入文件名或关键词',
          prefix: Icon(LucideIcons.search),
        ),
        const SizedBox(height: HyperUiSpacing.md),
        const HyperTextField(type: 'textarea', placeholder: '补充说明', rows: 3),
      ],
    );
  }
}
