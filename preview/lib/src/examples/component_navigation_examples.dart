import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';

// doc-region TabBarComponentExample
class TabBarComponentExample extends StatefulWidget {
  const TabBarComponentExample({super.key});

  @override
  State<TabBarComponentExample> createState() => _TabBarComponentExampleState();
}

class _TabBarComponentExampleState extends State<TabBarComponentExample> {
  int _index = 0;
  int _dockIndex = 0;
  int _pairIndex = 0;
  int _actionCount = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 150,
          child: Center(
            child: Text('当前页面：${['首页', '数码', '发现', '我的'][_index]}'),
          ),
        ),
        HyperTabBar(
          safeArea: false,
          selectedIndex: _index,
          onChanged: (index) => setState(() => _index = index),
          items: const [
            HyperTabItem(icon: LucideIcons.house, label: '首页'),
            HyperTabItem(icon: LucideIcons.smartphone, label: '数码'),
            HyperTabItem(icon: LucideIcons.compass, label: '发现'),
            HyperTabItem(icon: LucideIcons.user, label: '我的'),
          ],
        ),
        const SizedBox(height: 20),
        const Text('48 直径单项入口：通知角标与独立点击'),
        const SizedBox(height: 12),
        Center(
          child: HyperTabBar(
            type: 'single',
            safeArea: false,
            margin: EdgeInsets.zero,
            selectedIndex: 0,
            badgeCount: 8,
            onChanged: (_) => HyperToast.show(context, '打开通知'),
            items: const [HyperTabItem(icon: LucideIcons.bell, label: '通知')],
          ),
        ),
        const SizedBox(height: 24),
        Text('非悬浮动作栏：已触发 $_actionCount 次（最近禁用）'),
        HyperTabBar(
          floating: false,
          selectedIndex: null,
          safeArea: false,
          itemEnabled: (item) => item.label != '最近',
          onChanged: (_) => setState(() => _actionCount++),
          items: const [
            HyperTabItem(icon: LucideIcons.house, label: '首页'),
            HyperTabItem(icon: LucideIcons.info, label: '最近'),
            HyperTabItem(icon: LucideIcons.bell, label: '消息'),
            HyperTabItem(icon: LucideIcons.settings, label: '设置'),
          ],
        ),
        const SizedBox(height: 24),
        Text('56 高导航与 48 直径入口：已触发 $_actionCount 次'),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: HyperTabBar(
                  safeArea: false,
                  margin: EdgeInsets.zero,
                  selectedIndex: _pairIndex,
                  onChanged: (index) => setState(() => _pairIndex = index),
                  items: const [
                    HyperTabItem(icon: LucideIcons.history, label: '最近'),
                    HyperTabItem(icon: LucideIcons.list, label: '列表'),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              HyperTabBar(
                type: 'single',
                safeArea: false,
                selectedIndex: null,
                onChanged: (_) => setState(() => _actionCount++),
                items: const [
                  HyperTabItem(icon: LucideIcons.folderOpen, label: '打开'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text('组合示例：左侧通知入口 + 底部导航'),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              HyperTabBar(
                type: 'single',
                safeArea: false,
                selectedIndex: 0,
                badgeCount: 27,
                onChanged: (_) => HyperToast.show(context, '打开通知'),
                items: const [
                  HyperTabItem(icon: LucideIcons.bell, label: '通知'),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: HyperTabBar(
                  safeArea: false,
                  margin: EdgeInsets.zero,
                  selectedIndex: _dockIndex,
                  onChanged: (index) => setState(() => _dockIndex = index),
                  items: const [
                    HyperTabItem(icon: LucideIcons.house, label: '首页'),
                    HyperTabItem(icon: LucideIcons.trendingUp, label: '选股'),
                    HyperTabItem(
                      icon: LucideIcons.slidersHorizontal,
                      label: '行情',
                    ),
                    HyperTabItem(icon: LucideIcons.star, label: '自选'),
                    HyperTabItem(icon: LucideIcons.settings, label: '设置'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
// end-doc-region TabBarComponentExample

// doc-region ListTileComponentExample
class ListTileComponentExample extends StatelessWidget {
  // 同时展示独立卡片与平铺行，核对选中背景内的默认留白。
  const ListTileComponentExample({super.key});

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyperUiSpacing.xs),
    child: HyperText(text),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('基础（图标 + 标题 + 副标题 + 右侧 meta）'),
        const HyperListTile(
          title: '产品需求说明',
          subtitle: 'PDF · 今天 09:30',
          meta: '12.6 MB',
          leadingIcon: LucideIcons.fileText,
        ),
        const SizedBox(height: 10),

        _label('选中与禁用状态'),
        const HyperListTile(
          type: 'plain',
          title: '已选择的项目',
          subtitle: '展示选中状态',
          selected: true,
          leadingIcon: LucideIcons.circleCheckBig,
        ),
        const SizedBox(height: 10),
        const HyperListTile(title: '不可用项目', enabled: false),
        const SizedBox(height: 10),

        _label('自定义插槽（leading / trailing，showChevron: false）'),
        const HyperListTile(
          title: '项目成员',
          subtitle: '头部与尾部都是任意 Widget',
          leading: HyperAvatar(),
          trailing: HyperBadge(type: 'tag', label: '管理员'),
          showChevron: false,
        ),
      ],
    );
  }
}
// end-doc-region ListTileComponentExample

// doc-region MenuGroupComponentExample
class MenuGroupComponentExample extends StatelessWidget {
  // 标题与组内行、分隔线共用宿主水平留白。
  const MenuGroupComponentExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const HyperMenuGroup(
      title: '设置',
      subtitle: '账户与应用偏好',
      children: [
        HyperListTile(
          title: '账户与安全',
          subtitle: '密码、设备与登录记录',
          leadingIcon: LucideIcons.shield,
        ),
        HyperListTile(
          title: '外观与显示',
          subtitle: '主题、字号与动态效果',
          leadingIcon: LucideIcons.palette,
        ),
        HyperListTile(
          title: '关于',
          meta: 'v1.0.0',
          leadingIcon: LucideIcons.info,
        ),
      ],
    );
  }
}
// end-doc-region MenuGroupComponentExample

// doc-region SlideMenuComponentExample
class SlideMenuComponentExample extends StatelessWidget {
  // 内容装饰由库内卡片表面提供，侧滑操作区保持自身状态色。
  const SlideMenuComponentExample({super.key});

  @override
  Widget build(BuildContext context) {
    return HyperSlideMenu(
      startActions: [
        HyperSlideAction(
          label: '置顶',
          icon: LucideIcons.arrowUpToLine,
          onPressed: () => HyperToast.show(context, '已置顶'),
        ),
      ],
      endActions: [
        HyperSlideAction(
          label: '删除',
          icon: LucideIcons.trash,
          type: 'danger',
          onPressed: () => HyperToast.show(context, '已删除', type: 'error'),
        ),
      ],
      child: const HyperListTile(
        title: '向左或向右拖动',
        subtitle: '释放时会根据位置与速度吸附',
        leadingIcon: LucideIcons.fileText,
      ),
    );
  }
}
// end-doc-region SlideMenuComponentExample

// doc-region FilterBarComponentExample
class FilterBarComponentExample extends StatefulWidget {
  const FilterBarComponentExample({super.key});
  @override
  State<FilterBarComponentExample> createState() =>
      _FilterBarComponentExampleState();
}

class _FilterBarComponentExampleState extends State<FilterBarComponentExample> {
  int _selected = 0;
  bool _enabled = true;
  static const _categories = [
    '全部',
    'PDF',
    'Word',
    '文本',
    'Markdown',
    '表格',
    '演示文稿',
  ];
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      HyperSwitch(
        value: _enabled,
        onChanged: (value) => setState(() => _enabled = value),
        label: '允许筛选',
      ),
      const SizedBox(height: 12),
      HyperFilterBar<String>(
        items: _categories,
        selectedIndex: _selected,
        onChanged: (value) => setState(() => _selected = value),
        enabled: _enabled,
        itemEnabled: (item) => item != '演示文稿',
        itemBuilder: (item, selected, enabled) => HyperText(item, maxLines: 1),
      ),
      const SizedBox(height: 12),
      HyperText('当前选中：${_categories[_selected]}'),
      const SizedBox(height: 12),
      HyperText(
        '点击分类切换，左右滑动查看更多',
        color: HyperUiThemeTokens.of(context).mutedForeground,
      ),
    ],
  );
}
// end-doc-region FilterBarComponentExample

// doc-region StepsComponentExample
class StepsComponentExample extends StatefulWidget {
  const StepsComponentExample({super.key});

  @override
  State<StepsComponentExample> createState() => _StepsComponentExampleState();
}

class _StepsComponentExampleState extends State<StepsComponentExample> {
  int _current = 1;

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyperUiSpacing.xs),
    child: HyperText(text),
  );

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _label('水平步骤（current 受控切换）'),
      HyperSteps(
        current: _current,
        steps: const [HyperStep('创建'), HyperStep('配置'), HyperStep('完成')],
      ),
      const SizedBox(height: 16),
      HyperButton(
        label: '下一步',
        onPressed: () => setState(() => _current = (_current + 1) % 3),
      ),
      const SizedBox(height: HyperUiSpacing.lg),

      _label('纵向步骤（vertical，可带副标题）'),
      HyperSteps(
        current: _current,
        type: 'vertical',
        steps: const [
          HyperStep('创建项目', subtitle: '填写基本信息'),
          HyperStep('配置成员', subtitle: '邀请协作者加入'),
          HyperStep('发布上线', subtitle: '对外可见'),
        ],
      ),
    ],
  );
}
// end-doc-region StepsComponentExample

// doc-region ProgressComponentExample
class ProgressComponentExample extends StatelessWidget {
  const ProgressComponentExample({super.key});

  @override
  Widget build(BuildContext context) => const Column(
    mainAxisSize: MainAxisSize.min,
    spacing: 12,
    children: [
      HyperProgress(value: .68),
      HyperProgress(value: .72, showLabel: false),
      HyperProgress(value: .45, showLabel: false),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          HyperProgress(type: 'circular', value: .42),
          HyperProgress(type: 'circular', showLabel: false),
        ],
      ),
    ],
  );
}
// end-doc-region ProgressComponentExample
