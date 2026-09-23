import 'package:flutter/material.dart';
import 'package:flutter_hyper_ui/hy_ui.dart';

// doc-region GlassWeightComponentExample
class GlassWeightComponentExample extends StatelessWidget {
  const GlassWeightComponentExample({super.key});

  @override
  Widget build(BuildContext context) => const HyWrap(
    children: [
      HyGlass(weight: HyGlassWeight.subtle, padding: EdgeInsets.all(16), child: Text('Subtle')),
      HyGlass(weight: HyGlassWeight.regular, padding: EdgeInsets.all(16), child: Text('Regular')),
      HyGlass(weight: HyGlassWeight.prominent, padding: EdgeInsets.all(16), child: Text('Prominent')),
      HyGlass(weight: HyGlassWeight.solid, padding: EdgeInsets.all(16), child: Text('Solid')),
    ],
  );
}
// end-doc-region GlassWeightComponentExample

// doc-region PressableComponentExample
class PressableComponentExample extends StatefulWidget {
  const PressableComponentExample({super.key});

  @override
  State<PressableComponentExample> createState() => _PressableComponentExampleState();
}

class _PressableComponentExampleState extends State<PressableComponentExample> {
  int _count = 0;

  @override
  Widget build(BuildContext context) => HyPressable(
    semanticLabel: '按压反馈示例',
    borderRadius: BorderRadius.circular(22),
    onPressed: () => setState(() => _count++),
    child: HyGlass(
      padding: const EdgeInsets.all(22),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.touch_app_outlined),
          const SizedBox(width: 10),
          Text('按住感受缩放 · $_count'),
        ],
      ),
    ),
  );
}
// end-doc-region PressableComponentExample

// doc-region SoftBackgroundComponentExample
class SoftBackgroundComponentExample extends StatelessWidget {
  const SoftBackgroundComponentExample({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox(
    height: 190,
    child: HySoftBackground(
      child: Center(
        child: HyGlass(
          weight: HyGlassWeight.regular,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: Text('环境柔光为玻璃提供景深'),
        ),
      ),
    ),
  );
}
// end-doc-region SoftBackgroundComponentExample
