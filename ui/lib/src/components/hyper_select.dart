import 'package:flutter_hyper_ui/src/theme/hyper_palette.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hyper_glass_theme.dart';
import '../theme/hyper_ui_spacing.dart';
import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_action_sheet.dart';
import 'hyper_button.dart';
import 'hyper_pressable.dart';
import 'hyper_selection_field.dart';

class HyperOption<T> {
  const HyperOption({
    required this.value,
    required this.label,
    this.enabled = true,
  });
  final T value;
  final String label;
  final bool enabled;
}

class HyperSelect<T> extends StatelessWidget {
  const HyperSelect({
    super.key,
    required this.options,
    required this.values,
    this.onChanged,
    this.multiple = false,
    this.placeholder = '请选择',
    this.label,
  });
  final List<HyperOption<T>> options;
  final List<T> values;
  final ValueChanged<List<T>>? onChanged;
  final bool multiple;
  final String placeholder;
  final String? label;

  Future<void> _open(BuildContext context) async {
    final result = await HyperActionSheet.show<List<T>>(
      context,
      title: label ?? placeholder,
      builder: (_) => _HyperSelectionPanel<T>(
        options: options,
        values: values,
        multiple: multiple,
      ),
    );
    if (result != null) onChanged?.call(result);
  }

  @override
  Widget build(BuildContext context) {
    final selectedLabels = options
        .where((option) => values.contains(option.value))
        .map((option) => option.label)
        .toList();
    return buildHySelectionField(
      context,
      value: selectedLabels.isEmpty ? placeholder : selectedLabels.join('、'),
      isPlaceholder: selectedLabels.isEmpty,
      label: label,
      onTap: onChanged == null ? null : () => _open(context),
    );
  }
}

class _HyperSelectionPanel<T> extends StatefulWidget {
  const _HyperSelectionPanel({
    required this.options,
    required this.values,
    required this.multiple,
  });
  final List<HyperOption<T>> options;
  final List<T> values;
  final bool multiple;
  @override
  State<_HyperSelectionPanel<T>> createState() =>
      _HyperSelectionPanelState<T>();
}

class _HyperSelectionPanelState<T> extends State<_HyperSelectionPanel<T>> {
  late final List<T> selected = List.of(widget.values);

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final option in widget.options)
          Padding(
            padding: const EdgeInsets.only(bottom: HyperUiSpacing.xs),
            child: _HyperSelectOptionRow<T>(
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
            padding: const EdgeInsets.all(HyperUiSpacing.xl),
            child: Text(
              '暂无选项',
              textAlign: TextAlign.center,
              style: TextStyle(color: tokens.mutedForeground),
            ),
          ),
        if (widget.multiple)
          Padding(
            padding: const EdgeInsets.only(top: HyperUiSpacing.xs),
            child: HyperButton.filled(
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

class _HyperSelectOptionRow<T> extends StatelessWidget {
  const _HyperSelectOptionRow({
    required this.option,
    required this.selected,
    required this.multiple,
    required this.onPressed,
  });

  final HyperOption<T> option;
  final bool selected;
  final bool multiple;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    final glass = HyperGlassTheme.of(context);
    final indicatorRadius = BorderRadius.circular(multiple ? 6 : 10);
    return HyperPressable(
      onPressed: option.enabled ? onPressed : null,
      borderRadius: BorderRadius.circular(14),
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
                color: selected ? tokens.primary : HyperPalette.transparent,
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
