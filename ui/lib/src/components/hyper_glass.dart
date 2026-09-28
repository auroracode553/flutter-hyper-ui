import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../theme/hyper_glass_theme.dart';
import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_pressable.dart';

/// 内部表面绘制层。公开材质档位由 HyperUiTheme 配置。
///
/// [HyperGlass] 只负责材质、裁切与触控反馈。业务间距由外部决定，避免基础材质
/// 与卡片、菜单等高阶组件互相耦合。
class HyperGlass extends StatelessWidget {
  const HyperGlass({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.radius = 24,
    this.type = 'regular',
    this.borderColor,
    this.shadows,
    this.color,
    this.onTap,
    this.clipBehavior = Clip.antiAlias,
  }) : assert(
         type == 'subtle' ||
             type == 'regular' ||
             type == 'prominent' ||
             type == 'solid',
         'HyperGlass.type must be subtle, regular, prominent, or solid.',
       );

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final String type;
  final Color? color;
  final Color? borderColor;
  final List<BoxShadow>? shadows;
  final VoidCallback? onTap;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    if (type != 'subtle' &&
        type != 'regular' &&
        type != 'prominent' &&
        type != 'solid') {
      throw ArgumentError.value(type, 'type', 'Invalid glass type');
    }
    final glass = HyperGlassTheme.of(context);
    final tokens = HyperUiThemeTokens.of(context);
    final highContrast = MediaQuery.maybeOf(context)?.highContrast ?? false;
    final shape = BorderRadius.circular(radius);
    final surfaceColor = color ?? _surfaceColor(glass, tokens, highContrast);
    final effectiveBlur = highContrast || type == 'solid'
        ? 0.0
        : type == 'prominent'
        ? glass.blurStrong
        : glass.blur;
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
              (type == 'subtle' ? const <BoxShadow>[] : glass.surfaceShadows),
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
    return switch (type) {
      'subtle' => glass.surfaceSubtle,
      'prominent' => glass.surfaceStrong,
      'solid' => tokens.card,
      'regular' => glass.surface,
      _ => throw ArgumentError.value(type, 'type', 'Invalid glass type'),
    };
  }
}
