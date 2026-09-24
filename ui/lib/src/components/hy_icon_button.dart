import 'package:flutter/material.dart';

import '../theme/hy_ui_radii.dart';
import 'hy_pressable.dart';

/// 自绘图标按钮。
///
/// 使用 [HyPressable] 提供即时按压反馈，不依赖 Material 墨水波纹，
/// 与玻璃拟态设计语言保持一致。
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
  final Color? backgroundColor;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final effectiveColor =
        color ?? Theme.of(context).colorScheme.onSurfaceVariant;
    Widget child = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Icon(icon, size: iconSize, color: effectiveColor),
    );
    if (tooltip != null) child = Tooltip(message: tooltip!, child: child);
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
