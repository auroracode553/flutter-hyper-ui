import 'package:flutter_hyper_ui/hyper_ui.dart';
import 'package:flutter/widgets.dart';
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
          spacing: HyperUiSpacing.xs,
          runSpacing: HyperUiSpacing.xs,
          children: [
            HyperButton.filled(label: '小按钮', height: 32, onPressed: _noop),
            HyperButton.filled(label: '默认按钮', round: true, onPressed: _noop),
            HyperButton.outline(label: '处理中', loading: true, onPressed: _noop),
          ],
        ),
        const SizedBox(height: HyperUiSpacing.md),
        // 带图标的按钮：图标 + 文字。
        Wrap(
          spacing: HyperUiSpacing.xs,
          runSpacing: HyperUiSpacing.xs,
          children: [
            HyperButton.outline(
              label: '导出',
              icon: LucideIcons.share2,
              onPressed: _noop,
            ),
            HyperButton.danger(
              label: '删除',
              icon: LucideIcons.trash,
              onPressed: _noop,
            ),
            HyperButton.tonal(
              label: '带图标胶囊',
              icon: LucideIcons.settings,
              round: true,
              onPressed: _noop,
            ),
          ],
        ),
        const SizedBox(height: HyperUiSpacing.md),
        // 图标按钮：仅图标，方形（省略 label 自动呈现）。
        Wrap(
          spacing: HyperUiSpacing.xs,
          runSpacing: HyperUiSpacing.xs,
          children: [
            HyperButton.icon(
              icon: LucideIcons.plus,
              onPressed: _noop,
              tooltip: '新建',
            ),
            HyperButton.icon(
              icon: LucideIcons.refreshCw,
              type: 'tonal',
              onPressed: _noop,
              tooltip: '刷新',
            ),
            HyperButton.icon(
              icon: LucideIcons.share2,
              type: 'outline',
              onPressed: _noop,
              tooltip: '分享',
            ),
            HyperButton.icon(
              icon: LucideIcons.trash,
              type: 'danger',
              onPressed: _noop,
              tooltip: '删除',
            ),
            HyperButton.icon(
              icon: LucideIcons.refreshCw,
              loading: true,
              onPressed: _noop,
              tooltip: '加载中',
            ),
          ],
        ),
        const SizedBox(height: HyperUiSpacing.md),
        // 通栏按钮：显式 expanded 铺满父级宽度。
        HyperButton.filled(
          label: '通栏按钮（expanded: true）',
          expanded: true,
          onPressed: _noop,
        ),
      ],
    );
  }
}

void _noop() {}
