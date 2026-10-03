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
    return HyperActionSheet.show<T>(
      context,
      title: title,
      builder: (sheetContext) => _PickerContent<T>(
        options: enabled,
        initialIndex: initialIndex.clamp(0, enabled.length - 1),
      ),
    );
  }
}

/// 控制器随弹层内容销毁，返回结果后的关闭动画仍可安全布局滚轮。
class _PickerContent<T> extends StatefulWidget {
  const _PickerContent({required this.options, required this.initialIndex});

  final List<HyperOption<T>> options;
  final int initialIndex;

  @override
  State<_PickerContent<T>> createState() => _PickerContentState<T>();
}

class _PickerContentState<T> extends State<_PickerContent<T>> {
  late int _index = widget.initialIndex;
  late final FixedExtentScrollController _controller =
      FixedExtentScrollController(initialItem: _index);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(
        height: 200,
        child: HyperWheelPicker(
          controller: _controller,
          labels: widget.options.map((option) => option.label).toList(),
          onSelected: (value) => _index = value,
        ),
      ),
      const SizedBox(height: HyperUiSpacing.sm),
      HyperButton(
        label: '确定',
        size: 'large',
        expanded: true,
        onPressed: () => Navigator.pop(context, widget.options[_index].value),
      ),
    ],
  );
}
