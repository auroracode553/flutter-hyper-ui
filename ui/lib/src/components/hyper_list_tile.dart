import 'package:flutter_hyper_ui/src/theme/hyper_palette.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hyper_glass_theme.dart';
import '../theme/hyper_ui_spacing.dart';
import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_glass.dart';
import 'hyper_lists.dart';
import 'hyper_pressable.dart';

/// 通用列表/设置菜单行。
///
/// Inside [HyperMenuGroup], the group owns the surface automatically.
class HyperListTile extends StatelessWidget {
  const HyperListTile({
    super.key,
    this.type = 'auto',
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
    this.enabled = true,
    this.showChevron = true,
  }) : assert(
         type == 'auto' || type == 'plain' || type == 'glass',
         'HyperListTile.type must be auto, plain, or glass.',
       );

  final String type;
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
  final bool enabled;
  final bool showChevron;

  bool get _hasLeading => leading != null || leadingIcon != null;

  @override
  Widget build(BuildContext context) {
    if (type != 'auto' && type != 'plain' && type != 'glass') {
      throw ArgumentError.value(type, 'type', 'Invalid list tile type');
    }
    final plain =
        type == 'plain' || (type == 'auto' && HyperMenuGroup.contains(context));
    final tokens = HyperUiThemeTokens.of(context);
    final glass = HyperGlassTheme.of(context);
    final radius = BorderRadius.circular(plain ? 12 : 15);
    final row = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      constraints: const BoxConstraints(minHeight: 46),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? tokens.muted : HyperPalette.transparent,
        borderRadius: radius,
      ),
      child: Row(
        children: <Widget>[
          if (_hasLeading) ...<Widget>[
            _buildLeading(tokens, glass),
            const SizedBox(width: HyperUiSpacing.sm),
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
            const SizedBox(width: HyperUiSpacing.sm),
            trailing!,
          ] else if (showChevron && onTap != null) ...<Widget>[
            const SizedBox(width: HyperUiSpacing.sm),
            Icon(
              LucideIcons.chevronRight,
              size: 18,
              color: tokens.mutedForeground,
            ),
          ],
        ],
      ),
    );

    if (plain) {
      return HyperPressable(
        onPressed: enabled ? onTap : null,
        enabled: enabled,
        pressedScale: 0.992,
        borderRadius: radius,
        child: row,
      );
    }

    return HyperGlass(
      radius: 18,
      blur: 14,
      type: 'regular',
      padding: const EdgeInsets.all(3),
      onTap: enabled ? onTap : null,
      color: selected ? glass.surfaceStrong : null,
      borderColor: selected ? tokens.primary.withAlpha(90) : null,
      child: row,
    );
  }

  Widget _buildLeading(HyperUiThemeTokens tokens, HyperGlassTheme glass) {
    if (leading != null) return leading!;
    final color = leadingColor ?? tokens.primary;
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: color.withAlpha(28),
        borderRadius: BorderRadius.circular(11),
        // 与 HyperGlass 一致的合成边缘：高光叠微量分隔色，避免纯白高光在浅色下不可见。
        border: Border.all(
          color: Color.alphaBlend(glass.edgeShade, glass.edgeHighlight),
        ),
      ),
      alignment: Alignment.center,
      child: Icon(leadingIcon, size: 18, color: color),
    );
  }
}
