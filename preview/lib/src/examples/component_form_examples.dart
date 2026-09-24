import 'package:flutter/material.dart';
import 'package:flutter_hyper_ui/hy_ui.dart';

// doc-region TextFieldComponentExample
class TextFieldComponentExample extends StatelessWidget {
  const TextFieldComponentExample({super.key});

  // 字段标题写在输入框外部：输入组件本身不携带标题与说明。
  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyUiSpacing.xs),
    child: HyText(text, variant: HyTextStyle.caption),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('基础输入'),
        const HyTextField(hintText: '请输入内容'),
        const SizedBox(height: HyUiSpacing.lg),

        _label('可清空'),
        const HyTextField(
          clearable: true,
          initialValue: '示例内容',
          hintText: '输入后右侧显示清空按钮',
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('密码显隐'),
        const HyTextField(
          obscureText: true,
          showPasswordToggle: true,
          hintText: '请输入密码',
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('前缀与后缀插槽'),
        const HyTextField(
          hintText: '搜索组件',
          prefix: Icon(Icons.search_rounded),
          suffix: Icon(Icons.tune_rounded),
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('多行输入'),
        const HyTextField(maxLines: 3, hintText: '请输入多行内容'),
        const SizedBox(height: HyUiSpacing.lg),

        _label('字数统计'),
        const HyTextField(
          maxLength: 50,
          showCounter: true,
          hintText: '最多输入 50 个字符',
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('禁用与只读'),
        const HyTextField(enabled: false, initialValue: '禁用状态'),
        const SizedBox(height: HyUiSpacing.sm),
        const HyTextField(readOnly: true, initialValue: '只读状态'),
        const SizedBox(height: HyUiSpacing.lg),

        _label('错误态'),
        const HyTextField(
          initialValue: '错误内容',
          errorText: '内容格式不正确',
        ),
      ],
    );
  }
}
// end-doc-region TextFieldComponentExample

// doc-region SegmentedControlComponentExample
class SegmentedControlComponentExample extends StatefulWidget {
  const SegmentedControlComponentExample({super.key});

  @override
  State<SegmentedControlComponentExample> createState() =>
      _SegmentedControlComponentExampleState();
}

class _SegmentedControlComponentExampleState
    extends State<SegmentedControlComponentExample> {
  String _value = 'day';

  @override
  Widget build(BuildContext context) {
    return HySegmentedControl<String>(
      selectedValue: _value,
      onChanged: (value) => setState(() => _value = value),
      options: const [
        HySegmentOption(value: 'day', label: '日'),
        HySegmentOption(value: 'week', label: '周'),
        HySegmentOption(value: 'month', label: '月'),
      ],
    );
  }
}
// end-doc-region SegmentedControlComponentExample

// doc-region DropdownComponentExample
class DropdownComponentExample extends StatefulWidget {
  const DropdownComponentExample({super.key});

  @override
  State<DropdownComponentExample> createState() =>
      _DropdownComponentExampleState();
}

class _DropdownComponentExampleState extends State<DropdownComponentExample> {
  String? _value = 'recent';

  @override
  Widget build(BuildContext context) {
    return HyDropdown<String>(
      label: '排序方式',
      value: _value,
      onChanged: (value) => setState(() => _value = value),
      options: const [
        HyOption(value: 'recent', label: '最近更新'),
        HyOption(value: 'name', label: '按名称'),
        HyOption(value: 'created', label: '创建时间'),
      ],
    );
  }
}
// end-doc-region DropdownComponentExample

// doc-region CheckboxComponentExample
class CheckboxComponentExample extends StatefulWidget {
  const CheckboxComponentExample({super.key});

  @override
  State<CheckboxComponentExample> createState() =>
      _CheckboxComponentExampleState();
}

class _CheckboxComponentExampleState extends State<CheckboxComponentExample> {
  bool? _value = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HyCheckbox(
          value: _value,
          label: '同步到所有设备',
          onChanged: (value) => setState(() => _value = value),
        ),
        const HyCheckbox(value: false, label: '禁用状态'),
      ],
    );
  }
}
// end-doc-region CheckboxComponentExample

// doc-region RadioComponentExample
class RadioComponentExample extends StatefulWidget {
  const RadioComponentExample({super.key});

  @override
  State<RadioComponentExample> createState() => _RadioComponentExampleState();
}

class _RadioComponentExampleState extends State<RadioComponentExample> {
  String _value = 'system';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final option in const ['system', 'light', 'dark'])
          HyRadio<String>(
            value: option,
            groupValue: _value,
            label: const {
              'system': '跟随系统',
              'light': '浅色',
              'dark': '深色',
            }[option]!,
            onChanged: (value) => setState(() => _value = value),
          ),
      ],
    );
  }
}
// end-doc-region RadioComponentExample

