import 'package:flutter/material.dart';

import '../theme/hy_glass_theme.dart';
import '../theme/hy_ui_effects.dart';
import '../theme/hy_ui_spacing.dart';
import '../theme/hy_ui_theme_tokens.dart';
import 'hy_button.dart';
import 'hy_glass.dart';
import 'hy_list_tile.dart';

class HyAction<T> {
  const HyAction({
    required this.value,
    required this.label,
    this.icon,
    this.destructive = false,
    this.enabled = true,
  });

  final T value;
  final String label;
  final IconData? icon;
  final bool destructive;
  final bool enabled;
}

/// 统一的底部玻璃弹层。传入 builder 展示自定义内容，传入 actions 展示操作列表。
abstract final class HyActionSheet {
  static Future<T?> show<T>(
    BuildContext context, {
    WidgetBuilder? builder,
    List<HyAction<T>>? actions,
    String? title,
    bool dismissible = true,
    String cancelLabel = '取消',
  }) {
    if ((builder == null) == (actions == null)) {
      throw ArgumentError('HyActionSheet.show 需要且只需 builder 或 actions。');
    }
    final glass = HyGlassTheme.of(context);
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: dismissible,
      enableDrag: dismissible,
      backgroundColor: Colors.transparent,
      barrierColor: glass.scrim,
      builder: (sheetContext) {
        final tokens = HyUiThemeTokens.of(sheetContext);
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(sheetContext).height * .85,
            ),
            child: HyGlass(
              radius: 30,
              blur: HyUiEffects.glassBlurStrong,
              weight: HyGlassWeight.prominent,
              padding: const EdgeInsets.all(HyUiSpacing.md),
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
                          margin: const EdgeInsets.only(bottom: HyUiSpacing.md),
                          decoration: BoxDecoration(
                            color: tokens.border,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      if (title != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: HyUiSpacing.md,
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
                      if (builder != null)
                        builder(sheetContext)
                      else
                        _HyActionList<T>(
                          actions: actions!,
                          cancelLabel: cancelLabel,
                        ),
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

class _HyActionList<T> extends StatelessWidget {
  const _HyActionList({required this.actions, required this.cancelLabel});

  final List<HyAction<T>> actions;
  final String cancelLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final action in actions)
          HyListTile(
            title: action.label,
            leadingIcon: action.icon,
            leadingColor: action.destructive ? tokens.error : tokens.primary,
            titleColor: action.destructive ? tokens.error : null,
            enabled: action.enabled,
            grouped: true,
            showChevron: false,
            onTap: () => Navigator.pop(context, action.value),
          ),
        const SizedBox(height: HyUiSpacing.sm),
        HyButton.ghost(
          label: cancelLabel,
          expanded: true,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
