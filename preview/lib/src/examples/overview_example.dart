import 'package:flutter_hyper_ui/hyper_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class OverviewExample extends StatelessWidget {
  const OverviewExample({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);

    return Wrap(
      spacing: HyperUiSpacing.sm,
      runSpacing: HyperUiSpacing.sm,
      children: [
        _OverviewTile(
          title: 'Button',
          subtitle: '动作按钮',
          icon: LucideIcons.hand,
          color: tokens.primary,
          child: HyperButton.filled(
            label: '打开',
            onPressed: _noop,
          ),
        ),
        _OverviewTile(
          title: 'Input',
          subtitle: '输入控件',
          icon: LucideIcons.squarePen,
          color: tokens.warning,
          child: const HyperTextField(hintText: '搜索文件'),
        ),
        _OverviewTile(
          title: 'Data',
          subtitle: '数据展示',
          icon: LucideIcons.list,
          color: tokens.success,
          child: const HyperProgress(value: 0.72, strokeWidth: 8, showLabel: false),
        ),
        _OverviewTile(
          title: 'Feedback',
          subtitle: '状态反馈',
          icon: LucideIcons.lightbulb,
          color: tokens.info,
          child: const HyperBadge(
            label: '已同步',
            tone: HyperUiTone.success,
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
    final tokens = HyperUiThemeTokens.of(context);

    return SizedBox(
      width: 220,
      child: HyperCard(
        title: title,
        subtitle: subtitle,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(HyperUiRadii.sm),
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
