import 'package:flutter/material.dart';

import '../theme/hy_glass_theme.dart';
import '../theme/hy_ui_radii.dart';
import 'hy_pressable.dart';
import 'hy_tooltip.dart';

/// 自绘图标按钮。
///
/// 默认使用白色玻璃表面（[HyGlassTheme.surface]）作为背景，与玻璃拟态
/// 设计语言保持一致；需要无背景的纯图标按钮时请显式传
/// `backgroundColor: Colors.transparent`。
class HyIconButton extends StatelessWidget {
  const HyIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.semanticLabel,
    this.size = 36,
    this.iconSize = 18,
    this.color,
    this.backgroundColor,
    this.radius = HyUiRadii.full,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final String? semanticLabel;
  final double size;
  final double iconSize;
  final Color? color;

  /// 背景色，默认使用玻璃表面色（浅色 = 白色玻璃，深色 = 深色玻璃）。
  /// 显式传值可覆盖默认玻璃样式。
  final Color? backgroundColor;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final glass = HyGlassTheme.of(context);
    final effectiveColor =
        color ?? Theme.of(context).colorScheme.onSurfaceVariant;
    final effectiveBackground = backgroundColor ?? glass.surface;
    final effectiveBorder = Color.alphaBlend(glass.edgeShade, glass.edgeHighlight);
    Widget child = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: effectiveBackground,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: effectiveBorder),
      ),
      child: Icon(icon, size: iconSize, color: effectiveColor),
    );
    if (tooltip != null) child = HyTooltip(message: tooltip!, child: child);
    return Semantics(
      button: true,
      enabled: enabled,
      label: semanticLabel ?? tooltip,
      child: HyPressable(
        onPressed: onPressed,
        borderRadius: BorderRadius.circular(radius),
        child: child,
      ),
    );
  }
}
