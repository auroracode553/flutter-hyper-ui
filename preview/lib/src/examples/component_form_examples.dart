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
        const HyTextField(initialValue: '错误内容', errorText: '内容格式不正确'),
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
  String _scope = 'all';
  String _view = 'list';

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
        _label('受控切换'),
        HySegmentedControl<String>(
          selectedValue: _value,
          onChanged: (value) => setState(() => _value = value),
          options: const [
            HySegmentOption(value: 'day', label: '日'),
            HySegmentOption(value: 'week', label: '周'),
            HySegmentOption(value: 'month', label: '月'),
          ],
        ),
        const SizedBox(height: HyUiSpacing.sm),
        HyText('当前值：$_value', variant: HyTextStyle.caption),
        const SizedBox(height: HyUiSpacing.lg),

        _label('非等宽布局'),
        HySegmentedControl<String>(
          equalWidth: false,
          selectedValue: _scope,
          onChanged: (value) => setState(() => _scope = value),
          options: const [
            HySegmentOption(value: 'all', label: '全部'),
            HySegmentOption(value: 'todo', label: '待办'),
            HySegmentOption(value: 'done', label: '已完成'),
            HySegmentOption(value: 'draft', label: '草稿箱'),
          ],
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('图标与禁用项'),
        HySegmentedControl<String>(
          selectedValue: _view,
          onChanged: (value) => setState(() => _view = value),
          options: const [
            HySegmentOption(
              value: 'list',
              label: '列表',
              icon: Icons.view_list_rounded,
            ),
            HySegmentOption(
              value: 'chart',
              label: '图表',
              icon: Icons.insights_rounded,
            ),
            HySegmentOption(
              value: 'board',
              label: '看板（未开放）',
              icon: Icons.dashboard_rounded,
              enabled: false,
            ),
          ],
        ),
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
  String? _owner;

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
        _label('带标签的单选'),
        HyDropdown<String>(
          label: '排序方式',
          value: _value,
          onChanged: (value) => setState(() => _value = value),
          options: const [
            HyOption(value: 'recent', label: '最近更新'),
            HyOption(value: 'name', label: '按名称'),
            HyOption(value: 'created', label: '创建时间'),
          ],
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('占位与禁用项'),
        HyDropdown<String>(
          placeholder: '选择负责人',
          value: _owner,
          onChanged: (value) => setState(() => _owner = value),
          options: const [
            HyOption(value: 'ada', label: 'Ada'),
            HyOption(value: 'bob', label: 'Bob'),
            HyOption(value: 'eve', label: 'Eve（已停用）', enabled: false),
          ],
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('固定宽度与菜单高度'),
        SizedBox(
          width: 220,
          child: HyDropdown<int>(
            value: 20,
            menuMaxHeight: 160,
            onChanged: (value) {},
            options: const [
              HyOption(value: 10, label: '每页 10 条'),
              HyOption(value: 20, label: '每页 20 条'),
              HyOption(value: 50, label: '每页 50 条'),
              HyOption(value: 100, label: '每页 100 条'),
            ],
          ),
        ),
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
  bool? _partial;
  bool _plain = false;

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyUiSpacing.xs),
    child: HyText(text, variant: HyTextStyle.caption),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('受控复选'),
        HyCheckbox(
          value: _value,
          label: '同步到所有设备',
          onChanged: (value) => setState(() => _value = value),
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('三态（全选 / 部分 / 空）'),
        HyCheckbox(
          tristate: true,
          value: _partial,
          label: '已选择 2 / 4 项',
          onChanged: (value) => setState(() => _partial = value),
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('禁用状态'),
        const HyCheckbox(value: false, label: '禁用 · 未选中'),
        const SizedBox(height: HyUiSpacing.sm),
        const HyCheckbox(value: true, label: '禁用 · 已选中'),
        const SizedBox(height: HyUiSpacing.lg),

        _label('纯控件（无标签）'),
        Row(
          children: [
            HyCheckbox(
              value: _plain,
              onChanged: (value) => setState(() => _plain = value ?? false),
            ),
            const SizedBox(width: HyUiSpacing.md),
            const HyCheckbox(value: true),
            const SizedBox(width: HyUiSpacing.md),
            const HyCheckbox(value: false, tristate: true),
          ],
        ),
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

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyUiSpacing.xs),
    child: HyText(text, variant: HyTextStyle.caption),
  );

  @override
  Widget build(BuildContext context) {
    const labels = <String, String>{
      'system': '跟随系统',
      'light': '浅色',
      'dark': '深色',
      'amoled': '纯黑（Pro）',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('互斥单选'),
        for (final entry in labels.entries)
          HyRadio<String>(
            value: entry.key,
            groupValue: _value,
            label: entry.value,
            // Pro 档位仅作展示：onChanged 为 null 即禁用。
            onChanged: entry.key == 'amoled'
                ? null
                : (value) => setState(() => _value = value),
          ),
        const SizedBox(height: HyUiSpacing.sm),
        HyText('当前值：$_value', variant: HyTextStyle.caption),
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
  bool _plain = false;

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyUiSpacing.xs),
    child: HyText(text, variant: HyTextStyle.caption),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('受控开关'),
        HySwitch(
          value: _enabled,
          label: '接收消息通知',
          onChanged: (value) => setState(() => _enabled = value),
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('禁用状态'),
        const HySwitch(value: true, label: '禁用 · 开启'),
        const SizedBox(height: HyUiSpacing.sm),
        const HySwitch(value: false, label: '禁用 · 关闭'),
        const SizedBox(height: HyUiSpacing.lg),

        _label('纯控件（无标签）'),
        Row(
          children: [
            HySwitch(
              value: _plain,
              onChanged: (value) => setState(() => _plain = value),
            ),
            const SizedBox(width: HyUiSpacing.md),
            const HySwitch(value: true),
          ],
        ),
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
  double _continuous = 42;
  double _discrete = 3;
  double _age = 26;
  String? _committedAge;

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
        _label('连续取值'),
        HySlider(
          value: _continuous,
          onChanged: (value) => setState(() => _continuous = value),
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('离散分段（divisions: 5）'),
        HySlider(
          value: _discrete,
          max: 5,
          divisions: 5,
          onChanged: (value) => setState(() => _discrete = value),
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('自定义范围与提交回调'),
        HySlider(
          value: _age,
          min: 18,
          max: 60,
          showValue: false,
          onChanged: (value) => setState(() => _age = value),
          // onChangeEnd 在拖动结束时触发，适合提交最终值。
          onChangeEnd: (value) =>
              setState(() => _committedAge = '已提交：${value.toInt()} 岁'),
        ),
        const SizedBox(height: HyUiSpacing.sm),
        HyText(
          '当前：${_age.toInt()} 岁${_committedAge == null ? '' : ' · $_committedAge'}',
          variant: HyTextStyle.caption,
        ),
      ],
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
  List<String> _single = const [];
  List<String> _multi = const ['design'];

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyUiSpacing.xs),
    child: HyText(text, variant: HyTextStyle.caption),
  );

  @override
  Widget build(BuildContext context) {
    const options = <HyOption<String>>[
      HyOption(value: 'design', label: '设计'),
      HyOption(value: 'develop', label: '开发'),
      HyOption(value: 'test', label: '测试'),
      HyOption(value: 'archive', label: '已归档', enabled: false),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('单选'),
        HySelect<String>(
          label: '交付状态',
          values: _single,
          onChanged: (values) => setState(() => _single = values),
          options: options,
        ),
        const SizedBox(height: HyUiSpacing.sm),
        HyText(
          _single.isEmpty ? '尚未选择' : '已选择：${_single.first}',
          variant: HyTextStyle.caption,
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('多选与禁用项'),
        HySelect<String>(
          label: '选择协作角色',
          multiple: true,
          values: _multi,
          onChanged: (values) => setState(() => _multi = values),
          options: options,
        ),
        const SizedBox(height: HyUiSpacing.sm),
        HyText(
          _multi.isEmpty ? '尚未选择' : '已选择：${_multi.join('、')}',
          variant: HyTextStyle.caption,
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('占位文案（未选择时）'),
        const HySelect<String>(
          placeholder: '请选择所在团队',
          values: [],
          options: [
            HyOption(value: 'app', label: '应用组'),
            HyOption(value: 'web', label: '平台组'),
          ],
        ),
      ],
    );
  }
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
  double _ten = 7;

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyUiSpacing.xs),
    child: HyText(text, variant: HyTextStyle.caption),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('基础评分'),
        Row(
          children: [
            HyRate(
              value: _value,
              onChanged: (value) => setState(() => _value = value),
            ),
            const SizedBox(width: 12),
            Text('${_value.toInt()} / 5'),
          ],
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('只读展示（不传 onChanged）'),
        const Row(
          children: [HyRate(value: 3.5), SizedBox(width: 12), Text('3.5 / 5')],
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('数量与尺寸自定义'),
        Row(
          children: [
            HyRate(
              value: _ten,
              count: 10,
              size: 20,
              onChanged: (value) => setState(() => _ten = value),
            ),
            const SizedBox(width: 12),
            Text('${_ten.toInt()} / 10'),
          ],
        ),
      ],
    );
  }
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
  String _city = '上海';

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyUiSpacing.xs),
    child: HyText(text, variant: HyTextStyle.caption),
  );

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

  Future<void> _pickCity() async {
    final value = await HyPicker.show<String>(
      context,
      title: '常用城市',
      // initialIndex 让滚轮停在指定项。
      initialIndex: 2,
      options: const [
        HyOption(value: '北京', label: '北京'),
        HyOption(value: '广州', label: '广州'),
        HyOption(value: '上海', label: '上海'),
        HyOption(value: '深圳', label: '深圳'),
      ],
    );
    if (mounted && value != null) setState(() => _city = value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('基础滚轮选择'),
        Row(
          children: [
            HyButton.tonal(label: '选择交付周期', onPressed: _pick),
            const SizedBox(width: 14),
            Text(_value),
          ],
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('指定初始项（initialIndex: 2）'),
        Row(
          children: [
            HyButton.tonal(label: '选择城市', onPressed: _pickCity),
            const SizedBox(width: 14),
            Text(_city),
          ],
        ),
      ],
    );
  }
}
// end-doc-region PickerComponentExample

