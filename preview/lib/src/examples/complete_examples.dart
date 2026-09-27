import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';
import 'upload_example.dart';

class AtomsExample extends StatefulWidget {
  const AtomsExample({super.key});
  @override
  State<AtomsExample> createState() => _AtomsExampleState();
}

class _AtomsExampleState extends State<AtomsExample> {
  bool _tagVisible = true;
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    spacing: 12,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const HyperText('轻盈，也清晰。', type: 'h1'),
      const HyperText('HYPER UI / SOFT GLASS', type: 'h5'),
      HyperCard(
        title: '文字与图标',
        subtitle: '统一层级，保留呼吸感',
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            HyperText('柔光玻璃', type: 'h2'),
            HyperText('为日常体验设计', type: 'h3'),
            HyperText('清晰的正文与安静的辅助信息。'),
            HyperText('辅助说明 · 13 pt', type: 'h5'),
            HyperText('提示信息 · 12 pt', type: 'h6'),
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 12,
              children: [
                HyperIcon(HyperIcons.home),
                HyperIcon(HyperIcons.cart),
                HyperIcon(HyperIcons.settings),
                HyperIcon(HyperIcons.profile),
              ],
            ),
          ],
        ),
      ),
      const HyperCard(
        title: '头像与角标',
        child: Wrap(
          runSpacing: 8,
          spacing: 24,
          children: [
            HyperAvatar(text: '林', size: 56),
            HyperAvatar(text: 'UI', size: 56, radius: 18),
            HyperAvatar(size: 56),
            HyperBadge.count(count: 128, child: HyperAvatar(text: '讯')),
            HyperBadge.count(dot: true, child: HyperIcon(LucideIcons.bell)),
          ],
        ),
      ),
      HyperCard(
        title: '状态标签',
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            const HyperBadge.tag(label: '已完成', tone: HyperUiTone.success),
            const HyperBadge.tag(label: '待处理', tone: HyperUiTone.warning),
            const HyperBadge.tag(label: '已失败', tone: HyperUiTone.error),
            if (_tagVisible)
              HyperBadge.tag(
                label: '可移除',
                onClose: () => setState(() => _tagVisible = false),
              ),
            if (!_tagVisible)
              HyperButton.ghost(
                label: '恢复标签',
                onPressed: () => setState(() => _tagVisible = true),
              ),
          ],
        ),
      ),
      HyperCard(
        title: '图片 · 点击缩放预览',
        subtitle: '网络加载、内存缓存、失败占位',
        child: HyperImage.network(
          'https://images.unsplash.com/photo-1470770841072-f978cf4d019e?w=900',
          width: double.infinity,
          height: 200,
          preview: true,
        ),
      ),
    ],
  );
}

class LayoutExample extends StatelessWidget {
  const LayoutExample({super.key});
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    spacing: 12,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const HyperText('有序的空间', type: 'h2'),
      HyperCard(
        title: '常用入口 · Grid',
        footer: const HyperText('统一 12 dp 间距', type: 'h5'),
        child: GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            for (final entry in const [
              (LucideIcons.wallet, '钱包'),
              (LucideIcons.receiptText, '订单'),
              (LucideIcons.heart, '收藏'),
              (LucideIcons.mapPin, '地址'),
              (LucideIcons.headset, '帮助'),
              (LucideIcons.settings, '设置'),
            ])
              HyperGlass(
                blur: 0,
                radius: 18,
                onTap: () => HyperToast.show(context, entry.$2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HyperIcon(entry.$1),
                    const SizedBox(height: 8),
                    Text(entry.$2),
                  ],
                ),
              ),
          ],
        ),
      ),
      const HyperCard(
        title: '分割与流式布局',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                HyperBadge.tag(label: '柔光'),
                HyperBadge.tag(label: '轻盈'),
                HyperBadge.tag(label: '自然'),
                HyperBadge.tag(label: '自适应换行'),
              ],
            ),
            HyperDivider(dashed: true),
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 12,
              children: [
                Text('左侧'),
                HyperDivider(axis: Axis.vertical),
                Text('右侧'),
              ],
            ),
          ],
        ),
      ),
      const HyperCard(title: '骨架占位', child: HyperSkeleton(card: true, rows: 2)),
      HyperCard(
        child: HyperEmptyState(
          icon: LucideIcons.searchX,
          title: '没有找到结果',
          message: '试试其他关键词',
          action: HyperButton.tonal(
            label: '重新搜索',
            onPressed: () => HyperToast.show(context, '已重置搜索条件'),
          ),
        ),
      ),
      const HyperCard(
        child: HyperEmptyState(
          icon: LucideIcons.wifiOff,
          title: '网络暂时不可用',
          message: '请检查连接后重试',
        ),
      ),
    ],
  );
}

class FormsExample extends StatefulWidget {
  const FormsExample({super.key});
  @override
  State<FormsExample> createState() => _FormsExampleState();
}

