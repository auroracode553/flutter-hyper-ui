import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hy_ui_spacing.dart';
import '../theme/hy_ui_theme_tokens.dart';
import 'hy_action_sheet.dart';
import 'hy_button.dart';
import 'hy_pressable.dart';
import 'hy_segmented_control.dart';

/// 日期与区间使用月历，时间使用滚轮，弹层共用 HyActionSheet。
abstract final class HyDatePicker {
  static Future<DateTime?> date(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    final first = _dateOnly(firstDate ?? DateTime(1900));
    final last = _dateOnly(lastDate ?? DateTime(2100, 12, 31));
    assert(!last.isBefore(first));
    final initial = _clampDate(initialDate ?? DateTime.now(), first, last);
    return HyActionSheet.show<DateTime>(
      context,
      title: '选择日期',
      builder: (_) => _DatePanel(initial: initial, first: first, last: last),
    );
  }

  static Future<TimeOfDay?> time(
    BuildContext context, {
    TimeOfDay? initialTime,
  }) => HyActionSheet.show<TimeOfDay>(
    context,
    title: '选择时间',
    builder: (_) => _TimePanel(initial: initialTime ?? TimeOfDay.now()),
  );

  static Future<DateTimeRange?> range(
    BuildContext context, {
    DateTimeRange? initialRange,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    final first = _dateOnly(firstDate ?? DateTime(1900));
    final last = _dateOnly(lastDate ?? DateTime(2100, 12, 31));
    assert(!last.isBefore(first));
    final start = _clampDate(
      initialRange?.start ?? DateTime.now(),
      first,
      last,
    );
    final end = _clampDate(initialRange?.end ?? start, start, last);
    return HyActionSheet.show<DateTimeRange>(
      context,
      title: '选择日期区间',
      builder: (_) => _DateRangePanel(
        initialStart: start,
        initialEnd: end,
        first: first,
        last: last,
      ),
    );
  }
}

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

DateTime _clampDate(DateTime date, DateTime first, DateTime last) {
  final day = _dateOnly(date);
  if (day.isBefore(first)) return first;
  if (day.isAfter(last)) return last;
  return day;
}

String _formatDate(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

Widget _pickerTheme(BuildContext context, Widget child) {
  final tokens = HyUiThemeTokens.of(context);
  return CupertinoTheme(
    data: CupertinoThemeData(
      brightness: Theme.of(context).brightness,
      primaryColor: tokens.primary,
      textTheme: CupertinoTextThemeData(
        dateTimePickerTextStyle: TextStyle(
          color: tokens.foreground,
          fontSize: 18,
        ),
      ),
    ),
    child: child,
  );
}

class _DatePanel extends StatefulWidget {
  const _DatePanel({
    required this.initial,
    required this.first,
    required this.last,
  });

  final DateTime initial;
  final DateTime first;
  final DateTime last;

  @override
  State<_DatePanel> createState() => _DatePanelState();
}

class _DatePanelState extends State<_DatePanel> {
  late DateTime _selected = widget.initial;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      _CalendarMonth(
        initialMonth: widget.initial,
        first: widget.first,
        last: widget.last,
        start: _selected,
        onSelected: (date) => setState(() => _selected = date),
      ),
      const SizedBox(height: HyUiSpacing.sm),
      HyButton.filled(
        label: '确定',
        height: 44,
        expanded: true,
        onPressed: () => Navigator.pop(context, _selected),
      ),
    ],
  );
}

class _TimePanel extends StatefulWidget {
  const _TimePanel({required this.initial});

  final TimeOfDay initial;

  @override
  State<_TimePanel> createState() => _TimePanelState();
}

class _TimePanelState extends State<_TimePanel> {
  late TimeOfDay _selected = widget.initial;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(
        height: 216,
        child: _pickerTheme(
          context,
          CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            use24hFormat: true,
            initialDateTime: DateTime(
              2020,
              1,
              1,
              widget.initial.hour,
              widget.initial.minute,
            ),
            onDateTimeChanged: (date) =>
                _selected = TimeOfDay(hour: date.hour, minute: date.minute),
          ),
        ),
      ),
      const SizedBox(height: HyUiSpacing.sm),
      HyButton.filled(
        label: '确定',
        height: 44,
        expanded: true,
        onPressed: () => Navigator.pop(context, _selected),
      ),
    ],
  );
}

class _DateRangePanel extends StatefulWidget {
  const _DateRangePanel({
    required this.initialStart,
    required this.initialEnd,
    required this.first,
    required this.last,
  });

