import 'package:flutter/material.dart';

import '../theme/doc_ui_radii.dart';
import '../theme/doc_ui_spacing.dart';
import '../theme/doc_ui_theme_tokens.dart';
import 'doc_tone.dart';

class DocTag extends StatelessWidget {
  final String label;
  final DocUiTone tone;
  final IconData? icon;
  final bool selected;
  final VoidCallback? onTap;

  const DocTag({
    super.key,
    required this.label,
    this.tone = DocUiTone.neutral,
    this.icon,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = DocUiThemeTokens.of(context);
    final toneColor = tone.color(tokens);
    final background = selected ? toneColor : tokens.card;
    final foreground = selected ? tokens.primaryForeground : tokens.foreground;
    final iconColor = selected ? tokens.primaryForeground : toneColor;
    final borderColor = selected ? toneColor : tokens.border;

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(DocUiRadii.sm),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: DocUiSpacing.sm),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DocUiRadii.sm),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: iconColor),
                const SizedBox(width: DocUiSpacing.xs),
              ],
              Text(
                label,
                style: TextStyle(
                  color: foreground,
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
