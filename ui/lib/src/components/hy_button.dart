import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/hy_glass_theme.dart';
import '../theme/hy_ui_radii.dart';
import '../theme/hy_ui_spacing.dart';
import '../theme/hy_ui_theme_tokens.dart';
import 'hy_pressable.dart';
import 'hy_tooltip.dart';

/// 按钮视觉层级。filled / tonal / outline / ghost 视觉重量依次递减，
/// danger 为危险语义的红色强调（等效 filled 层级的红）。
enum HyButtonVariant { filled, tonal, outline, ghost, danger }

/// 通用柔性玻璃按钮。
///
/// 各变体共享相同尺寸、触控反馈和无障碍行为；颜色仅表达动作层级，不绑定业务。
///
/// 属性约定：
/// - 变体优先使用具名构造 `HyButton.filled / tonal / outline / ghost / danger`，
///   需要程序化切换时才用底层 [variant] 参数。
/// - 高度用数值 [height] 控制（默认 38），字号、内边距与图标尺寸随高度联动推导，
///   不需要枚举档位；更小/更大的按钮直接传对应像素值。
/// - 宽度默认按内容收缩（等价 CSS 的 inline-block），需要铺满父级时传 [expanded]。
/// - 仅提供 [icon] 而不传 [label] 时自动呈现方形图标按钮，也可直接用
///   [HyButton.icon] 构造；[round] 取胶囊圆角、[circle] 强制宽高相等并取胶囊圆角，
///   二者为 true 时忽略 [radius]（圆角恒为高度的一半）。
/// - 图标尺寸默认随 [height] 联动，[iconSize] 可覆盖。
class HyButton extends StatelessWidget {
  const HyButton({
    super.key,
    this.label,
    this.onPressed,
    this.variant = HyButtonVariant.filled,
    this.height = 38,
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.expanded = false,
    this.radius = HyUiRadii.sm,
    this.round = false,
    this.circle = false,
    this.iconSize,
    this.tooltip,
    this.semanticLabel,
    this.color,
    this.backgroundColor,
  });

  /// 方形图标按钮：不展示文字，仅呈现图标（或加载态）。
  ///
  /// 默认使用 36 像素的玻璃表面；[tooltip] 会在悬停或长按时提示，
  /// [semanticLabel] 用于无障碍朗读。
  const HyButton.icon({
    super.key,
    required this.icon,
    this.onPressed,
    this.variant = HyButtonVariant.tonal,
    this.height = 36,
    this.loading = false,
    this.radius = HyUiRadii.full,
    this.round = false,
    this.circle = false,
    this.iconSize = 18,
    this.tooltip,
    this.semanticLabel,
    this.color,
    this.backgroundColor,
  }) : label = null,
       trailingIcon = null,
       expanded = false;

  const HyButton.filled({
    super.key,
    this.label,
    this.onPressed,
    this.height = 38,
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.expanded = false,
    this.radius = HyUiRadii.sm,
    this.round = false,
    this.circle = false,
    this.iconSize,
    this.tooltip,
    this.semanticLabel,
    this.color,
    this.backgroundColor,
  }) : variant = HyButtonVariant.filled;

  const HyButton.tonal({
    super.key,
    this.label,
    this.onPressed,
    this.height = 38,
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.expanded = false,
    this.radius = HyUiRadii.sm,
    this.round = false,
    this.circle = false,
    this.iconSize,
    this.tooltip,
    this.semanticLabel,
    this.color,
    this.backgroundColor,
  }) : variant = HyButtonVariant.tonal;

  const HyButton.outline({
    super.key,
    this.label,
    this.onPressed,
    this.height = 38,
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.expanded = false,
    this.radius = HyUiRadii.sm,
    this.round = false,
    this.circle = false,
    this.iconSize,
    this.tooltip,
    this.semanticLabel,
    this.color,
    this.backgroundColor,
  }) : variant = HyButtonVariant.outline;

  const HyButton.ghost({
    super.key,
    this.label,
    this.onPressed,
    this.height = 38,
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.expanded = false,
    this.radius = HyUiRadii.sm,
    this.round = false,
    this.circle = false,
    this.iconSize,
    this.tooltip,
    this.semanticLabel,
    this.color,
    this.backgroundColor,
  }) : variant = HyButtonVariant.ghost;

