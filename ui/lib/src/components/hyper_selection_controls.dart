import 'package:flutter_hyper_ui/src/theme/hyper_palette.dart';
import 'package:flutter/widgets.dart';
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
    final tokens = HyperUiThemeTokens.of(context);
    final glass = HyperGlassTheme.of(context);
    final selected = value == groupValue;
    final radio = HyperPressable(
      onPressed: onChanged == null ? null : () => onChanged!(value),
      child: SizedBox.square(
        dimension: 44,
        child: Center(
          child: Container(
            width: 21,
            height: 21,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: glass.surfaceSubtle,
              border: Border.all(
                color: selected ? tokens.primary : tokens.input,
                width: selected ? 6 : 1.5,
              ),
            ),
          ),
        ),
      ),
    );
    if (label == null) return radio;
    return HyperListTile(
      type: 'plain',
      title: label!,
      trailing: radio,
      enabled: onChanged != null,
      showChevron: false,
      onTap: onChanged == null ? null : () => onChanged!(value),
    );
  }
}

class HyperSwitch extends StatelessWidget {
  const HyperSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final control = _HyperSwitchControl(value: value, onChanged: onChanged);
    if (label == null) return control;
    return HyperListTile(
      type: 'plain',
      title: label!,
      trailing: control,
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
        ? HyperPalette.transparent
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
                    color: glass.shadow.withValues(
                      alpha: glass.shadow.a * (enabled ? 1 : 0.5),
                    ),
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
    final amount = ((value.clamp(min, max) - min) / (max - min)).toDouble();
    double nextValue(double localX, double width) {
      final fraction = (localX / width).clamp(0.0, 1.0);
      var next = min + fraction * (max - min);
      if (divisions != null && divisions! > 0) {
        next =
            min +
            ((next - min) / (max - min) * divisions!).round() *
                (max - min) /
                divisions!;
      }
      return next;
    }

    return Row(
      children: <Widget>[
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) => GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: onChanged == null
                  ? null
                  : (details) => onChanged!(
                      nextValue(details.localPosition.dx, constraints.maxWidth),
                    ),
              onHorizontalDragStart: onChanged == null
                  ? null
                  : (_) => onChangeStart?.call(value),
              onHorizontalDragUpdate: onChanged == null
                  ? null
                  : (details) => onChanged!(
                      nextValue(details.localPosition.dx, constraints.maxWidth),
                    ),
              onHorizontalDragEnd: onChanged == null
                  ? null
                  : (_) => onChangeEnd?.call(value),
              child: SizedBox(
                height: 44,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: <Widget>[
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: glass.controlTrack,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    Container(
                      width: constraints.maxWidth * amount,
                      height: 6,
                      decoration: BoxDecoration(
                        color: tokens.primary,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    Positioned(
                      left: (constraints.maxWidth * amount - 10).clamp(
                        0.0,
                        constraints.maxWidth - 20,
                      ),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: onChanged == null ? tokens.muted : tokens.card,
                          border: Border.all(color: tokens.primary, width: 2),
                          boxShadow: <BoxShadow>[
                            BoxShadow(color: glass.shadow, blurRadius: 5),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (showValue)
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(value.toStringAsFixed(0)),
          ),
      ],
    );
  }
}
