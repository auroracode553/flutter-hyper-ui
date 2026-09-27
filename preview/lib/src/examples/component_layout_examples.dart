import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';

// doc-region DividerComponentExample
class DividerComponentExample extends StatelessWidget {
  const DividerComponentExample({super.key});

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyperUiSpacing.xs),
    child: HyperText(text, type: 'h5'),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('实线与虚线'),
        const Text('实线分隔'),
        const HyperDivider(),
        const Text('虚线分隔'),
        const HyperDivider(dashed: true),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('缩进（indent: 24）'),
        const HyperDivider(indent: 24, dashed: true),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('纵向分隔'),
        const SizedBox(
          height: 58,
          child: Row(
            children: [
              Expanded(child: Text('左侧')),
              HyperDivider(axis: Axis.vertical),
              SizedBox(width: 14),
              Expanded(child: Text('右侧')),
            ],
          ),
        ),
      ],
    );
  }
}
// end-doc-region DividerComponentExample

// doc-region EmptyStateComponentExample
class EmptyStateComponentExample extends StatelessWidget {
  const EmptyStateComponentExample({super.key});

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyperUiSpacing.xs),
    child: HyperText(text, type: 'h5'),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('带恢复操作'),
        HyperEmptyState(
          icon: LucideIcons.searchX,
          title: '没有找到结果',
          message: '换一个关键词，或者清除筛选条件后重试。',
          action: HyperButton.tonal(label: '清除筛选', onPressed: () {}),
        ),
        const SizedBox(height: HyperUiSpacing.lg),

        _label('纯提示（无操作按钮）'),
        const HyperEmptyState(
          icon: LucideIcons.inbox,
          title: '这里还是空的',
          message: '创建第一个项目后它会出现在这里。',
        ),
      ],
    );
  }
}
// end-doc-region EmptyStateComponentExample

// doc-region PageContentComponentExample
class PageContentComponentExample extends StatelessWidget {
  const PageContentComponentExample({super.key});

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyperUiSpacing.xs),
    child: HyperText(text, type: 'h5'),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('统一边距（默认 16/12/16/40）：灰底即屏幕边缘，卡片距边缘 16'),
        SizedBox(
          height: 320,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: CustomScrollView(
              slivers: [
                HyperPageContentSliver(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
                      HyperListTile(
                        leadingIcon: Icons.star_rounded,
                        leadingColor: Color(0xFFF59E0B),
                        title: '第一项',
                        subtitle: '统一边距',
                      ),
                      HyperListTile(
                        leadingIcon: Icons.favorite_rounded,
                        leadingColor: Color(0xFFEF4444),
                        title: '第二项',
                        subtitle: '宽屏自动居中限宽',
                      ),
                      HyperListTile(
                        leadingIcon: Icons.settings_rounded,
                        leadingColor: Color(0xFF6B7280),
                        title: '第三项',
                        subtitle: '手机端占满宽度',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
// end-doc-region PageContentComponentExample
