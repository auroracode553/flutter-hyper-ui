import 'package:flutter_hyper_ui/hy_ui.dart';
import 'package:flutter/material.dart';

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
            IconButton(
              onPressed: () {},
              tooltip: '搜索',
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {},
              tooltip: '选择',
              icon: const Icon(Icons.checklist),
            ),
          ],
        ),
        Divider(color: tokens.border),
        const SizedBox(height: HyUiSpacing.sm),
        HyListTile(
          title: '阅读计划.md',
          subtitle: 'Markdown · 今天',
          leadingIcon: Icons.data_object_outlined,
          leadingColor: tokens.foreground,
        ),
        const SizedBox(height: HyUiSpacing.xs),
        HyListTile(
          title: '销售预测.xlsx',
          subtitle: '表格 · 昨天',
          leadingIcon: Icons.table_chart_outlined,
          leadingColor: tokens.success,
        ),
      ],
    );
  }
}
