import 'package:flutter/material.dart';

import '../theme/hy_ui_radii.dart';
import '../theme/hy_ui_theme_tokens.dart';

class HyProgressBar extends StatelessWidget {
  final double value;
  final double height;
  final Color? color;
  final Color? backgroundColor;

  const HyProgressBar({
    super.key,
    required this.value,
    this.height = 8,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    final clampedValue = value.clamp(0, 1).toDouble();

    return ClipRRect(
      borderRadius: BorderRadius.circular(HyUiRadii.full),
      child: SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: backgroundColor ?? tokens.muted),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: clampedValue,
              child: ColoredBox(color: color ?? tokens.primary),
            ),
          ],
        ),
      ),
    );
  }
}
