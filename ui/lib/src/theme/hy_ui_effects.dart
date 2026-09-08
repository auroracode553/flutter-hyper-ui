import 'package:flutter/material.dart';

abstract final class HyUiEffects {
  static const double glassBlur = 18;
  static const Duration selectionDuration = Duration(milliseconds: 180);
  static const Curve selectionCurve = Cubic(.77, 0, .175, 1);
  static List<BoxShadow> surfaceShadows(Brightness brightness) => [
    BoxShadow(color: Colors.black.withAlpha(brightness == Brightness.dark ? 45 : 12),
      blurRadius: 24, offset: const Offset(0, 8)),
  ];
}
