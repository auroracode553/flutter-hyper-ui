import 'package:flutter_hyper_ui/src/theme/hyper_palette.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hyper_surface_theme.dart';
import '../theme/hyper_ui_spacing.dart';
import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_glass.dart';
import 'hyper_lists.dart';
import '../interaction/press_feedback.dart';
import 'hyper_surface_scope.dart';

/// 通用列表/设置菜单行。
///
/// Inside [HyperMenuGroup], the group owns the surface automatically.
class HyperListTile extends StatelessWidget {
  /// 创建列表行，禁用时停止点击和长按通知。
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
    this.onPressed,
    this.onLongPressed,
    this.selected = false,
    this.enabled = true,
    this.showChevron = true,
  }) : assert(
         type == 'auto' || type == 'plain' || type == 'glass',
         'HyperListTile.type must be auto, plain, or glass.',
       );

  /// 组件形态。
  final String type;
  /// 标题文字。
  final String title;
  /// 副标题文字。
  final String? subtitle;
  /// 补充元信息文字。
  final String? meta;
  /// 前置自定义内容。
  final Widget? leading;
  /// 前置图标。
  final IconData? leadingIcon;
  /// 前置图标颜色。
  final Color? leadingColor;
  /// 标题颜色。
  final Color? titleColor;
  /// 尾部自定义内容。
  final Widget? trailing;
  /// 点击时触发，可独立于长按启用。
  final VoidCallback? onPressed;
  /// 长按行时触发，禁用时停止通知。
  final VoidCallback? onLongPressed;
  /// 是否显示选中状态。
  final bool selected;
  /// 是否允许交互。
  final bool enabled;
  /// 是否在可点击时显示右侧箭头。
  final bool showChevron;

  /// 是否存在前置内容或图标。
  bool get _hasLeading => leading != null || leadingIcon != null;

  /// 根据当前主题和参数构建组件界面。
  @override
  Widget build(BuildContext context) {
    if (type != 'auto' && type != 'plain' && type != 'glass') {
      throw ArgumentError.value(type, 'type', 'Invalid list tile type');
    }
    final hasParentSurface =
        HyperMenuGroup.contains(context) || HyperSurfaceScope.contains(context);
    final plain = type == 'plain' || (type == 'auto' && hasParentSurface);
    final tokens = HyperUiThemeTokens.of(context);
    final glass = HyperSurfaceTheme.of(context);
    final radius = BorderRadius.circular(plain ? 12 : 15);
    final row = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      constraints: const BoxConstraints(minHeight: 46),
      // 仅复用父表面时共享其留白，独立平铺行仍保护选中背景内的内容。
      padding: EdgeInsets.symmetric(
        horizontal: plain && hasParentSurface ? 0 : 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: selected ? glass.selection : HyperPalette.transparent,
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
                  maxLines: 2,
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
          ] else if (showChevron && onPressed != null) ...<Widget>[
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
      return PressFeedback(
        onPressed: enabled ? onPressed : null,
        onLongPressed: enabled ? onLongPressed : null,
        enabled: enabled,
        pressedScale: 0.992,
        borderRadius: radius,
        child: row,
      );
    }

    return HyperGlass.card(
      radius: 18,
      showBorder: selected,
      padding: const EdgeInsets.symmetric(vertical: 3),
      onPressed: enabled ? onPressed : null,
        onLongPressed: enabled ? onLongPressed : null,
      color: selected ? glass.surfaceStrong : null,
      borderColor: selected ? tokens.primary.withAlpha(90) : null,
      child: row,
    );
  }

  /// 根据主题颜色构建前置内容。
  Widget _buildLeading(HyperUiThemeTokens tokens, HyperSurfaceTheme glass) {
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
