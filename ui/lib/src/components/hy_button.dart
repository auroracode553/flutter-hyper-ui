import 'package:flutter/material.dart';


import '../theme/hy_ui_spacing.dart';
import '../theme/hy_ui_theme_tokens.dart';

enum HyButtonVariant {
  filled,
  tonal,
  outline,
  ghost,
  danger,
}

enum HyButtonSize {
  sm,
  md,
  lg,
}

class HyButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final HyButtonVariant variant;
  final HyButtonSize size;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool loading;
  final bool expanded;
  final double radius;

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

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    final disabled = onPressed == null;
    final blocked = disabled || loading;
    final visual = _HyButtonVisual.resolve(
      tokens: tokens,
      variant: variant,
      disabled: disabled,
    );
    final metrics = _HyButtonMetrics.resolve(size);

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: metrics.minWidth,
        minHeight: metrics.height,
      ),
      child: SizedBox(
        width: expanded ? double.infinity : null,
        height: metrics.height,
        child: Material(
          color: visual.background,
          borderRadius: BorderRadius.circular(radius),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: blocked ? null : onPressed,
            borderRadius: BorderRadius.circular(radius),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: metrics.horizontal),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(
                  color: visual.border,
                  width: visual.borderWidth,
                ),
              ),
              child: IconTheme(
                data: IconThemeData(color: visual.foreground, size: 18),
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: visual.foreground,
                    fontSize: metrics.fontSize,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                  child: _buildContent(visual.foreground),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Color foreground) {
    final text = Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    final children = <Widget>[
      if (loading) ...[
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(foreground),
          ),
        ),
        const SizedBox(width: HyUiSpacing.xs),
      ] else if (icon != null) ...[
        Icon(icon),
        const SizedBox(width: HyUiSpacing.xs),
      ],
      if (expanded) Flexible(child: text) else text,
      if (trailingIcon != null) ...[
        const SizedBox(width: HyUiSpacing.xs),
        Icon(trailingIcon),
      ],
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
      children: children,
    );
  }
}

class _HyButtonMetrics {
  final double height;
  final double minWidth;
  final double horizontal;
  final double fontSize;

  const _HyButtonMetrics({
    required this.height,
    required this.minWidth,
    required this.horizontal,
    required this.fontSize,
  });

  static _HyButtonMetrics resolve(HyButtonSize size) {
    return switch (size) {
      HyButtonSize.sm => const _HyButtonMetrics(
          height: 32,
          minWidth: 56,
          horizontal: 10,
          fontSize: 13,
        ),
      HyButtonSize.md => const _HyButtonMetrics(
          height: 40,
          minWidth: 72,
          horizontal: 14,
          fontSize: 14,
        ),
      HyButtonSize.lg => const _HyButtonMetrics(
          height: 48,
          minWidth: 88,
          horizontal: 18,
          fontSize: 15,
        ),
    };
  }
}

class _HyButtonVisual {
  final Color background;
  final Color foreground;
  final Color border;
  final double borderWidth;

  const _HyButtonVisual({
    required this.background,
    required this.foreground,
    required this.border,
    required this.borderWidth,
  });

  static _HyButtonVisual resolve({
    required HyUiThemeTokens tokens,
    required HyButtonVariant variant,
    required bool disabled,
  }) {
    if (disabled) {
      final isGhost = variant == HyButtonVariant.ghost;
      return _HyButtonVisual(
        background: isGhost ? Colors.transparent : tokens.muted,
        foreground: tokens.mutedForeground,
        border: isGhost ? Colors.transparent : tokens.border,
        borderWidth: isGhost ? 0 : 1,
      );
    }

    return switch (variant) {
      HyButtonVariant.filled => _HyButtonVisual(
          background: tokens.primary,
          foreground: tokens.primaryForeground,
          border: tokens.primary,
          borderWidth: 1,
        ),
      HyButtonVariant.tonal => _HyButtonVisual(
          background: tokens.selectionBackground,
          foreground: tokens.primary,
          border: tokens.selectionBackground,
          borderWidth: 1,
        ),
      HyButtonVariant.outline => _HyButtonVisual(
          background: tokens.card,
          foreground: tokens.foreground,
          border: tokens.border,
          borderWidth: 1,
        ),
      HyButtonVariant.ghost => _HyButtonVisual(
          background: Colors.transparent,
          foreground: tokens.foreground,
          border: Colors.transparent,
          borderWidth: 0,
        ),
      HyButtonVariant.danger => _HyButtonVisual(
          background: tokens.error,
          foreground: tokens.primaryForeground,
          border: tokens.error,
          borderWidth: 1,
        ),
    };
  }
}
