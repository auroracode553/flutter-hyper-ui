import 'package:flutter/widgets.dart';

/// 内部材质边界：子列表行复用父表面，不再叠加玻璃和阴影。
class HyperSurfaceScope extends InheritedWidget {
  /// 标记共用表面，以及父级是否已提供列表内容的水平留白。
  const HyperSurfaceScope({
    super.key,
    required super.child,
    this.sharesHorizontalPadding = true,
  });

  /// 浮层的外框留白不替代列表行内部留白。
  final bool sharesHorizontalPadding;

  /// 判断当前内容是否已经处于共用表面内。
  static bool contains(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<HyperSurfaceScope>() != null;

  /// 读取最近表面是否已提供内容水平留白。
  static bool sharesPadding(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<HyperSurfaceScope>()
          ?.sharesHorizontalPadding ?? true;

  /// 留白归属改变时通知列表行重新布局。
  @override
  bool updateShouldNotify(HyperSurfaceScope oldWidget) =>
      sharesHorizontalPadding != oldWidget.sharesHorizontalPadding;
}
