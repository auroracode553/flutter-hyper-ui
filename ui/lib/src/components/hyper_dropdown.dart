import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_anchored_surface.dart';
import 'hyper_list_tile.dart';
import 'hyper_select.dart';
import 'hyper_selection_field.dart';

/// 锚定触发器展开的通用下拉选择器。
///
/// 移动端全屏表单可使用 [HyperSelect] 的底部面板；空间充足或需要保持上下文时使用
/// [HyperDropdown]。
class HyperDropdown<T> extends StatelessWidget {
  const HyperDropdown({
    super.key,
    required this.options,
    this.value,
    this.onChanged,
    this.label,
    this.placeholder = '请选择',
    this.menuMaxHeight = 320,
    this.width,
  });

  final List<HyperOption<T>> options;
  final T? value;
  final ValueChanged<T>? onChanged;
  final String? label;
  final String placeholder;
  final double menuMaxHeight;
  final double? width;

  HyperOption<T>? get _selected {
    for (final option in options) {
      if (option.value == value) return option;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
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
                        HyperListTile.plain(
                          title: option.label,
                          selected: option.value == value,
                          enabled: option.enabled,
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
                            hyperMenuOf(menuContext)?.close();
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