class _FormsExampleState extends State<FormsExample> {
  bool _checked = true, _enabled = true;
  int _radio = 0;
  double _slider = 64;
  List<String> _single = ['自然'], _multiple = ['柔光'];
  String _date = '选择日期 / 时间 / 区间';
  final _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    spacing: 12,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const HyperText('每一次输入，都从容', type: 'h2'),
      HyperCard(
        title: '输入与校验',
        child: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HyperTextField(
                hintText: '请输入称呼',
                maxLength: 20,
                validator: (value) =>
                    value == null || value.trim().isEmpty ? '请输入称呼' : null,
              ),
              const HyperTextField(
                type: 'password',
                showPasswordToggle: true,
                hintText: '可切换显示与隐藏',
              ),
              const HyperTextField(type: 'textarea', rows: 3, maxLength: 120),
              const HyperTextField(initialValue: '不可编辑', enabled: false),
              HyperButton(
                label: '保存',
                onPressed: () {
                  if (_form.currentState!.validate()) {
                    HyperToast.show(context, '已保存', tone: HyperUiTone.success);
                  }
                },
              ),
            ],
          ),
        ),
      ),
      HyperCard(
        title: '选择偏好',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HyperSelect<String>(
              label: '单选',
              options: const [
                HyperOption(value: '自然', label: '自然'),
                HyperOption(value: '鲜明', label: '鲜明'),
              ],
              values: _single,
              onChanged: (value) => setState(() => _single = value),
            ),
            HyperSelect<String>(
              label: '多选',
              multiple: true,
              options: const [
                HyperOption(value: '柔光', label: '柔光'),
                HyperOption(value: '玻璃', label: '玻璃'),
                HyperOption(value: '景深', label: '景深'),
              ],
              values: _multiple,
              onChanged: (value) => setState(() => _multiple = value),
            ),
            HyperCheckbox(
              label: '接收产品更新',
              value: _checked,
              onChanged: (value) => setState(() => _checked = value ?? false),
            ),
            HyperRadio(
              value: 0,
              groupValue: _radio,
              label: '标准模式',
              onChanged: (value) => setState(() => _radio = value),
            ),
            HyperRadio(
              value: 1,
              groupValue: _radio,
              label: '专注模式',
              onChanged: (value) => setState(() => _radio = value),
            ),
            HyperSwitch(
              label: '柔光效果',
              value: _enabled,
              onChanged: (value) => setState(() => _enabled = value),
            ),
            Text('亮度 ${_slider.round()}%'),
            HyperSlider(
              value: _slider,
              divisions: 100,
              onChanged: (value) => setState(() => _slider = value),
            ),
          ],
        ),
      ),
      HyperCard(
        title: '底部选择器',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            Text(_date),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                HyperButton.tonal(
                  label: '选项',
                  onPressed: () async {
                    final result = await HyperPicker.show(
                      context,
                      options: const [
                        HyperOption(value: '上海', label: '上海'),
                        HyperOption(value: '北京', label: '北京'),
                        HyperOption(value: '深圳', label: '深圳'),
                      ],
                    );
                    if (mounted && result != null)
                      setState(() => _date = result);
                  },
                ),
                HyperButton.tonal(
                  label: '日期',
                  onPressed: () async {
                    final result = await HyperDatePicker.date(context);
                    if (mounted && result != null)
                      setState(
                        () => _date = result.toString().split(' ').first,
                      );
                  },
                ),
                HyperButton.tonal(
                  label: '时间',
                  onPressed: () async {
                    final result = await HyperDatePicker.time(context);
                    if (mounted && result != null)
                      setState(() => _date = result.format(context));
                  },
                ),
                HyperButton.tonal(
                  label: '区间',
                  onPressed: () async {
                    final result = await HyperDatePicker.range(context);
                    if (mounted && result != null)
                      setState(
                        () => _date =
                            '${result.start.month}/${result.start.day} — ${result.end.month}/${result.end.day}',
                      );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      const UploadExample(),
    ],
  );
}

class FullNavigationExample extends StatefulWidget {
  const FullNavigationExample({super.key});
  @override
  State<FullNavigationExample> createState() => _FullNavigationExampleState();
}

class _FullNavigationExampleState extends State<FullNavigationExample> {
  int _tab = 0, _step = 1;
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    spacing: 12,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const HyperText('流动的秩序', type: 'h2'),
      HyperCard(
        title: '悬浮导航',
        subtitle: '柔光胶囊 · 选中状态随页面同步',
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                ['首页', '发现', '我的'][_tab],
                style: TextStyle(
                  color: HyperUiThemeTokens.of(context).foreground,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            HyperTabBar(
              safeArea: false,
              items: const [
                HyperTabItem(icon: HyperIcons.home, label: '首页'),
                HyperTabItem(icon: LucideIcons.compass, label: '发现'),
                HyperTabItem(icon: HyperIcons.profile, label: '我的'),
              ],
              selectedIndex: _tab,
              onSelected: (value) => setState(() => _tab = value),
            ),
          ],
        ),
      ),
      const HyperCard(
        title: '标签与联动页面',
        child: SizedBox(
          height: 220,
          child: HyperTabHost(
            length: 3,
            child: Column(
              children: [
                HyperTabs(tabs: [Text('推荐'), Text('关注'), Text('收藏')]),
                Expanded(
                  child: HyperTabView(
                    children: [
                      Center(child: Text('为你推荐')),
                      Center(child: Text('你关注的内容')),
                      Center(child: Text('收藏的灵感')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      HyperCard(
        title: '流程步骤',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HyperSteps(
              current: _step,
              steps: const [HyperStep('提交'), HyperStep('处理中'), HyperStep('完成')],
            ),
            HyperButton.tonal(
              label: '下一步',
              onPressed: () => setState(() => _step = (_step + 1) % 3),
            ),
            const HyperProgress(value: .64),
            const Center(child: HyperProgress(value: .72, circular: true)),
          ],
        ),
      ),
    ],
  );
}
