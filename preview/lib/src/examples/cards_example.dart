import 'package:flutter_hyper_ui/doc_ui.dart';
import 'package:flutter/material.dart';

class CardsExample extends StatelessWidget {
  const CardsExample({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = DocUiThemeTokens.of(context);

    return Wrap(
      spacing: DocUiSpacing.sm,
      runSpacing: DocUiSpacing.sm,
      children: [
        SizedBox(
          width: 340,
          child: DocCard(
            title: '季度文档归档',
            subtitle: '12 个文件 · 最近更新 09:42',
            leading: _IconBox(
              icon: Icons.folder_open_outlined,
              color: tokens.primary,
            ),
            actions: const [
              DocBadge(label: '同步中', tone: DocUiTone.info),
            ],
            footer: const Row(
              children: [
                Expanded(child: DocProgressBar(value: 0.68)),
                SizedBox(width: DocUiSpacing.sm),
                Text('68%'),
              ],
            ),
            child: Text(
              '合同、报价单与会议纪要正在归档，完成后会写入最近文档列表。',
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
          child: DocCard(
            selected: true,
            title: '会议纪要归档',
            subtitle: '已加入批量处理队列。',
            leading: _IconBox(
              icon: Icons.check_circle_outline,
              color: tokens.success,
            ),
            child: const Wrap(
              spacing: DocUiSpacing.xs,
              runSpacing: DocUiSpacing.xs,
              children: [
                DocTag(label: 'PDF', selected: true),
                DocTag(label: 'DOCX'),
                DocTag(label: 'Markdown'),
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
    final tokens = DocUiThemeTokens.of(context);

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(DocUiRadii.sm),
      ),
      child: Icon(
        icon,
        size: 20,
        color: tokens.primaryForeground,
      ),
    );
  }
}
