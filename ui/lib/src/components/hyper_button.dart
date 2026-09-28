import 'package:flutter_hyper_ui/src/theme/hyper_palette.dart';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'hyper_progress_painters.dart';

import '../theme/hyper_glass_theme.dart';
import '../theme/hyper_ui_spacing.dart';
import '../theme/hyper_ui_size.dart';
import '../theme/hyper_ui_theme.dart';
import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_pressable.dart';
import 'hyper_tooltip.dart';

/// Self-drawn button with a small default API and an optional content slot.
class HyperButton extends StatelessWidget {
  const HyperButton({
    super.key,
    this.type = 'filled',
    this.label,
    this.child,
    this.onPressed,
    this.size = 'default',
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.expanded = false,
    this.tooltip,
    this.color,
    this.backgroundColor,
  }) : assert(
         type == 'filled' ||
             type == 'tonal' ||
             type == 'outline' ||
             type == 'ghost' ||
             type == 'danger',
         'HyperButton.type must be filled, tonal, outline, ghost, or danger.',
       ),
       assert(
         label == null || child == null,
         'HyperButton.label and child cannot be used together.',
       );

  final String? label;
  final Widget? child;
  final VoidCallback? onPressed;
  final String type;
  final String size;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool loading;
  final bool expanded;
  final String? tooltip;
  final Color? color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    if (label != null && this.child != null) {
      throw ArgumentError(
        'HyperButton.label and child cannot be used together.',
      );
    }
    final variant = switch (type) {
      'tonal' => _ButtonVariant.tonal,
      'outline' => _ButtonVariant.outline,
      'ghost' => _ButtonVariant.ghost,
      'danger' => _ButtonVariant.danger,
      'filled' => _ButtonVariant.filled,
      _ => throw ArgumentError.value(type, 'type', 'Invalid button type'),
    };
    final tokens = HyperUiThemeTokens.of(context);
    final glass = HyperGlassTheme.of(context);
    final disabled = onPressed == null;
    final blocked = disabled || loading;
    final metrics = _HyperButtonMetrics.fromSize(size);
    final hasLabel = label != null && label!.isNotEmpty;
    final isIconOnly =
        !hasLabel && this.child == null && (icon != null || loading);
    assert(
      (hasLabel ? 1 : 0) +
              (this.child != null ? 1 : 0) +
              (icon != null ? 1 : 0) +
              (loading ? 1 : 0) >
          0,
      'HyperButton needs label, child, icon, or loading.',
    );

    final visual = _HyperButtonVisual.resolve(
      tokens: tokens,
      glass: glass,
      variant: variant,
      disabled: disabled,
    );
    final foreground = color ?? visual.foreground;
    final background =
        backgroundColor ??
        (isIconOnly && variant == _ButtonVariant.tonal
            ? glass.surface
            : visual.background);
    final isSquare = isIconOnly;
    final borderRadius = BorderRadius.circular(metrics.height / 2);
    final effectiveIconSize = isIconOnly
        ? metrics.iconOnlyIconSize
        : metrics.labelIconSize;

