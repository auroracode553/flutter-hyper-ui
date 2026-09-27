import 'package:flutter/widgets.dart';

import 'hyper_glass.dart';
import 'hyper_layout.dart';

import '../theme/hyper_ui_radii.dart';
import '../theme/hyper_ui_spacing.dart';
import '../theme/hyper_ui_theme_tokens.dart';
import '../theme/hyper_glass_theme.dart';

class HyperCard extends StatelessWidget {
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
  final HyperGlassWeight weight;
  final Color? borderColor;
  final List<BoxShadow>? shadows;

  const HyperCard({
    super.key,
    this.child,
    this.title,
    this.subtitle,
    this.leading,
    this.actions = const [],
    this.footer,
    this.padding = const EdgeInsets.all(HyperUiSpacing.cardPadding),
    this.onTap,
    this.selected = false,
    this.radius = HyperUiRadii.md,
    this.blur = 18,
    this.weight = HyperGlassWeight.regular,
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
    final tokens = HyperUiThemeTokens.of(context);
    final content = Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_hasHeader) _buildHeader(context),
          if (_hasHeader && child != null)
            const SizedBox(height: HyperUiSpacing.sm),
          if (child != null) child!,
          if (footer != null) ...[
            const SizedBox(height: HyperUiSpacing.sm),
            HyperDivider(color: tokens.border),
            const SizedBox(height: HyperUiSpacing.sm),
            footer!,
          ],
        ],
      ),
    );

    return HyperGlass(
      radius: radius,
      blur: blur,
      onTap: onTap,
      weight: weight,
      color: selected ? HyperGlassTheme.of(context).surfaceStrong : null,
      borderColor: borderColor ?? (selected ? tokens.primary : null),
      shadows: shadows,
      child: content,
    );
  }

  Widget _buildHeader(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (leading != null) ...[
          leading!,
          const SizedBox(width: HyperUiSpacing.sm),
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
                    fontSize: 14,
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
          const SizedBox(width: HyperUiSpacing.xs),
          Wrap(spacing: HyperUiSpacing.xs, children: actions),
        ],
      ],
    );
  }
}
