import 'package:flutter/widgets.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';

// doc-region ThemeModeDialogComponentExample
class ThemeModeDialogComponentExample extends StatefulWidget {
  const ThemeModeDialogComponentExample({super.key});

  @override
  State<ThemeModeDialogComponentExample> createState() =>
      _ThemeModeDialogComponentExampleState();
}

class _ThemeModeDialogComponentExampleState
    extends State<ThemeModeDialogComponentExample> {
  bool? _mode;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      HyperText(
        '当前主题：${_mode == null
            ? '跟随系统'
            : _mode!
            ? '深色'
            : '浅色'}',
      ),
      HyperButton(
        label: '主题设置',
        onPressed: () => HyperThemeModeDialog.show(
          context,
          value: _mode,
          onChanged: (value) => setState(() => _mode = value),
        ),
      ),
    ],
  );
}
// end-doc-region ThemeModeDialogComponentExample
