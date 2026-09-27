import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';

/// 首页英雄区真机预览：用真实 Hyper UI 组件拼成一个手机首页，
/// 开关、底部导航均可交互。
class HomeHeroExample extends StatefulWidget {
  const HomeHeroExample({super.key});

  @override
  State<HomeHeroExample> createState() => _HomeHeroExampleState();
}

class _HomeHeroExampleState extends State<HomeHeroExample> {
  bool _notifications = true;
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const HyperText('下午好', type: 'h5'),
        const HyperText('保持从容，专注重要的事。', type: 'h1'),
        const SizedBox(height: 8),

        // 今日进度
        HyperCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HyperText('今日进度'),
                  HyperText('72%', type: 'h2'),
                ],
              ),
              const SizedBox(height: 12),
              const HyperProgress(value: 0.72, showLabel: false),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 设置项：外观与显示
        HyperCard(
          onTap: () => HyperToast.show(context, '打开外观与显示'),
          child: Row(
            children: [
              const HyperIcon(HyperIcons.settings),
              const SizedBox(width: 12),
              const Expanded(child: HyperText('外观与显示')),
              HyperIcon(
                LucideIcons.chevronRight,
                color: HyperUiThemeTokens.of(context).mutedForeground,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 设置项：通知开关
        HyperCard(
          child: Row(
            children: [
              const HyperIcon(LucideIcons.bell),
              const SizedBox(width: 12),
              const Expanded(child: HyperText('通知')),
              HyperSwitch(
                value: _notifications,
                onChanged: (value) => setState(() => _notifications = value),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 底部导航
        HyperTabBar(
          selectedIndex: _tab,
          onSelected: (index) => setState(() => _tab = index),
          items: const [
            HyperTabItem(icon: LucideIcons.house, label: '首页'),
            HyperTabItem(icon: LucideIcons.zap, label: '发现'),
            HyperTabItem(icon: LucideIcons.user, label: '我的'),
          ],
        ),
      ],
    );
  }
}
