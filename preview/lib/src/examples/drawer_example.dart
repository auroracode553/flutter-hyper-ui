import 'package:flutter/widgets.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';

class DrawerExample extends StatefulWidget {
  const DrawerExample({super.key});

  @override
  State<DrawerExample> createState() => _DrawerExampleState();
}

class _DrawerExampleState extends State<DrawerExample> {
  String _result = '尚未选择';

  Future<void> _openMenu() async {
    final result = await HyperDrawer.show<String>(
      context,
      title: '工作空间',
      placement: HyperDrawerPlacement.start,
      width: 300,
      scrollable: false,
      builder: (drawerContext) => ListView(
        padding: EdgeInsets.zero,
        children: [
          for (final label in ['概览', '我的项目', '收藏', '设置'])
            HyperListTile(
              title: label,
              showChevron: true,
              onTap: () => Navigator.pop(drawerContext, label),
            ),
        ],
      ),
    );
    if (!mounted) return;
    setState(() => _result = result ?? '已取消');
  }

  Future<void> _openFilters() async {
    var onlyUnread = false;
    final result = await HyperDrawer.show<bool>(
      context,
      title: '筛选通知',
      dismissible: false,
      builder: (drawerContext) => StatefulBuilder(
        builder: (context, setDrawerState) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('此示例关闭了遮罩点击；可通过关闭按钮或返回键取消。'),
            const SizedBox(height: 20),
            HyperListTile(
              title: '仅显示未读',
              trailing: HyperSwitch(
                value: onlyUnread,
                onChanged: (value) => setDrawerState(() => onlyUnread = value),
              ),
              onTap: () => setDrawerState(() => onlyUnread = !onlyUnread),
            ),
            const HyperTextField(hintText: '输入关键词，查看键盘适配'),
            const SizedBox(height: 20),
            for (var index = 1; index <= 12; index++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text('通知分类 $index'),
              ),
          ],
        ),
      ),
      footerBuilder: (drawerContext) => HyperButton(
        label: '应用筛选',
        onPressed: () => Navigator.pop(drawerContext, onlyUnread),
      ),
    );
    if (!mounted) return;
    setState(
      () => _result = result == null
          ? '已取消'
          : result
          ? '仅显示未读'
          : '显示全部通知',
    );
  }

  @override
  Widget build(BuildContext context) => HyperCard(
    title: '抽屉',
    subtitle: '侧边导航与筛选面板，沿用柔光玻璃材质。',
    child: Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            HyperButton.tonal(label: '左侧导航', onPressed: _openMenu),
            HyperButton.tonal(label: '右侧筛选', onPressed: _openFilters),
          ],
        ),
        Text('返回结果：$_result'),
      ],
    ),
  );
}
