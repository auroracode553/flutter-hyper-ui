import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_pressable.dart';

/// 日期格的附属条目；仅接收展示数据，不持有业务对象。
@immutable
class HyperCalendarItem {
  const HyperCalendarItem({required this.label, this.color});
  final String label;
  final Color? color;
}

/// 与日期选择器共用圆形选中、今日描边和主题配色的轻量日期格。
class HyperCalendarDay extends StatelessWidget {
  const HyperCalendarDay({
    super.key,
    required this.day,
    this.selected = false,
    this.today = false,
    this.enabled = true,
    this.adjacent = false,
    this.emphasized = false,
    this.inRange = false,
    this.size = 'default',
    this.expanded = false,
    this.subtitle,
    this.subtitleColor,
    this.badge,
    this.badgeColor,
    this.items = const [],
    this.itemCount,
    this.onPressed,
    this.onLongPressed,
    this.onItemsPressed,
  }) : assert(day >= 1 && day <= 31),
       assert(size == 'small' || size == 'default' || size == 'large'),
       assert(itemCount == null || itemCount >= items.length);

  final int day;
  final bool selected, today, enabled, adjacent, emphasized, inRange, expanded;
  final String size;
  final String? subtitle, badge;
  final Color? subtitleColor, badgeColor;
  final List<HyperCalendarItem> items;
  final int? itemCount;
  final VoidCallback? onPressed, onLongPressed, onItemsPressed;

  /// 宿主可复用最小行高，展开和裁剪时无需复制组件内的字号与间距。
  static double minimumHeight(
    TextScaler textScaler, {
    String size = 'default',
    bool hasSubtitle = false,
    int itemRows = 0,
  }) {
    assert(itemRows >= 0 && itemRows <= 3);
    final font = size == 'small'
        ? 10.0
        : size == 'large'
        ? 17.0
        : 14.0;
    final base = size == 'small'
        ? 20.0
        : size == 'large'
        ? 48.0
        : 42.0;
    return math.max(
          base,
          textScaler.scale(font) * 1.2 +
              (hasSubtitle ? textScaler.scale(9) * 1.2 + 2 : 0) +
              (size == 'small' ? 6 : 12),
        ) +
        itemRows * (textScaler.scale(10) * 1.2 + 8);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    final scaler = MediaQuery.textScalerOf(context);
    final baseHeight = minimumHeight(
      scaler,
      size: size,
      hasSubtitle: subtitle != null,
    );
    final foreground = selected
        ? tokens.primaryForeground
        : !enabled || adjacent
        ? tokens.mutedForeground.withAlpha(105)
        : emphasized
        ? tokens.primary
        : tokens.foreground;
    final count = itemCount ?? items.length;
    final font = size == 'small'
        ? 10.0
        : size == 'large'
        ? 17.0
        : 14.0;
    final labelHeight = scaler.scale(10) * 1.2 + 6;

    Widget buildContent(double height) {
      final visible = ((height - baseHeight) / (labelHeight + 2)).floor().clamp(
        0,
        3,
      );
      // 溢出独占最后一个位置，不占用标题行的可读宽度。
      final overflow = visible > 0 && count > math.min(visible, items.length);
      final rows = math.min(overflow ? visible - 1 : visible, items.length);
      final remaining = count - rows;
      final diameter = math.max(0.0, math.min(baseHeight - 6, height - 6));
      final date = SizedBox(
        height: math.min(baseHeight, height),
        child: Center(
          child: Container(
            width: diameter,
            height: diameter,
            decoration: BoxDecoration(
              color: selected ? tokens.primary : null,
              shape: BoxShape.circle,
              border: today && enabled && !selected
                  ? Border.all(color: tokens.primary)
                  : null,
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$day',
                        style: TextStyle(
                          fontSize: font,
                          height: 1.2,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: foreground,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9,
                            height: 1.2,
                            color: selected
                                ? tokens.primaryForeground
                                : !enabled || adjacent
                                ? foreground
                                : subtitleColor ?? tokens.mutedForeground,
                          ),
                        ),
                      if (visible == 0 && count > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: foreground,
                              shape: BoxShape.circle,
                            ),
                            child: const SizedBox.square(dimension: 3),
                          ),
                        ),
                    ],
                  ),
                ),
                if (badge != null)
                  PositionedDirectional(
                    end: -3,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 3,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor ?? tokens.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        badge!,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 8,
                          height: 1,
                          color: tokens.primaryForeground,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
      return ClipRect(
        child: Column(
          children: [
            date,
            if (rows > 0 || overflow)
              HyperPressable(
                onPressed: enabled ? onItemsPressed ?? onPressed : null,
                child: Column(
                  children: [
                    for (var index = 0; index < rows; index++)
                      _CalendarItemLabel(
                        item: items[index],
                        height: labelHeight,
                      ),
                    if (overflow)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: SizedBox(
                          height: labelHeight,
                          child: Center(
                            child: Text(
                              '+$remaining',
                              style: TextStyle(
                                fontSize: 10,
                                height: 1.2,
                                color: tokens.foreground,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      );
    }

    final content = expanded
        ? LayoutBuilder(
            builder: (_, constraints) => buildContent(
              constraints.hasBoundedHeight ? constraints.maxHeight : baseHeight,
            ),
          )
        : SizedBox(height: baseHeight, child: buildContent(baseHeight));
    final surface = ColoredBox(
      color: inRange ? tokens.selectionBackground : const Color(0x00000000),
      child: content,
    );
    if (onPressed == null && onLongPressed == null) return surface;
    return HyperPressable(
      enabled: enabled,
      onPressed: enabled ? onPressed : null,
      onLongPressed: enabled ? onLongPressed : null,
      child: surface,
    );
  }
}

class _CalendarItemLabel extends StatelessWidget {
  const _CalendarItemLabel({required this.item, required this.height});
  final HyperCalendarItem item;
  final double height;

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    final tone = item.color ?? tokens.primary;
    final background = Color.alphaBlend(tone.withAlpha(40), tokens.background);
    final foreground = background.computeLuminance() > .5
        ? Color.lerp(tone, tokens.foreground, .45)!
        : Color.lerp(tone, tokens.foreground, .65)!;
    return Container(
      height: height,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        item.label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 10, height: 1.2, color: foreground),
      ),
    );
  }
}
