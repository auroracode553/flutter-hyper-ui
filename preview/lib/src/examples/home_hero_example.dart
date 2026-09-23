import 'package:flutter/material.dart';
import 'package:flutter_hyper_ui/hy_ui.dart';

/// 首页英雄区真机预览：用真实 Hy UI 组件拼成一个手机首页，
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
    return HySpace(
      alignment: CrossAxisAlignment.stretch,
      children: [
        const HyText('下午好', variant: HyTextStyle.caption),
        const HyText('保持从容，专注重要的事。',
            variant: HyTextStyle.display),
        const SizedBox(height: 8),

        // 今日进度
        HyCard(
          child: HySpace(children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HyText('今日进度'),
                HyText('72%', variant: HyTextStyle.title),
              ],
            ),
            const SizedBox(height: 12),
            const HyProgress(value: 0.72, showLabel: false),
          ]),
        ),
        const SizedBox(height: 12),

        // 设置项：外观与显示
        HyCard(
          onTap: () => HyToast.show(context, '打开外观与显示'),
          child: Row(children: [
            const HyIcon(HyIcons.settings),
            const SizedBox(width: 12),
            const Expanded(child: HyText('外观与显示')),
            HyIcon(Icons.chevron_right,
                color: HyUiThemeTokens.of(context).mutedForeground),
          ]),
        ),
        const SizedBox(height: 12),

        // 设置项：通知开关
        HyCard(
          child: Row(children: [
            const HyIcon(Icons.notifications_outlined),
            const SizedBox(width: 12),
            const Expanded(child: HyText('通知')),
            HySwitch(
              value: _notifications,
              onChanged: (value) =>
                  setState(() => _notifications = value),
            ),
          ]),
        ),
        const SizedBox(height: 16),

        // 底部导航
        HyTabBar(
          selectedIndex: _tab,
          onSelected: (index) => setState(() => _tab = index),
          items: const [
            HyTabItem(icon: Icons.home_outlined, label: '首页'),
            HyTabItem(icon: Icons.bolt_outlined, label: '发现'),
            HyTabItem(icon: Icons.person_outline, label: '我的'),
          ],
        ),
      ],
    );
  }
}
