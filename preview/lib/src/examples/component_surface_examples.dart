import 'package:flutter/material.dart';
import 'package:flutter_hyper_ui/hy_ui.dart';

// doc-region CardComponentExample
class CardComponentExample extends StatelessWidget {
  const CardComponentExample({super.key});

  @override
  Widget build(BuildContext context) {
    return HyCard(
      title: '本周专注',
      subtitle: '保持轻量、清晰的内容层级',
      leading: const Icon(Icons.auto_awesome_outlined),
      actions: [
        IconButton(
          tooltip: '更多',
          onPressed: () {},
          icon: const Icon(Icons.more_horiz_rounded),
        ),
      ],
      footer: const Text('上次更新：今天 09:30'),
      child: const Text('卡片负责组织标题、正文、操作区与底部信息，不持有业务状态。'),
    );
  }
}
// end-doc-region CardComponentExample

// doc-region GlassComponentExample
class GlassComponentExample extends StatelessWidget {
  const GlassComponentExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        HyGlass(
          weight: HyGlassWeight.subtle,
          padding: EdgeInsets.all(18),
          child: Text('Subtle · 小面积辅助表面'),
        ),
        SizedBox(height: 12),
        HyGlass(
          weight: HyGlassWeight.regular,
          padding: EdgeInsets.all(18),
          child: Text('Regular · 常规内容表面'),
        ),
        SizedBox(height: 12),
        HyGlass(
          weight: HyGlassWeight.prominent,
          padding: EdgeInsets.all(18),
          child: Text('Prominent · 浮层和模态表面'),
        ),
      ],
    );
  }
}
// end-doc-region GlassComponentExample
