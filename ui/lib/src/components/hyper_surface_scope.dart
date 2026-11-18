import 'package:flutter/widgets.dart';

/// 内部材质边界：子列表行复用父表面，不再叠加玻璃和阴影。
class HyperSurfaceScope extends InheritedWidget {
  /// 只标记共用表面，不消费子组件自己的内容留白。
  const HyperSurfaceScope({super.key, required super.child});

  /// 判断当前内容是否已经处于共用表面内。
  static bool contains(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<HyperSurfaceScope>() != null;

  /// 表面标记不持有可变状态。
  @override
  bool updateShouldNotify(HyperSurfaceScope oldWidget) => false;
}