// doc-region SwitchComponentExample
class SwitchComponentExample extends StatefulWidget {
  const SwitchComponentExample({super.key});

  @override
  State<SwitchComponentExample> createState() => _SwitchComponentExampleState();
}

class _SwitchComponentExampleState extends State<SwitchComponentExample> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HySwitch(
          value: _enabled,
          label: '接收消息通知',
          onChanged: (value) => setState(() => _enabled = value),
        ),
        const HySwitch(value: false, label: '禁用状态'),
      ],
    );
  }
}
// end-doc-region SwitchComponentExample

// doc-region SliderComponentExample
class SliderComponentExample extends StatefulWidget {
  const SliderComponentExample({super.key});

  @override
  State<SliderComponentExample> createState() => _SliderComponentExampleState();
}

class _SliderComponentExampleState extends State<SliderComponentExample> {
  double _value = 42;

  @override
  Widget build(BuildContext context) {
    return HySlider(
      value: _value,
      divisions: 10,
      onChanged: (value) => setState(() => _value = value),
    );
  }
}
// end-doc-region SliderComponentExample

// doc-region SelectComponentExample
class SelectComponentExample extends StatefulWidget {
  const SelectComponentExample({super.key});

  @override
  State<SelectComponentExample> createState() => _SelectComponentExampleState();
}

class _SelectComponentExampleState extends State<SelectComponentExample> {
  List<String> _values = const ['design'];

  @override
  Widget build(BuildContext context) => HySelect<String>(
    label: '选择协作角色',
    multiple: true,
    values: _values,
    onChanged: (values) => setState(() => _values = values),
    options: const [
      HyOption(value: 'design', label: '设计'),
      HyOption(value: 'develop', label: '开发'),
      HyOption(value: 'test', label: '测试'),
      HyOption(value: 'archive', label: '已归档', enabled: false),
    ],
  );
}
// end-doc-region SelectComponentExample

// doc-region RateComponentExample
class RateComponentExample extends StatefulWidget {
  const RateComponentExample({super.key});

  @override
  State<RateComponentExample> createState() => _RateComponentExampleState();
}

class _RateComponentExampleState extends State<RateComponentExample> {
  double _value = 4;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      HyRate(value: _value, onChanged: (value) => setState(() => _value = value)),
      const SizedBox(width: 12),
      Text('${_value.toInt()} / 5'),
    ],
  );
}
// end-doc-region RateComponentExample

// doc-region PickerComponentExample
class PickerComponentExample extends StatefulWidget {
  const PickerComponentExample({super.key});

  @override
  State<PickerComponentExample> createState() => _PickerComponentExampleState();
}

class _PickerComponentExampleState extends State<PickerComponentExample> {
  String _value = '尚未选择';

  Future<void> _pick() async {
    final value = await HyPicker.show<String>(
      context,
      title: '选择交付周期',
      options: const [
        HyOption(value: '今天', label: '今天'),
        HyOption(value: '本周', label: '本周'),
        HyOption(value: '下周', label: '下周'),
      ],
    );
    if (mounted && value != null) setState(() => _value = value);
  }

  @override
  Widget build(BuildContext context) => Row(
    children: [
      HyButton.tonal(label: '打开滚轮选择器', onPressed: _pick),
      const SizedBox(width: 14),
      Text(_value),
    ],
  );
}
// end-doc-region PickerComponentExample

// doc-region DatePickerComponentExample
class DatePickerComponentExample extends StatefulWidget {
  const DatePickerComponentExample({super.key});

  @override
  State<DatePickerComponentExample> createState() => _DatePickerComponentExampleState();
}

class _DatePickerComponentExampleState extends State<DatePickerComponentExample> {
  DateTime? _date;

  Future<void> _pick() async {
    final value = await HyDatePicker.date(context, initialDate: _date);
    if (mounted && value != null) setState(() => _date = value);
  }

  @override
  Widget build(BuildContext context) => Row(
    children: [
      HyButton.tonal(label: '选择日期', icon: Icons.calendar_today_outlined, onPressed: _pick),
      const SizedBox(width: 14),
      Text(_date == null ? '未选择' : '${_date!.year}-${_date!.month}-${_date!.day}'),
    ],
  );
}
// end-doc-region DatePickerComponentExample

// doc-region FilePickerComponentExample
class FilePickerComponentExample extends StatelessWidget {
  const FilePickerComponentExample({super.key});

  @override
  Widget build(BuildContext context) => const HyCard(
    title: '能力由业务层注入',
    leading: Icon(Icons.extension_outlined),
    child: Text('HyFilePicker 负责选择文件，HyFileUpload 负责上传；组件库不绑定平台插件或网络实现。'),
  );
}
// end-doc-region FilePickerComponentExample
