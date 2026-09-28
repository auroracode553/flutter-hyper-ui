import 'package:flutter/widgets.dart';

import '../theme/hyper_glass_theme.dart';
import '../theme/hyper_ui_effects.dart';
import '../theme/hyper_ui_spacing.dart';
import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_button.dart';
import 'hyper_glass.dart';
import 'hyper_list_tile.dart';
import 'hyper_modal.dart';

class HyperAction<T> {
  const HyperAction({
    required this.value,
    required this.label,
    this.icon,
    this.type = 'default',
    this.enabled = true,
  }) : assert(type == 'default' || type == 'danger');

  final T value;
  final String label;
  final IconData? icon;
  final String type;
  final bool enabled;

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
  }) => _show<T>(
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
  }) => _show<T>(
    context,
    title: title,
    dismissible: dismissible,
    builder: (_) =>
        _HyperActionList<T>(actions: actions, cancelLabel: cancelLabel),
  );

  static Future<T?> _show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    String? title,
    required bool dismissible,
  }) {
    final glass = HyperGlassTheme.of(context);
    return showHyperModal<T>(
      context,
      alignment: Alignment.bottomCenter,
      dismissible: dismissible,
      scrim: glass.scrim,
      builder: (sheetContext) {
        final tokens = HyperUiThemeTokens.of(sheetContext);
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(sheetContext).height * .85,
            ),
            child: HyperGlass(
              radius: 30,
              blur: HyperUiEffects.glassBlurStrong,
              type: 'prominent',
              padding: const EdgeInsets.all(HyperUiSpacing.md),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 32,
                          height: 4,
                          margin: const EdgeInsets.only(
                            bottom: HyperUiSpacing.md,
                          ),
                          decoration: BoxDecoration(
                            color: tokens.border,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      if (title != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: HyperUiSpacing.md,
                          ),
                          child: Text(
                            title,
                            style: TextStyle(
                              color: tokens.foreground,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      builder(sheetContext),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
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
            showChevron: false,
            onTap: () => Navigator.pop(context, action.value),
          ),
        const SizedBox(height: HyperUiSpacing.sm),
        HyperButton(
          type: 'ghost',
          label: cancelLabel,
          expanded: true,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
