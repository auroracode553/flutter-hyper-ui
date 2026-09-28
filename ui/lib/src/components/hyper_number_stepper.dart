import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hyper_glass_theme.dart';
import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_glass.dart';
import 'hyper_button.dart';

/// 用于数量、份数等整数输入的受控步进器。
class HyperNumberStepper extends StatelessWidget {
  const HyperNumberStepper({
    super.key,
    required this.value,
    this.onChanged,
    this.min = 0,
    this.max = 99,
    this.step = 1,
  }) : assert(min <= max),
       assert(step > 0),
       assert(value >= min && value <= max);

  final int value;
  final ValueChanged<int>? onChanged;
  final int min;
  final int max;
  final int step;

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    final glass = HyperGlassTheme.of(context);
    final canDecrease = onChanged != null && value > min;
    final canIncrease = onChanged != null && value < max;

    return HyperGlass(
      radius: 16,
      blur: 14,
      type: 'subtle',
      borderColor: tokens.input,
      padding: const EdgeInsets.all(3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          HyperButton(
            type: 'tonal',
            icon: LucideIcons.minus,
            size: 'small',
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
                  fontFeatures: const <FontFeature>[
                    FontFeature.tabularFigures(),
                  ],
                ),
              ),
            ),
          ),
          HyperButton(
            type: 'tonal',
            icon: LucideIcons.plus,
            size: 'small',
            color: canIncrease ? tokens.foreground : tokens.mutedForeground,
            backgroundColor: glass.selection,
            onPressed: canIncrease
                ? () => onChanged!((value + step).clamp(min, max).toInt())
                : null,
          ),
        ],
      ),
    );
  }
}
