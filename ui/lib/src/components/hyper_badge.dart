import 'package:flutter_hyper_ui/src/theme/hyper_palette.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hyper_glass_theme.dart';
import '../theme/hyper_ui_radii.dart';
import '../theme/hyper_ui_spacing.dart';
import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_pressable.dart';
import 'hyper_tone.dart';
import 'hyper_tooltip.dart';

/// 状态、可交互标签与角标共用的语义徽标。
class HyperBadge extends StatelessWidget {
  const HyperBadge({
    super.key,
    this.type = 'status',
    this.label,
    this.tone = HyperUiTone.neutral,
    this.color,
    this.icon,
    this.subtle = true,
    this.selected = false,
    this.onTap,
    this.onClose,
    this.child,
    this.count = 0,
    this.max = 99,
    this.dot = false,
    this.showZero = false,
  }) : assert(type == 'status' || type == 'tag' || type == 'count'),
       assert(type == 'count' ? child != null : label != null),
       assert(type != 'count' || label == null),
       assert(type == 'count' || child == null),
       assert(type == 'tag' || (onTap == null && onClose == null && !selected)),
       assert(max > 0);

  final String type;
  final String? label;
  final HyperUiTone tone;
  final Color? color;
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

  @override
  Widget build(BuildContext context) {
    if (type != 'status' && type != 'tag' && type != 'count') {
      throw ArgumentError.value(type, 'type', 'Invalid badge type');
    }
    if (type == 'count' ? child == null : label == null) {
      throw ArgumentError(
        'HyperBadge requires child for count or label otherwise.',
      );
    }
    if (type != 'count' && child != null) {
      throw ArgumentError('HyperBadge.child only applies to count.');
    }
    if (type != 'tag' && (onTap != null || onClose != null || selected)) {
      throw ArgumentError('HyperBadge interactions only apply to tag.');
    }
    if (type == 'count') return _buildCount(context);
    final tokens = HyperUiThemeTokens.of(context);
    final glass = HyperGlassTheme.of(context);
    final toneColor = color ?? tone.color(tokens);
    final isTag = type == 'tag';
    final strong = isTag ? selected : !subtle;
    final onTone = toneColor.computeLuminance() < 0.5
        ? HyperPalette.white
        : HyperPalette.black;
    final foreground = strong ? onTone : toneColor;
    final background = strong
        ? toneColor
        : isTag
        ? glass.surfaceSubtle
        : Color.alphaBlend(toneColor.withAlpha(31), tokens.card);
    final radius = BorderRadius.circular(
      isTag ? HyperUiRadii.sm : HyperUiRadii.full,
    );
    final pill = Container(
      constraints: isTag ? const BoxConstraints(minHeight: 30) : null,
      padding: EdgeInsets.symmetric(
        horizontal: isTag ? HyperUiSpacing.sm : HyperUiSpacing.xs,
        vertical: isTag ? 3 : HyperUiSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: radius,
        border: isTag
            ? Border.all(color: selected ? toneColor : tokens.input)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: isTag ? 16 : 13, color: foreground),
            const SizedBox(width: HyperUiSpacing.xxs),
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
            HyperTooltip(
              message: '移除 $label',
              child: HyperPressable(
                onPressed: onClose,
                borderRadius: BorderRadius.circular(HyperUiRadii.full),
                child: SizedBox.square(
                  dimension: 20,
                  child: Icon(LucideIcons.x, size: 14, color: foreground),
                ),
              ),
            ),
        ],
      ),
    );
    if (!isTag) return pill;
    return HyperPressable(onPressed: onTap, borderRadius: radius, child: pill);
  }

  Widget _buildCount(BuildContext context) {
    final visible = dot || count > 0 || showZero;
    final tokens = HyperUiThemeTokens.of(context);
    final badgeColor =
        color ??
        (tone == HyperUiTone.neutral ? tokens.error : tone.color(tokens));
    final countColor = badgeColor.computeLuminance() < 0.5
        ? HyperPalette.white
        : HyperPalette.black;
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
                color: badgeColor,
                borderRadius: BorderRadius.circular(HyperUiRadii.full),
                border: Border.all(color: tokens.background, width: 1),
              ),
              child: dot
                  ? null
                  : Text(
                      count > max ? '$max+' : '$count',
                      style: TextStyle(
                        color: countColor,
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
