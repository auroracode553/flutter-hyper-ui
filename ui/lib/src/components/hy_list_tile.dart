import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
    this.titleColor,
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
  final Color? titleColor;
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
    final radius = BorderRadius.circular(grouped ? 12 : 15);
    final row = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      constraints: const BoxConstraints(minHeight: 46),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? tokens.muted : Colors.transparent,
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
                        ? titleColor ?? tokens.cardForeground
                        : tokens.mutedForeground,
                    fontSize: 14,
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
              LucideIcons.chevronRight,
              size: 18,
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
      padding: const EdgeInsets.all(3),
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
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: color.withAlpha(28),
        borderRadius: BorderRadius.circular(11),
        // 与 HyGlass 一致的合成边缘：高光叠微量分隔色，避免纯白高光在浅色下不可见。
        border: Border.all(
          color: Color.alphaBlend(glass.edgeShade, glass.edgeHighlight),
        ),
      ),
      alignment: Alignment.center,
      child: Icon(leadingIcon, size: 18, color: color),
    );
  }
}
