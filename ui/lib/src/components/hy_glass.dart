import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/hy_glass_theme.dart';
import '../theme/hy_ui_effects.dart';
import '../theme/hy_ui_theme_tokens.dart';
import 'hy_pressable.dart';

/// 玻璃的视觉厚度。面积越大的浮层应使用越重的材质。
enum HyGlassWeight { subtle, regular, prominent, solid }

/// Hy UI 的统一柔性玻璃材质。
///
/// [HyGlass] 只负责材质、裁切与触控反馈。业务间距由外部决定，避免基础材质
/// 与卡片、菜单等高阶组件互相耦合。
class HyGlass extends StatelessWidget {
  const HyGlass({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.radius = 24,
    this.blur = HyUiEffects.glassBlur,
    this.weight = HyGlassWeight.regular,
    this.borderColor,
    this.shadows,
    this.color,
    this.onTap,
    this.clipBehavior = Clip.antiAlias,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final double blur;
  final HyGlassWeight weight;
  final Color? color;
  final Color? borderColor;
  final List<BoxShadow>? shadows;
  final VoidCallback? onTap;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final glass = HyGlassTheme.of(context);
    final tokens = HyUiThemeTokens.of(context);
    final highContrast = MediaQuery.maybeOf(context)?.highContrast ?? false;
    final shape = BorderRadius.circular(radius);
    final surfaceColor = color ?? _surfaceColor(glass, tokens, highContrast);
    final effectiveBlur = highContrast || weight == HyGlassWeight.solid
        ? 0.0
        : blur;
    final effectiveBorder =
        borderColor ??
        (highContrast
            ? tokens.foreground.withAlpha(150)
            : Color.alphaBlend(glass.edgeShade, glass.edgeHighlight));

    Widget material = DecoratedBox(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: shape,
        border: Border.all(color: effectiveBorder),
      ),
      child: Padding(padding: padding, child: child),
    );

    if (effectiveBlur > 0) {
      material = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: effectiveBlur, sigmaY: effectiveBlur),
        child: material,
      );
    }

    Widget result = ClipRRect(
      borderRadius: shape,
      clipBehavior: clipBehavior,
      child: material,
    );

    if (onTap != null) {
      result = HyPressable(
        onPressed: onTap,
        borderRadius: shape,
        child: result,
      );
    }

    return RepaintBoundary(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: shape,
          boxShadow:
              shadows ??
              (weight == HyGlassWeight.subtle
                  ? const <BoxShadow>[]
                  : HyUiEffects.surfaceShadows(theme.brightness)),
        ),
        child: result,
      ),
    );
  }

  Color _surfaceColor(
    HyGlassTheme glass,
    HyUiThemeTokens tokens,
    bool highContrast,
  ) {
    if (highContrast) return tokens.card;
    return switch (weight) {
      HyGlassWeight.subtle => glass.surfaceSubtle,
      HyGlassWeight.regular => glass.surface,
      HyGlassWeight.prominent => glass.surfaceStrong,
      HyGlassWeight.solid => tokens.card,
    };
  }
}

/// 为页面提供低饱和、非循环的环境色背景，让透明材质具有可感知的景深。
class HySoftBackground extends StatelessWidget {
  const HySoftBackground({super.key, required this.child, this.intensity = 1})
    : assert(intensity >= 0 && intensity <= 1);

  final Widget child;
  final double intensity;

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    final alpha = (28 * intensity).round();
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color.alphaBlend(
              tokens.primary.withAlpha(alpha),
              tokens.background,
            ),
            tokens.background,
            Color.alphaBlend(
              const Color(0xFF9A82D7).withAlpha(alpha),
              tokens.background,
            ),
          ],
          stops: const <double>[0, 0.52, 1],
        ),
      ),
      child: child,
    );
  }
}
