import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

abstract final class HyUiEffects {
  static const double glassBlur = 20;
  static const double glassBlurStrong = 28;

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

  static List<BoxShadow> surfaceShadows(Brightness brightness) => <BoxShadow>[
    BoxShadow(
      color: Colors.black.withAlpha(brightness == Brightness.dark ? 82 : 20),
      blurRadius: 28,
      spreadRadius: -6,
      offset: const Offset(0, 12),
    ),
    BoxShadow(
      color: Colors.black.withAlpha(brightness == Brightness.dark ? 35 : 8),
      blurRadius: 8,
      spreadRadius: -3,
      offset: const Offset(0, 3),
    ),
  ];
}
