import 'package:flutter/widgets.dart';

import '../theme/hyper_glass_theme.dart';
import '../theme/hyper_ui_theme_tokens.dart';

/// A reusable wheel with Hyper's own selection surface.
class HyperWheelPicker extends StatelessWidget {
  const HyperWheelPicker({
    super.key,
    required this.controller,
    required this.labels,
    required this.onSelected,
    this.itemExtent = 40,
  });

  final FixedExtentScrollController controller;
  final List<String> labels;
  final ValueChanged<int> onSelected;
  final double itemExtent;

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    final glass = HyperGlassTheme.of(context);
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        IgnorePointer(
          child: Container(
            height: itemExtent,
            decoration: BoxDecoration(
              color: glass.selection,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: glass.edgeShade),
            ),
          ),
        ),
        ListWheelScrollView.useDelegate(
          controller: controller,
          itemExtent: itemExtent,
          diameterRatio: 1.6,
          physics: const FixedExtentScrollPhysics(),
          onSelectedItemChanged: onSelected,
          childDelegate: ListWheelChildBuilderDelegate(
            childCount: labels.length,
            builder: (context, index) => Center(
              child: Text(
                labels[index],
                style: TextStyle(color: tokens.foreground, fontSize: 17),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