  final DateTime initialStart;
  final DateTime initialEnd;
  final DateTime first;
  final DateTime last;

  @override
  State<_DateRangePanel> createState() => _DateRangePanelState();
}

class _DateRangePanelState extends State<_DateRangePanel> {
  late DateTime _start = widget.initialStart;
  late DateTime _end = widget.initialEnd;
  bool _editingStart = true;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      HySegmentedControl<bool>(
        options: const [
          HySegmentOption(value: true, label: '开始日期'),
          HySegmentOption(value: false, label: '结束日期'),
        ],
        selectedValue: _editingStart,
        onChanged: (value) => setState(() => _editingStart = value),
      ),
      const SizedBox(height: HyUiSpacing.xs),
      Text(
        '${_formatDate(_start)} — ${_formatDate(_end)}',
        style: TextStyle(
          color: HyUiThemeTokens.of(context).mutedForeground,
          fontSize: 12,
        ),
      ),
      _CalendarMonth(
        key: ValueKey(_editingStart),
        initialMonth: _editingStart ? _start : _end,
        first: widget.first,
        last: widget.last,
        start: _start,
        end: _end,
        onSelected: (selected) {
          setState(() {
            if (_editingStart) {
              _start = selected;
              if (_end.isBefore(_start)) _end = _start;
              _editingStart = false;
            } else if (selected.isBefore(_start)) {
              _start = selected;
              _end = selected;
            } else {
              _end = selected;
            }
          });
        },
      ),
      const SizedBox(height: HyUiSpacing.sm),
      HyButton.filled(
        label: '确定',
        height: 44,
        expanded: true,
        onPressed: () => Navigator.pop(
          context,
          DateTimeRange(start: _start, end: _end),
        ),
      ),
    ],
  );
}

/// 日期与区间共用的月历；选择状态由外层持有，翻月状态留在月历内部。
class _CalendarMonth extends StatefulWidget {
  const _CalendarMonth({
    super.key,
    required this.initialMonth,
    required this.first,
    required this.last,
    required this.start,
    required this.onSelected,
    this.end,
  });

  final DateTime initialMonth;
  final DateTime first;
  final DateTime last;
  final DateTime start;
  final DateTime? end;
  final ValueChanged<DateTime> onSelected;

  @override
  State<_CalendarMonth> createState() => _CalendarMonthState();
}

class _CalendarMonthState extends State<_CalendarMonth> {
  late DateTime _visibleMonth = DateTime(
    widget.initialMonth.year,
    widget.initialMonth.month,
  );
  bool _choosingMonth = false;

  bool _monthAvailable(DateTime month) {
    final firstDay = DateTime(month.year, month.month);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    return !lastDay.isBefore(widget.first) &&
        !firstDay.isAfter(widget.last);
  }

  void _changeMonth(int offset) {
    final next = DateTime(_visibleMonth.year, _visibleMonth.month + offset);
    if (_monthAvailable(next)) setState(() => _visibleMonth = next);
  }