  const HyButton.danger({
    super.key,
    this.label,
    this.onPressed,
    this.height = 38,
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.expanded = false,
    this.radius = HyUiRadii.sm,
    this.round = false,
    this.circle = false,
    this.iconSize,
    this.tooltip,
    this.semanticLabel,
    this.color,
    this.backgroundColor,
  }) : variant = HyButtonVariant.danger;

  final String? label;
  final VoidCallback? onPressed;
  final HyButtonVariant variant;
  final double height;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool loading;
  final bool expanded;
  final double radius;
  final bool round;
  final bool circle;
  final double? iconSize;
  final String? tooltip;
  final String? semanticLabel;
  final Color? color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    final glass = HyGlassTheme.of(context);
    final disabled = onPressed == null;
    final blocked = disabled || loading;
    final metrics = _HyButtonMetrics.fromHeight(height);
    final hasLabel = label != null && label!.isNotEmpty;
    final isIconOnly = !hasLabel && (icon != null || loading);
    assert(
      hasLabel || icon != null || loading,
      'HyButton 必须提供 label 或 icon（至少一项）。',
    );

    final visual = _HyButtonVisual.resolve(
      tokens: tokens,
      glass: glass,
      variant: variant,
      disabled: disabled,
    );
    final foreground = color ?? visual.foreground;
    final background = backgroundColor ??
        (isIconOnly && variant == HyButtonVariant.tonal
            ? glass.surface
            : visual.background);
    final isSquare = isIconOnly || circle;
    // round / circle 取胶囊圆角；其余用显式 radius。
    final effectiveRadius = (round || circle) ? metrics.height / 2 : radius;
    final borderRadius = BorderRadius.circular(effectiveRadius);
    // 图标按钮的图标随尺寸放大，带文字时按档位取 labelIconSize。
    final effectiveIconSize =
        iconSize ?? (isIconOnly ? metrics.iconOnlyIconSize : metrics.labelIconSize);

    final content = Container(
      height: metrics.height,
      padding: EdgeInsets.symmetric(
        horizontal: isIconOnly ? 0 : metrics.horizontal,
      ),
      decoration: BoxDecoration(
        color: backgroundColor != null ||
                (isIconOnly && variant == HyButtonVariant.tonal) ||
                visual.gradient == null
            ? background
            : null,
        gradient: backgroundColor != null ||
                (isIconOnly && variant == HyButtonVariant.tonal)
            ? null
            : visual.gradient,
        borderRadius: borderRadius,
        border: Border.all(color: visual.border),
        boxShadow: visual.shadows,
      ),
      child: Align(
        alignment: Alignment.center,
        // widthFactor: 1 让宽度跟随内容收缩（等价 inline-block），
        // 避免 Container 的 Align 在受限宽度下填满父级；通栏由外层 SizedBox 收紧。
        widthFactor: 1,
        child: IconTheme(
          data: IconThemeData(
            color: foreground,
            size: effectiveIconSize,
          ),
          child: isIconOnly
              ? _buildIconOnly(foreground, effectiveIconSize)
              : DefaultTextStyle(
                  style: TextStyle(
                    color: foreground,
                    fontSize: metrics.fontSize,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    letterSpacing: 0.05,
                  ),
                  // 圆形（宽高相等）按钮内空间有限，文字按比例缩小而非溢出。
                  child: isSquare
                      ? FittedBox(
                          fit: BoxFit.scaleDown,
                          child: _buildContent(foreground),
                        )
                      : _buildContent(foreground),
                ),
        ),
      ),
    );

    final String? semantic = semanticLabel ??
        (hasLabel
            ? (loading ? '$label，正在处理' : label)
            : (loading ? '正在处理' : tooltip));

