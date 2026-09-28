import 'package:flutter/widgets.dart';

abstract final class HyperUiEffects {
  static const Duration pressInDuration = Duration(milliseconds: 85);
  static const Duration pressOutDuration = Duration(milliseconds: 180);
  static const Duration selectionDuration = Duration(milliseconds: 260);
  static const Duration overlayDuration = Duration(milliseconds: 280);

  static const Curve selectionCurve = Curves.easeOutCubic;
  static const Curve overlayCurve = Curves.easeOutCubic;

  /// 用于拖拽释放后的吸附。阻尼接近临界值，快速且不过度弹跳。
  static const SpringDescription settleSpring = SpringDescription(
    mass: 1,
    stiffness: 470,
    damping: 42,
  );
}
