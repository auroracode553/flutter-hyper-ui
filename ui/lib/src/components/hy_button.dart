import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/hy_glass_theme.dart';
import '../theme/hy_ui_spacing.dart';
import '../theme/hy_ui_theme_tokens.dart';
import 'hy_pressable.dart';
import 'hy_tooltip.dart';

enum HyButtonVariant { filled, tonal, outline, ghost, danger }

enum HyButtonSize { sm, md, lg }

/// 通用柔性玻璃按钮。
///
/// 各变体共享相同尺寸、触控反馈和无障碍行为；颜色仅表达动作层级，不绑定业务。
///
/// 宽度默认按内容收缩（等价 CSS 的 inline-block），需要铺满父级时传
/// [expanded]。仅提供 [icon] 而不传 [label] 时自动呈现为方形图标按钮，
/// 也可以直接用 [HyButton.icon] 构造；[round] / [circle] 控制胶囊与圆形外观。
class HyButton extends StatelessWidget {
  const HyButton({
    super.key,
    this.label,
    this.onPressed,
    this.variant = HyButtonVariant.filled,
    this.size = HyButtonSize.md,
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.expanded = false,
    this.radius = 16,
    this.round = false,
    this.circle = false,
    this.iconSize,
    this.tooltip,
    this.semanticLabel,
  });

  /// 方形图标按钮：不展示文字，仅呈现图标（或加载态）。
  ///
  /// 尺寸与变体语义和普通按钮一致；[tooltip] 会在悬停或长按时提示，
  /// [semanticLabel] 用于无障碍朗读。
  const HyButton.icon({
    super.key,
    required this.icon,
    this.onPressed,
    this.variant = HyButtonVariant.filled,
    this.size = HyButtonSize.md,
    this.loading = false,
    this.radius = 16,
    this.round = false,
    this.circle = false,
    this.iconSize,
    this.tooltip,
    this.semanticLabel,
  }) : label = null,
       trailingIcon = null,
       expanded = false;

  const HyButton.filled({
    super.key,
    this.label,
    this.onPressed,
    this.size = HyButtonSize.md,
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.expanded = false,
    this.radius = 16,
    this.round = false,
    this.circle = false,
    this.iconSize,
    this.tooltip,
    this.semanticLabel,
  }) : variant = HyButtonVariant.filled;

  const HyButton.tonal({
    super.key,
    this.label,
    this.onPressed,
    this.size = HyButtonSize.md,
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.expanded = false,
    this.radius = 16,
    this.round = false,
    this.circle = false,
    this.iconSize,
    this.tooltip,
    this.semanticLabel,
  }) : variant = HyButtonVariant.tonal;

  const HyButton.outline({
    super.key,
    this.label,
    this.onPressed,
    this.size = HyButtonSize.md,
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.expanded = false,
    this.radius = 16,
    this.round = false,
    this.circle = false,
    this.iconSize,
    this.tooltip,
    this.semanticLabel,
  }) : variant = HyButtonVariant.outline;

  const HyButton.ghost({
    super.key,
    this.label,
    this.onPressed,
    this.size = HyButtonSize.md,
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.expanded = false,
    this.radius = 16,
    this.round = false,
    this.circle = false,
    this.iconSize,
    this.tooltip,
    this.semanticLabel,
  }) : variant = HyButtonVariant.ghost;

  const HyButton.danger({
    super.key,
    this.label,
    this.onPressed,
    this.size = HyButtonSize.md,
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.expanded = false,
    this.radius = 16,
    this.round = false,
    this.circle = false,
    this.iconSize,
    this.tooltip,
    this.semanticLabel,
  }) : variant = HyButtonVariant.danger;

  final String? label;
  final VoidCallback? onPressed;
  final HyButtonVariant variant;
  final HyButtonSize size;
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

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    final glass = HyGlassTheme.of(context);
    final disabled = onPressed == null;
    final blocked = disabled || loading;
    final metrics = _HyButtonMetrics.resolve(size);
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
    final isSquare = isIconOnly || circle;
    // round / circle 取胶囊圆角；其余用显式 radius。
    final effectiveRadius = (round || circle) ? metrics.height / 2 : radius;
    final borderRadius = BorderRadius.circular(effectiveRadius);
    // 图标按钮的图标随尺寸放大，带文字时保持既有 17 号图标。
    final effectiveIconSize =
        iconSize ?? (isIconOnly ? metrics.iconOnlyIconSize : 17);

    final content = Container(
      height: metrics.height,
      padding: EdgeInsets.symmetric(
        horizontal: isIconOnly ? 0 : metrics.horizontal,
      ),
      decoration: BoxDecoration(
        color: visual.gradient == null ? visual.background : null,
        gradient: visual.gradient,
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
            color: visual.foreground,
            size: effectiveIconSize,
          ),
          child: isIconOnly
              ? _buildIconOnly(visual.foreground, effectiveIconSize)
              : DefaultTextStyle(
                  style: TextStyle(
                    color: visual.foreground,
                    fontSize: metrics.fontSize,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    letterSpacing: 0.05,
                  ),
                  // 圆形（宽高相等）按钮内空间有限，文字按比例缩小而非溢出。
                  child: isSquare
                      ? FittedBox(
                          fit: BoxFit.scaleDown,
                          child: _buildContent(visual.foreground),
                        )
                      : _buildContent(visual.foreground),
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
  });

  final double height;
  final double minWidth;
  final double horizontal;
  final double fontSize;
  final double iconOnlyIconSize;

  static _HyButtonMetrics resolve(HyButtonSize size) => switch (size) {
    HyButtonSize.sm => const _HyButtonMetrics(
      height: 32,
      minWidth: 52,
      horizontal: 10,
      fontSize: 12,
      iconOnlyIconSize: 18,
    ),
    HyButtonSize.md => const _HyButtonMetrics(
      height: 38,
      minWidth: 68,
      horizontal: 14,
      fontSize: 13,
      iconOnlyIconSize: 20,
    ),
    HyButtonSize.lg => const _HyButtonMetrics(
      height: 44,
      minWidth: 82,
      horizontal: 18,
      fontSize: 14,
      iconOnlyIconSize: 22,
    ),
  };
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
