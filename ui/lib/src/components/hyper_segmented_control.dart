import 'package:flutter_hyper_ui/src/theme/hyper_palette.dart';
import 'package:flutter/widgets.dart';

import '../theme/hyper_ui_radii.dart';
import '../theme/hyper_ui_effects.dart';
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
        paintSelection: !equalWidth,
      );
      return equalWidth ? Expanded(child: item) : item;
    }).toList();

    return HyperGlass(
      radius: 18,
      type: 'subtle',
      padding: const EdgeInsets.all(4),
      child: equalWidth && options.isNotEmpty
          ? _buildEqualWidth(context, children)
          : Row(
              mainAxisSize: equalWidth ? MainAxisSize.max : MainAxisSize.min,
              children: children,
            ),
    );
  }

  Widget _buildEqualWidth(BuildContext context, List<Widget> children) =>
      LayoutBuilder(
        builder: (context, constraints) {
          final selected = options.indexWhere(
            (option) => option.value == selectedValue,
          );
          final rtl = Directionality.of(context) == TextDirection.rtl;
          final visualIndex = rtl ? options.length - selected - 1 : selected;
          final cellWidth = constraints.maxWidth / options.length;
          return Stack(
            children: [
              if (selected >= 0)
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.topLeft,
                    // 仅平移选中底板，标签保持稳定，快速切换沿用当前位置。
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                        begin: visualIndex.toDouble(),
                        end: visualIndex.toDouble(),
                      ),
                      duration:
                          MediaQuery.maybeOf(context)?.disableAnimations == true
                          ? Duration.zero
                          : HyperUiEffects.selectionDuration,
                      curve: HyperUiEffects.selectionCurve,
                      child: Container(
                        width: cellWidth,
                        height: 32,
                        decoration: BoxDecoration(
                          color: HyperGlassTheme.of(context).selection,
                          borderRadius: BorderRadius.circular(HyperUiRadii.sm),
                        ),
                      ),
                      builder: (context, position, child) => Transform.translate(
                        offset: Offset(position * cellWidth, 0),
                        child: child,
                      ),
                    ),
                  ),
                ),
              Row(children: children),
            ],
          );
        },
      );
}

class _HyperSegmentItem<T> extends StatelessWidget {
  final HyperSegmentOption<T> option;
  final bool selected;
  final ValueChanged<T> onSelected;
  final bool constrainLabel;
  final bool paintSelection;

  const _HyperSegmentItem({
    required this.option,
    required this.selected,
    required this.onSelected,
    required this.constrainLabel,
    required this.paintSelection,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    final foreground = selected
        ? tokens.foreground
        : option.enabled
        ? tokens.foreground
        : tokens.mutedForeground;
    final background = selected && paintSelection
        ? HyperGlassTheme.of(context).selection
        : HyperPalette.transparent;

    return HyperPressable(
      onPressed: option.enabled ? () => onSelected(option.value) : null,
      borderRadius: BorderRadius.circular(HyperUiRadii.sm),
      child: AnimatedContainer(
        duration: HyperUiEffects.durationOf(
          context,
          HyperUiEffects.stateDuration,
        ),
        curve: HyperUiEffects.selectionCurve,
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