// doc-region DatePickerComponentExample
class DatePickerComponentExample extends StatefulWidget {
  const DatePickerComponentExample({super.key});

  @override
  State<DatePickerComponentExample> createState() =>
      _DatePickerComponentExampleState();
}

class _DatePickerComponentExampleState
    extends State<DatePickerComponentExample> {
  DateTime? _date;
  TimeOfDay? _time;
  DateTimeRange? _range;

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyUiSpacing.xs),
    child: HyText(text, variant: HyTextStyle.caption),
  );

  Future<void> _pickDate() async {
    final value = await HyDatePicker.date(context, initialDate: _date);
    if (mounted && value != null) setState(() => _date = value);
  }

  Future<void> _pickTime() async {
    final value = await HyDatePicker.time(context, initialTime: _time);
    if (mounted && value != null) setState(() => _time = value);
  }

  Future<void> _pickRange() async {
    final value = await HyDatePicker.range(context, initialRange: _range);
    if (mounted && value != null) setState(() => _range = value);
  }

  String _format(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('日期选择'),
        Row(
          children: [
            HyButton.tonal(
              label: '选择日期',
              icon: Icons.calendar_today_outlined,
              onPressed: _pickDate,
            ),
            const SizedBox(width: 14),
            Text(_date == null ? '未选择' : _format(_date!)),
          ],
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('时间选择'),
        Row(
          children: [
            HyButton.tonal(
              label: '选择时间',
              icon: Icons.schedule_outlined,
              onPressed: _pickTime,
            ),
            const SizedBox(width: 14),
            Text(
              _time == null
                  ? '未选择'
                  : '${_time!.hour.toString().padLeft(2, '0')}:${_time!.minute.toString().padLeft(2, '0')}',
            ),
          ],
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('日期区间'),
        Row(
          children: [
            HyButton.tonal(
              label: '选择区间',
              icon: Icons.date_range_outlined,
              onPressed: _pickRange,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                _range == null
                    ? '未选择'
                    : '${_format(_range!.start)} ~ ${_format(_range!.end)}',
              ),
            ),
          ],
        ),
      ],
    );
  }
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
