import 'package:flutter_hyper_ui/doc_ui.dart';
import 'package:flutter/material.dart';

class DataExample extends StatelessWidget {
  const DataExample({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = DocUiThemeTokens.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: DocUiSpacing.xs,
          runSpacing: DocUiSpacing.xs,
          children: const [
            DocBadge(label: 'PDF', tone: DocUiTone.error),
            DocBadge(label: 'Word', tone: DocUiTone.primary),
            DocBadge(label: '表格', tone: DocUiTone.success),
            DocBadge(label: '文本', tone: DocUiTone.warning),
          ],
        ),
        const SizedBox(height: DocUiSpacing.md),
        DocListTile(
          title: '产品需求说明.pdf',
          subtitle: 'PDF 文档 · 最近打开 08:30',
          meta: '12.6 MB',
          leadingIcon: Icons.picture_as_pdf_outlined,
          leadingColor: tokens.error,
        ),
        const SizedBox(height: DocUiSpacing.xs),
        DocListTile(
          title: '会议纪要.docx',
          subtitle: 'Word 文档 · 最近打开 昨天',
          meta: '386 KB',
          selected: true,
          leadingIcon: Icons.article_outlined,
          leadingColor: tokens.primary,
        ),
        const SizedBox(height: DocUiSpacing.md),
        const DocProgressBar(value: 0.42),
      ],
    );
  }
}
