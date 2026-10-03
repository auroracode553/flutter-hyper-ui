import 'dart:math' as math;
import 'package:flutter/widgets.dart';

/// 锚定表面内部布局：按实际内容尺寸选择上下方向，并避让屏幕与键盘。
class HyperAnchoredLayout extends SingleChildLayoutDelegate {
  const HyperAnchoredLayout({
    required this.anchor,
    required this.insets,
    required this.width,
    required this.maxHeight,
  });

  final Rect anchor;
  final EdgeInsets insets;
  final double width;
  final double maxHeight;
  static const gap = 6.0;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final availableWidth = math.max(
      0.0,
      constraints.maxWidth - insets.horizontal,
    );
    final below = constraints.maxHeight - insets.bottom - anchor.bottom - gap;
    final above = anchor.top - insets.top - gap;
    return BoxConstraints(
      minWidth: math.min(width, availableWidth),
      maxWidth: math.min(width, availableWidth),
      maxHeight: math.max(0.0, math.min(maxHeight, math.max(above, below))),
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final right = math.max(
      insets.left,
      size.width - insets.right - childSize.width,
    );
    final bottom = math.max(
      insets.top,
      size.height - insets.bottom - childSize.height,
    );
    final below = anchor.bottom + gap;
    final top = below + childSize.height <= size.height - insets.bottom
        ? below
        : anchor.top - gap - childSize.height;
    return Offset(
      anchor.left.clamp(insets.left, right),
      top.clamp(insets.top, bottom),
    );
  }

  @override
  bool shouldRelayout(HyperAnchoredLayout oldDelegate) =>
      anchor != oldDelegate.anchor ||
      insets != oldDelegate.insets ||
      width != oldDelegate.width ||
      maxHeight != oldDelegate.maxHeight;
}
