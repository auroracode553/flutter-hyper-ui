import 'package:flutter_hyper_ui/hy_ui.dart';
import 'package:flutter/material.dart';

class CardsExample extends StatelessWidget {
  const CardsExample({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);

    return Wrap(
      spacing: HyUiSpacing.sm,
      runSpacing: HyUiSpacing.sm,
      children: [
        SizedBox(
          width: 340,
          child: HyCard(
            title: '本周活动计划',
            subtitle: '12 项活动 · 最近更新 09:42',
            leading: _IconBox(
              icon: Icons.folder_open_outlined,
              color: tokens.primary,
            ),
            actions: const [
              HyBadge(label: '同步中', tone: HyUiTone.info),
            ],
            footer: const Row(
              children: [
                Expanded(child: HyProgressBar(value: 0.68)),
                SizedBox(width: HyUiSpacing.sm),
                Text('68%'),
              ],
            ),
            child: Text(
              '本周的活动正在同步，完成后会更新你的个人日程。',
              style: TextStyle(
                color: tokens.mutedForeground,
                fontSize: 14,
                height: 1.45,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 300,
          child: HyCard(
            selected: true,
            title: '周末出行计划',
            subtitle: '已加入批量处理队列。',
            leading: _IconBox(
              icon: Icons.check_circle_outline,
              color: tokens.success,
            ),
            child: const Wrap(
              spacing: HyUiSpacing.xs,
              runSpacing: HyUiSpacing.xs,
              children: [
                HyTag(label: '旅行', selected: true),
                HyTag(label: '精选'),
                HyTag(label: '日常'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _IconBox({
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(HyUiRadii.sm),
      ),
      child: Icon(
        icon,
        size: 20,
        color: tokens.primaryForeground,
      ),
    );
  }
}
