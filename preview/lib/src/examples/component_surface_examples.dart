import 'package:flutter/material.dart';
import 'package:flutter_hyper_ui/hy_ui.dart';

// doc-region CardComponentExample
class CardComponentExample extends StatelessWidget {
  const CardComponentExample({super.key});

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyUiSpacing.xs),
    child: HyText(text, variant: HyTextStyle.caption),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('完整结构（标题 / 副标题 / 操作 / 正文 / 底部）'),
        HyCard(
          title: '本周专注',
          subtitle: '保持轻量、清晰的内容层级',
          leading: const Icon(Icons.auto_awesome_outlined),
          actions: [
            HyIconButton(
              icon: Icons.more_horiz_rounded,
              tooltip: '更多',
              onPressed: () {},
            ),
          ],
          footer: const Text('上次更新：今天 09:30'),
          child: const Text('卡片负责组织标题、正文、操作区与底部信息，不持有业务状态。'),
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('选中态（selected）与无标题纯内容'),
        HyCard(
          selected: true,
          title: '已选择的方案',
          subtitle: '选中时边缘使用主色强调',
          child: const Text('适合在多个卡片中标记当前选项。'),
        ),
        const SizedBox(height: 12),
        const HyCard(
          child: Text('没有标题与副标题时，卡片只作为内容容器使用。'),
        ),
      ],
    );
  }
}
// end-doc-region CardComponentExample

// doc-region GlassComponentExample
class GlassComponentExample extends StatelessWidget {
  const GlassComponentExample({super.key});

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: HyUiSpacing.xs),
    child: HyText(text, variant: HyTextStyle.caption),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label('四档重量（weight 控制表面层级）'),
        const HyGlass(
          weight: HyGlassWeight.subtle,
          padding: EdgeInsets.all(18),
          child: Text('Subtle · 小面积辅助表面'),
        ),
        const SizedBox(height: 12),
        const HyGlass(
          weight: HyGlassWeight.regular,
          padding: EdgeInsets.all(18),
          child: Text('Regular · 常规内容表面'),
        ),
        const SizedBox(height: 12),
        const HyGlass(
          weight: HyGlassWeight.prominent,
          padding: EdgeInsets.all(18),
          child: Text('Prominent · 浮层和模态表面'),
        ),
        const SizedBox(height: HyUiSpacing.lg),

        _label('自定义圆角与模糊（radius: 16 / blur: 0）'),
        const HyGlass(
          radius: 16,
          blur: 0,
          padding: EdgeInsets.all(18),
          child: Text('关闭模糊后仅保留表面与描边，性能更友好。'),
        ),
      ],
    );
  }
}
// end-doc-region GlassComponentExample
