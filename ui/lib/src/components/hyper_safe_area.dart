import 'dart:math' as math;

import 'package:flutter/widgets.dart';

enum HyperSafeAreaEdge { top, bottom }

abstract final class HyperSafeAreaDefaults {
  static const double minimumBottomSpacing = 20;
}

/// 按需保护内容；不改变窗口、IME 或子组件业务高度。
class HyperSafeArea extends StatelessWidget {
  const HyperSafeArea({
    super.key,
    this.edge = HyperSafeAreaEdge.bottom,
    required this.child,
  });
  final HyperSafeAreaEdge edge;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final inherited = context
        .dependOnInheritedWidgetOfExactType<_ConsumedSafeArea>();
    final consumed = inherited?.padding ?? EdgeInsets.zero;
    final system = MediaQuery.paddingOf(context);
    final portrait = MediaQuery.orientationOf(context) == Orientation.portrait;
    final top = edge == HyperSafeAreaEdge.top;
    // 系统区由 MediaQuery.removePadding 消费；已用的最小留白也传给后代，避免嵌套叠加。
    final padding = EdgeInsets.only(
      top: top ? system.top : 0,
      bottom: top
          ? 0
          : math.max(
              system.bottom,
              math.max(
                (portrait ? HyperSafeAreaDefaults.minimumBottomSpacing : 0.0) -
                    consumed.bottom,
                0.0,
              ),
            ),
    );
    return Padding(
      padding: padding,
      child: MediaQuery.removePadding(
        context: context,
        removeTop: top,
        removeBottom: !top,
        child: _ConsumedSafeArea(padding: consumed + padding, child: child),
      ),
    );
  }
}

class _ConsumedSafeArea extends InheritedWidget {
  const _ConsumedSafeArea({required this.padding, required super.child});
  final EdgeInsets padding;
  @override
  bool updateShouldNotify(_ConsumedSafeArea oldWidget) =>
      padding != oldWidget.padding;
}
