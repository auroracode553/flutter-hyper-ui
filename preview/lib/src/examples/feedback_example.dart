import 'package:flutter_hyper_ui/hy_ui.dart';
import 'package:flutter/material.dart';

class FeedbackExample extends StatelessWidget {
  const FeedbackExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Wrap(
          spacing: HyUiSpacing.xs,
          runSpacing: HyUiSpacing.xs,
          children: [
            HyBadge(
              label: '已完成',
              tone: HyUiTone.success,
              icon: Icons.check_circle_outline,
            ),
            HyBadge(
              label: '需关注',
              tone: HyUiTone.warning,
              icon: Icons.info_outline,
            ),
            HyBadge(
              label: '失败',
              tone: HyUiTone.error,
              icon: Icons.error_outline,
            ),
          ],
        ),
        const SizedBox(height: HyUiSpacing.lg),
        HyEmptyState(
          icon: Icons.folder_off_outlined,
          title: '暂无最近文档',
          message: '打开文件后，最近访问记录会显示在这里。',
          action: HyButton.filled(
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
