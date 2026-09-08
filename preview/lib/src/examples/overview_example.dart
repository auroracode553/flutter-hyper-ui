import 'package:flutter_hyper_ui/hy_ui.dart';
import 'package:flutter/material.dart';

class OverviewExample extends StatelessWidget {
  const OverviewExample({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);

    return Wrap(
      spacing: HyUiSpacing.sm,
      runSpacing: HyUiSpacing.sm,
      children: [
        _OverviewTile(
          title: 'Button',
          subtitle: '动作按钮',
          icon: Icons.touch_app_outlined,
          color: tokens.primary,
          child: HyButton.filled(
            label: '打开',
            onPressed: _noop,
          ),
        ),
        _OverviewTile(
          title: 'Input',
          subtitle: '输入控件',
          icon: Icons.edit_note_outlined,
          color: tokens.warning,
          child: const HyTextField(hintText: '搜索文件'),
        ),
        _OverviewTile(
          title: 'Data',
          subtitle: '数据展示',
          icon: Icons.view_list_outlined,
          color: tokens.success,
          child: const HyProgressBar(value: 0.72),
        ),
        _OverviewTile(
          title: 'Feedback',
          subtitle: '状态反馈',
          icon: Icons.tips_and_updates_outlined,
          color: tokens.info,
          child: const HyBadge(
            label: '已同步',
            tone: HyUiTone.success,
          ),
        ),
      ],
    );
  }
}

class _OverviewTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget child;

  const _OverviewTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);

    return SizedBox(
      width: 220,
      child: HyCard(
        title: title,
        subtitle: subtitle,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(HyUiRadii.sm),
          ),
          child: Icon(
            icon,
            color: tokens.primaryForeground,
            size: 20,
          ),
        ),
        child: child,
      ),
    );
  }
}

void _noop() {}
