import 'package:flutter_hyper_ui/hy_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ButtonsExample extends StatelessWidget {
  const ButtonsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: HyUiSpacing.xs,
          runSpacing: HyUiSpacing.xs,
          children: [
            HyButton.filled(
              label: '打开文件',
              icon: LucideIcons.plus,
              onPressed: _noop,
            ),
            HyButton.tonal(
              label: '同步状态',
              icon: LucideIcons.refreshCw,
              onPressed: _noop,
            ),
            HyButton.outline(
              label: '导出',
              icon: LucideIcons.share2,
              onPressed: _noop,
            ),
            HyButton.ghost(
              label: '更多',
              trailingIcon: LucideIcons.chevronDown,
              onPressed: _noop,
            ),
            HyButton.danger(
              label: '删除',
              icon: LucideIcons.trash,
              onPressed: _noop,
            ),
          ],
        ),
        const SizedBox(height: HyUiSpacing.md),
        Wrap(
          spacing: HyUiSpacing.xs,
          runSpacing: HyUiSpacing.xs,
          children: [
            HyButton.filled(
              label: '小按钮',
              size: HyButtonSize.sm,
              onPressed: _noop,
            ),
            HyButton.filled(
              label: '默认按钮',
              onPressed: _noop,
            ),
            HyButton.filled(
              label: '大按钮',
              size: HyButtonSize.lg,
              onPressed: _noop,
            ),
            HyButton.outline(
              label: '处理中',
              loading: true,
              onPressed: _noop,
            ),
          ],
        ),
      ],
    );
  }
}

void _noop() {}