  void _changeYear(int offset) {
    final year = _visibleMonth.year + offset;
    if (year < widget.first.year || year > widget.last.year) return;
    var month = _visibleMonth.month;
    if (year == widget.first.year && month < widget.first.month) {
      month = widget.first.month;
    }
    if (year == widget.last.year && month > widget.last.month) {
      month = widget.last.month;
    }
    setState(() => _visibleMonth = DateTime(year, month));
  }

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            HyButton.icon(
              icon: LucideIcons.chevronLeft,
              tooltip: '上个月',
              height: 34,
              radius: 12,
              onPressed: _monthAvailable(
                DateTime(_visibleMonth.year, _visibleMonth.month - 1),
              )
                  ? () => _changeMonth(-1)
                  : null,
            ),
            Expanded(
              child: HyButton.ghost(
                label: '${_visibleMonth.year} 年 ${_visibleMonth.month} 月',
                trailingIcon: LucideIcons.chevronDown,
                height: 38,
                expanded: true,
                onPressed: () => setState(
                  () => _choosingMonth = !_choosingMonth,
                ),
              ),
            ),
            HyButton.icon(
              icon: LucideIcons.chevronRight,
              tooltip: '下个月',
              height: 34,
              radius: 12,
              onPressed: _monthAvailable(
                DateTime(_visibleMonth.year, _visibleMonth.month + 1),
              )
                  ? () => _changeMonth(1)
                  : null,
            ),
          ],
        ),
        const SizedBox(height: HyUiSpacing.sm),
        if (_choosingMonth)
          _buildMonthChooser(tokens)
        else
          _buildDays(tokens),
      ],
    );
  }

  Widget _buildMonthChooser(HyUiThemeTokens tokens) {
    final year = _visibleMonth.year;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HyButton.ghost(
              label: '−10 年',
              height: 34,
              onPressed: year - 10 >= widget.first.year
                  ? () => _changeYear(-10)
                  : null,
            ),
            HyButton.icon(
              icon: LucideIcons.chevronLeft,
              tooltip: '上一年',
              height: 34,
              onPressed: year > widget.first.year
                  ? () => _changeYear(-1)
                  : null,
            ),
            Text(
              '$year 年',
              style: TextStyle(
                color: tokens.foreground,
                fontWeight: FontWeight.w700,
              ),
            ),
            HyButton.icon(
              icon: LucideIcons.chevronRight,
              tooltip: '下一年',
              height: 34,
              onPressed: year < widget.last.year
                  ? () => _changeYear(1)
                  : null,
            ),
            HyButton.ghost(
              label: '+10 年',
              height: 34,
              onPressed: year + 10 <= widget.last.year
                  ? () => _changeYear(10)
                  : null,
            ),
          ],
        ),
        const SizedBox(height: HyUiSpacing.sm),
        for (var row = 0; row < 4; row++) ...[
          Row(
            children: [
              for (var column = 0; column < 3; column++) ...[
                if (column > 0) const SizedBox(width: HyUiSpacing.xs),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final month = row * 3 + column + 1;
                      final target = DateTime(year, month);
                      return HyButton(
                        label: '$month 月',
                        variant: month == _visibleMonth.month
                            ? HyButtonVariant.filled
                            : HyButtonVariant.tonal,
                        height: 42,
                        expanded: true,
                        onPressed: _monthAvailable(target)
                            ? () => setState(() {
                                _visibleMonth = target;
                                _choosingMonth = false;
                              })
                            : null,
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
          if (row < 3) const SizedBox(height: HyUiSpacing.xs),
        ],
      ],
    );
  }

  Widget _buildDays(HyUiThemeTokens tokens) {
    final year = _visibleMonth.year;
    final month = _visibleMonth.month;
    final firstWeekday = DateTime(year, month).weekday - 1;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final today = _dateOnly(DateTime.now());
    const weekdays = ['一', '二', '三', '四', '五', '六', '日'];

    return Column(
      children: [
        Row(
          children: [
            for (final weekday in weekdays)
              Expanded(
                child: Center(
                  child: Text(
                    weekday,
                    style: TextStyle(
                      color: tokens.mutedForeground,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: HyUiSpacing.xs),
        for (var row = 0; row < 6; row++)
          Row(
            children: [
              for (var column = 0; column < 7; column++)
                _buildDayCell(
                  tokens,
                  row * 7 + column - firstWeekday + 1,
                  daysInMonth,
                  today,
                ),
            ],
          ),
      ],
    );
  }

  Widget _buildDayCell(
    HyUiThemeTokens tokens,
    int day,
    int daysInMonth,
    DateTime today,
  ) {
    if (day < 1 || day > daysInMonth) {
      return const Expanded(child: SizedBox(height: 42));
    }
    final date = DateTime(_visibleMonth.year, _visibleMonth.month, day);
    final enabled = !date.isBefore(widget.first) && !date.isAfter(widget.last);
    final isStart = date == widget.start;
    final isEnd = widget.end != null && date == widget.end;
    final selected = isStart || isEnd;
    final between = widget.end != null &&
        date.isAfter(widget.start) &&
        date.isBefore(widget.end!);
    final isToday = date == today;

    return Expanded(
      child: Semantics(
        selected: selected,
        child: HyPressable(
          onPressed: enabled ? () => widget.onSelected(date) : null,
          semanticLabel: _formatDate(date),
          borderRadius: BorderRadius.circular(21),
          child: Container(
            height: 42,
            alignment: Alignment.center,
            color: between ? tokens.selectionBackground : null,
            child: Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? tokens.primary : null,
                shape: BoxShape.circle,
                border: isToday && enabled && !selected
                    ? Border.all(color: tokens.primary)
                    : null,
              ),
              child: Text(
                '$day',
                style: TextStyle(
                  color: selected
                      ? tokens.primaryForeground
                      : enabled
                          ? tokens.foreground
                          : tokens.mutedForeground.withAlpha(105),
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
