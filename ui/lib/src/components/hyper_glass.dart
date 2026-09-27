import 'package:flutter_hyper_ui/src/theme/hyper_ui_theme.dart';
import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../theme/hyper_glass_theme.dart';
import '../theme/hyper_ui_effects.dart';
import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_pressable.dart';

/// 玻璃的视觉厚度。面积越大的浮层应使用越重的材质。
enum HyperGlassWeight { subtle, regular, prominent, solid }

/// Hyper UI 的统一柔性玻璃材质。
///
/// [HyperGlass] 只负责材质、裁切与触控反馈。业务间距由外部决定，避免基础材质
/// 与卡片、菜单等高阶组件互相耦合。
class HyperGlass extends StatelessWidget {
  const HyperGlass({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.radius = 24,
    this.blur = HyperUiEffects.glassBlur,
    this.weight = HyperGlassWeight.regular,
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
  final HyperGlassWeight weight;
  final Color? color;
  final Color? borderColor;
  final List<BoxShadow>? shadows;
  final VoidCallback? onTap;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final theme = HyperUiTheme.of(context);
    final glass = HyperGlassTheme.of(context);
    final tokens = HyperUiThemeTokens.of(context);
    final highContrast = MediaQuery.maybeOf(context)?.highContrast ?? false;
    final shape = BorderRadius.circular(radius);
    final surfaceColor = color ?? _surfaceColor(glass, tokens, highContrast);
    final effectiveBlur = highContrast || weight == HyperGlassWeight.solid
        ? 0.0
        : blur;
    final effectiveBorder =
        borderColor ??
        (highContrast
            ? tokens.foreground.withAlpha(150)
            : Color.alphaBlend(glass.edgeShade, glass.edgeHighlight));

    Widget surface = DecoratedBox(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: shape,
        border: Border.all(color: effectiveBorder),
      ),
      child: Padding(padding: padding, child: child),
    );

    if (effectiveBlur > 0) {
      surface = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: effectiveBlur, sigmaY: effectiveBlur),
        child: surface,
      );
    }

    Widget result = ClipRRect(
      borderRadius: shape,
      clipBehavior: clipBehavior,
      child: surface,
    );

    if (onTap != null) {
      result = HyperPressable(
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
              (weight == HyperGlassWeight.subtle
                  ? const <BoxShadow>[]
                  : HyperUiEffects.surfaceShadows(theme.brightness)),
        ),
        child: result,
      ),
    );
  }

  Color _surfaceColor(
    HyperGlassTheme glass,
    HyperUiThemeTokens tokens,
    bool highContrast,
  ) {
    if (highContrast) return tokens.card;
    return switch (weight) {
      HyperGlassWeight.subtle => glass.surfaceSubtle,
      HyperGlassWeight.regular => glass.surface,
      HyperGlassWeight.prominent => glass.surfaceStrong,
      HyperGlassWeight.solid => tokens.card,
    };
  }
}
