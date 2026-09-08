import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'hy_bottom_sheet.dart';
import 'hy_button.dart';
import 'hy_select.dart';

abstract final class HyPicker {
  static Future<T?> show<T>(BuildContext context, {required List<HyOption<T>> options,
    int initialIndex = 0, String title = '选择选项'}) async {
    final enabled = options.where((option) => option.enabled).toList();
    if (enabled.isEmpty) return null;
    var index = initialIndex.clamp(0, enabled.length - 1).toInt();
    final controller = FixedExtentScrollController(initialItem: index);
    try {
      return await HyBottomSheet.show<T>(context, title: title, builder: (sheetContext) =>
        Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(height: 220, child: CupertinoPicker(scrollController: controller,
            itemExtent: 44, onSelectedItemChanged: (value) => index = value,
            children: enabled.map((option) => Center(child: Text(option.label))).toList())),
          HyButton(label: '确定', expanded: true,
            onPressed: () => Navigator.pop(sheetContext, enabled[index].value)),
        ]));
    } finally { controller.dispose(); }
  }
}

abstract final class HyDatePicker {
  static Future<DateTime?> date(BuildContext context, {DateTime? initialDate,
    DateTime? firstDate, DateTime? lastDate}) {
    final first = firstDate ?? DateTime(1900);
    final last = lastDate ?? DateTime(2100, 12, 31);
    assert(!last.isBefore(first));
    final initial = initialDate ?? DateTime.now();
    return showDatePicker(context: context, initialDate: initial.isBefore(first) ? first
      : initial.isAfter(last) ? last : initial, firstDate: first, lastDate: last);
  }
  static Future<TimeOfDay?> time(BuildContext context, {TimeOfDay? initialTime}) =>
    showTimePicker(context: context, initialTime: initialTime ?? TimeOfDay.now());
  static Future<DateTimeRange?> range(BuildContext context, {DateTimeRange? initialRange,
    DateTime? firstDate, DateTime? lastDate}) => showDateRangePicker(context: context,
      initialDateRange: initialRange, firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2100, 12, 31));
}
