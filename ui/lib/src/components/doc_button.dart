import 'package:flutter/material.dart';

import '../theme/doc_ui_radii.dart';
import '../theme/doc_ui_spacing.dart';
import '../theme/doc_ui_theme_tokens.dart';

enum DocButtonVariant {
  filled,
  tonal,
  outline,
  ghost,
  danger,
}

enum DocButtonSize {
  sm,
  md,
  lg,
}

class DocButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final DocButtonVariant variant;
  final DocButtonSize size;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool loading;
  final bool expanded;

  const DocButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = DocButtonVariant.filled,
    this.size = DocButtonSize.md,
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.expanded = false,
  });

  const DocButton.filled({
    super.key,
    required this.label,
    this.onPressed,
    this.size = DocButtonSize.md,
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.expanded = false,
  }) : variant = DocButtonVariant.filled;

  const DocButton.tonal({
    super.key,
    required this.label,
    this.onPressed,
    this.size = DocButtonSize.md,
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.expanded = false,
  }) : variant = DocButtonVariant.tonal;

  const DocButton.outline({
    super.key,
    required this.label,
    this.onPressed,
    this.size = DocButtonSize.md,
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.expanded = false,
  }) : variant = DocButtonVariant.outline;

  const DocButton.ghost({
    super.key,
    required this.label,
    this.onPressed,
    this.size = DocButtonSize.md,
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.expanded = false,
  }) : variant = DocButtonVariant.ghost;

  const DocButton.danger({
    super.key,
    required this.label,
    this.onPressed,
    this.size = DocButtonSize.md,
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.expanded = false,
  }) : variant = DocButtonVariant.danger;

  @override
  Widget build(BuildContext context) {
    final tokens = DocUiThemeTokens.of(context);
    final disabled = onPressed == null;
    final blocked = disabled || loading;
    final visual = _DocButtonVisual.resolve(
      tokens: tokens,
      variant: variant,
      disabled: disabled,
    );
    final metrics = _DocButtonMetrics.resolve(size);

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
          borderRadius: BorderRadius.circular(DocUiRadii.sm),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: blocked ? null : onPressed,
            borderRadius: BorderRadius.circular(DocUiRadii.sm),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: metrics.horizontal),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(DocUiRadii.sm),
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
        const SizedBox(width: DocUiSpacing.xs),
      ] else if (icon != null) ...[
        Icon(icon),
        const SizedBox(width: DocUiSpacing.xs),
      ],
      if (expanded) Flexible(child: text) else text,
      if (trailingIcon != null) ...[
        const SizedBox(width: DocUiSpacing.xs),
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

class _DocButtonMetrics {
  final double height;
  final double minWidth;
  final double horizontal;
  final double fontSize;

  const _DocButtonMetrics({
    required this.height,
    required this.minWidth,
    required this.horizontal,
    required this.fontSize,
  });

  static _DocButtonMetrics resolve(DocButtonSize size) {
    return switch (size) {
      DocButtonSize.sm => const _DocButtonMetrics(
          height: 32,
          minWidth: 56,
          horizontal: 10,
          fontSize: 13,
        ),
      DocButtonSize.md => const _DocButtonMetrics(
          height: 40,
          minWidth: 72,
          horizontal: 14,
          fontSize: 14,
        ),
      DocButtonSize.lg => const _DocButtonMetrics(
          height: 48,
          minWidth: 88,
          horizontal: 18,
          fontSize: 15,
        ),
    };
  }
}

class _DocButtonVisual {
  final Color background;
  final Color foreground;
  final Color border;
  final double borderWidth;

  const _DocButtonVisual({
    required this.background,
    required this.foreground,
    required this.border,
    required this.borderWidth,
  });

  static _DocButtonVisual resolve({
    required DocUiThemeTokens tokens,
    required DocButtonVariant variant,
    required bool disabled,
  }) {
    if (disabled) {
      final isGhost = variant == DocButtonVariant.ghost;
      return _DocButtonVisual(
        background: isGhost ? Colors.transparent : tokens.muted,
        foreground: tokens.mutedForeground,
        border: isGhost ? Colors.transparent : tokens.border,
        borderWidth: isGhost ? 0 : 1,
      );
    }

    return switch (variant) {
      DocButtonVariant.filled => _DocButtonVisual(
          background: tokens.primary,
          foreground: tokens.primaryForeground,
          border: tokens.primary,
          borderWidth: 1,
        ),
      DocButtonVariant.tonal => _DocButtonVisual(
          background: tokens.selectionBackground,
          foreground: tokens.primary,
          border: tokens.selectionBackground,
          borderWidth: 1,
        ),
      DocButtonVariant.outline => _DocButtonVisual(
          background: tokens.card,
          foreground: tokens.foreground,
          border: tokens.border,
          borderWidth: 1,
        ),
      DocButtonVariant.ghost => _DocButtonVisual(
          background: Colors.transparent,
          foreground: tokens.foreground,
          border: Colors.transparent,
          borderWidth: 0,
        ),
      DocButtonVariant.danger => _DocButtonVisual(
          background: tokens.error,
          foreground: tokens.primaryForeground,
          border: tokens.error,
          borderWidth: 1,
        ),
    };
  }
}
