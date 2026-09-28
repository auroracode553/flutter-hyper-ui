import 'package:flutter/widgets.dart';

import '../theme/hyper_ui_spacing.dart';
import 'hyper_action_sheet.dart';
import 'hyper_button.dart';
import 'hyper_select.dart';
import 'hyper_wheel_picker.dart';

abstract final class HyperPicker {
  static Future<T?> show<T>(
    BuildContext context, {
    required List<HyperOption<T>> options,
    int initialIndex = 0,
    String title = '选择选项',
  }) async {
    final enabled = options.where((option) => option.enabled).toList();
    if (enabled.isEmpty) return null;
    var index = initialIndex.clamp(0, enabled.length - 1).toInt();
    final controller = FixedExtentScrollController(initialItem: index);
    try {
      return await HyperActionSheet.show<T>(
        context,
        title: title,
        builder: (sheetContext) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 200,
              child: HyperWheelPicker(
                controller: controller,
                labels: enabled.map((option) => option.label).toList(),
                onSelected: (value) => index = value,
              ),
            ),
            const SizedBox(height: HyperUiSpacing.sm),
            HyperButton(
              label: '确定',
              size: 'large',
              expanded: true,
              onPressed: () =>
                  Navigator.pop(sheetContext, enabled[index].value),
            ),
          ],
        ),
      );
    } finally {
      controller.dispose();
    }
  }
}
