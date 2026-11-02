import 'package:flutter_hyper_ui/src/theme/hyper_palette.dart';
import 'package:flutter/widgets.dart';

import '../theme/hyper_ui_radii.dart';
import '../theme/hyper_ui_effects.dart';
import '../theme/hyper_surface_theme.dart';
import '../theme/hyper_ui_spacing.dart';
import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_control_surface.dart';
import '../utils/hyper_spring_motion.dart';
import '../interaction/press_feedback.dart';

class HyperTabsItem<T> {
  final T value;
  final String label;
  final IconData? icon;
  final bool enabled;

  const HyperTabsItem({
    required this.value,
    required this.label,
    this.icon,
    this.enabled = true,
  });
}

class HyperTabs<T> extends StatelessWidget {
  final List<HyperTabsItem<T>> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final bool equalWidth;
  final bool enabled;

  const HyperTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
    this.equalWidth = true,
    this.enabled = true,
  }) : assert(selectedIndex >= 0 && selectedIndex < tabs.length);

  @override
  Widget build(BuildContext context) {
    final children = tabs.asMap().entries.map((entry) {
      final index = entry.key;
      final option = entry.value;
      final item = _HyperTabsItem<T>(
        option: option,
        selected: index == selectedIndex,
        onSelected: enabled
            ? (_) {
                if (index != selectedIndex) onChanged(index);
              }
            : null,
        constrainLabel: equalWidth,
        paintSelection: !equalWidth,
      );
      return equalWidth ? Expanded(child: item) : item;
    }).toList();

    return HyperControlSurface(
      radius: 18,
      role: HyperControlSurfaceRole.field,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: equalWidth && tabs.isNotEmpty
            ? _buildEqualWidth(context, children)
            : Row(
                mainAxisSize: equalWidth ? MainAxisSize.max : MainAxisSize.min,
                children: children,
              ),
      ),
    );
  }

  Widget _buildEqualWidth(BuildContext context, List<Widget> children) =>
      LayoutBuilder(
        builder: (context, constraints) {
          final selection = HyperSurfaceTheme.of(context).selection;
          final selected = selectedIndex;
          final rtl = Directionality.of(context) == TextDirection.rtl;
          final visualIndex = rtl ? tabs.length - selected - 1 : selected;
          final cellWidth = constraints.maxWidth / tabs.length;
          return Stack(
            children: [
              if (selected >= 0)
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.topLeft,
                    // 仅平移选中底板，标签保持稳定，快速切换沿用当前位置。
                    child: HyperSpringMotion(
                      value: visualIndex.toDouble(),
                      builder: (context, position) => Transform.translate(
                        offset: Offset(position * cellWidth, 0),
                        child: HyperControlSurface(
                          radius: 16,
                          role: HyperControlSurfaceRole.compact,
                          color: selection.withValues(
                            alpha: selection.a * 0.75,
                          ),
                          child: SizedBox(width: cellWidth, height: 32),
                        ),
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

class _HyperTabsItem<T> extends StatelessWidget {
  final HyperTabsItem<T> option;
  final bool selected;
  final ValueChanged<T>? onSelected;
  final bool constrainLabel;
  final bool paintSelection;

  const _HyperTabsItem({
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
        : option.enabled && onSelected != null
        ? tokens.foreground
        : tokens.mutedForeground;

    return PressFeedback(
      onPressed: option.enabled && onSelected != null
          ? () => onSelected!(option.value)
          : null,
      borderRadius: BorderRadius.circular(HyperUiRadii.sm),
      child: _selectionSurface(
        context,
        AnimatedContainer(
          duration: HyperUiEffects.durationOf(
            context,
            HyperUiEffects.stateDuration,
          ),
          curve: HyperUiEffects.selectionCurve,
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: HyperUiSpacing.sm),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: HyperPalette.transparent,
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
      ),
    );
  }

  Widget _selectionSurface(BuildContext context, Widget child) {
    final selection = HyperSurfaceTheme.of(context).selection;
    return paintSelection
        ? Stack(
            children: [
              Positioned.fill(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(end: selected ? 1 : 0),
                  duration: HyperUiEffects.durationOf(
                    context,
                    HyperUiEffects.stateDuration,
                  ),
                  curve: HyperUiEffects.selectionCurve,
                  builder: (context, progress, _) => progress <= 0
                      ? const SizedBox.shrink()
                      : Opacity(
                          opacity: progress,
                          child: HyperControlSurface(
                            radius: 16,
                            role: HyperControlSurfaceRole.compact,
                            color: selection.withValues(
                              alpha: selection.a * 0.75,
                            ),
                            child: const SizedBox.expand(),
                          ),
                        ),
                ),
              ),
              child,
            ],
          )
        : child;
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
