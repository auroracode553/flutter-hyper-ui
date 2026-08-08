import 'package:flutter/material.dart';

import '../theme/doc_ui_radii.dart';
import '../theme/doc_ui_spacing.dart';
import '../theme/doc_ui_theme_tokens.dart';
import 'doc_tone.dart';

class DocBadge extends StatelessWidget {
  final String label;
  final DocUiTone tone;
  final IconData? icon;
  final bool subtle;

  const DocBadge({
    super.key,
    required this.label,
    this.tone = DocUiTone.neutral,
    this.icon,
    this.subtle = true,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = DocUiThemeTokens.of(context);
    final toneColor = tone.color(tokens);
    final backgroundColor = subtle
        ? Color.alphaBlend(_withAlpha(toneColor, 0.12), tokens.card)
        : toneColor;
    final foregroundColor = subtle ? toneColor : tokens.primaryForeground;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DocUiSpacing.xs,
        vertical: DocUiSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(DocUiRadii.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: foregroundColor),
            const SizedBox(width: DocUiSpacing.xxs),
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
