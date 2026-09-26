import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hy_glass_theme.dart';
import '../theme/hy_ui_theme_tokens.dart';
import 'hy_list_tile.dart';
import 'hy_pressable.dart';

class HyCheckbox extends StatelessWidget {
  const HyCheckbox({
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
    final tokens = HyUiThemeTokens.of(context);
    final glass = HyGlassTheme.of(context);
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
        onChanged?.call(value == true ? null : value == false ? true : false);
      } else {
        onChanged?.call(!(value ?? false));
      }
    }
    if (label == null) {
      return HyPressable(
        onPressed: onChanged == null ? null : toggle,
        semanticLabel: '复选',
        borderRadius: BorderRadius.circular(12),
        child: SizedBox.square(dimension: 44, child: Center(child: box)),
      );
    }
    return HyListTile(
      title: label!,
      trailing: box,
      enabled: onChanged != null,
      showChevron: false,
      onTap: onChanged == null ? null : toggle,
    );
  }
}

class HyRadio<T> extends StatelessWidget {
  const HyRadio({
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
    return HyListTile(
      title: label!,
      trailing: Theme(data: theme, child: radio),
      grouped: true,
      enabled: onChanged != null,
      showChevron: false,
      onTap: onChanged == null ? null : () => onChanged!(value),
    );
  }
}

class HySwitch extends StatelessWidget {
  const HySwitch({super.key, required this.value, this.onChanged, this.label});

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final theme = _selectionTheme(context);
    final control = Switch(value: value, onChanged: onChanged);
    if (label == null) return Theme(data: theme, child: control);
    return HyListTile(
      title: label!,
      trailing: Theme(data: theme, child: control),
      grouped: true,
      enabled: onChanged != null,
      showChevron: false,
      onTap: onChanged == null ? null : () => onChanged!(!value),
    );
  }
}

class HySlider extends StatelessWidget {
  const HySlider({
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
    final tokens = HyUiThemeTokens.of(context);
    final glass = HyGlassTheme.of(context);
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
  final tokens = HyUiThemeTokens.of(context);
  final glass = HyGlassTheme.of(context);
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
