import 'package:flutter_hyper_ui/src/theme/hyper_palette.dart';
import 'package:flutter/widgets.dart';

import '../theme/hyper_ui_radii.dart';
import '../theme/hyper_glass_theme.dart';
import '../theme/hyper_ui_spacing.dart';
import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_glass.dart';
import 'hyper_pressable.dart';

class HyperSegmentOption<T> {
  final T value;
  final String label;
  final IconData? icon;
  final bool enabled;

  const HyperSegmentOption({
    required this.value,
    required this.label,
    this.icon,
    this.enabled = true,
  });
}

class HyperSegmentedControl<T> extends StatelessWidget {
  final List<HyperSegmentOption<T>> options;
  final T selectedValue;
  final ValueChanged<T> onChanged;
  final bool equalWidth;

  const HyperSegmentedControl({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    this.equalWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final children = options.map((option) {
      final item = _HyperSegmentItem<T>(
        option: option,
        selected: option.value == selectedValue,
        onSelected: onChanged,
        constrainLabel: equalWidth,
      );
      return equalWidth ? Expanded(child: item) : item;
    }).toList();

    return HyperGlass(
      radius: 18,
      type: 'subtle',
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: equalWidth ? MainAxisSize.max : MainAxisSize.min,
        children: children,
      ),
    );
  }
}

class _HyperSegmentItem<T> extends StatelessWidget {
  final HyperSegmentOption<T> option;
  final bool selected;
  final ValueChanged<T> onSelected;
  final bool constrainLabel;

  const _HyperSegmentItem({
    required this.option,
    required this.selected,
    required this.onSelected,
    required this.constrainLabel,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    final foreground = selected
        ? tokens.foreground
        : option.enabled
        ? tokens.foreground
        : tokens.mutedForeground;
    final background = selected
        ? HyperGlassTheme.of(context).selection
        : HyperPalette.transparent;

    return HyperPressable(
      onPressed: option.enabled ? () => onSelected(option.value) : null,
      borderRadius: BorderRadius.circular(HyperUiRadii.sm),
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: HyperUiSpacing.sm),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(HyperUiRadii.sm),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (option.icon != null) ...[
              Icon(option.icon, size: 16, color: foreground),
              const SizedBox(width: HyperUiSpacing.xs),
            ],
            if (constrainLabel)
              Flexible(child: _buildLabel(foreground))
            else
              _buildLabel(foreground),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(Color foreground) {
    return Text(
      option.label,
      style: TextStyle(
        color: foreground,
        fontSize: 13,
        fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
