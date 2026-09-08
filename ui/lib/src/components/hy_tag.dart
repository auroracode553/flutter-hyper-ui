import 'package:flutter/material.dart';

import '../theme/hy_ui_radii.dart';
import '../theme/hy_ui_spacing.dart';
import '../theme/hy_ui_theme_tokens.dart';
import 'hy_tone.dart';

class HyTag extends StatelessWidget {
  final String label;
  final HyUiTone tone;
  final IconData? icon;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onClose;

  const HyTag({
    super.key,
    required this.label,
    this.tone = HyUiTone.neutral,
    this.icon,
    this.selected = false,
    this.onTap,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    final toneColor = tone.color(tokens);
    final background = selected ? toneColor : tokens.card;
    final foreground = selected ? tokens.primaryForeground : toneColor;
    final iconColor = selected ? tokens.primaryForeground : toneColor;
    final borderColor = selected ? toneColor : tokens.border;

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(HyUiRadii.sm),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: HyUiSpacing.sm),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(HyUiRadii.sm),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: iconColor),
                const SizedBox(width: HyUiSpacing.xs),
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
              if (onClose != null) SizedBox(width: 28, child: IconButton(
                padding: EdgeInsets.zero, tooltip: '移除 $label', onPressed: onClose,
                icon: Icon(Icons.close, size: 14, color: foreground))),
            ],
          ),
        ),
      ),
    );
  }
}
