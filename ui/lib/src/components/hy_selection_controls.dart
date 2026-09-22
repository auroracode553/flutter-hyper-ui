import 'package:flutter/material.dart';

import '../theme/hy_glass_theme.dart';
import '../theme/hy_ui_theme_tokens.dart';

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
    final theme = _selectionTheme(context);
    final checkbox = Checkbox(
      value: value,
      onChanged: onChanged,
      tristate: tristate,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
    );
    if (label == null) return Theme(data: theme, child: checkbox);
    return Theme(
      data: theme,
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        tristate: tristate,
        contentPadding: EdgeInsets.zero,
        dense: true,
        title: Text(label!),
        controlAffinity: ListTileControlAffinity.leading,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

class HyRadio<T> extends StatelessWidget {
  const HyRadio({
    super.key,
    required this.value,
    required this.groupValue,
    this.onChanged,
    required this.label,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _selectionTheme(context),
      child: RadioListTile<T>(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged == null
            ? null
            : (next) {
                if (next != null) onChanged!(next);
              },
        contentPadding: EdgeInsets.zero,
        dense: true,
        title: Text(label),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
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
    return Theme(
      data: theme,
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        title: Text(label!),
        contentPadding: EdgeInsets.zero,
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
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

class HyRate extends StatelessWidget {
  const HyRate({
    super.key,
    required this.value,
    this.onChanged,
    this.count = 5,
    this.size = 26,
  }) : assert(count > 0);

  final double value;
  final double size;
  final int count;
  final ValueChanged<double>? onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    return Wrap(
      children: <Widget>[
        for (var index = 0; index < count; index++)
          Semantics(
            selected: value >= index + 1,
            child: IconButton(
              tooltip: '${index + 1} 星',
              iconSize: size,
              onPressed: onChanged == null
                  ? null
                  : () => onChanged!(index + 1.0),
              color: tokens.warning,
              disabledColor: tokens.warning.withAlpha(130),
              icon: Icon(
                value >= index + 1
                    ? Icons.star_rounded
                    : value > index
                    ? Icons.star_half_rounded
                    : Icons.star_outline_rounded,
              ),
            ),
          ),
      ],
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
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(stateColor),
      checkColor: WidgetStatePropertyAll(tokens.primaryForeground),
      overlayColor: WidgetStatePropertyAll(tokens.primary.withAlpha(24)),
      side: BorderSide(color: glass.edgeShade, width: 1.2),
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
      trackOutlineColor: WidgetStatePropertyAll(glass.edgeShade),
      overlayColor: WidgetStatePropertyAll(tokens.primary.withAlpha(24)),
    ),
  );
}
