import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';

// doc-region GlassWeightComponentExample
class GlassWeightComponentExample extends StatelessWidget {
  const GlassWeightComponentExample({super.key});

  @override
  Widget build(BuildContext context) => const Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      HyperGlass(
        weight: HyperGlassWeight.subtle,
        padding: EdgeInsets.all(16),
        child: Text('Subtle'),
      ),
      HyperGlass(
        weight: HyperGlassWeight.regular,
        padding: EdgeInsets.all(16),
        child: Text('Regular'),
      ),
      HyperGlass(
        weight: HyperGlassWeight.prominent,
        padding: EdgeInsets.all(16),
        child: Text('Prominent'),
      ),
      HyperGlass(
        weight: HyperGlassWeight.solid,
        padding: EdgeInsets.all(16),
        child: Text('Solid'),
      ),
    ],
  );
}
// end-doc-region GlassWeightComponentExample

// doc-region PressableComponentExample
class PressableComponentExample extends StatefulWidget {
  const PressableComponentExample({super.key});

  @override
  State<PressableComponentExample> createState() =>
      _PressableComponentExampleState();
}

class _PressableComponentExampleState extends State<PressableComponentExample> {
  int _count = 0;

  @override
  Widget build(BuildContext context) => HyperPressable(
    borderRadius: BorderRadius.circular(22),
    onPressed: () => setState(() => _count++),
    child: HyperGlass(
      padding: const EdgeInsets.all(22),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(LucideIcons.hand),
          const SizedBox(width: 10),
          Text('按住感受缩放 · $_count'),
        ],
      ),
    ),
  );
}
// end-doc-region PressableComponentExample
