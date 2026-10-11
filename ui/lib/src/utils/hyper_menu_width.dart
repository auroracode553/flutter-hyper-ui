import 'dart:math' as math;
import 'package:flutter/widgets.dart';

/// 菜单自动宽度按文字与控件占位计算，与 Compose 共用 160–240 的紧凑范围。
double measureHyperMenuWidth(
  BuildContext context, {
  required Iterable<String> labels,
  double horizontalSpace = 68,
}) {
  final painter = TextPainter(
    textDirection: Directionality.of(context),
    textScaler: MediaQuery.maybeOf(context)?.textScaler ?? TextScaler.noScaling,
    maxLines: 1,
  );
  final style = DefaultTextStyle.of(context).style.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );
  var textWidth = 0.0;
  try {
    for (final label in labels) {
      painter.text = TextSpan(text: label, style: style);
      painter.layout();
      textWidth = math.max(textWidth, painter.width);
    }
  } finally {
    painter.dispose();
  }
  return (textWidth + horizontalSpace)
      .ceilToDouble()
      .clamp(160.0, 240.0)
      .toDouble();
}
