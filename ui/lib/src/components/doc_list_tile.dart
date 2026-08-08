import 'package:flutter/material.dart';

import '../theme/doc_ui_radii.dart';
import '../theme/doc_ui_spacing.dart';
import '../theme/doc_ui_theme_tokens.dart';

class DocListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? meta;
  final Widget? leading;
  final IconData? leadingIcon;
  final Color? leadingColor;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool selected;

  const DocListTile({
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
  });

  @override
  Widget build(BuildContext context) {
    final tokens = DocUiThemeTokens.of(context);
    final borderColor = selected ? tokens.primary : tokens.border;
    final backgroundColor =
        selected ? tokens.selectionBackground : tokens.card;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(DocUiRadii.md),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(DocUiSpacing.cardPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DocUiRadii.md),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              if (_hasLeading) ...[
                _buildLeading(tokens),
                const SizedBox(width: DocUiSpacing.sm),
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
                      const SizedBox(height: DocUiSpacing.xxs),
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
              const SizedBox(width: DocUiSpacing.sm),
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

  Widget _buildLeading(DocUiThemeTokens tokens) {
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
        borderRadius: BorderRadius.circular(DocUiRadii.sm),
      ),
      child: Icon(
        icon,
        size: 20,
        color: tokens.primaryForeground,
      ),
    );
  }
}
