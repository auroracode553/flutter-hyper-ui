import 'package:flutter_hyper_ui/hy_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class NavigationExample extends StatelessWidget {
  const NavigationExample({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        HyTopBar(
          title: '最近文档',
          subtitle: '共 24 个项目',
          safeArea: false,
          actions: [
            HyIconButton(
              icon: LucideIcons.search,
              tooltip: '搜索',
              onPressed: () {},
            ),
            HyIconButton(
              icon: LucideIcons.listChecks,
              tooltip: '选择',
              onPressed: () {},
            ),
          ],
        ),
        HyDivider(color: tokens.border),
        const SizedBox(height: HyUiSpacing.sm),
        HyListTile(
          title: '阅读计划.md',
          subtitle: 'Markdown · 今天',
          leadingIcon: LucideIcons.braces,
          leadingColor: tokens.foreground,
        ),
        const SizedBox(height: HyUiSpacing.xs),
        HyListTile(
          title: '销售预测.xlsx',
          subtitle: '表格 · 昨天',
          leadingIcon: LucideIcons.table,
          leadingColor: tokens.success,
        ),
      ],
    );
  }
}
