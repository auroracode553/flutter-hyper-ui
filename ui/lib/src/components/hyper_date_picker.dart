import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hyper_ui_spacing.dart';
import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_action_sheet.dart';
import 'hyper_button.dart';
import 'hyper_pressable.dart';
import 'hyper_segmented_control.dart';
import 'hyper_wheel_picker.dart';

@immutable
class HyperTimeOfDay {
  const HyperTimeOfDay({required this.hour, required this.minute})
    : assert(hour >= 0 && hour < 24),
      assert(minute >= 0 && minute < 60);

  factory HyperTimeOfDay.now() {
    final now = DateTime.now();
    return HyperTimeOfDay(hour: now.hour, minute: now.minute);
  }

  final int hour;
  final int minute;

  String format() =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}

@immutable
class HyperDateRange {
  const HyperDateRange({required this.start, required this.end});

  final DateTime start;
  final DateTime end;
}

/// 日期与区间使用月历，时间使用滚轮，弹层共用 HyperActionSheet。
abstract final class HyperDatePicker {
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
    return HyperActionSheet.show<DateTime>(
      context,
      title: '选择日期',
      builder: (_) => _DatePanel(initial: initial, first: first, last: last),
    );
  }

  static Future<HyperTimeOfDay?> time(
    BuildContext context, {
    HyperTimeOfDay? initialTime,
  }) => HyperActionSheet.show<HyperTimeOfDay>(
    context,
    title: '选择时间',
    builder: (_) => _TimePanel(initial: initialTime ?? HyperTimeOfDay.now()),
  );

  static Future<HyperDateRange?> range(
    BuildContext context, {
    HyperDateRange? initialRange,
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
    return HyperActionSheet.show<HyperDateRange>(
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
      const SizedBox(height: HyperUiSpacing.sm),
      HyperButton(
        label: '确定',
        size: 'large',
        expanded: true,
        onPressed: () => Navigator.pop(context, _selected),
      ),
    ],
  );
}

class _TimePanel extends StatefulWidget {
  const _TimePanel({required this.initial});

  final HyperTimeOfDay initial;

  @override
  State<_TimePanel> createState() => _TimePanelState();
}

