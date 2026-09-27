import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';

// doc-region TextFieldComponentExample
class TextFieldComponentExample extends StatelessWidget {
  const TextFieldComponentExample({super.key});

  // 字段标题写在输入框外部：输入组件本身不携带标题与说明。
  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyperUiSpacing.xs),
    child: HyperText(text, type: 'h5'),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('基础输入'),
        const HyperTextField(hintText: '请输入内容'),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('可清空'),
        const HyperTextField(
          clearable: true,
          initialValue: '示例内容',
          hintText: '输入后右侧显示清空按钮',
        ),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('密码显隐'),
        const HyperTextField(
          type: 'password',
          showPasswordToggle: true,
          hintText: '请输入密码',
        ),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('前缀与后缀插槽'),
        const HyperTextField(
          hintText: '搜索组件',
          prefix: Icon(LucideIcons.search),
          suffix: Icon(LucideIcons.slidersHorizontal),
        ),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('多行输入'),
        const HyperTextField(type: 'textarea', rows: 3, hintText: '请输入多行内容'),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('字数统计'),
        const HyperTextField(
          maxLength: 50,
          showCounter: true,
          hintText: '最多输入 50 个字符',
        ),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('禁用与只读'),
        const HyperTextField(enabled: false, initialValue: '禁用状态'),
        const SizedBox(height: HyperUiSpacing.sm),
        const HyperTextField(readOnly: true, initialValue: '只读状态'),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('错误态'),
        const HyperTextField(initialValue: '错误内容', errorText: '内容格式不正确'),
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
    padding: const EdgeInsets.only(bottom: HyperUiSpacing.xs),
    child: HyperText(text, type: 'h5'),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('受控切换'),
        HyperSegmentedControl<String>(
          selectedValue: _value,
          onChanged: (value) => setState(() => _value = value),
          options: const [
            HyperSegmentOption(value: 'day', label: '日'),
            HyperSegmentOption(value: 'week', label: '周'),
            HyperSegmentOption(value: 'month', label: '月'),
          ],
        ),
        const SizedBox(height: HyperUiSpacing.sm),
        HyperText('当前值：$_value', type: 'h5'),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('非等宽布局'),
        HyperSegmentedControl<String>(
          equalWidth: false,
          selectedValue: _scope,
          onChanged: (value) => setState(() => _scope = value),
          options: const [
            HyperSegmentOption(value: 'all', label: '全部'),
            HyperSegmentOption(value: 'todo', label: '待办'),
            HyperSegmentOption(value: 'done', label: '已完成'),
            HyperSegmentOption(value: 'draft', label: '草稿箱'),
          ],
        ),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('图标与禁用项'),
        HyperSegmentedControl<String>(
          selectedValue: _view,
          onChanged: (value) => setState(() => _view = value),
          options: const [
            HyperSegmentOption(
              value: 'list',
              label: '列表',
              icon: LucideIcons.list,
            ),
            HyperSegmentOption(
              value: 'chart',
              label: '图表',
              icon: LucideIcons.trendingUp,
            ),
            HyperSegmentOption(
              value: 'board',
              label: '看板（未开放）',
              icon: LucideIcons.layoutDashboard,
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
  int _pageSize = 20;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        HyperDropdown<String>(
          label: '排序方式',
          value: _value,
          onChanged: (value) => setState(() => _value = value),
          options: const [
            HyperOption(value: 'recent', label: '最近更新'),
            HyperOption(value: 'name', label: '按名称'),
            HyperOption(value: 'created', label: '创建时间'),
          ],
        ),
        const SizedBox(height: HyperUiSpacing.xl),

        HyperDropdown<String>(
          label: '负责人',
          placeholder: '选择负责人',
          value: _owner,
          onChanged: (value) => setState(() => _owner = value),
          options: const [
            HyperOption(value: 'ada', label: 'Ada'),
            HyperOption(value: 'bob', label: 'Bob'),
            HyperOption(value: 'eve', label: 'Eve（已停用）', enabled: false),
          ],
        ),
        const SizedBox(height: HyperUiSpacing.xl),

        SizedBox(
          width: 220,
          child: HyperDropdown<int>(
            label: '每页数量',
            value: _pageSize,
            menuMaxHeight: 160,
            onChanged: (value) => setState(() => _pageSize = value),
            options: const [
              HyperOption(value: 10, label: '每页 10 条'),
              HyperOption(value: 20, label: '每页 20 条'),
              HyperOption(value: 50, label: '每页 50 条'),
              HyperOption(value: 100, label: '每页 100 条'),
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
    padding: const EdgeInsets.only(bottom: HyperUiSpacing.xs),
    child: HyperText(text, type: 'h5'),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('受控复选'),
        HyperCheckbox(
          value: _value,
          label: '同步到所有设备',
          onChanged: (value) => setState(() => _value = value),
        ),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('三态（全选 / 部分 / 空）'),
        HyperCheckbox(
          tristate: true,
          value: _partial,
          label: '已选择 2 / 4 项',
          onChanged: (value) => setState(() => _partial = value),
        ),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('禁用状态'),
        const HyperCheckbox(value: false, label: '禁用 · 未选中'),
        const SizedBox(height: HyperUiSpacing.sm),
        const HyperCheckbox(value: true, label: '禁用 · 已选中'),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('纯控件（无标签）'),
        Row(
          children: [
            HyperCheckbox(
              value: _plain,
              onChanged: (value) => setState(() => _plain = value ?? false),
            ),
            const SizedBox(width: HyperUiSpacing.md),
            const HyperCheckbox(value: true),
            const SizedBox(width: HyperUiSpacing.md),
            const HyperCheckbox(value: false, tristate: true),
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
    padding: const EdgeInsets.only(bottom: HyperUiSpacing.xs),
    child: HyperText(text, type: 'h5'),
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
          HyperRadio<String>(
            value: entry.key,
            groupValue: _value,
            label: entry.value,
            // Pro 档位仅作展示：onChanged 为 null 即禁用。
            onChanged: entry.key == 'amoled'
                ? null
                : (value) => setState(() => _value = value),
          ),
        const SizedBox(height: HyperUiSpacing.sm),
        HyperText('当前值：$_value', type: 'h5'),
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
    padding: const EdgeInsets.only(bottom: HyperUiSpacing.xs),
    child: HyperText(text, type: 'h5'),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('受控开关'),
        HyperSwitch(
          value: _enabled,
          label: '接收消息通知',
          onChanged: (value) => setState(() => _enabled = value),
        ),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('禁用状态'),
        const HyperSwitch(value: true, label: '禁用 · 开启'),
        const SizedBox(height: HyperUiSpacing.sm),
        const HyperSwitch(value: false, label: '禁用 · 关闭'),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('纯控件（无标签）'),
        Row(
          children: [
            HyperSwitch(
              value: _plain,
              onChanged: (value) => setState(() => _plain = value),
            ),
            const SizedBox(width: HyperUiSpacing.md),
            const HyperSwitch(value: true),
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
    padding: const EdgeInsets.only(bottom: HyperUiSpacing.xs),
    child: HyperText(text, type: 'h5'),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('连续取值'),
        HyperSlider(
          value: _continuous,
          onChanged: (value) => setState(() => _continuous = value),
        ),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('离散分段（divisions: 5）'),
        HyperSlider(
          value: _discrete,
          max: 5,
          divisions: 5,
          onChanged: (value) => setState(() => _discrete = value),
        ),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('自定义范围与提交回调'),
        HyperSlider(
          value: _age,
          min: 18,
          max: 60,
          showValue: false,
          onChanged: (value) => setState(() => _age = value),
          // onChangeEnd 在拖动结束时触发，适合提交最终值。
          onChangeEnd: (value) =>
              setState(() => _committedAge = '已提交：${value.toInt()} 岁'),
        ),
        const SizedBox(height: HyperUiSpacing.sm),
        HyperText(
          '当前：${_age.toInt()} 岁${_committedAge == null ? '' : ' · $_committedAge'}',
          type: 'h5',
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
  List<String> _single = const ['test'];
  List<String> _multi = const ['design', 'develop'];
  List<String> _team = const [];

  @override
  Widget build(BuildContext context) {
    const options = <HyperOption<String>>[
      HyperOption(value: 'design', label: '设计'),
      HyperOption(value: 'develop', label: '开发'),
      HyperOption(value: 'test', label: '测试'),
      HyperOption(value: 'archive', label: '已归档', enabled: false),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        HyperSelect<String>(
          label: '交付状态',
          values: _single,
          onChanged: (values) => setState(() => _single = values),
          options: options,
        ),
        const SizedBox(height: HyperUiSpacing.xl),

        HyperSelect<String>(
          label: '协作角色',
          multiple: true,
          values: _multi,
          onChanged: (values) => setState(() => _multi = values),
          options: options,
        ),
        const SizedBox(height: HyperUiSpacing.xl),

        HyperSelect<String>(
          label: '所在团队',
          placeholder: '请选择所在团队',
          values: _team,
          onChanged: (values) => setState(() => _team = values),
          options: const [
            HyperOption(value: 'app', label: '应用组'),
            HyperOption(value: 'web', label: '平台组'),
          ],
        ),
      ],
    );
  }
}
// end-doc-region SelectComponentExample

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
    padding: const EdgeInsets.only(bottom: HyperUiSpacing.xs),
    child: HyperText(text, type: 'h5'),
  );

  Future<void> _pick() async {
    final value = await HyperPicker.show<String>(
      context,
      title: '选择交付周期',
      options: const [
        HyperOption(value: '今天', label: '今天'),
        HyperOption(value: '本周', label: '本周'),
        HyperOption(value: '下周', label: '下周'),
      ],
    );
    if (mounted && value != null) setState(() => _value = value);
  }

  Future<void> _pickCity() async {
    final value = await HyperPicker.show<String>(
      context,
      title: '常用城市',
      // initialIndex 让滚轮停在指定项。
      initialIndex: 2,
      options: const [
        HyperOption(value: '北京', label: '北京'),
        HyperOption(value: '广州', label: '广州'),
        HyperOption(value: '上海', label: '上海'),
        HyperOption(value: '深圳', label: '深圳'),
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
            HyperButton.tonal(label: '选择交付周期', onPressed: _pick),
            const SizedBox(width: 14),
            HyperBadge(label: _value),
          ],
        ),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('指定初始项（initialIndex: 2）'),
        Row(
          children: [
            HyperButton.tonal(label: '选择城市', onPressed: _pickCity),
            const SizedBox(width: 14),
            HyperBadge(label: _city),
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
    padding: const EdgeInsets.only(bottom: HyperUiSpacing.xs),
    child: HyperText(text, type: 'h5'),
  );

  Future<void> _pickDate() async {
    final value = await HyperDatePicker.date(context, initialDate: _date);
    if (mounted && value != null) setState(() => _date = value);
  }

  Future<void> _pickTime() async {
    final value = await HyperDatePicker.time(context, initialTime: _time);
    if (mounted && value != null) setState(() => _time = value);
  }

  Future<void> _pickRange() async {
    final value = await HyperDatePicker.range(context, initialRange: _range);
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
        _label('月历选择日期'),
        Row(
          children: [
            HyperButton.tonal(
              label: '选择日期',
              icon: LucideIcons.calendar,
              onPressed: _pickDate,
            ),
            const SizedBox(width: 14),
            HyperBadge(label: _date == null ? '未选择' : _format(_date!)),
          ],
        ),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('时间选择'),
        Row(
          children: [
            HyperButton.tonal(
              label: '选择时间',
              icon: LucideIcons.clock,
              onPressed: _pickTime,
            ),
            const SizedBox(width: 14),
            HyperBadge(
              label: _time == null
                  ? '未选择'
                  : '${_time!.hour.toString().padLeft(2, '0')}:${_time!.minute.toString().padLeft(2, '0')}',
            ),
          ],
        ),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('月历选择日期区间'),
        Row(
          children: [
            HyperButton.tonal(
              label: '选择区间',
              icon: LucideIcons.calendarDays,
              onPressed: _pickRange,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: HyperBadge(
                label: _range == null
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
  Widget build(BuildContext context) => const HyperCard(
    title: '能力由业务层注入',
    leading: Icon(LucideIcons.puzzle),
    child: Text('HyperFilePicker 负责选择文件，HyperFileUpload 负责上传；组件库不绑定平台插件或网络实现。'),
  );
}
// end-doc-region FilePickerComponentExample
