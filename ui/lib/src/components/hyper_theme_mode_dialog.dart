import 'package:flutter/widgets.dart';

import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_glass.dart';
import 'hyper_modal.dart';
import 'hyper_pressable.dart';
import 'hyper_selection_controls.dart';

/// 三选项主题面板；null 跟随系统，false 浅色，true 深色。
class HyperThemeModeDialog extends StatelessWidget {
  const HyperThemeModeDialog({
    super.key,
    required this.value,
    required this.onChanged,
    required this.onClose,
    this.title = '主题设置',
  });

  final bool? value;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onClose;
  final String title;

  /// 使用库内模态宿主；保存与应用主题由调用方负责。
  static Future<void> show(
    BuildContext context, {
    required bool? value,
    required ValueChanged<bool?> onChanged,
    String title = '主题设置',
  }) => showHyperModal<void>(
    context,
    builder: (dialogContext) => HyperThemeModeDialog(
      value: value,
      onChanged: onChanged,
      onClose: () => Navigator.pop(dialogContext),
      title: title,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    Widget option(String label, bool? mode) => HyperPressable(
      onPressed: () {
        onChanged(mode);
        onClose();
      },
      pressedScale: 0.992,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 36),
        // 主题选项独立使用紧凑行，不改变普通设置菜单的默认行高。
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: tokens.foreground,
                    fontSize: 14,
                    height: 1.25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              HyperRadio<bool?>(value: mode, groupValue: value),
            ],
          ),
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: HyperGlass(
          radius: 26,
          type: 'prominent',
          padding: const EdgeInsets.all(18),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    color: tokens.foreground,
                    fontSize: 20,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                option('跟随系统', null),
                option('浅色', false),
                option('深色', true),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