class _TimePanelState extends State<_TimePanel> {
  late int _hour = widget.initial.hour;
  late int _minute = widget.initial.minute;
  late final FixedExtentScrollController _hourController =
      FixedExtentScrollController(initialItem: _hour);
  late final FixedExtentScrollController _minuteController =
      FixedExtentScrollController(initialItem: _minute);

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(
        height: 216,
        child: Row(
          children: <Widget>[
            Expanded(
              child: HyperWheelPicker(
                controller: _hourController,
                labels: List<String>.generate(
                  24,
                  (value) => value.toString().padLeft(2, '0'),
                ),
                onSelected: (value) => _hour = value,
              ),
            ),
            const Text(' : '),
            Expanded(
              child: HyperWheelPicker(
                controller: _minuteController,
                labels: List<String>.generate(
                  60,
                  (value) => value.toString().padLeft(2, '0'),
                ),
                onSelected: (value) => _minute = value,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: HyperUiSpacing.sm),
      HyperButton(
        label: '确定',
        size: 'large',
        expanded: true,
        onPressed: () => Navigator.pop(
          context,
          HyperTimeOfDay(hour: _hour, minute: _minute),
        ),
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
      HyperSegmentedControl<bool>(
        options: const [
          HyperSegmentOption(value: true, label: '开始日期'),
          HyperSegmentOption(value: false, label: '结束日期'),
        ],
        selectedValue: _editingStart,
        onChanged: (value) => setState(() => _editingStart = value),
      ),
      const SizedBox(height: HyperUiSpacing.xs),
      Text(
        '${_formatDate(_start)} — ${_formatDate(_end)}',
        style: TextStyle(
          color: HyperUiThemeTokens.of(context).mutedForeground,
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
      const SizedBox(height: HyperUiSpacing.sm),
      HyperButton(
        label: '确定',
        size: 'large',
        expanded: true,
        onPressed: () =>
            Navigator.pop(context, HyperDateRange(start: _start, end: _end)),
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
    return !lastDay.isBefore(widget.first) && !firstDay.isAfter(widget.last);
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
    final tokens = HyperUiThemeTokens.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            HyperButton.icon(
              icon: LucideIcons.chevronLeft,
              tooltip: '上个月',
              size: 'small',
              onPressed:
                  _monthAvailable(
                    DateTime(_visibleMonth.year, _visibleMonth.month - 1),
                  )
                  ? () => _changeMonth(-1)
                  : null,
            ),
            Expanded(
              child: HyperButton.ghost(
                label: '${_visibleMonth.year} 年 ${_visibleMonth.month} 月',
                trailingIcon: LucideIcons.chevronDown,
                expanded: true,
                onPressed: () =>
                    setState(() => _choosingMonth = !_choosingMonth),
              ),
            ),
            HyperButton.icon(
              icon: LucideIcons.chevronRight,
              tooltip: '下个月',
              size: 'small',
              onPressed:
                  _monthAvailable(
                    DateTime(_visibleMonth.year, _visibleMonth.month + 1),
                  )
                  ? () => _changeMonth(1)
                  : null,
            ),
          ],
        ),
        const SizedBox(height: HyperUiSpacing.sm),
        if (_choosingMonth) _buildMonthChooser(tokens) else _buildDays(tokens),
      ],
    );
  }

  Widget _buildMonthChooser(HyperUiThemeTokens tokens) {
    final year = _visibleMonth.year;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HyperButton.ghost(
              label: '−10 年',
              size: 'small',
              onPressed: year - 10 >= widget.first.year
                  ? () => _changeYear(-10)
                  : null,
            ),
            HyperButton.icon(
              icon: LucideIcons.chevronLeft,
              tooltip: '上一年',
              size: 'small',
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
            HyperButton.icon(
              icon: LucideIcons.chevronRight,
              tooltip: '下一年',
              size: 'small',
              onPressed: year < widget.last.year ? () => _changeYear(1) : null,
            ),
            HyperButton.ghost(
              label: '+10 年',
              size: 'small',
              onPressed: year + 10 <= widget.last.year
                  ? () => _changeYear(10)
                  : null,
            ),
          ],
        ),
        const SizedBox(height: HyperUiSpacing.sm),
        for (var row = 0; row < 4; row++) ...[
          Row(
            children: [
              for (var column = 0; column < 3; column++) ...[
                if (column > 0) const SizedBox(width: HyperUiSpacing.xs),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final month = row * 3 + column + 1;
                      final target = DateTime(year, month);
                      void selectMonth() => setState(() {
                        _visibleMonth = target;
                        _choosingMonth = false;
                      });
                      final onPressed = _monthAvailable(target)
                          ? selectMonth
                          : null;
                      return month == _visibleMonth.month
                          ? HyperButton(
                              label: '$month 月',
                              size: 'large',
                              expanded: true,
                              onPressed: onPressed,
                            )
                          : HyperButton.tonal(
                              label: '$month 月',
                              size: 'large',
                              expanded: true,
                              onPressed: onPressed,
                            );
                    },
                  ),
                ),
              ],
            ],
          ),
          if (row < 3) const SizedBox(height: HyperUiSpacing.xs),
        ],
      ],
    );
  }

  Widget _buildDays(HyperUiThemeTokens tokens) {
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
        const SizedBox(height: HyperUiSpacing.xs),
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
    HyperUiThemeTokens tokens,
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
    final between =
        widget.end != null &&
        date.isAfter(widget.start) &&
        date.isBefore(widget.end!);
    final isToday = date == today;

    return Expanded(
      child: HyperPressable(
        onPressed: enabled ? () => widget.onSelected(date) : null,
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
    );
  }
}
