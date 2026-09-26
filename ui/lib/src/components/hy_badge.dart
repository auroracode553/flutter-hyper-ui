import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hy_glass_theme.dart';
import '../theme/hy_ui_radii.dart';
import '../theme/hy_ui_spacing.dart';
import '../theme/hy_ui_theme_tokens.dart';
import 'hy_button.dart';
import 'hy_pressable.dart';
import 'hy_tone.dart';

enum _HyBadgeKind { status, tag, count }

/// 状态、可交互标签与角标共用的语义徽标。
class HyBadge extends StatelessWidget {
  const HyBadge({
    super.key,
    required this.label,
    this.tone = HyUiTone.neutral,
    this.icon,
    this.subtle = true,
  }) : selected = false,
       onTap = null,
       onClose = null,
       child = null,
       count = 0,
       max = 99,
       dot = false,
       showZero = false,
       _kind = _HyBadgeKind.status;

  const HyBadge.tag({
    super.key,
    required this.label,
    this.tone = HyUiTone.neutral,
    this.icon,
    this.selected = false,
    this.onTap,
    this.onClose,
  }) : subtle = true,
       child = null,
       count = 0,
       max = 99,
       dot = false,
       showZero = false,
       _kind = _HyBadgeKind.tag;

  const HyBadge.count({
    super.key,
    required this.child,
    this.count = 0,
    this.max = 99,
    this.dot = false,
    this.showZero = false,
  }) : label = null,
       tone = HyUiTone.error,
       icon = null,
       subtle = false,
       selected = false,
       onTap = null,
       onClose = null,
       _kind = _HyBadgeKind.count;

  final String? label;
  final HyUiTone tone;
  final IconData? icon;
  final bool subtle;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onClose;
  final Widget? child;
  final int count;
  final int max;
  final bool dot;
  final bool showZero;
  final _HyBadgeKind _kind;

  @override
  Widget build(BuildContext context) {
    if (_kind == _HyBadgeKind.count) return _buildCount(context);
    final tokens = HyUiThemeTokens.of(context);
    final glass = HyGlassTheme.of(context);
    final toneColor = tone.color(tokens);
    final isTag = _kind == _HyBadgeKind.tag;
    final strong = isTag ? selected : !subtle;
    final onTone = ThemeData.estimateBrightnessForColor(toneColor) ==
            Brightness.dark
        ? Colors.white
        : Colors.black;
    final foreground = strong ? onTone : toneColor;
    final background = strong
        ? toneColor
        : isTag
        ? glass.surfaceSubtle
        : Color.alphaBlend(toneColor.withAlpha(31), tokens.card);
    final radius = BorderRadius.circular(
      isTag ? HyUiRadii.sm : HyUiRadii.full,
    );
    final pill = Container(
      constraints: isTag ? const BoxConstraints(minHeight: 30) : null,
      padding: EdgeInsets.symmetric(
        horizontal: isTag ? HyUiSpacing.sm : HyUiSpacing.xs,
        vertical: isTag ? 3 : HyUiSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: radius,
        border: isTag ? Border.all(color: selected ? toneColor : tokens.input) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: isTag ? 16 : 13, color: foreground),
            const SizedBox(width: HyUiSpacing.xxs),
          ],
          Text(
            label!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: foreground,
              fontSize: isTag ? 13 : 12,
              fontWeight: selected || !isTag
                  ? FontWeight.w600
                  : FontWeight.w500,
              height: 1.2,
            ),
          ),
          if (onClose != null)
            HyButton.icon(
              icon: LucideIcons.x,
              height: 24,
              iconSize: 14,
              color: foreground,
              tooltip: '移除 $label',
              onPressed: onClose,
              backgroundColor: Colors.transparent,
            ),
        ],
      ),
    );
    if (!isTag) return pill;
    return HyPressable(onPressed: onTap, borderRadius: radius, child: pill);
  }

  Widget _buildCount(BuildContext context) {
    final visible = dot || count > 0 || showZero;
    final tokens = HyUiThemeTokens.of(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child!,
        if (visible)
          Positioned(
            top: -5,
            right: -5,
            child: Container(
              constraints: BoxConstraints(minWidth: dot ? 8 : 16),
              height: dot ? 8 : 16,
              padding: dot
                  ? EdgeInsets.zero
                  : const EdgeInsets.symmetric(horizontal: 4),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: tokens.error,
                borderRadius: BorderRadius.circular(HyUiRadii.full),
                border: Border.all(color: tokens.background, width: 1),
              ),
              child: dot
                  ? null
                  : Text(
                      count > max ? '$max+' : '$count',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        height: 1,
                      ),
                    ),
            ),
          ),
      ],
    );
  }
}
