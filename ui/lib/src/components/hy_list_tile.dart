import 'package:flutter/material.dart';

import '../theme/hy_glass_theme.dart';
import '../theme/hy_ui_spacing.dart';
import '../theme/hy_ui_theme_tokens.dart';
import 'hy_glass.dart';
import 'hy_pressable.dart';

/// 通用列表/设置菜单行。
///
/// [grouped] 为 true 时不重复绘制玻璃表面，交由外部 [HyMenuGroup] 承载材质。
class HyListTile extends StatelessWidget {
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
    this.enabled = true,
    this.showChevron = true,
  });

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
  final bool enabled;
  final bool showChevron;

  bool get _hasLeading => leading != null || leadingIcon != null;

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    final glass = HyGlassTheme.of(context);
    final radius = BorderRadius.circular(grouped ? 12 : 18);
    final row = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      constraints: const BoxConstraints(minHeight: 52),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? glass.selection : Colors.transparent,
        borderRadius: radius,
      ),
      child: Row(
        children: <Widget>[
          if (_hasLeading) ...<Widget>[
            _buildLeading(tokens, glass),
            const SizedBox(width: HyUiSpacing.sm),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    color: enabled
                        ? tokens.cardForeground
                        : tokens.mutedForeground,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...<Widget>[
                  const SizedBox(height: 3),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: tokens.mutedForeground,
                      fontSize: 12,
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (meta != null) ...<Widget>[
                  const SizedBox(height: 4),
                  Text(
                    meta!,
                    style: TextStyle(
                      color: tokens.mutedForeground,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...<Widget>[
            const SizedBox(width: HyUiSpacing.sm),
            trailing!,
          ] else if (showChevron && onTap != null) ...<Widget>[
            const SizedBox(width: HyUiSpacing.sm),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: tokens.mutedForeground,
            ),
          ],
        ],
      ),
    );

    if (grouped) {
      return HyPressable(
        onPressed: enabled ? onTap : null,
        enabled: enabled,
        pressedScale: 0.992,
        borderRadius: radius,
        semanticLabel: title,
        child: row,
      );
    }

    return HyGlass(
      radius: 18,
      blur: 14,
      weight: HyGlassWeight.regular,
      onTap: enabled ? onTap : null,
      color: selected ? glass.surfaceStrong : null,
      borderColor: selected ? tokens.primary.withAlpha(90) : null,
      child: row,
    );
  }

  Widget _buildLeading(HyUiThemeTokens tokens, HyGlassTheme glass) {
    if (leading != null) return leading!;
    final color = leadingColor ?? tokens.primary;
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: color.withAlpha(28),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: glass.edgeHighlight),
      ),
      alignment: Alignment.center,
      child: Icon(leadingIcon, size: 20, color: color),
    );
  }
}
