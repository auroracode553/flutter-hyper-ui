import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_hyper_ui/hy_ui.dart';

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
    return HySpace(
      alignment: CrossAxisAlignment.stretch,
      spacing: 18,
      children: <Widget>[
        const HyText('柔性玻璃组件库', variant: HyTextStyle.display),
        const HyText('统一材质、状态、动效与无障碍语义，不绑定任何业务。', variant: HyTextStyle.caption),
        HyNavBar(
          title: 'Navbar',
          subtitle: '内容可从玻璃层下方滚动',
          safeArea: false,
          floating: true,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            HyButton.icon(
              icon: LucideIcons.ellipsis,
              tooltip: '更多',
              onPressed: () => HyToast.show(context, 'Navbar action'),
            ),
          ],
        ),
        HyCard(
          title: 'TabBar',
          subtitle: '点击、拖拽、速度投影与边缘阻尼',
          child: HyTabBar(
            safeArea: false,
            margin: EdgeInsets.zero,
            selectedIndex: _tab,
            onSelected: (value) => setState(() => _tab = value),
            items: const <HyTabItem>[
              HyTabItem(icon: LucideIcons.house, label: '首页'),
              HyTabItem(icon: LucideIcons.compass, label: '发现'),
              HyTabItem(icon: LucideIcons.user, label: '我的'),
            ],
          ),
        ),
        HyCard(
          title: 'Button',
          child: Wrap(spacing: 8, runSpacing: 8,
            children: <Widget>[
              HyButton.filled(
                label: '主要操作',
                icon: LucideIcons.sparkles,
                onPressed: () => HyToast.show(context, '主要操作'),
              ),
              HyButton.tonal(label: '柔和', onPressed: () {}),
              HyButton.outline(label: '描边', onPressed: () {}),
              HyButton.ghost(label: '幽灵', onPressed: () {}),
              HyButton.danger(label: '危险', onPressed: () {}),
              const HyButton.filled(label: '加载中', loading: true),
            ],
          ),
        ),
        HyCard(
          title: 'TextField / Dropdown',
          child: HySpace(
            alignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const HyTextField(
                hintText: '输入关键词',
                prefix: Icon(LucideIcons.search),
              ),
              HyDropdown<String>(
                label: '材质厚度',
                value: _dropdown,
                options: const <HyOption<String>>[
                  HyOption(value: 'subtle', label: '轻薄'),
                  HyOption(value: 'regular', label: '标准'),
                  HyOption(value: 'prominent', label: '突出'),
                ],
                onChanged: (value) => setState(() => _dropdown = value),
              ),
            ],
          ),
        ),
        HyCard(
          title: 'Selection controls',
          child: HySpace(
            alignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              HyCheckbox(
                value: _checked,
                label: 'Checkbox',
                onChanged: (value) => setState(() => _checked = value ?? false),
              ),
              HyRadio<int>(
                value: 0,
                groupValue: _radio,
                label: 'Radio A',
                onChanged: (value) => setState(() => _radio = value),
              ),
              HyRadio<int>(
                value: 1,
                groupValue: _radio,
                label: 'Radio B',
                onChanged: (value) => setState(() => _radio = value),
              ),
              HySwitch(
                value: _enabled,
                label: 'Switch',
                onChanged: (value) => setState(() => _enabled = value),
              ),
              HySlider(
                value: _slider,
                divisions: 100,
                onChanged: (value) => setState(() => _slider = value),
              ),
            ],
          ),
        ),
        HyMenuGroup(
          title: 'MenuGroup',
          subtitle: '适用于设置页、个人中心与详情菜单。',
          children: <Widget>[
            HyListTile(
              grouped: true,
              title: '外观与显示',
              subtitle: '主题、字号和动态效果',
              leadingIcon: LucideIcons.palette,
              leadingColor: const Color(0xFF8C79CF),
              onTap: () => HyToast.show(context, '外观与显示'),
            ),
            HyListTile(
              grouped: true,
              title: '通知',
              leadingIcon: LucideIcons.bell,
              leadingColor: const Color(0xFFD69A4A),
              trailing: HySwitch(
                value: _enabled,
                onChanged: (value) => setState(() => _enabled = value),
              ),
              showChevron: false,
            ),
            HyListTile(
              grouped: true,
              title: '隐私与安全',
              leadingIcon: LucideIcons.shield,
              leadingColor: const Color(0xFF5C9C88),
              onTap: () {},
            ),
          ],
        ),
        HyCard(
          title: 'SlideMenu',
          subtitle: '向左拖动显示操作',
          padding: const EdgeInsets.all(8),
          child: HySlideMenu(
            endActions: <HySlideAction>[
              HySlideAction(
                label: '置顶',
                icon: LucideIcons.arrowUpToLine,
                color: const Color(0xFF6B7280),
                onPressed: () => HyToast.show(context, '已置顶'),
              ),
              HySlideAction(
                label: '删除',
                icon: LucideIcons.trash,
                onPressed: () =>
                    HyToast.show(context, '已删除', tone: HyUiTone.error),
              ),
            ],
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  HyAvatar(text: 'HY'),
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
        HyCard(
          title: 'Drawer / Toast / Skeleton',
          child: HySpace(
            alignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Wrap(spacing: 8, runSpacing: 8,
                children: <Widget>[
                  HyButton.tonal(
                    label: '打开抽屉',
                    onPressed: () => HyDrawer.show<void>(
                      context,
                      title: '通用抽屉',
                      builder: (_) => const HyMenuGroup(
                        children: <Widget>[
                          HyListTile(grouped: true, title: '筛选条件'),
                          HyListTile(grouped: true, title: '排序方式'),
                          HyListTile(grouped: true, title: '显示选项'),
                        ],
                      ),
                    ),
                  ),
                  HyButton.tonal(
                    label: '显示 Toast',
                    onPressed: () => HyToast.show(
                      context,
                      '操作已完成',
                      tone: HyUiTone.success,
                      actionLabel: '撤销',
                      onAction: () {},
                    ),
                  ),
                ],
              ),
              const HySkeleton(card: true, rows: 2),
            ],
          ),
        ),
      ],
    );
  }
}
