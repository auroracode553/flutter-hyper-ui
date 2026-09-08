import 'package:flutter/material.dart';
import 'package:flutter_hyper_ui/hy_ui.dart';
import 'interactive_examples.dart';
import 'upload_example.dart';

class AtomsExample extends StatefulWidget {
  const AtomsExample({super.key});
  @override
  State<AtomsExample> createState() => _AtomsExampleState();
}
class _AtomsExampleState extends State<AtomsExample> {
  bool _tagVisible = true;
  @override
  Widget build(BuildContext context) => HySpace(alignment: CrossAxisAlignment.stretch, children: [
    const HyText('轻盈，也清晰。', variant: HyTextStyle.display),
    const HyText('HY UI / SOFT GLASS', variant: HyTextStyle.caption),
    HyCard(title: '文字与图标', subtitle: '统一层级，保留呼吸感', child: const HySpace(children: [
      HyText('柔光玻璃', variant: HyTextStyle.title),
      HyText('为日常体验设计', variant: HyTextStyle.heading),
      HyText('清晰的正文与安静的辅助信息。'),
      HyText('辅助说明 · 13 pt', variant: HyTextStyle.caption),
      HyText('提示信息 · 12 pt', variant: HyTextStyle.hint),
      HySpace(direction: Axis.horizontal, children: [HyIcon(HyIcons.home),
        HyIcon(HyIcons.cart), HyIcon(HyIcons.settings), HyIcon(HyIcons.profile)]),
    ])),
    const HyCard(title: '头像与角标', child: HyWrap(spacing: 24, children: [
      HyAvatar(text: '林', size: 56), HyAvatar(text: 'HY', size: 56, radius: 18),
      HyAvatar(size: 56), HyCountBadge(count: 128, child: HyAvatar(text: '讯')),
      HyCountBadge(dot: true, child: HyIcon(Icons.notifications_outlined)),
    ])),
    HyCard(title: '状态标签', child: HyWrap(children: [
      const HyTag(label: '已完成', tone: HyUiTone.success),
      const HyTag(label: '待处理', tone: HyUiTone.warning),
      const HyTag(label: '已失败', tone: HyUiTone.error),
      if (_tagVisible) HyTag(label: '可移除', onClose: () => setState(() => _tagVisible = false)),
      if (!_tagVisible) HyButton.ghost(label: '恢复标签', onPressed: () => setState(() => _tagVisible = true)),
    ])),
    HyCard(title: '图片 · 点击缩放预览', subtitle: '网络加载、内存缓存、失败占位',
      child: HyImage.network('https://images.unsplash.com/photo-1470770841072-f978cf4d019e?w=900',
        width: double.infinity, height: 200, preview: true)),
  ]);
}

class LayoutExample extends StatelessWidget {
  const LayoutExample({super.key});
  @override
  Widget build(BuildContext context) => HySpace(alignment: CrossAxisAlignment.stretch, children: [
    const HyText('有序的空间', variant: HyTextStyle.title),
    HyCard(title: '常用入口 · Grid', footer: const HyText('统一 12 dp 间距', variant: HyTextStyle.caption),
      child: HyGrid(childAspectRatio: 1.2, children: [
        for (final entry in const [(Icons.wallet_outlined, '钱包'), (Icons.receipt_long_outlined, '订单'),
          (Icons.favorite_border, '收藏'), (Icons.location_on_outlined, '地址'),
          (Icons.headset_mic_outlined, '帮助'), (Icons.settings_outlined, '设置')])
          HyGlass(blur: 0, radius: 18, onTap: () => HyToast.show(context, entry.$2),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              HyIcon(entry.$1), const SizedBox(height: 8), Text(entry.$2)])),
      ])),
    const HyCard(title: '分割与流式布局', child: HySpace(alignment: CrossAxisAlignment.stretch, children: [
      HyWrap(children: [HyTag(label: '柔光'), HyTag(label: '轻盈'), HyTag(label: '自然'), HyTag(label: '自适应换行')]),
      HyDivider(dashed: true),
      HySpace(direction: Axis.horizontal, children: [Text('左侧'), HyDivider(axis: Axis.vertical), Text('右侧')]),
    ])),
    const HyCard(title: '骨架占位', child: HySkeleton(card: true, rows: 2)),
    HyCard(child: HyEmptyState(icon: Icons.search_off_rounded, title: '没有找到结果',
      message: '试试其他关键词', action: HyButton.tonal(label: '重新搜索',
        onPressed: () => HyToast.show(context, '已重置搜索条件')))),
    const HyCard(child: HyEmptyState(icon: Icons.wifi_off_rounded, title: '网络暂时不可用', message: '请检查连接后重试')),
  ]);
}

