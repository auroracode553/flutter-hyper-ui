import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hy_glass_theme.dart';
import '../theme/hy_ui_theme_tokens.dart';
import 'hy_icon_button.dart';
import 'hy_list_tile.dart';

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
    return HyListTile(
      title: label!,
      trailing: Theme(data: theme, child: checkbox),
      grouped: true,
      enabled: onChanged != null,
      showChevron: false,
      onTap: onChanged == null
          ? null
          : () {
              if (tristate) {
                onChanged!(
                  value == true ? null : value == false ? true : false,
                );
              } else {
                onChanged!(!(value ?? false));
              }
            },
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

class HyRate extends StatelessWidget {
  const HyRate({
    super.key,
    required this.value,
    this.onChanged,
    this.count = 5,
    this.size = 20,
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
            child: Opacity(
              opacity: onChanged == null ? 0.5 : 1,
              child: HyIconButton(
                icon: value >= index + 1
                    ? LucideIcons.star
                    : value > index
                    ? LucideIcons.starHalf
                    : LucideIcons.star,
                semanticLabel: '${index + 1} 星',
                size: size + 12,
                iconSize: size,
                onPressed: onChanged == null
                    ? null
                    : () => onChanged!(index + 1.0),
                color: tokens.warning,
                // 星星是评分图标而非按钮，保持无背景。
                backgroundColor: Colors.transparent,
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
