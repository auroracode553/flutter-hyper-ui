import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hyper_glass_theme.dart';
import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_list_tile.dart';
import 'hyper_pressable.dart';

class HyperCheckbox extends StatelessWidget {
  const HyperCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.tristate = false,
  });

  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final String? label;
  final bool tristate;

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    final glass = HyperGlassTheme.of(context);
    final selected = value == true || (tristate && value == null);
    final box = AnimatedContainer(
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 160),
      width: 21,
      height: 21,
      decoration: BoxDecoration(
        color: selected ? tokens.primary : glass.surfaceSubtle,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: selected ? tokens.primary : tokens.input,
          width: 1.5,
        ),
      ),
      child: selected
          ? Icon(
              value == null ? LucideIcons.minus : LucideIcons.check,
              size: 15,
              color: tokens.primaryForeground,
            )
          : null,
    );
    void toggle() {
      if (tristate) {
        onChanged?.call(
          value == true
              ? null
              : value == false
              ? true
              : false,
        );
      } else {
        onChanged?.call(!(value ?? false));
      }
    }

    if (label == null) {
      return HyperPressable(
        onPressed: onChanged == null ? null : toggle,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox.square(dimension: 44, child: Center(child: box)),
      );
    }
    return HyperListTile(
      title: label!,
      trailing: box,
      enabled: onChanged != null,
      showChevron: false,
      onTap: onChanged == null ? null : toggle,
    );
  }
}

class HyperRadio<T> extends StatelessWidget {
  const HyperRadio({
    super.key,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.label,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final theme = _selectionTheme(context);
    final radio = Radio<T>(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged == null
          ? null
          : (next) {
              if (next != null) onChanged!(next);
            },
    );
    if (label == null) return Theme(data: theme, child: radio);
    return HyperListTile(
      title: label!,
      trailing: Theme(data: theme, child: radio),
      grouped: true,
      enabled: onChanged != null,
      showChevron: false,
      onTap: onChanged == null ? null : () => onChanged!(value),
    );
  }
}

class HyperSwitch extends StatelessWidget {
  const HyperSwitch({super.key, required this.value, this.onChanged, this.label});

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final control = _HyperSwitchControl(value: value, onChanged: onChanged);
    if (label == null) return control;
    return HyperListTile(
      title: label!,
      trailing: control,
      grouped: true,
      enabled: onChanged != null,
      showChevron: false,
      onTap: onChanged == null ? null : () => onChanged!(!value),
    );
  }
}

/// 自绘开关轨道，保证关闭态在不同玻璃背景上仍有清晰层次。
class _HyperSwitchControl extends StatelessWidget {
  const _HyperSwitchControl({required this.value, this.onChanged});

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    final glass = HyperGlassTheme.of(context);
    final enabled = onChanged != null;
    final trackColor = value
        ? (enabled ? tokens.primary : tokens.primary.withAlpha(90))
        : Color.alphaBlend(
            glass.controlTrack,
            enabled ? glass.surfaceStrong : glass.surfaceSubtle,
          );
    final outlineColor = value
        ? Colors.transparent
        : Color.alphaBlend(glass.edgeShade, glass.edgeHighlight);

    return HyperPressable(
      onPressed: enabled ? () => onChanged!(!value) : null,
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        width: 52,
        height: 32,
        child: AnimatedContainer(
          duration: MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: trackColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: outlineColor),
          ),
          child: AnimatedAlign(
            duration: MediaQuery.disableAnimationsOf(context)
                ? Duration.zero
                : const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: value ? tokens.primaryForeground : tokens.card,
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withAlpha(enabled ? 24 : 12),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: const SizedBox.square(dimension: 24),
            ),
          ),
        ),
      ),
    );
  }
}

class HyperSlider extends StatelessWidget {
  const HyperSlider({
    super.key,
    required this.value,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0,
    this.max = 100,
    this.divisions,
    this.showValue = true,
  }) : assert(max > min);

  final double value;
  final double min;
  final double max;
  final int? divisions;
  final bool showValue;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    final glass = HyperGlassTheme.of(context);
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: tokens.primary,
        inactiveTrackColor: glass.controlTrack,
        disabledActiveTrackColor: tokens.primary.withAlpha(80),
        disabledInactiveTrackColor: glass.controlTrack,
        trackHeight: 6,
        thumbColor: tokens.card,
        disabledThumbColor: tokens.muted,
        overlayColor: tokens.primary.withAlpha(24),
        valueIndicatorColor: glass.surfaceStrong,
        valueIndicatorTextStyle: TextStyle(
          color: tokens.foreground,
          fontWeight: FontWeight.w600,
        ),
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 10,
          elevation: 3,
          pressedElevation: 5,
        ),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 22),
      ),
      child: Slider(
        value: value.clamp(min, max).toDouble(),
        min: min,
        max: max,
        divisions: divisions,
        onChanged: onChanged,
        onChangeStart: onChangeStart,
        onChangeEnd: onChangeEnd,
        label: showValue ? value.toStringAsFixed(0) : null,
      ),
    );
  }
}

ThemeData _selectionTheme(BuildContext context) {
  final base = Theme.of(context);
  final tokens = HyperUiThemeTokens.of(context);
  final glass = HyperGlassTheme.of(context);
  Color? stateColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return tokens.mutedForeground.withAlpha(80);
    }
    if (states.contains(WidgetState.selected)) return tokens.primary;
    return glass.surfaceStrong;
  }

  return base.copyWith(
    splashFactory: NoSplash.splashFactory,
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    visualDensity: VisualDensity.compact,
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(stateColor),
      checkColor: WidgetStatePropertyAll(tokens.primaryForeground),
      overlayColor: WidgetStatePropertyAll(tokens.primary.withAlpha(24)),
      side: BorderSide(color: tokens.input, width: 1.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return tokens.mutedForeground.withAlpha(80);
        }
        return states.contains(WidgetState.selected)
            ? tokens.primary
            : tokens.mutedForeground;
      }),
      overlayColor: WidgetStatePropertyAll(tokens.primary.withAlpha(24)),
    ),
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return glass.controlTrack;
        return states.contains(WidgetState.selected)
            ? tokens.primary
            : glass.controlTrack;
      }),
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return tokens.muted;
        return states.contains(WidgetState.selected)
            ? tokens.primaryForeground
            : tokens.card;
      }),
      trackOutlineColor: WidgetStatePropertyAll(tokens.input),
      overlayColor: WidgetStatePropertyAll(tokens.primary.withAlpha(24)),
    ),
  );
}
