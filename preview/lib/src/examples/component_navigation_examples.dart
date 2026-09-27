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
          onSelected: (index) => setState(() => _index = index),
          items: const [
            HyperTabItem(icon: LucideIcons.house, label: '首页'),
            HyperTabItem(icon: LucideIcons.smartphone, label: '数码'),
            HyperTabItem(icon: LucideIcons.compass, label: '发现'),
            HyperTabItem(icon: LucideIcons.user, label: '我的'),
          ],
        ),
      ],
    );
  }
}
// end-doc-region TabBarComponentExample

// doc-region ListTileComponentExample
class ListTileComponentExample extends StatelessWidget {
  const ListTileComponentExample({super.key});

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
          leading: HyperAvatar(size: 34),
          trailing: HyperBadge.tag(label: '管理员'),
          showChevron: false,
        ),
      ],
    );
  }
}
// end-doc-region ListTileComponentExample

// doc-region MenuGroupComponentExample
class MenuGroupComponentExample extends StatelessWidget {
  const MenuGroupComponentExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const HyperMenuGroup(
      title: '设置',
      subtitle: '账户与应用偏好',
      children: [
        HyperListTile(
          grouped: true,
          title: '账户与安全',
          subtitle: '密码、设备与登录记录',
          leadingIcon: LucideIcons.shield,
        ),
        HyperListTile(
          grouped: true,
          title: '外观与显示',
          subtitle: '主题、字号与动态效果',
          leadingIcon: LucideIcons.palette,
        ),
        HyperListTile(
          grouped: true,
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
          color: HyperUiThemeTokens.of(context).error,
          onPressed: () =>
              HyperToast.show(context, '已删除', tone: HyperUiTone.error),
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

// doc-region TabsComponentExample
class TabsComponentExample extends StatelessWidget {
  const TabsComponentExample({super.key});

  @override
  Widget build(BuildContext context) => HyperTabHost(
    length: 3,
    child: Column(
      children: [
        const HyperTabs(tabs: [Text('概览'), Text('动态'), Text('成员')]),
        SizedBox(
          height: 150,
          child: HyperTabView(
            children: [
              Center(
                child: Text(
                  '项目概览',
                  style: TextStyle(
                    color: HyperUiThemeTokens.of(context).foreground,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Center(child: Text('最近没有新动态')),
              const Center(child: Text('共有 8 位成员')),
            ],
          ),
        ),
      ],
    ),
  );
}
// end-doc-region TabsComponentExample

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
    child: HyperText(text, type: 'h5'),
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
      HyperButton.tonal(
        label: '下一步',
        onPressed: () => setState(() => _current = (_current + 1) % 3),
      ),
      const SizedBox(height: HyperUiSpacing.lg),

      _label('纵向步骤（vertical，可带副标题）'),
      HyperSteps(
        current: _current,
        vertical: true,
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
      HyperProgress(value: .72, strokeWidth: 8, showLabel: false),
      HyperProgress(value: .45, strokeWidth: 12, showLabel: false),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          HyperProgress(value: .42, circular: true),
          HyperProgress(circular: true, showLabel: false),
        ],
      ),
    ],
  );
}
// end-doc-region ProgressComponentExample
