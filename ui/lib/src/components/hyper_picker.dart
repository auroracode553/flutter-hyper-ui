import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/hyper_ui_spacing.dart';
import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_action_sheet.dart';
import 'hyper_button.dart';
import 'hyper_select.dart';

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
              child: CupertinoTheme(
                data: CupertinoThemeData(
                  brightness: Theme.of(sheetContext).brightness,
                  textTheme: CupertinoTextThemeData(
                    pickerTextStyle: TextStyle(
                      color: HyperUiThemeTokens.of(sheetContext).foreground,
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
            const SizedBox(height: HyperUiSpacing.sm),
            HyperButton.filled(
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
