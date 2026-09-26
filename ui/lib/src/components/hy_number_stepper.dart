import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hy_glass_theme.dart';
import '../theme/hy_ui_theme_tokens.dart';
import 'hy_glass.dart';
import 'hy_button.dart';

/// 用于数量、份数等整数输入的受控步进器。
class HyNumberStepper extends StatelessWidget {
  const HyNumberStepper({
    super.key,
    required this.value,
    this.onChanged,
    this.min = 0,
    this.max = 99,
    this.step = 1,
    this.semanticLabel,
  }) : assert(min <= max),
       assert(step > 0),
       assert(value >= min && value <= max);

  final int value;
  final ValueChanged<int>? onChanged;
  final int min;
  final int max;
  final int step;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    final glass = HyGlassTheme.of(context);
    final canDecrease = onChanged != null && value > min;
    final canIncrease = onChanged != null && value < max;

    return Semantics(
      label: semanticLabel ?? '数量',
      value: '$value',
      child: HyGlass(
        radius: 16,
        blur: 14,
        weight: HyGlassWeight.subtle,
        borderColor: tokens.input,
        padding: const EdgeInsets.all(3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            HyButton.icon(
              icon: LucideIcons.minus,
              semanticLabel: '减少',
              height: 32,
              iconSize: 17,
              radius: 12,
              color: canDecrease ? tokens.foreground : tokens.mutedForeground,
              backgroundColor: glass.selection,
              onPressed: canDecrease
                  ? () => onChanged!((value - step).clamp(min, max).toInt())
                  : null,
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 36),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  '$value',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: tokens.foreground,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ),
            HyButton.icon(
              icon: LucideIcons.plus,
              semanticLabel: '增加',
              height: 32,
              iconSize: 17,
              radius: 12,
              color: canIncrease ? tokens.foreground : tokens.mutedForeground,
              backgroundColor: glass.selection,
              onPressed: canIncrease
                  ? () => onChanged!((value + step).clamp(min, max).toInt())
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
