import 'package:flutter/material.dart';
import 'package:flutter_hyper_ui/hy_ui.dart';

// doc-region NavBarComponentExample
class NavBarComponentExample extends StatelessWidget {
  const NavBarComponentExample({super.key});

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
        _label('基础（自动返回按钮 + 居中标题）'),
        HyNavBar(
          title: '项目详情',
          subtitle: '最后更新于 10:24',
          centerTitle: true,
          safeArea: false,
          actions: [
            IconButton(
              tooltip: '分享',
              onPressed: () {},
              icon: const Icon(Icons.ios_share_outlined),
            ),
          ],
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('悬浮模式（floating，无返回按钮）'),
        HyNavBar(
          title: '项目详情',
          subtitle: '最后更新于 10:24',
          safeArea: false,
          floating: true,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              tooltip: '分享',
              onPressed: () {},
              icon: const Icon(Icons.ios_share_outlined),
            ),
          ],
        ),
      ],
    );
  }
}
// end-doc-region NavBarComponentExample

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
          child: Center(child: Text('当前页面：${['首页', '发现', '我的'][_index]}')),
        ),
        HyTabBar(
          safeArea: false,
          selectedIndex: _index,
          onSelected: (index) => setState(() => _index = index),
          items: const [
            HyTabItem(icon: Icons.home_outlined, label: '首页'),
            HyTabItem(icon: Icons.explore_outlined, label: '发现'),
            HyTabItem(icon: Icons.person_outline_rounded, label: '我的'),
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
    padding: const EdgeInsets.only(bottom: HyUiSpacing.xs),
    child: HyText(text, variant: HyTextStyle.caption),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('基础（图标 + 标题 + 副标题 + 右侧 meta）'),
        const HyListTile(
          title: '产品需求说明',
          subtitle: 'PDF · 今天 09:30',
          meta: '12.6 MB',
          leadingIcon: Icons.picture_as_pdf_outlined,
        ),
        const SizedBox(height: 10),

        _label('选中与禁用状态'),
        const HyListTile(
          title: '已选择的项目',
          subtitle: '展示选中状态',
          selected: true,
          leadingIcon: Icons.check_circle_outline,
        ),
        const SizedBox(height: 10),
        const HyListTile(title: '不可用项目', enabled: false),
        const SizedBox(height: 10),

        _label('自定义插槽（leading / trailing，showChevron: false）'),
        const HyListTile(
          title: '项目成员',
          subtitle: '头部与尾部都是任意 Widget',
          leading: CircleAvatar(child: Icon(Icons.person_outline_rounded)),
          trailing: HyTag(label: '管理员'),
          showChevron: false,
        ),
      ],
    );
  }
}
// end-doc-region ListTileComponentExample

// doc-region ListComponentExample
class ListComponentExample extends StatelessWidget {
  const ListComponentExample({super.key});

  @override
  Widget build(BuildContext context) {
    return HyList(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separator: const Divider(height: 1),
      children: const [
        ListTile(title: Text('第一项'), subtitle: Text('列表不绑定数据模型')),
        ListTile(title: Text('第二项'), subtitle: Text('分隔与间距可替换')),
        ListTile(title: Text('第三项'), subtitle: Text('子项可以是任意 Widget')),
      ],
    );
  }
}
// end-doc-region ListComponentExample

// doc-region MenuListComponentExample
class MenuListComponentExample extends StatelessWidget {
  const MenuListComponentExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const HyMenuList(
      title: '设置',
      subtitle: '账户与应用偏好',
      items: [
        HyMenuItem(
          title: '账户与安全',
          subtitle: '密码、设备与登录记录',
          leadingIcon: Icons.shield_outlined,
        ),
        HyMenuItem(
          title: '外观与显示',
          subtitle: '主题、字号与动态效果',
          leadingIcon: Icons.palette_outlined,
        ),
        HyMenuItem(
          title: '关于',
          meta: 'v1.0.0',
          leadingIcon: Icons.info_outline_rounded,
        ),
      ],
    );
  }
}
// end-doc-region MenuListComponentExample

// doc-region SlideMenuComponentExample
class SlideMenuComponentExample extends StatelessWidget {
  const SlideMenuComponentExample({super.key});

  @override
  Widget build(BuildContext context) {
    return HySlideMenu(
      startActions: [
        HySlideAction(
          label: '置顶',
          icon: Icons.vertical_align_top_rounded,
          onPressed: () => HyToast.show(context, '已置顶'),
        ),
      ],
      endActions: [
        HySlideAction(
          label: '删除',
          icon: Icons.delete_outline_rounded,
          color: Theme.of(context).colorScheme.error,
          onPressed: () => HyToast.show(context, '已删除', tone: HyUiTone.error),
        ),
      ],
      child: const ListTile(
        leading: CircleAvatar(child: Icon(Icons.description_outlined)),
        title: Text('向左或向右拖动'),
        subtitle: Text('释放时会根据位置与速度吸附'),
      ),
    );
  }
}
// end-doc-region SlideMenuComponentExample

