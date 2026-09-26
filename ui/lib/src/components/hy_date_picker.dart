import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/hy_ui_spacing.dart';
import '../theme/hy_ui_theme_tokens.dart';
import 'hy_action_sheet.dart';
import 'hy_button.dart';
import 'hy_segmented_control.dart';

/// 日期、时间与区间统一使用 HyActionSheet 的玻璃弹层。
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
      SizedBox(
        height: 216,
        child: _pickerTheme(
          context,
          CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: widget.initial,
            minimumDate: widget.first,
            maximumDate: widget.last,
            onDateTimeChanged: (date) => _selected = _dateOnly(date),
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
      SizedBox(
        height: 216,
        child: _pickerTheme(
          context,
          CupertinoDatePicker(
            key: ValueKey(_editingStart),
            mode: CupertinoDatePickerMode.date,
            initialDateTime: _editingStart ? _start : _end,
            minimumDate: _editingStart ? widget.first : _start,
            maximumDate: widget.last,
            onDateTimeChanged: (date) {
              final selected = _dateOnly(date);
              setState(() {
                if (_editingStart) {
                  _start = selected;
                  if (_end.isBefore(_start)) _end = _start;
                } else {
                  _end = selected;
                }
              });
            },
          ),
        ),
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
