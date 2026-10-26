import 'package:flutter/widgets.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';

// doc-region SectionTitleComponentExample
class SectionTitleComponentExample extends StatefulWidget {
  const SectionTitleComponentExample({super.key});
  @override
  State<SectionTitleComponentExample> createState() =>
      _SectionTitleComponentExampleState();
}

class _SectionTitleComponentExampleState
    extends State<SectionTitleComponentExample> {
  bool _enabled = true;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 14,
      vertical: HyperUiSpacing.pageVertical,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: HyperUiSpacing.sectionVertical,
      children: <Widget>[
        const HyperSectionTitle('独立分组标题'),
        HyperMenuGroup(
          title: '通用设置',
          children: <Widget>[
            HyperListTile(
              title: '通知',
              subtitle: '接收重要消息',
              onPressed: () => setState(() => _enabled = !_enabled),
              trailing: HyperSwitch(
                value: _enabled,
                onChanged: (value) => setState(() => _enabled = value),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
// end-doc-region SectionTitleComponentExample
