import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hy_ui_theme_tokens.dart';
import 'hy_anchored_surface.dart';
import 'hy_list_tile.dart';
import 'hy_select.dart';
import 'hy_selection_field.dart';

/// 锚定触发器展开的通用下拉选择器。
///
/// 移动端全屏表单可使用 [HySelect] 的底部面板；空间充足或需要保持上下文时使用
/// [HyDropdown]。
class HyDropdown<T> extends StatelessWidget {
  const HyDropdown({
    super.key,
    required this.options,
    this.value,
    this.onChanged,
    this.label,
    this.placeholder = '请选择',
    this.menuMaxHeight = 320,
    this.width,
  });

  final List<HyOption<T>> options;
  final T? value;
  final ValueChanged<T>? onChanged;
  final String? label;
  final String placeholder;
  final double menuMaxHeight;
  final double? width;

  HyOption<T>? get _selected {
    for (final option in options) {
      if (option.value == value) return option;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final triggerWidth =
            width ??
            (constraints.maxWidth.isFinite ? constraints.maxWidth : 240.0);
        return SizedBox(
          width: width,
          child: buildHyAnchoredSurface(
            width: triggerWidth,
            maxHeight: menuMaxHeight,
            padding: const EdgeInsets.all(5),
            contentBuilder: (menuContext) => options.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      '暂无选项',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: tokens.mutedForeground),
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final option in options)
                        HyListTile(
                          title: option.label,
                          selected: option.value == value,
                          enabled: option.enabled,
                          grouped: true,
                          showChevron: false,
                          trailing: option.value == value
                              ? Icon(
                                  LucideIcons.check,
                                  size: 18,
                                  color: tokens.primary,
                                )
                              : null,
                          onTap: () {
                            onChanged?.call(option.value);
                            MenuController.maybeOf(menuContext)?.close();
                          },
                        ),
                    ],
                  ),
            triggerBuilder: (anchorContext, controller) =>
                buildHySelectionField(
                  anchorContext,
                  value: _selected?.label ?? placeholder,
                  isPlaceholder: _selected == null,
                  label: label,
                  trailingIcon: controller.isOpen
                      ? LucideIcons.chevronUp
                      : LucideIcons.chevronDown,
                  onTap: onChanged == null
                      ? null
                      : () => controller.isOpen
                            ? controller.close()
                            : controller.open(),
                ),
          ),
        );
      },
    );
  }
}
