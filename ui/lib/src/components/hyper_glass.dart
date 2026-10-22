import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../theme/hyper_glass_theme.dart';
import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_pressable.dart';
import 'hyper_surface_scope.dart';

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
    this.showBorder = true,
    this.shadows,
    this.color,
    this.onPressed,
    this.clipBehavior = Clip.antiAlias,
  }) : _isCard = false,
       assert(
         type == 'subtle' ||
             type == 'regular' ||
             type == 'prominent' ||
             type == 'solid',
         'HyperGlass.type must be subtle, regular, prominent, or solid.',
       );

  /// 内容卡片共用入口：底色、无描边与阴影策略在此集中维护。
  /// 圆角、间距和状态强调仍由具体组件提供，不增加布局包装。
  const HyperGlass.card({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.radius = 24,
    this.borderColor,
    this.showBorder = false,
    this.color,
    this.onPressed,
    this.clipBehavior = Clip.antiAlias,
  }) : type = 'regular',
       shadows = null,
       _isCard = true;

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final String type;
  final Color? color;
  final Color? borderColor;
  final bool showBorder;
  final List<BoxShadow>? shadows;
  final VoidCallback? onPressed;
  final Clip clipBehavior;
  final bool _isCard;

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
        border: showBorder || highContrast
            ? Border.all(color: effectiveBorder)
            : null,
      ),
      child: HyperSurfaceScope(
        child: Padding(padding: padding, child: child),
      ),
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

    if (onPressed != null) {
      result = HyperPressable(
        onPressed: onPressed,
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
              (_isCard
                  ? glass.cardShadows
                  : type == 'subtle'
                  ? const <BoxShadow>[]
                  : glass.surfaceShadows),
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
