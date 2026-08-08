import 'package:flutter_hyper_ui/doc_ui.dart';
import 'package:flutter/material.dart';

class ButtonsExample extends StatelessWidget {
  const ButtonsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: DocUiSpacing.xs,
          runSpacing: DocUiSpacing.xs,
          children: [
            DocButton.filled(
              label: '打开文件',
              icon: Icons.add,
              onPressed: _noop,
            ),
            DocButton.tonal(
              label: '同步状态',
              icon: Icons.sync,
              onPressed: _noop,
            ),
            DocButton.outline(
              label: '导出',
              icon: Icons.ios_share,
              onPressed: _noop,
            ),
            DocButton.ghost(
              label: '更多',
              trailingIcon: Icons.keyboard_arrow_down,
              onPressed: _noop,
            ),
            DocButton.danger(
              label: '删除',
              icon: Icons.delete_outline,
              onPressed: _noop,
            ),
          ],
        ),
        const SizedBox(height: DocUiSpacing.md),
        Wrap(
          spacing: DocUiSpacing.xs,
          runSpacing: DocUiSpacing.xs,
          children: [
            DocButton.filled(
              label: '小按钮',
              size: DocButtonSize.sm,
              onPressed: _noop,
            ),
            DocButton.filled(
              label: '默认按钮',
              onPressed: _noop,
            ),
            DocButton.filled(
              label: '大按钮',
              size: DocButtonSize.lg,
              onPressed: _noop,
            ),
            DocButton.outline(
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
