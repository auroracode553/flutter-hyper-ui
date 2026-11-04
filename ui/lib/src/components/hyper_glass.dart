import 'package:flutter/widgets.dart';

import '../theme/hyper_surface_theme.dart';
import '../theme/hyper_ui_theme_tokens.dart';
import '../interaction/press_feedback.dart';
import 'hyper_surface_scope.dart';

/// 内部实色表面绘制层，统一边缘、阴影和触控反馈。
///
/// [HyperGlass] 只负责材质、裁切与触控反馈。业务间距由外部决定，避免基础材质
/// 与卡片、菜单等高阶组件互相耦合。
class HyperGlass extends StatelessWidget {
  /// 创建内部表面，保留调用方的布局与回调。
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
    this.onLongPressed,
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
    this.onLongPressed,
    this.clipBehavior = Clip.antiAlias,
  }) : type = 'regular',
       shadows = null,
       _isCard = true;

  /// 承载的正文内容。
  final Widget child;
  /// 内容内边距。
  final EdgeInsetsGeometry padding;
  /// 表面圆角半径。
  final double radius;
  /// 组件形态。
  final String type;
  /// 自定义语义基色。
  final Color? color;
  /// 显式边框颜色。
  final Color? borderColor;
  /// 是否显示普通边框。
  final bool showBorder;
  /// 显式覆盖的表面阴影。
  final List<BoxShadow>? shadows;
  /// 点击时触发，可独立于长按启用。
  final VoidCallback? onPressed;
  /// 长按表面时触发，可独立于点击启用。
  final VoidCallback? onLongPressed;
  /// 内容裁切方式。
  final Clip clipBehavior;
  /// 是否使用内容卡片阴影层级。
  final bool _isCard;

  /// 根据当前主题和参数构建组件界面。
  @override
  Widget build(BuildContext context) {
    if (type != 'subtle' &&
        type != 'regular' &&
        type != 'prominent' &&
        type != 'solid') {
      throw ArgumentError.value(type, 'type', 'Invalid glass type');
    }
    final glass = HyperSurfaceTheme.of(context);
    final tokens = HyperUiThemeTokens.of(context);
    final highContrast = MediaQuery.maybeOf(context)?.highContrast ?? false;
    final shape = BorderRadius.circular(radius);
    final surfaceColor = color ?? _surfaceColor(glass, tokens, highContrast);
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

    Widget result = ClipRRect(
      borderRadius: shape,
      clipBehavior: clipBehavior,
      child: surface,
    );

    if (onPressed != null || onLongPressed != null) {
      result = PressFeedback(
        onPressed: onPressed,
        onLongPressed: onLongPressed,
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

  /// 结合主题与高对比状态解析表面颜色。
  Color _surfaceColor(
    HyperSurfaceTheme glass,
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
