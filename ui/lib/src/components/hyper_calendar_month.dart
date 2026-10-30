import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_calendar_day.dart';

/// 无卡片、无导航的受控六行月历；导航与业务数据由宿主组合。
class HyperCalendarMonth extends StatelessWidget {
  const HyperCalendarMonth({
    super.key,
    required this.month,
    this.selectedDate,
    this.endDate,
    this.firstDate,
    this.lastDate,
    this.weekStart = DateTime.monday,

    this.showWeekdays = true,
    this.readOnly = false,
    this.expanded = false,
    this.emphasizedDays = const {},
    this.onChanged,
  }) : assert(weekStart >= 1 && weekStart <= 7);

  final DateTime month;
  final DateTime? selectedDate, endDate, firstDate, lastDate;
  final int weekStart;

  final bool showWeekdays, readOnly, expanded;

  /// 当前月份中使用主题色的日期数字，含义由调用方决定。
  final Set<int> emphasizedDays;
  final ValueChanged<DateTime>? onChanged;

  bool _enabled(DateTime date) =>
      (firstDate == null || !date.isBefore(_day(firstDate!))) &&
      (lastDate == null || !date.isAfter(_day(lastDate!)));

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    final start = DateTime(month.year, month.month);
    final count = DateTime(month.year, month.month + 1, 0).day;
    final offset = (start.weekday - weekStart + 7) % 7;
    final rowHeight = HyperCalendarDay.minimumHeight(
      MediaQuery.textScalerOf(context),
    );
    final today = _day(DateTime.now());
    final selected = selectedDate == null ? null : _day(selectedDate!);
    final end = endDate == null ? null : _day(endDate!);

    final grid = readOnly
        ? RepaintBoundary(
            child: CustomPaint(
              painter: _CalendarMonthPainter(
                month: start,
                offset: offset,
                count: count,
                today: today,
                selected: selected,
                end: end,
                first: firstDate == null ? null : _day(firstDate!),
                last: lastDate == null ? null : _day(lastDate!),
                tokens: tokens,
                textScaler: MediaQuery.textScalerOf(context),
                direction: Directionality.of(context),
                          emphasizedDays: emphasizedDays,
              ),
              child: const SizedBox.expand(),
            ),
          )
        : Column(
            children: [
              for (var row = 0; row < 6; row++)
                Expanded(
                  child: Row(
                    children: [
                      for (var column = 0; column < 7; column++)
                        Expanded(
                          child: Builder(
                            builder: (_) {
                              final day = row * 7 + column - offset + 1;
                              if (day < 1 || day > count)
                                return const SizedBox.shrink();
                              final date = DateTime(
                                start.year,
                                start.month,
                                day,
                              );
                              return HyperCalendarDay(
                                day: day,
                                                          expanded: true,
                                selected: date == selected || date == end,
                                today: date == today,
                                enabled: _enabled(date),
                                emphasized: emphasizedDays.contains(day),
                                inRange:
                                    selected != null &&
                                    end != null &&
                                    date.isAfter(selected) &&
                                    date.isBefore(end),
                                onPressed: onChanged == null
                                    ? null
                                    : () => onChanged!(date),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          );
    return Column(
      mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (showWeekdays) ...[
          Row(
            children: [
              for (var column = 0; column < 7; column++)
                Expanded(
                  child: Center(
                    child: Text(
                      '一二三四五六日'[(weekStart - 1 + column) % 7],
                      style: TextStyle(
                        fontSize: 12,
                        color: tokens.mutedForeground,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        if (expanded)
          Expanded(child: grid)
        else
          SizedBox(height: rowHeight * 6, child: grid),
      ],
    );
  }
}

DateTime _day(DateTime value) => DateTime(value.year, value.month, value.day);

/// 只读月历一次绘制，全年展示不创建数百个点击与动画节点。
class _CalendarMonthPainter extends CustomPainter {
  const _CalendarMonthPainter({
    required this.month,
    required this.offset,
    required this.count,
    required this.today,
    required this.selected,
    required this.end,
    required this.first,
    required this.last,
    required this.tokens,
    required this.textScaler,
    required this.direction,
    required this.emphasizedDays,
  });
  final DateTime month, today;
  final DateTime? selected, end, first, last;
  final int offset, count;
  final HyperUiThemeTokens tokens;
  final TextScaler textScaler;
  final TextDirection direction;

  final Set<int> emphasizedDays;

  @override
  void paint(Canvas canvas, Size bounds) {
    final width = bounds.width / 7;
    final height = bounds.height / 6;
    final diameter = math.max(
      0.0,
      math.min(
        width,
        math.min(
          HyperCalendarDay.minimumHeight(textScaler) - 6,
          height - 6,
        ),
      ),
    );
    final text = TextPainter(textDirection: direction, textScaler: textScaler);
    for (var day = 1; day <= count; day++) {
      final date = DateTime(month.year, month.month, day);
      final index = offset + day - 1;
      final column = direction == TextDirection.rtl ? 6 - index % 7 : index % 7;
      final center = Offset((column + .5) * width, (index ~/ 7 + .5) * height);
      final enabled =
          (first == null || !date.isBefore(first!)) &&
          (last == null || !date.isAfter(last!));
      final active = date == selected || date == end;
      if (selected != null &&
          end != null &&
          date.isAfter(selected!) &&
          date.isBefore(end!)) {
        canvas.drawRect(
          Rect.fromCenter(center: center, width: width, height: height),
          Paint()..color = tokens.selectionBackground,
        );
      }
      if (active) {
        canvas.drawCircle(
          center,
          diameter / 2,
          Paint()..color = tokens.primary,
        );
      } else if (date == today && enabled) {
        canvas.drawCircle(
          center,
          diameter / 2,
          Paint()
            ..color = tokens.primary
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );
      }
      text.text = TextSpan(
        text: '$day',
        style: TextStyle(
          fontSize: 14,
          height: 1.2,
          color: active
              ? tokens.primaryForeground
              : enabled
              ? emphasizedDays.contains(day)
                    ? tokens.primary
                    : tokens.foreground
              : tokens.mutedForeground.withAlpha(105),
          fontWeight: active ? FontWeight.w700 : FontWeight.w500,
        ),
      );
      text.layout(maxWidth: width);
      text.paint(canvas, center - Offset(text.width / 2, text.height / 2));
    }
    text.dispose();
  }

  @override
  bool shouldRepaint(covariant _CalendarMonthPainter old) =>
      month != old.month ||
      offset != old.offset ||
      count != old.count ||
      today != old.today ||
      selected != old.selected ||
      end != old.end ||
      first != old.first ||
      last != old.last ||
      tokens != old.tokens ||
      textScaler != old.textScaler ||
      direction != old.direction ||
      !setEquals(emphasizedDays, old.emphasizedDays);
}
