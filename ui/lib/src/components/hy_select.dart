import 'package:flutter/material.dart';
import 'hy_bottom_sheet.dart';
import 'hy_button.dart';
import 'hy_glass.dart';

class HyOption<T> {
  const HyOption({required this.value, required this.label, this.enabled = true});
  final T value;
  final String label;
  final bool enabled;
}

class HySelect<T> extends StatelessWidget {
  const HySelect({super.key, required this.options, required this.values,
    this.onChanged, this.multiple = false, this.placeholder = '请选择', this.label});
  final List<HyOption<T>> options;
  final List<T> values;
  final ValueChanged<List<T>>? onChanged;
  final bool multiple;
  final String placeholder;
  final String? label;

  Future<void> _open(BuildContext context) async {
    final result = await HyBottomSheet.show<List<T>>(context, title: label ?? placeholder,
      builder: (_) => _HySelectionPanel<T>(options: options, values: values, multiple: multiple));
    if (result != null) onChanged?.call(result);
  }
  @override
  Widget build(BuildContext context) {
    final labels = options.where((option) => values.contains(option.value)).map((option) => option.label);
    return HyGlass(radius: 16, blur: 0, child: ListTile(
      enabled: onChanged != null, title: Text(labels.isEmpty ? placeholder : labels.join('、')),
      subtitle: label == null ? null : Text(label!),
      trailing: const Icon(Icons.unfold_more_rounded),
      onTap: onChanged == null ? null : () => _open(context)));
  }
}

class _HySelectionPanel<T> extends StatefulWidget {
  const _HySelectionPanel({required this.options, required this.values, required this.multiple});
  final List<HyOption<T>> options;
  final List<T> values;
  final bool multiple;
  @override
  State<_HySelectionPanel<T>> createState() => _HySelectionPanelState<T>();
}

class _HySelectionPanelState<T> extends State<_HySelectionPanel<T>> {
  late final List<T> selected = List.of(widget.values);
  @override
  Widget build(BuildContext context) => Column(mainAxisSize: MainAxisSize.min, children: [
    for (final option in widget.options) CheckboxListTile(
      title: Text(option.label), value: selected.contains(option.value),
      onChanged: !option.enabled ? null : (checked) {
        if (!widget.multiple) { Navigator.pop(context, <T>[option.value]); return; }
        setState(() { if (checked == true) { selected.add(option.value); }
          else { selected.remove(option.value); } });
      }),
    if (widget.options.isEmpty) const Padding(padding: EdgeInsets.all(24), child: Text('暂无选项')),
    if (widget.multiple) HyButton(label: '确定', expanded: true,
      onPressed: () => Navigator.pop(context, List<T>.of(selected))),
  ]);
}