// doc-region TabsComponentExample
class TabsComponentExample extends StatelessWidget {
  const TabsComponentExample({super.key});

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 3,
    child: Column(
      children: [
        const HyTabs(
          tabs: [
            Tab(text: '概览'),
            Tab(text: '动态'),
            Tab(text: '成员'),
          ],
        ),
        SizedBox(
          height: 150,
          child: HyTabBarView(
            children: [
              Center(
                child: Text(
                  '项目概览',
                  style: Theme.of(context).textTheme.titleMedium,
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
    padding: const EdgeInsets.only(bottom: HyUiSpacing.xs),
    child: HyText(text, variant: HyTextStyle.caption),
  );

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _label('水平步骤（current 受控切换）'),
      HySteps(
        current: _current,
        steps: const [HyStep('创建'), HyStep('配置'), HyStep('完成')],
      ),
      const SizedBox(height: 16),
      HyButton.tonal(
        label: '下一步',
        onPressed: () => setState(() => _current = (_current + 1) % 3),
      ),
      const SizedBox(height: HyUiSpacing.lg),

      _label('纵向步骤（vertical，可带副标题）'),
      HySteps(
        current: _current,
        vertical: true,
        steps: const [
          HyStep('创建项目', subtitle: '填写基本信息'),
          HyStep('配置成员', subtitle: '邀请协作者加入'),
          HyStep('发布上线', subtitle: '对外可见'),
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
  Widget build(BuildContext context) => const HySpace(
    children: [
      HyProgress(value: .68),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          HyProgress(value: .42, circular: true),
          HyProgress(circular: true, showLabel: false),
        ],
      ),
    ],
  );
}
// end-doc-region ProgressComponentExample

// doc-region ProgressBarComponentExample
class ProgressBarComponentExample extends StatelessWidget {
  const ProgressBarComponentExample({super.key});

  @override
  Widget build(BuildContext context) => const HySpace(
    children: [
      Row(
        children: [
          Expanded(child: Text('下载中')),
          Text('72%'),
        ],
      ),
      HyProgressBar(value: .72),
      Row(
        children: [
          Expanded(child: Text('较粗轨道')),
          Text('45%'),
        ],
      ),
      HyProgressBar(value: .45, height: 12),
    ],
  );
}
// end-doc-region ProgressBarComponentExample

// doc-region PullRefreshComponentExample
class PullRefreshComponentExample extends StatelessWidget {
  const PullRefreshComponentExample({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 220,
    child: HyPullRefresh(
      onRefresh: () => Future<void>.delayed(const Duration(milliseconds: 700)),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          ListTile(title: Text('下拉刷新列表'), subtitle: Text('向下拖动以触发刷新')),
          ListTile(title: Text('最近项目')),
          ListTile(title: Text('收藏项目')),
        ],
      ),
    ),
  );
}
// end-doc-region PullRefreshComponentExample

// doc-region LoadMoreComponentExample
class LoadMoreComponentExample extends StatelessWidget {
  const LoadMoreComponentExample({super.key});

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyUiSpacing.xs),
    child: HyText(text, variant: HyTextStyle.caption),
  );

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      _label('滚动到底自动加载（hasMore: true）'),
      SizedBox(
        height: 190,
        child: HyLoadMore(
          hasMore: true,
          onLoadMore: () =>
              Future<void>.delayed(const Duration(milliseconds: 700)),
          child: ListView(
            children: const [
              ListTile(title: Text('第 1 条内容')),
              ListTile(title: Text('第 2 条内容')),
              ListTile(title: Text('第 3 条内容')),
            ],
          ),
        ),
      ),
      const SizedBox(height: HyUiSpacing.lg),

      _label('终态提示（hasMore: false）'),
      SizedBox(
        height: 170,
        child: HyLoadMore(
          hasMore: false,
          onLoadMore: () => Future<void>.value(),
          child: ListView(
            children: const [
              ListTile(title: Text('第 1 条内容')),
              ListTile(title: Text('第 2 条内容')),
              ListTile(title: Text('第 3 条内容')),
            ],
          ),
        ),
      ),
    ],
  );
}
// end-doc-region LoadMoreComponentExample

// doc-region StickyComponentExample
class StickyComponentExample extends StatelessWidget {
  const StickyComponentExample({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 240,
    child: CustomScrollView(
      slivers: [
        const HySticky(child: Center(child: Text('吸顶标题'))),
        SliverList.builder(
          itemCount: 8,
          itemBuilder: (_, index) => ListTile(title: Text('列表内容 ${index + 1}')),
        ),
      ],
    ),
  );
}
// end-doc-region StickyComponentExample
