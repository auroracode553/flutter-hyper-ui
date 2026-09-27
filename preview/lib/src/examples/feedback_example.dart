import 'package:flutter_hyper_ui/hyper_ui.dart';
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
          spacing: HyperUiSpacing.xs,
          runSpacing: HyperUiSpacing.xs,
          children: [
            HyperBadge(
              label: '已完成',
              tone: HyperUiTone.success,
              icon: LucideIcons.circleCheckBig,
            ),
            HyperBadge(
              label: '需关注',
              tone: HyperUiTone.warning,
              icon: LucideIcons.info,
            ),
            HyperBadge(
              label: '失败',
              tone: HyperUiTone.error,
              icon: LucideIcons.circleAlert,
            ),
          ],
        ),
        const SizedBox(height: HyperUiSpacing.lg),
        HyperEmptyState(
          icon: LucideIcons.folderX,
          title: '暂无最近文档',
          message: '打开文件后，最近访问记录会显示在这里。',
          action: HyperButton.filled(
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
