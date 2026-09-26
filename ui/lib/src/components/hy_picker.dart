import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/hy_ui_spacing.dart';
import '../theme/hy_ui_theme_tokens.dart';
import 'hy_action_sheet.dart';
import 'hy_button.dart';
import 'hy_select.dart';

abstract final class HyPicker {
  static Future<T?> show<T>(
    BuildContext context, {
    required List<HyOption<T>> options,
    int initialIndex = 0,
    String title = '选择选项',
  }) async {
    final enabled = options.where((option) => option.enabled).toList();
    if (enabled.isEmpty) return null;
    var index = initialIndex.clamp(0, enabled.length - 1).toInt();
    final controller = FixedExtentScrollController(initialItem: index);
    try {
      return await HyActionSheet.show<T>(
        context,
        title: title,
        builder: (sheetContext) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 200,
              child: CupertinoTheme(
                data: CupertinoThemeData(
                  brightness: Theme.of(sheetContext).brightness,
                  textTheme: CupertinoTextThemeData(
                    pickerTextStyle: TextStyle(
                      color: HyUiThemeTokens.of(sheetContext).foreground,
                      fontSize: 17,
                    ),
                  ),
                ),
                child: CupertinoPicker(
                  scrollController: controller,
                  itemExtent: 40,
                  onSelectedItemChanged: (value) => index = value,
                  children: enabled
                      .map((option) => Center(child: Text(option.label)))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: HyUiSpacing.sm),
            HyButton.filled(
              label: '确定',
              height: 44,
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
