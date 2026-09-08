import 'package:flutter/material.dart';

import '../theme/hy_ui_radii.dart';
import '../theme/hy_ui_spacing.dart';
import '../theme/hy_ui_theme_tokens.dart';

class HyListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? meta;
  final Widget? leading;
  final IconData? leadingIcon;
  final Color? leadingColor;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool selected;
  final bool grouped;

  const HyListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.meta,
    this.leading,
    this.leadingIcon,
    this.leadingColor,
    this.trailing,
    this.onTap,
    this.selected = false,
    this.grouped = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    final borderColor = grouped ? Colors.transparent : selected ? tokens.primary : tokens.border;
    final backgroundColor =
        selected ? tokens.selectionBackground : grouped ? Colors.transparent : tokens.card.withAlpha(190);

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(HyUiRadii.md),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(HyUiSpacing.cardPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(HyUiRadii.md),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              if (_hasLeading) ...[
                _buildLeading(tokens),
                const SizedBox(width: HyUiSpacing.sm),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: tokens.cardForeground,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          color: tokens.mutedForeground,
                          fontSize: 13,
                          height: 1.35,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (meta != null) ...[
                      const SizedBox(height: HyUiSpacing.xxs),
                      Text(
                        meta!,
                        style: TextStyle(
                          color: tokens.mutedForeground,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: HyUiSpacing.sm),
              trailing ??
                  Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: tokens.mutedForeground,
                  ),
            ],
          ),
        ),
      ),
    );
  }

  bool get _hasLeading => leading != null || leadingIcon != null;

  Widget _buildLeading(HyUiThemeTokens tokens) {
    final customLeading = leading;
    if (customLeading != null) {
      return customLeading;
    }

    final icon = leadingIcon;
    if (icon == null) {
      return const SizedBox.shrink();
    }

    final color = leadingColor ?? tokens.primary;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(HyUiRadii.sm),
      ),
      child: Icon(
        icon,
        size: 20,
        color: tokens.primaryForeground,
      ),
    );
  }
}
