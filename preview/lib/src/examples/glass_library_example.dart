import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';

/// 通用组件总览，不依赖任何业务模型或路由结构。
class GlassLibraryExample extends StatefulWidget {
  const GlassLibraryExample({super.key});

  @override
  State<GlassLibraryExample> createState() => _GlassLibraryExampleState();
}

class _GlassLibraryExampleState extends State<GlassLibraryExample> {
  int _tab = 0;
  int _radio = 0;
  bool _checked = true;
  bool _enabled = true;
  double _slider = 62;
  String? _dropdown = 'regular';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 18,
      children: <Widget>[
        const HyperText('柔性玻璃组件库', size: 'large'),
        const HyperText('统一材质、状态与动效，不绑定任何业务。', size: 'small'),
        HyperNavBar(
          title: const Text('Navbar'),
          subtitle: const Text('44px 透明导航栏'),
          safeArea: false,
          showBackButton: false,
          actions: <Widget>[
            HyperButton(
              type: 'tonal',
              icon: LucideIcons.ellipsis,
              tooltip: '更多',
              onPressed: () => HyperToast.show(context, 'Navbar action'),
            ),
          ],
        ),
        HyperCard(
          title: 'TabBar',
          subtitle: '点击、拖拽、速度投影与边缘阻尼',
          child: HyperTabBar(
            safeArea: false,
            selectedIndex: _tab,
            onSelected: (value) => setState(() => _tab = value),
            items: const <HyperTabItem>[
              HyperTabItem(icon: LucideIcons.house, label: '首页'),
              HyperTabItem(icon: LucideIcons.compass, label: '发现'),
              HyperTabItem(icon: LucideIcons.user, label: '我的'),
            ],
          ),
        ),
        HyperCard(
          title: 'Button',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              HyperButton(
                label: '主要操作',
                icon: LucideIcons.sparkles,
                onPressed: () => HyperToast.show(context, '主要操作'),
              ),
              HyperButton(type: 'tonal', label: '柔和', onPressed: () {}),
              HyperButton(type: 'outline', label: '描边', onPressed: () {}),
              HyperButton(type: 'ghost', label: '幽灵', onPressed: () {}),
              HyperButton(type: 'danger', label: '危险', onPressed: () {}),
              const HyperButton(label: '加载中', loading: true),
            ],
          ),
        ),
        HyperCard(
          title: 'TextField / Dropdown',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const HyperTextField(
                type: 'search',
                hintText: '输入关键词',
                prefix: Icon(LucideIcons.search),
              ),
              HyperDropdown<String>(
                label: '材质厚度',
                value: _dropdown,
                options: const <HyperOption<String>>[
                  HyperOption(value: 'subtle', label: '轻薄'),
                  HyperOption(value: 'regular', label: '标准'),
                  HyperOption(value: 'prominent', label: '突出'),
                ],
                onChanged: (value) => setState(() => _dropdown = value),
              ),
            ],
          ),
        ),
        HyperCard(
          title: 'Selection controls',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              HyperCheckbox(
                value: _checked,
                label: 'Checkbox',
                onChanged: (value) => setState(() => _checked = value ?? false),
              ),
              HyperRadio<int>(
                value: 0,
                groupValue: _radio,
                label: 'Radio A',
                onChanged: (value) => setState(() => _radio = value),
              ),
              HyperRadio<int>(
                value: 1,
                groupValue: _radio,
                label: 'Radio B',
                onChanged: (value) => setState(() => _radio = value),
              ),
              HyperSwitch(
                value: _enabled,
                label: 'Switch',
                onChanged: (value) => setState(() => _enabled = value),
              ),
              HyperSlider(
                value: _slider,
                divisions: 100,
                onChanged: (value) => setState(() => _slider = value),
              ),
            ],
          ),
        ),
        HyperMenuGroup(
          title: 'MenuGroup',
          subtitle: '适用于设置页、个人中心与详情菜单。',
          children: <Widget>[
            HyperListTile(
              title: '外观与显示',
              subtitle: '主题、字号和动态效果',
              leadingIcon: LucideIcons.palette,
              leadingColor: const Color(0xFF8C79CF),
              onTap: () => HyperToast.show(context, '外观与显示'),
            ),
            HyperListTile(
              title: '通知',
              leadingIcon: LucideIcons.bell,
              leadingColor: const Color(0xFFD69A4A),
              trailing: HyperSwitch(
                value: _enabled,
                onChanged: (value) => setState(() => _enabled = value),
              ),
              showChevron: false,
            ),
            HyperListTile(
              title: '隐私与安全',
              leadingIcon: LucideIcons.shield,
              leadingColor: const Color(0xFF5C9C88),
              onTap: () {},
            ),
          ],
        ),
        HyperCard(
          title: 'SlideMenu',
          subtitle: '向左拖动显示操作',
          padding: const EdgeInsets.all(8),
          child: HyperSlideMenu(
            endActions: <HyperSlideAction>[
              HyperSlideAction(
                label: '置顶',
                icon: LucideIcons.arrowUpToLine,
                color: const Color(0xFF6B7280),
                onPressed: () => HyperToast.show(context, '已置顶'),
              ),
              HyperSlideAction(
                label: '删除',
                icon: LucideIcons.trash,
                type: 'danger',
                onPressed: () => HyperToast.show(context, '已删除', type: 'error'),
              ),
            ],
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  HyperAvatar(text: 'UI'),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('可侧滑的通用列表项'),
                        Text('操作数量和颜色均可配置'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        HyperCard(
          title: 'Drawer / Toast / Skeleton',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  HyperButton(
                    type: 'tonal',
                    label: '打开抽屉',
                    onPressed: () => HyperDrawer.show<void>(
                      context,
                      title: '通用抽屉',
                      builder: (_) => const HyperMenuGroup(
                        children: <Widget>[
                          HyperListTile(title: '筛选条件'),
                          HyperListTile(title: '排序方式'),
                          HyperListTile(title: '显示选项'),
                        ],
                      ),
                    ),
                  ),
                  HyperButton(
                    type: 'tonal',
                    label: '显示 Toast',
                    onPressed: () => HyperToast.show(
                      context,
                      '操作已完成',
                      type: 'success',
                      actionLabel: '撤销',
                      onAction: () {},
                    ),
                  ),
                ],
              ),
              const HyperSkeleton(type: 'card', rows: 2),
            ],
          ),
        ),
      ],
    );
  }
}