    Widget child = ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: isSquare ? metrics.height : metrics.minWidth,
        minHeight: metrics.height,
      ),
      child: SizedBox(
        // 默认按内容收缩（inline-block）；仅 expanded 时铺满。
        width: isSquare
            ? metrics.height
            : (expanded ? double.infinity : null),
        child: HyPressable(
          onPressed: blocked ? null : onPressed,
          enabled: !blocked,
          borderRadius: borderRadius,
          semanticLabel: semantic,
          child: content,
        ),
      ),
    );

    if (tooltip != null && tooltip!.isNotEmpty) {
      child = HyTooltip(message: tooltip!, child: child);
    }
    return child;
  }

  /// 图标按钮内容：加载态显示转圈，否则居中显示图标。
  Widget _buildIconOnly(Color foreground, double iconSize) {
    if (loading) {
      return SizedBox.square(
        dimension: math.max(12.0, iconSize - 2),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(foreground),
        ),
      );
    }
    return Icon(icon!);
  }

  Widget _buildContent(Color foreground) {
    final text = Text(label!, maxLines: 1, overflow: TextOverflow.ellipsis);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
      children: <Widget>[
        if (loading) ...<Widget>[
          SizedBox.square(
            dimension: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(foreground),
            ),
          ),
          const SizedBox(width: HyUiSpacing.xs),
        ] else if (icon != null) ...<Widget>[
          Icon(icon),
          const SizedBox(width: HyUiSpacing.xs),
        ],
        if (expanded) Flexible(child: text) else text,
        if (trailingIcon != null) ...<Widget>[
          const SizedBox(width: HyUiSpacing.xs),
          Icon(trailingIcon),
        ],
      ],
    );
  }
}

class _HyButtonMetrics {
  const _HyButtonMetrics({
    required this.height,
    required this.minWidth,
    required this.horizontal,
    required this.fontSize,
    required this.iconOnlyIconSize,
    required this.labelIconSize,
  });

  final double height;
  final double minWidth;
  final double horizontal;
  final double fontSize;
  final double iconOnlyIconSize;
  /// 带文字时前置/后置图标的默认尺寸，随字号联动。
  final double labelIconSize;

  /// 由数值高度推导整套尺寸指标（以 38px 为基准档）：
  /// 字号与带文字图标每 6px 高度步进 1，图标按钮图标每 6px 步进 2，
  /// 水平内边距每 6px 步进 4，最小宽度每 6px 步进 15。
  static _HyButtonMetrics fromHeight(double height) {
    final d = height - 38;
    return _HyButtonMetrics(
      height: height,
      minWidth: 68 + d * 2.5,
      horizontal: 14 + d * 2 / 3,
      fontSize: 13 + d / 6,
      iconOnlyIconSize: 20 + d / 3,
      labelIconSize: 17 + d / 6,
    );
  }
}

class _HyButtonVisual {
  const _HyButtonVisual({
    required this.background,
    required this.foreground,
    required this.border,
    this.gradient,
    this.shadows = const <BoxShadow>[],
  });

  final Color background;
  final Color foreground;
  final Color border;
  final Gradient? gradient;
  final List<BoxShadow> shadows;

  static _HyButtonVisual resolve({
    required HyUiThemeTokens tokens,
    required HyGlassTheme glass,
    required HyButtonVariant variant,
    required bool disabled,
  }) {
    if (disabled) {
      return _HyButtonVisual(
        background: variant == HyButtonVariant.ghost
            ? Colors.transparent
            : glass.controlTrack,
        foreground: tokens.mutedForeground.withAlpha(150),
        // 禁用态保留弱化轮廓，色相与启用态一致（edgeShade 在浅色下仅 7% 黑，轮廓不可见）。
        border: variant == HyButtonVariant.ghost
            ? Colors.transparent
            : tokens.border.withAlpha(110),
      );
    }

    if (variant == HyButtonVariant.filled ||
        variant == HyButtonVariant.danger) {
      final base = variant == HyButtonVariant.danger
          ? tokens.error
          : tokens.primary;
      return _HyButtonVisual(
        background: base,
        foreground: tokens.primaryForeground,
        border: Colors.white.withAlpha(45),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Color.lerp(base, Colors.white, 0.10)!, base],
        ),
        shadows: <BoxShadow>[
          BoxShadow(
            color: base.withAlpha(50),
            blurRadius: 16,
            spreadRadius: -5,
            offset: const Offset(0, 7),
          ),
        ],
      );
    }

    return switch (variant) {
      HyButtonVariant.tonal => _HyButtonVisual(
        background: glass.selection,
        foreground: tokens.foreground,
        border: glass.edgeHighlight,
      ),
      HyButtonVariant.outline => _HyButtonVisual(
        background: glass.surfaceSubtle,
        foreground: tokens.foreground,
        // outline 层级依赖可感知轮廓，使用语义边框令牌而非玻璃分隔色。
        border: tokens.border,
      ),
      HyButtonVariant.ghost => _HyButtonVisual(
        background: Colors.transparent,
        foreground: tokens.foreground,
        border: Colors.transparent,
      ),
      HyButtonVariant.filled || HyButtonVariant.danger => throw StateError(
        'Filled variants are resolved before the switch.',
      ),
    };
  }
}