class FormsExample extends StatefulWidget {
  const FormsExample({super.key});
  @override
  State<FormsExample> createState() => _FormsExampleState();
}
class _FormsExampleState extends State<FormsExample> {
  bool _checked = true, _enabled = true;
  int _radio = 0;
  double _slider = 64, _rate = 4;
  List<String> _single = ['自然'], _multiple = ['柔光'];
  String _date = '选择日期 / 时间 / 区间';
  final _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) => HySpace(alignment: CrossAxisAlignment.stretch, children: [
    const HyText('每一次输入，都从容', variant: HyTextStyle.title),
    HyCard(title: '输入与校验', child: Form(key: _form, child: HySpace(
      alignment: CrossAxisAlignment.stretch, children: [
        HyTextField(label: '称呼', hintText: '请输入称呼', maxLength: 20,
          validator: (value) => value == null || value.trim().isEmpty ? '请输入称呼' : null),
        const HyTextField(label: '密码', obscureText: true, hintText: '可切换显示与隐藏'),
        const HyTextField(label: '备注', maxLines: 3, maxLength: 120),
        const HyTextField(label: '只读状态', initialValue: '不可编辑', enabled: false),
        HyButton(label: '保存', onPressed: () { if (_form.currentState!.validate()) {
          HyToast.show(context, '已保存', tone: HyUiTone.success); } }),
      ]))),
    HyCard(title: '选择偏好', child: HySpace(alignment: CrossAxisAlignment.stretch, children: [
      HySelect<String>(label: '单选', options: const [HyOption(value: '自然', label: '自然'),
        HyOption(value: '鲜明', label: '鲜明')], values: _single,
        onChanged: (value) => setState(() => _single = value)),
      HySelect<String>(label: '多选', multiple: true, options: const [
        HyOption(value: '柔光', label: '柔光'), HyOption(value: '玻璃', label: '玻璃'),
        HyOption(value: '景深', label: '景深')], values: _multiple,
        onChanged: (value) => setState(() => _multiple = value)),
      HyCheckbox(label: '接收产品更新', value: _checked, onChanged: (value) => setState(() => _checked = value ?? false)),
      HyRadio(value: 0, groupValue: _radio, label: '标准模式', onChanged: (value) => setState(() => _radio = value)),
      HyRadio(value: 1, groupValue: _radio, label: '专注模式', onChanged: (value) => setState(() => _radio = value)),
      HySwitch(label: '柔光效果', value: _enabled, onChanged: (value) => setState(() => _enabled = value)),
      Text('亮度 ${_slider.round()}%'), HySlider(value: _slider, divisions: 100,
        onChanged: (value) => setState(() => _slider = value)),
      HyRate(value: _rate, onChanged: (value) => setState(() => _rate = value)),
    ])),
    HyCard(title: '底部选择器', child: HySpace(children: [
      Text(_date), HyWrap(children: [
        HyButton.tonal(label: '选项', onPressed: () async {
          final result = await HyPicker.show(context, options: const [
            HyOption(value: '上海', label: '上海'), HyOption(value: '北京', label: '北京'),
            HyOption(value: '深圳', label: '深圳')]);
          if (mounted && result != null) setState(() => _date = result);
        }),
        HyButton.tonal(label: '日期', onPressed: () async {
          final result = await HyDatePicker.date(context);
          if (mounted && result != null) setState(() => _date = result.toString().split(' ').first);
        }),
        HyButton.tonal(label: '时间', onPressed: () async {
          final result = await HyDatePicker.time(context);
          if (mounted && result != null) setState(() => _date = result.format(context));
        }),
        HyButton.tonal(label: '区间', onPressed: () async {
          final result = await HyDatePicker.range(context);
          if (mounted && result != null) setState(() => _date = '${result.start.month}/${result.start.day} — ${result.end.month}/${result.end.day}');
        }),
      ]),
    ])),
    const UploadExample(),
  ]);
}

class FullNavigationExample extends StatefulWidget {
  const FullNavigationExample({super.key});
  @override
  State<FullNavigationExample> createState() => _FullNavigationExampleState();
}
class _FullNavigationExampleState extends State<FullNavigationExample> {
  int _tab = 0, _step = 1;
  @override
  Widget build(BuildContext context) => HySpace(alignment: CrossAxisAlignment.stretch, children: [
    const HyText('流动的秩序', variant: HyTextStyle.title),
    HyCard(title: '悬浮导航', subtitle: '柔光胶囊 · 选中状态随页面同步', child: Column(children: [
      Padding(padding: const EdgeInsets.all(24), child: Text(['首页', '发现', '我的'][_tab],
        style: Theme.of(context).textTheme.headlineMedium)),
      HyTabBar(safeArea: false, items: const [HyTabItem(icon: HyIcons.home, label: '首页'),
        HyTabItem(icon: Icons.explore_outlined, label: '发现'), HyTabItem(icon: HyIcons.profile, label: '我的')],
        selectedIndex: _tab, onSelected: (value) => setState(() => _tab = value)),
    ])),
    const HyCard(title: '标签与联动页面', child: SizedBox(height: 220,
      child: DefaultTabController(length: 3, child: Column(children: [
        HyTabs(tabs: [Tab(text: '推荐'), Tab(text: '关注'), Tab(text: '收藏')]),
        Expanded(child: HyTabBarView(children: [Center(child: Text('为你推荐')),
          Center(child: Text('你关注的内容')), Center(child: Text('收藏的灵感'))])),
      ])))),
    HyCard(title: '流程步骤', child: HySpace(alignment: CrossAxisAlignment.stretch, children: [
      HySteps(current: _step, steps: const [HyStep('提交'), HyStep('处理中'), HyStep('完成')]),
      HyButton.tonal(label: '下一步', onPressed: () => setState(() => _step = (_step + 1) % 3)),
      const HyProgress(value: .64), const Center(child: HyProgress(value: .72, circular: true)),
    ])),
    const ListInteractionExample(),
  ]);
}
