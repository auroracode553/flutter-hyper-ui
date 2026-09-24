import 'package:flutter/material.dart';

import '../theme/hy_glass_theme.dart';
import '../theme/hy_ui_spacing.dart';
import '../theme/hy_ui_theme_tokens.dart';
import 'hy_pressable.dart';

enum HyButtonVariant { filled, tonal, outline, ghost, danger }

enum HyButtonSize { sm, md, lg }

/// 通用柔性玻璃按钮。
///
/// 各变体共享相同尺寸、触控反馈和无障碍行为；颜色仅表达动作层级，不绑定业务。
class HyButton extends StatelessWidget {
  const HyButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = HyButtonVariant.filled,
    this.size = HyButtonSize.md,
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.expanded = false,
    this.radius = 16,
  });

  const HyButton.filled({
    super.key,
    required this.label,
    this.onPressed,
    this.size = HyButtonSize.md,
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.expanded = false,
    this.radius = 16,
  }) : variant = HyButtonVariant.filled;

  const HyButton.tonal({
    super.key,
    required this.label,
    this.onPressed,
    this.size = HyButtonSize.md,
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.expanded = false,
    this.radius = 16,
  }) : variant = HyButtonVariant.tonal;

  const HyButton.outline({
    super.key,
    required this.label,
    this.onPressed,
    this.size = HyButtonSize.md,
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.expanded = false,
    this.radius = 16,
  }) : variant = HyButtonVariant.outline;

  const HyButton.ghost({
    super.key,
    required this.label,
    this.onPressed,
    this.size = HyButtonSize.md,
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.expanded = false,
    this.radius = 16,
  }) : variant = HyButtonVariant.ghost;

  const HyButton.danger({
    super.key,
    required this.label,
    this.onPressed,
    this.size = HyButtonSize.md,
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.expanded = false,
    this.radius = 16,
  }) : variant = HyButtonVariant.danger;

  final String label;
  final VoidCallback? onPressed;
  final HyButtonVariant variant;
  final HyButtonSize size;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool loading;
  final bool expanded;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    final glass = HyGlassTheme.of(context);
    final disabled = onPressed == null;
    final blocked = disabled || loading;
    final metrics = _HyButtonMetrics.resolve(size);
    final visual = _HyButtonVisual.resolve(
      tokens: tokens,
      glass: glass,
      variant: variant,
      disabled: disabled,
    );
    final borderRadius = BorderRadius.circular(radius);

    final content = Container(
      height: metrics.height,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: metrics.horizontal),
      decoration: BoxDecoration(
        color: visual.gradient == null ? visual.background : null,
        gradient: visual.gradient,
        borderRadius: borderRadius,
        border: Border.all(color: visual.border),
        boxShadow: visual.shadows,
      ),
      child: IconTheme(
        data: IconThemeData(color: visual.foreground, size: 18),
        child: DefaultTextStyle(
          style: TextStyle(
            color: visual.foreground,
            fontSize: metrics.fontSize,
            fontWeight: FontWeight.w600,
            height: 1.2,
            letterSpacing: 0.05,
          ),
          child: _buildContent(visual.foreground),
        ),
      ),
    );

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: metrics.minWidth,
        minHeight: metrics.height,
      ),
      child: SizedBox(
        width: expanded ? double.infinity : null,
        child: HyPressable(
          onPressed: blocked ? null : onPressed,
          enabled: !blocked,
          borderRadius: borderRadius,
          semanticLabel: loading ? '$label，正在处理' : label,
          child: content,
        ),
      ),
    );
  }

  Widget _buildContent(Color foreground) {
    final text = Text(label, maxLines: 1, overflow: TextOverflow.ellipsis);
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
  });

  final double height;
  final double minWidth;
  final double horizontal;
  final double fontSize;

  static _HyButtonMetrics resolve(HyButtonSize size) => switch (size) {
    HyButtonSize.sm => const _HyButtonMetrics(
      height: 34,
      minWidth: 58,
      horizontal: 12,
      fontSize: 13,
    ),
    HyButtonSize.md => const _HyButtonMetrics(
      height: 42,
      minWidth: 76,
      horizontal: 16,
      fontSize: 14,
    ),
    HyButtonSize.lg => const _HyButtonMetrics(
      height: 50,
      minWidth: 92,
      horizontal: 20,
      fontSize: 15,
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
