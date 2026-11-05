import 'package:flutter/widgets.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// doc-region TabBarComponentExample
/// 对应 Kotlin 文档的多项导航；点击时整栏保持原比例，镜片轻微放大与短回弹使用正式组件。
class TabBarComponentExample extends StatelessWidget {
  const TabBarComponentExample({super.key});

  @override
  Widget build(BuildContext context) => const _TabBarScene();
}
// end-doc-region TabBarComponentExample

// doc-region DockedTabBarComponentExample
class DockedTabBarComponentExample extends StatelessWidget {
  const DockedTabBarComponentExample({super.key});

  // 正式 TabBar 按图文与安全区测量总高，示例不额外添加占位或 SafeArea。
  @override
  Widget build(BuildContext context) => const _TabBarScene(actions: true);
}
// end-doc-region DockedTabBarComponentExample

// doc-region SingleTabBarComponentExample
class SingleTabBarComponentExample extends StatelessWidget {
  const SingleTabBarComponentExample({super.key});

  @override
  Widget build(BuildContext context) => const _TabBarScene(single: true);
}
// end-doc-region SingleTabBarComponentExample

/// 与 Compose TabBarDemo 使用相同文案、图标、状态和覆盖布局，不挤占正文。
class _TabBarScene extends StatefulWidget {
  const _TabBarScene({this.single = false, this.actions = false});
  final bool single, actions;

  @override
  State<_TabBarScene> createState() => _TabBarSceneState();
}

class _TabBarSceneState extends State<_TabBarScene> {
  static const _items = [
    HyperTabItem(icon: LucideIcons.house, label: '首页'),
    HyperTabItem(icon: LucideIcons.info, label: '最近'),
    HyperTabItem(icon: LucideIcons.list, label: '列表'),
    HyperTabItem(icon: LucideIcons.compass, label: '发现'),
    HyperTabItem(icon: LucideIcons.settings, label: '设置'),
  ];
  static const _message = HyperTabItem(icon: LucideIcons.bell, label: '消息');
  int _selected = 0;
  late int _count = widget.actions ? 0 : 3;

  @override
  Widget build(BuildContext context) {
    final single = widget.single;
    final actions = widget.actions;
    final label = single ? _message.label : _items[_selected].label;
    final navigation = HyperTabBar(
      // 悬浮栏在并排宿主中共用间距；非悬浮栏固定由内部 HyperSafeArea 避让。
      safeArea: false,
      margin: EdgeInsets.zero,
      type: single ? 'single' : 'multiple',
      floating: !actions,
      items: single ? const [_message] : _items,
      selectedIndex: actions
          ? null
          : single
          ? 0
          : _selected,
      badgeCount: _count,
      itemEnabled: (item) => !actions || item.label != '最近',
      onChanged: (index) => setState(() {
        if (!single) _selected = index;
        if (single || actions) _count++;
      }),
    );
    return Stack(
      children: [
        Positioned.fill(
          child: Center(
            child: Text(actions ? '最近动作：$label · $_count 次' : '当前页面：$label'),
          ),
        ),
        if (single)
          Align(
            alignment: Alignment.topCenter,
            child: HyperButton(
              onPressed: () => setState(() => _count = _count == 0 ? 3 : 0),
              content: const Text('切换角标'),
            ),
          ),
        Align(
          alignment: Alignment.bottomCenter,
          child: single || actions
              ? navigation
              : Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      HyperTabBar(
                        safeArea: false,
                        margin: EdgeInsets.zero,
                        type: 'single',
                        items: const [_message],
                        selectedIndex: null,
                        badgeCount: _count,
                        onChanged: (_) => setState(() => _count++),
                      ),
                      const SizedBox(width: 8),
                      Flexible(child: navigation),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}

// doc-region TrailingTabBarComponentExample
/// 对应 Kotlin 文档的两项导航加右侧独立打开入口。
class TrailingTabBarComponentExample extends StatefulWidget {
  const TrailingTabBarComponentExample({super.key});

  @override
  State<TrailingTabBarComponentExample> createState() => _TrailingTabBarState();
}

class _TrailingTabBarState extends State<TrailingTabBarComponentExample> {
  int _selected = 0;
  int _count = 0;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Expanded(
        child: Center(
          child: Text('当前：${['最近', '列表'][_selected]} · 打开 $_count 次'),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: HyperTabBar(
                safeArea: false,
                margin: EdgeInsets.zero,
                items: const [
                  HyperTabItem(icon: LucideIcons.info, label: '最近'),
                  HyperTabItem(icon: LucideIcons.house, label: '列表'),
                ],
                selectedIndex: _selected,
                onChanged: (index) => setState(() => _selected = index),
              ),
            ),
            const SizedBox(width: 8),
            HyperTabBar(
              safeArea: false,
              margin: EdgeInsets.zero,
              type: 'single',
              items: const [
                HyperTabItem(icon: LucideIcons.folderOpen, label: '打开'),
              ],
              selectedIndex: null,
              onChanged: (_) => setState(() => _count++),
            ),
          ],
        ),
      ),
    ],
  );
}
// end-doc-region TrailingTabBarComponentExample
