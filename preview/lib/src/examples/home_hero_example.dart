import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';

/// 首页英雄区真机预览：用真实 Hyper UI 组件拼成一个库介绍首页，
/// 开关、底部导航均可交互。
class HomeHeroExample extends StatefulWidget {
  const HomeHeroExample({super.key});

  @override
  State<HomeHeroExample> createState() => _HomeHeroExampleState();
}

class _HomeHeroExampleState extends State<HomeHeroExample> {
  bool _followSystemTheme = true;
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final muted = HyperUiThemeTokens.of(context).mutedForeground;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 品牌与定位
          const HyperText('HYPER UI · FLUTTER', size: 'small'),
          const HyperText('柔性玻璃组件库', size: 'large'),
          const SizedBox(height: 2),

          // 库数据
          HyperCard(
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _HeroStat(value: '48', label: '组件文档'),
                _HeroStat(value: '1', label: '第三方依赖'),
                _HeroStat(value: '2', label: '明暗主题'),
              ],
            ),
          ),

          // 特性：桌面端 · 移动端自适应
          HyperCard(
            onTap: () => HyperToast.show(context, '桌面端 · 移动端自适应'),
            child: Row(
              children: [
                const HyperIcon(LucideIcons.monitorSmartphone),
                const SizedBox(width: 10),
                const Expanded(child: HyperText('桌面端 · 移动端自适应')),
                HyperIcon(LucideIcons.chevronRight, color: muted),
              ],
            ),
          ),

          // 特性：明暗主题（开关可交互）
          HyperCard(
            child: Row(
              children: [
                const HyperIcon(LucideIcons.sunMoon),
                const SizedBox(width: 10),
                const Expanded(child: HyperText('跟随系统明暗主题')),
                HyperSwitch(
                  value: _followSystemTheme,
                  onChanged: (value) =>
                      setState(() => _followSystemTheme = value),
                ),
              ],
            ),
          ),

          // 开始使用
          HyperButton(
            label: '开始使用',
            onPressed: () => HyperToast.show(context, '开始使用 Hyper UI'),
          ),

          // 把底部导航顶到屏幕底部、home indicator 上方
          const Spacer(),

          // 底部导航
          HyperTabBar(
            selectedIndex: _tab,
            onSelected: (index) => setState(() => _tab = index),
            items: const [
              HyperTabItem(icon: LucideIcons.layers, label: '组件'),
              HyperTabItem(icon: LucideIcons.bookOpen, label: '文档'),
              HyperTabItem(icon: LucideIcons.palette, label: '主题'),
            ],
          ),
          // 让出底部 home indicator 安全区
          const SizedBox(height: 18),
        ],
      ),
    );
  }
}

/// 库数据项：数值 + 说明
class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        HyperText(value, size: 'default'),
        HyperText(label, size: 'small'),
      ],
    );
  }
}
