import 'package:flutter/material.dart';

import '../theme/hy_glass_theme.dart';
import '../theme/hy_ui_effects.dart';
import '../theme/hy_ui_theme_tokens.dart';
import 'hy_button.dart';
import 'hy_glass.dart';
import 'hy_pressable.dart';

abstract final class HyBottomSheet {
  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    String? title,
    bool dismissible = true,
  }) => showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    isDismissible: dismissible,
    enableDrag: dismissible,
    backgroundColor: Colors.transparent,
    barrierColor: HyGlassTheme.of(context).scrim,
    builder: (sheetContext) => Padding(
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
          padding: const EdgeInsets.all(16),
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
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(sheetContext).dividerColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  if (title != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        title,
                        style: Theme.of(sheetContext).textTheme.titleLarge,
                      ),
                    ),
                  builder(sheetContext),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

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
  final bool destructive, enabled;
}

abstract final class HyActionSheet {
  static Future<T?> show<T>(
    BuildContext context, {
    required List<HyAction<T>> actions,
    String? title,
    String cancelLabel = '取消',
  }) => HyBottomSheet.show<T>(
    context,
    title: title,
    builder: (sheetContext) {
      final tokens = HyUiThemeTokens.of(context);
      final destructiveColor = Theme.of(context).colorScheme.error;
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final action in actions)
            HyPressable(
              onPressed: action.enabled
                  ? () => Navigator.pop(sheetContext, action.value)
                  : null,
              child: Container(
                constraints: const BoxConstraints(minHeight: 48),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    if (action.icon != null) ...[
                      Icon(
                        action.icon,
                        size: 20,
                        color: action.destructive
                            ? destructiveColor
                            : action.enabled
                            ? null
                            : tokens.mutedForeground,
                      ),
                      const SizedBox(width: 12),
                    ],
                    Text(
                      action.label,
                      style: TextStyle(
                        color: action.destructive
                            ? destructiveColor
                            : action.enabled
                            ? null
                            : tokens.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          HyButton.ghost(
            label: cancelLabel,
            expanded: true,
            onPressed: () => Navigator.pop(sheetContext),
          ),
        ],
      );
    },
  );
}