    final content = Container(
      height: metrics.height,
      padding: EdgeInsets.symmetric(
        horizontal: isIconOnly ? 0 : metrics.horizontal,
      ),
      decoration: BoxDecoration(
        color:
            backgroundColor != null ||
                (isIconOnly && variant == _ButtonVariant.tonal) ||
                visual.gradient == null
            ? background
            : null,
        gradient:
            backgroundColor != null ||
                (isIconOnly && variant == _ButtonVariant.tonal)
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
          data: IconThemeData(color: foreground, size: effectiveIconSize),
          child: isIconOnly
              ? _buildIconOnly(foreground, effectiveIconSize)
              : DefaultTextStyle(
                  style: TextStyle(
                    color: foreground,
                    fontFamily: HyperUiTheme.of(context).fontFamily,
                    fontSize: metrics.fontSize,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    letterSpacing: 0.05,
                    decoration: TextDecoration.none,
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

    Widget child = ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: isSquare ? metrics.height : metrics.minWidth,
        minHeight: metrics.height,
      ),
      child: SizedBox(
        // 默认按内容收缩（inline-block）；仅 expanded 时铺满。
        width: isSquare ? metrics.height : (expanded ? double.infinity : null),
        child: HyperPressable(
          onPressed: blocked ? null : onPressed,
          enabled: !blocked,
          borderRadius: borderRadius,
          child: content,
        ),
      ),
    );

    if (tooltip != null && tooltip!.isNotEmpty) {
      child = HyperTooltip(message: tooltip!, child: child);
    }
    return child;
  }

  /// 图标按钮内容：加载态显示转圈，否则居中显示图标。
  Widget _buildIconOnly(Color foreground, double iconSize) {
    if (loading) {
      return SizedBox.square(
        dimension: math.max(12.0, iconSize - 2),
        child: HyperSpinner(strokeWidth: 2, color: foreground),
      );
    }
    return child ?? Icon(icon!);
  }

  Widget _buildContent(Color foreground) {
    final content =
        child ?? Text(label!, maxLines: 1, overflow: TextOverflow.ellipsis);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
      children: <Widget>[
        if (loading) ...<Widget>[
          SizedBox.square(
            dimension: 16,
            child: HyperSpinner(strokeWidth: 2, color: foreground),
          ),
          const SizedBox(width: HyperUiSpacing.xs),
        ] else if (icon != null) ...<Widget>[
          Icon(icon),
          const SizedBox(width: HyperUiSpacing.xs),
        ],
        if (expanded) Flexible(child: content) else content,
        if (trailingIcon != null) ...<Widget>[
          const SizedBox(width: HyperUiSpacing.xs),
          Icon(trailingIcon),
        ],
      ],
    );
  }
}

class _HyperButtonMetrics {
  const _HyperButtonMetrics({
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

  /// A single size choice controls height, text, icon, and padding together.
  static _HyperButtonMetrics fromSize(String size) {
    final height = hyperUiSizeValue(size, small: 32, normal: 38, large: 44);
    final d = height - 38;
    return _HyperButtonMetrics(
      height: height,
      minWidth: 68 + d * 2.5,
      horizontal: 14 + d * 2 / 3,
      fontSize: 13 + d / 6,
      iconOnlyIconSize: 20 + d / 3,
      labelIconSize: 17 + d / 6,
    );
  }
}

class _HyperButtonVisual {
  const _HyperButtonVisual({
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

  static _HyperButtonVisual resolve({
    required HyperUiThemeTokens tokens,
    required HyperGlassTheme glass,
    required _ButtonVariant variant,
    required bool disabled,
  }) {
    if (disabled) {
      return _HyperButtonVisual(
        background: variant == _ButtonVariant.ghost
            ? HyperPalette.transparent
            : glass.controlTrack,
        foreground: tokens.mutedForeground.withAlpha(150),
        // 禁用态保留弱化轮廓，色相与启用态一致（edgeShade 在浅色下仅 7% 黑，轮廓不可见）。
        border: variant == _ButtonVariant.ghost
            ? HyperPalette.transparent
            : tokens.border.withAlpha(110),
      );
    }

    if (variant == _ButtonVariant.filled || variant == _ButtonVariant.danger) {
      final base = variant == _ButtonVariant.danger
          ? tokens.error
          : tokens.primary;
      return _HyperButtonVisual(
        background: base,
        foreground: tokens.primaryForeground,
        border: tokens.primaryForeground.withAlpha(45),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color.lerp(base, tokens.primaryForeground, 0.10)!,
            base,
          ],
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
      _ButtonVariant.tonal => _HyperButtonVisual(
        background: glass.selection,
        foreground: tokens.foreground,
        border: glass.edgeHighlight,
      ),
      _ButtonVariant.outline => _HyperButtonVisual(
        background: glass.surfaceSubtle,
        foreground: tokens.foreground,
        // outline 层级依赖可感知轮廓，使用语义边框令牌而非玻璃分隔色。
        border: tokens.border,
      ),
      _ButtonVariant.ghost => _HyperButtonVisual(
        background: HyperPalette.transparent,
        foreground: tokens.foreground,
        border: HyperPalette.transparent,
      ),
      _ => throw StateError('Unexpected button variant'),
    };
  }
}

enum _ButtonVariant { filled, tonal, outline, ghost, danger }
