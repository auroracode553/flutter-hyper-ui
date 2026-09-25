import 'package:flutter/material.dart';

import '../theme/hy_ui_theme_tokens.dart';
import 'hy_glass.dart';
import 'hy_pressable.dart';
import 'hy_select.dart';

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
          child: MenuAnchor(
            style: const MenuStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.transparent),
              elevation: WidgetStatePropertyAll(0),
              padding: WidgetStatePropertyAll(EdgeInsets.zero),
            ),
            menuChildren: <Widget>[
              SizedBox(
                width: triggerWidth,
                child: HyGlass(
                  radius: 18,
                  blur: 28,
                  weight: HyGlassWeight.prominent,
                  padding: const EdgeInsets.all(5),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: menuMaxHeight),
                    child: options.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              '暂无选项',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: tokens.mutedForeground),
                            ),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                for (final option in options)
                                  _DropdownOption<T>(
                                    option: option,
                                    selected: option.value == value,
                                    onSelected: (selected) {
                                      onChanged?.call(selected);
                                    },
                                  ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
            ],
            builder: (context, controller, child) {
              return HyGlass(
                radius: 16,
                blur: 14,
                weight: HyGlassWeight.subtle,
                onTap: onChanged == null
                    ? null
                    : () => controller.isOpen
                          ? controller.close()
                          : controller.open(),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 44),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              if (label != null) ...<Widget>[
                                Text(
                                  label!,
                                  style: TextStyle(
                                    color: tokens.mutedForeground,
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(height: 2),
                              ],
                              Text(
                                _selected?.label ?? placeholder,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: _selected == null
                                      ? tokens.mutedForeground
                                      : tokens.foreground,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          controller.isOpen
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: tokens.mutedForeground,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _DropdownOption<T> extends StatelessWidget {
  const _DropdownOption({
    required this.option,
    required this.selected,
    required this.onSelected,
  });

  final HyOption<T> option;
  final bool selected;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    return HyPressable(
      onPressed: option.enabled
          ? () {
              onSelected(option.value);
              MenuController.maybeOf(context)?.close();
            }
          : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: selected ? tokens.muted : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                option.label,
                style: TextStyle(
                  color: option.enabled
                      ? tokens.foreground
                      : tokens.mutedForeground,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
            if (selected)
              Icon(Icons.check_rounded, size: 18, color: tokens.foreground),
          ],
        ),
      ),
    );
  }
}
