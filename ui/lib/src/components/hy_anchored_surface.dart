import 'package:flutter/material.dart';

import 'hy_glass.dart';

/// 锚定菜单与补充气泡共用的玻璃宿主，具体内容由调用方提供。
Widget buildHyAnchoredSurface({
  required double width,
  required double maxHeight,
  required EdgeInsetsGeometry padding,
  required WidgetBuilder contentBuilder,
  required Widget Function(BuildContext, MenuController) triggerBuilder,
}) => MenuAnchor(
  style: const MenuStyle(
    backgroundColor: WidgetStatePropertyAll(Colors.transparent),
    elevation: WidgetStatePropertyAll(0),
    padding: WidgetStatePropertyAll(EdgeInsets.zero),
  ),
  menuChildren: [
    SizedBox(
      width: width,
      child: HyGlass(
        radius: 18,
        blur: 28,
        weight: HyGlassWeight.prominent,
        padding: padding,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: SingleChildScrollView(
            child: Builder(builder: contentBuilder),
          ),
        ),
      ),
    ),
  ],
  builder: (anchorContext, controller, child) =>
      triggerBuilder(anchorContext, controller),
);
