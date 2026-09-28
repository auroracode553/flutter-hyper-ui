import 'package:flutter_hyper_ui/hyper_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DataExample extends StatelessWidget {
  const DataExample({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: HyperUiSpacing.xs,
          runSpacing: HyperUiSpacing.xs,
          children: const [
            HyperBadge(label: '旅行', tone: HyperUiTone.error),
            HyperBadge(label: 'Word', tone: HyperUiTone.primary),
            HyperBadge(label: '表格', tone: HyperUiTone.success),
            HyperBadge(label: '文本', tone: HyperUiTone.warning),
          ],
        ),
        const SizedBox(height: HyperUiSpacing.md),
        HyperListTile(
          title: '产品需求说明.pdf',
          subtitle: 'PDF 文档 · 最近打开 08:30',
          meta: '12.6 MB',
          leadingIcon: LucideIcons.fileText,
          leadingColor: tokens.error,
        ),
        const SizedBox(height: HyperUiSpacing.xs),
        HyperListTile(
          title: '周末出行计划',
          subtitle: 'Word 文档 · 最近打开 昨天',
          meta: '386 KB',
          selected: true,
          leadingIcon: LucideIcons.fileText,
          leadingColor: tokens.primary,
        ),
        const SizedBox(height: HyperUiSpacing.md),
        const HyperProgress(value: 0.42, size: 'large', showLabel: false),
      ],
    );
  }
}
