import 'package:flutter_hyper_ui/doc_ui.dart';
import 'package:flutter/material.dart';

class FeedbackExample extends StatelessWidget {
  const FeedbackExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Wrap(
          spacing: DocUiSpacing.xs,
          runSpacing: DocUiSpacing.xs,
          children: [
            DocBadge(
              label: '已完成',
              tone: DocUiTone.success,
              icon: Icons.check_circle_outline,
            ),
            DocBadge(
              label: '需关注',
              tone: DocUiTone.warning,
              icon: Icons.info_outline,
            ),
            DocBadge(
              label: '失败',
              tone: DocUiTone.error,
              icon: Icons.error_outline,
            ),
          ],
        ),
        const SizedBox(height: DocUiSpacing.lg),
        DocEmptyState(
          icon: Icons.folder_off_outlined,
          title: '暂无最近文档',
          message: '打开文件后，最近访问记录会显示在这里。',
          action: DocButton.filled(
            label: '选择文件',
            icon: Icons.add,
            onPressed: _noop,
          ),
        ),
      ],
    );
  }
}

void _noop() {}
