import 'package:flutter/widgets.dart';

/// 内部材质边界：子列表行复用父表面，不再叠加玻璃和阴影。
class HyperSurfaceScope extends InheritedWidget {
  const HyperSurfaceScope({super.key, required super.child});

  static bool contains(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<HyperSurfaceScope>() != null;

  @override
  bool updateShouldNotify(HyperSurfaceScope oldWidget) => false;
}
