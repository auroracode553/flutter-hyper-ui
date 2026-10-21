import 'package:flutter/widgets.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// doc-region CalendarDayComponentExample
class CalendarDayComponentExample extends StatefulWidget {
  const CalendarDayComponentExample({super.key});
  @override
  State<CalendarDayComponentExample> createState() =>
      _CalendarDayComponentExampleState();
}

class _CalendarDayComponentExampleState
    extends State<CalendarDayComponentExample> {
  int _selected = 9;
  String _feedback = '点击选择日期，长按查看反馈';
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Row(
        children: [
          for (final day in [7, 8, 9, 10])
            Expanded(
              child: HyperCalendarDay(
                day: day,
                today: day == 8,
                selected: _selected == day,
                enabled: day != 10,
                onPressed: () => setState(() => _selected = day),
              ),
            ),
        ],
      ),
      const SizedBox(height: 16),
      SizedBox(
        width: 100,
        height: 120,
        child: HyperCalendarDay(
          day: 11,
          size: 'large',
          expanded: true,
          subtitle: '辅助说明',
          badge: '待',
          badgeColor: context.hyperUi.warning,
          items: const [
            HyperCalendarItem(label: '预约确认'),
            HyperCalendarItem(label: '资料提交'),
          ],
          itemCount: 4,
          onPressed: () => setState(() => _feedback = '选择 11 日'),
          onLongPressed: () => setState(() => _feedback = '长按 11 日'),
          onItemsPressed: () => setState(() => _feedback = '查看全部 4 个条目'),
        ),
      ),
      const SizedBox(height: 16),
      HyperText(_feedback, size: 'small'),
    ],
  );
}

// end-doc-region CalendarDayComponentExample

// doc-region CalendarMonthComponentExample
class CalendarMonthComponentExample extends StatefulWidget {
  const CalendarMonthComponentExample({super.key});
  @override
  State<CalendarMonthComponentExample> createState() =>
      _CalendarMonthComponentExampleState();
}

class _CalendarMonthComponentExampleState
    extends State<CalendarMonthComponentExample> {
  DateTime _month = DateTime(2026, 10);
  DateTime _selected = DateTime(2026, 10, 21);
  bool _sunday = false, _compact = false, _readOnly = false, _emphasized = true;
  void _move(int offset) =>
      setState(() => _month = DateTime(_month.year, _month.month + offset));
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Row(
        children: [
          HyperButton(
            type: 'icon',
            icon: LucideIcons.chevronLeft,
            onPressed: () => _move(-1),
          ),
          Expanded(
            child: HyperText(
              '${_month.year} 年 ${_month.month} 月',
              textAlign: TextAlign.center,
            ),
          ),
          HyperButton(
            type: 'icon',
            icon: LucideIcons.chevronRight,
            onPressed: () => _move(1),
          ),
        ],
      ),
      const SizedBox(height: 12),
      HyperCalendarMonth(
        month: _month,
        selectedDate: _selected,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100, 12, 31),
        weekStart: _sunday ? 7 : 1,
        size: _compact ? 'small' : 'default',
        readOnly: _readOnly,
        emphasizedDays: _emphasized ? const {1, 2, 3, 4, 5, 6, 7} : const {},
        onChanged: (date) => setState(() => _selected = date),
      ),
      const SizedBox(height: 16),
      HyperText(
        '已选：${_selected.year}-${_selected.month}-${_selected.day}',
        size: 'small',
      ),
      HyperSwitch(
        label: '周日开始',
        value: _sunday,
        onChanged: (value) => setState(() => _sunday = value),
      ),
      HyperSwitch(
        label: '紧凑尺寸',
        value: _compact,
        onChanged: (value) => setState(() => _compact = value),
      ),
      HyperSwitch(
        label: '只读展示',
        value: _readOnly,
        onChanged: (value) => setState(() => _readOnly = value),
      ),
      HyperSwitch(
        label: '强调日期',
        value: _emphasized,
        onChanged: (value) => setState(() => _emphasized = value),
      ),
    ],
  );
}
// end-doc-region CalendarMonthComponentExample
