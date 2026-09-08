import 'package:flutter/material.dart';

import '../theme/hy_ui_radii.dart';
import '../theme/hy_ui_spacing.dart';
import '../theme/hy_ui_theme_tokens.dart';
import 'hy_tone.dart';

class HyBadge extends StatelessWidget {
  final String label;
  final HyUiTone tone;
  final IconData? icon;
  final bool subtle;

  const HyBadge({
    super.key,
    required this.label,
    this.tone = HyUiTone.neutral,
    this.icon,
    this.subtle = true,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    final toneColor = tone.color(tokens);
    final backgroundColor = subtle
        ? Color.alphaBlend(_withAlpha(toneColor, 0.12), tokens.card)
        : toneColor;
    final foregroundColor = subtle ? toneColor : tokens.primaryForeground;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: HyUiSpacing.xs,
        vertical: HyUiSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(HyUiRadii.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: foregroundColor),
            const SizedBox(width: HyUiSpacing.xxs),
          ],
          Text(
            label,
            style: TextStyle(
              color: foregroundColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Color _withAlpha(Color color, double alpha) {
    return color.withAlpha((255 * alpha).round());
  }
}
