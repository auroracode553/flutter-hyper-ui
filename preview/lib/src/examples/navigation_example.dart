import 'package:flutter_hyper_ui/hyper_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class NavigationExample extends StatelessWidget {
  const NavigationExample({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        HyperNavBar(
          title: const Text('最近文档'),
          subtitle: const Text('共 24 个项目'),
          safeArea: false,
          actions: [
            HyperButton.icon(
              icon: LucideIcons.search,
              tooltip: '搜索',
              onPressed: () {},
            ),
            HyperButton.icon(
              icon: LucideIcons.listChecks,
              tooltip: '选择',
              onPressed: () {},
            ),
          ],
        ),
        HyperDivider(color: tokens.border),
        const SizedBox(height: HyperUiSpacing.sm),
        HyperListTile(
          title: '阅读计划.md',
          subtitle: 'Markdown · 今天',
          leadingIcon: LucideIcons.braces,
          leadingColor: tokens.foreground,
        ),
        const SizedBox(height: HyperUiSpacing.xs),
        HyperListTile(
          title: '销售预测.xlsx',
          subtitle: '表格 · 昨天',
          leadingIcon: LucideIcons.table,
          leadingColor: tokens.success,
        ),
      ],
    );
  }
}
