import 'package:flutter/widgets.dart';

import '../theme/hyper_ui_spacing.dart';
import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_button.dart';
import 'hyper_list_tile.dart';
import 'hyper_sheet_route.dart';

class HyperAction<T> {
  const HyperAction({
    required this.value,
    required this.label,
    this.icon,
    this.type = 'default',
    this.enabled = true,
    this.selected = false,
  }) : assert(type == 'default' || type == 'danger');

  final T value;
  final String label;
  final IconData? icon;
  final String type;
  final bool enabled;

  /// 当前动作是否已选中，供菜单和选择列表展示。
  final bool selected;

  bool get isDanger => switch (type) {
    'default' => false,
    'danger' => true,
    _ => throw ArgumentError.value(type, 'type', 'Invalid action type'),
  };
}

/// Bottom sheet with separate entry points for custom content and action lists.
abstract final class HyperActionSheet {
  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    String? title,
    bool dismissible = true,
  }) => showHySheet<T>(
    context,
    builder: builder,
    title: title,
    dismissible: dismissible,
  );

  static Future<T?> choose<T>(
    BuildContext context, {
    required List<HyperAction<T>> actions,
    String? title,
    bool dismissible = true,
    String cancelLabel = '取消',
  }) => showHySheet<T>(
    context,
    title: title,
    dismissible: dismissible,
    builder: (_) =>
        _HyperActionList<T>(actions: actions, cancelLabel: cancelLabel),
  );
}

class _HyperActionList<T> extends StatelessWidget {
  const _HyperActionList({required this.actions, required this.cancelLabel});

  final List<HyperAction<T>> actions;
  final String cancelLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final action in actions)
          HyperListTile(
            type: 'plain',
            title: action.label,
            leadingIcon: action.icon,
            leadingColor: action.isDanger ? tokens.error : tokens.primary,
            titleColor: action.isDanger ? tokens.error : null,
            enabled: action.enabled,
            selected: action.selected,
            showChevron: false,
            onPressed: () => Navigator.pop(context, action.value),
          ),
        const SizedBox(height: HyperUiSpacing.sm),
        HyperButton(
          label: cancelLabel,
          expanded: true,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
