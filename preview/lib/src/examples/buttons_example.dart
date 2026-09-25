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
        const SizedBox(height: HyUiSpacing.md),
        // 图标按钮：只传 icon、省略 label，自动呈现方形；round 变圆形。
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
              icon: LucideIcons.ellipsis,
              variant: HyButtonVariant.ghost,
              round: true,
              onPressed: _noop,
              tooltip: '更多',
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
        const SizedBox(height: HyUiSpacing.sm),
        // 胶囊与圆形：round 取胶囊圆角，circle 宽高相等并取胶囊圆角。
        Wrap(
          spacing: HyUiSpacing.xs,
          runSpacing: HyUiSpacing.xs,
          children: [
            HyButton.filled(
              label: '胶囊按钮',
              round: true,
              onPressed: _noop,
            ),
            HyButton.tonal(
              label: '带图标胶囊',
              icon: LucideIcons.settings,
              round: true,
              onPressed: _noop,
            ),
            HyButton.outline(
              label: '圆形胶囊',
              icon: LucideIcons.heart,
              circle: true,
              onPressed: _noop,
            ),
            HyButton.icon(
              icon: LucideIcons.chevronDown,
              variant: HyButtonVariant.danger,
              size: HyButtonSize.sm,
              round: true,
              onPressed: _noop,
              tooltip: '小号圆形',
            ),
          ],
        ),
        const SizedBox(height: HyUiSpacing.sm),
        // 宽度：默认按内容收缩（inline-block），仅 expanded 铺满父级。
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
