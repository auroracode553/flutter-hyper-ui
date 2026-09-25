import 'package:flutter_hyper_ui/hy_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
              icon: LucideIcons.circleCheckBig,
            ),
            HyBadge(
              label: '需关注',
              tone: HyUiTone.warning,
              icon: LucideIcons.info,
            ),
            HyBadge(
              label: '失败',
              tone: HyUiTone.error,
              icon: LucideIcons.circleAlert,
            ),
          ],
        ),
        const SizedBox(height: HyUiSpacing.lg),
        HyEmptyState(
          icon: LucideIcons.folderX,
          title: '暂无最近文档',
          message: '打开文件后，最近访问记录会显示在这里。',
          action: HyButton.filled(
            label: '选择文件',
            icon: LucideIcons.plus,
            onPressed: _noop,
          ),
        ),
      ],
    );
  }
}

void _noop() {}
