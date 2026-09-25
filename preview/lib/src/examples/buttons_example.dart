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
        // 文字按钮：尺寸与形状（默认按内容收缩，等价 inline-block）。
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
              round: true,
              onPressed: _noop,
            ),
            HyButton.outline(
              label: '处理中',
              loading: true,
              onPressed: _noop,
            ),
          ],
        ),
        const SizedBox(height: HyUiSpacing.md),
        // 带图标的按钮：图标 + 文字。
        Wrap(
          spacing: HyUiSpacing.xs,
          runSpacing: HyUiSpacing.xs,
          children: [
            HyButton.outline(
              label: '导出',
              icon: LucideIcons.share2,
              onPressed: _noop,
            ),
            HyButton.danger(
              label: '删除',
              icon: LucideIcons.trash,
              onPressed: _noop,
            ),
            HyButton.tonal(
              label: '带图标胶囊',
              icon: LucideIcons.settings,
              round: true,
              onPressed: _noop,
            ),
          ],
        ),
        const SizedBox(height: HyUiSpacing.md),
        // 图标按钮：仅图标，方形（省略 label 自动呈现）。
        Wrap(
          spacing: HyUiSpacing.xs,
          runSpacing: HyUiSpacing.xs,
          children: [
            HyButton.icon(
              icon: LucideIcons.plus,
              onPressed: _noop,
              tooltip: '新建',
            ),
            HyButton.icon(
              icon: LucideIcons.refreshCw,
              variant: HyButtonVariant.tonal,
              onPressed: _noop,
              tooltip: '刷新',
            ),
            HyButton.icon(
              icon: LucideIcons.share2,
              variant: HyButtonVariant.outline,
              onPressed: _noop,
              tooltip: '分享',
            ),
            HyButton.icon(
              icon: LucideIcons.trash,
              variant: HyButtonVariant.danger,
              onPressed: _noop,
              tooltip: '删除',
            ),
            HyButton.icon(
              icon: LucideIcons.refreshCw,
              loading: true,
              onPressed: _noop,
              tooltip: '加载中',
            ),
          ],
        ),
        const SizedBox(height: HyUiSpacing.md),
        // 通栏按钮：显式 expanded 铺满父级宽度。
        HyButton.filled(
          label: '通栏按钮（expanded: true）',
          expanded: true,
          onPressed: _noop,
        ),
      ],
    );
  }
}

void _noop() {}
