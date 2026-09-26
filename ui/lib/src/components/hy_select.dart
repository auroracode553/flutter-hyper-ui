import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hy_glass_theme.dart';
import '../theme/hy_ui_spacing.dart';
import '../theme/hy_ui_theme_tokens.dart';
import 'hy_bottom_sheet.dart';
import 'hy_button.dart';
import 'hy_form_field.dart';
import 'hy_glass.dart';
import 'hy_pressable.dart';

class HyOption<T> {
  const HyOption({
    required this.value,
    required this.label,
    this.enabled = true,
  });
  final T value;
  final String label;
  final bool enabled;
}

class HySelect<T> extends StatelessWidget {
  const HySelect({
    super.key,
    required this.options,
    required this.values,
    this.onChanged,
    this.multiple = false,
    this.placeholder = '请选择',
    this.label,
  });
  final List<HyOption<T>> options;
  final List<T> values;
  final ValueChanged<List<T>>? onChanged;
  final bool multiple;
  final String placeholder;
  final String? label;

  Future<void> _open(BuildContext context) async {
    final result = await HyBottomSheet.show<List<T>>(
      context,
      title: label ?? placeholder,
      builder: (_) => _HySelectionPanel<T>(
        options: options,
        values: values,
        multiple: multiple,
      ),
    );
    if (result != null) onChanged?.call(result);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    final selectedLabels = options
        .where((option) => values.contains(option.value))
        .map((option) => option.label)
        .toList();
    final displayValue = selectedLabels.isEmpty
        ? placeholder
        : selectedLabels.join('、');

    // 与 HyTextField 共用输入轮廓，字段标题交给 HyFormField 排版。
    final field = HyGlass(
      radius: 16,
      blur: 14,
      weight: HyGlassWeight.subtle,
      borderColor: tokens.input,
      onTap: onChanged == null ? null : () => _open(context),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  displayValue,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.3,
                    fontWeight: FontWeight.w500,
                    color: selectedLabels.isEmpty
                        ? tokens.mutedForeground
                        : tokens.foreground,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                LucideIcons.chevronDown,
                size: 18,
                color: tokens.mutedForeground,
              ),
            ],
          ),
        ),
      ),
    );

    if (label == null) return field;
    return HyFormField(label: label!, child: field);
  }
}

class _HySelectionPanel<T> extends StatefulWidget {
  const _HySelectionPanel({
    required this.options,
    required this.values,
    required this.multiple,
  });
  final List<HyOption<T>> options;
  final List<T> values;
  final bool multiple;
  @override
  State<_HySelectionPanel<T>> createState() => _HySelectionPanelState<T>();
}

class _HySelectionPanelState<T> extends State<_HySelectionPanel<T>> {
  late final List<T> selected = List.of(widget.values);

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final option in widget.options)
          Padding(
            padding: const EdgeInsets.only(bottom: HyUiSpacing.xs),
            child: _HySelectOptionRow<T>(
              option: option,
              selected: selected.contains(option.value),
              multiple: widget.multiple,
              onPressed: () {
                if (!widget.multiple) {
                  Navigator.pop(context, <T>[option.value]);
                  return;
                }
                setState(() {
                  if (selected.contains(option.value)) {
                    selected.remove(option.value);
                  } else {
                    selected.add(option.value);
                  }
                });
              },
            ),
          ),
        if (widget.options.isEmpty)
          Padding(
            padding: const EdgeInsets.all(HyUiSpacing.xl),
            child: Text(
              '暂无选项',
              textAlign: TextAlign.center,
              style: TextStyle(color: tokens.mutedForeground),
            ),
          ),
        if (widget.multiple)
          Padding(
            padding: const EdgeInsets.only(top: HyUiSpacing.xs),
            child: HyButton.filled(
              label: selected.isEmpty ? '确定' : '确定（${selected.length}）',
              height: 44,
              expanded: true,
              onPressed: () => Navigator.pop(context, List<T>.of(selected)),
            ),
          ),
      ],
    );
  }
}

class _HySelectOptionRow<T> extends StatelessWidget {
  const _HySelectOptionRow({
    required this.option,
    required this.selected,
    required this.multiple,
    required this.onPressed,
  });

  final HyOption<T> option;
  final bool selected;
  final bool multiple;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    final glass = HyGlassTheme.of(context);
    final indicatorRadius = BorderRadius.circular(multiple ? 6 : 10);
    return HyPressable(
      onPressed: option.enabled ? onPressed : null,
      borderRadius: BorderRadius.circular(14),
      semanticLabel: option.label,
      child: Container(
        constraints: const BoxConstraints(minHeight: 52),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? glass.selection : glass.surfaceSubtle,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? tokens.primary.withAlpha(90) : tokens.input,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                option.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: option.enabled
                      ? tokens.foreground
                      : tokens.mutedForeground,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: selected ? tokens.primary : Colors.transparent,
                borderRadius: indicatorRadius,
                border: Border.all(
                  color: selected ? tokens.primary : tokens.input,
                  width: 1.5,
                ),
              ),
              child: selected
                  ? multiple
                        ? Icon(
                            LucideIcons.check,
                            size: 14,
                            color: tokens.primaryForeground,
                          )
                        : Center(
                            child: Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: tokens.primaryForeground,
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
