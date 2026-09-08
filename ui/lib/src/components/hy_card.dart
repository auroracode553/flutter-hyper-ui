import 'package:flutter/material.dart';
import 'hy_glass.dart';

import '../theme/hy_ui_radii.dart';
import '../theme/hy_ui_spacing.dart';
import '../theme/hy_ui_theme_tokens.dart';

class HyCard extends StatelessWidget {
  final Widget? child;
  final String? title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget> actions;
  final Widget? footer;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool selected;
  final double radius;
  final double blur;
  final Color? borderColor;
  final List<BoxShadow>? shadows;

  const HyCard({
    super.key,
    this.child,
    this.title,
    this.subtitle,
    this.leading,
    this.actions = const [],
    this.footer,
    this.padding = const EdgeInsets.all(HyUiSpacing.cardPadding),
    this.onTap,
    this.selected = false,
    this.radius = HyUiRadii.md,
    this.blur = 18,
    this.borderColor,
    this.shadows,
  });

  bool get _hasHeader {
    return title != null ||
        subtitle != null ||
        leading != null ||
        actions.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    final content = Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_hasHeader) _buildHeader(context),
          if (_hasHeader && child != null) const SizedBox(height: HyUiSpacing.sm),
          if (child != null) child!,
          if (footer != null) ...[
            const SizedBox(height: HyUiSpacing.sm),
            Divider(color: tokens.border),
            const SizedBox(height: HyUiSpacing.sm),
            footer!,
          ],
        ],
      ),
    );

    return HyGlass(radius: radius, blur: blur, onTap: onTap,
      color: selected ? tokens.selectionBackground : null,
      borderColor: borderColor ?? (selected ? tokens.primary : null),
      shadows: shadows, child: content);
  }

  Widget _buildHeader(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (leading != null) ...[
          leading!,
          const SizedBox(width: HyUiSpacing.sm),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null)
                Text(
                  title!,
                  style: TextStyle(
                    color: tokens.cardForeground,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: TextStyle(
                    color: tokens.mutedForeground,
                    fontSize: 13,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        if (actions.isNotEmpty) ...[
          const SizedBox(width: HyUiSpacing.xs),
          Wrap(
            spacing: HyUiSpacing.xs,
            children: actions,
          ),
        ],
      ],
    );
  }
}
