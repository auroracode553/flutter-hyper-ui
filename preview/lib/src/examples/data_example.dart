import 'package:flutter_hyper_ui/hy_ui.dart';
import 'package:flutter/material.dart';

class DataExample extends StatelessWidget {
  const DataExample({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: HyUiSpacing.xs,
          runSpacing: HyUiSpacing.xs,
          children: const [
            HyBadge(label: '旅行', tone: HyUiTone.error),
            HyBadge(label: 'Word', tone: HyUiTone.primary),
            HyBadge(label: '表格', tone: HyUiTone.success),
            HyBadge(label: '文本', tone: HyUiTone.warning),
          ],
        ),
        const SizedBox(height: HyUiSpacing.md),
        HyListTile(
          title: '产品需求说明.pdf',
          subtitle: 'PDF 文档 · 最近打开 08:30',
          meta: '12.6 MB',
          leadingIcon: Icons.picture_as_pdf_outlined,
          leadingColor: tokens.error,
        ),
        const SizedBox(height: HyUiSpacing.xs),
        HyListTile(
          title: '周末出行计划',
          subtitle: 'Word 文档 · 最近打开 昨天',
          meta: '386 KB',
          selected: true,
          leadingIcon: Icons.article_outlined,
          leadingColor: tokens.primary,
        ),
        const SizedBox(height: HyUiSpacing.md),
        const HyProgressBar(value: 0.42),
      ],
    );
  }
}
