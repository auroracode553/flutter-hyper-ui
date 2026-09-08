import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/hy_ui_theme_tokens.dart';
import '../theme/hy_ui_effects.dart';

/// 共享柔光材质。列表中可关闭模糊，保留高光与边缘层次。
class HyGlass extends StatelessWidget {
  const HyGlass({super.key, required this.child, this.padding = EdgeInsets.zero,
    this.radius = 24, this.blur = HyUiEffects.glassBlur, this.borderColor, this.shadows,
    this.color, this.onTap});
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius, blur;
  final Color? color, borderColor;
  final List<BoxShadow>? shadows;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final tokens = HyUiThemeTokens.of(context);
    final shape = BorderRadius.circular(radius);
    final surface = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: shape,
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [color ?? tokens.card.withAlpha(dark ? 220 : 205),
            color ?? tokens.card.withAlpha(dark ? 180 : 145)]),
        border: Border.all(color: borderColor ?? Colors.white.withAlpha(dark ? 28 : 190)),
      ),
      child: Material(color: Colors.transparent, child: InkWell(
        onTap: onTap, borderRadius: shape,
        child: Padding(padding: padding, child: child))),
    );
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: shape,
        boxShadow: shadows ?? HyUiEffects.surfaceShadows(Theme.of(context).brightness)),
      child: ClipRRect(borderRadius: shape, child: blur <= 0 ? surface : BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur), child: surface)),
    );
  }
}

class HySoftBackground extends StatelessWidget {
  const HySoftBackground({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    return DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
        Color.alphaBlend(tokens.primary.withAlpha(25), tokens.background),
        tokens.background,
        Color.alphaBlend(const Color(0xFFB7A2ED).withAlpha(25), tokens.background),
      ])), child: child);
  }
}
