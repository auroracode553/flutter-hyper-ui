import 'package:flutter/material.dart';

import '../theme/doc_ui_radii.dart';
import '../theme/doc_ui_spacing.dart';
import '../theme/doc_ui_theme_tokens.dart';

class DocCard extends StatelessWidget {
  final Widget? child;
  final String? title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget> actions;
  final Widget? footer;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool selected;

  const DocCard({
    super.key,
    this.child,
    this.title,
    this.subtitle,
    this.leading,
    this.actions = const [],
    this.footer,
    this.padding = const EdgeInsets.all(DocUiSpacing.cardPadding),
    this.onTap,
    this.selected = false,
  });

  bool get _hasHeader {
    return title != null ||
        subtitle != null ||
        leading != null ||
        actions.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = DocUiThemeTokens.of(context);
    final backgroundColor =
        selected ? tokens.selectionBackground : tokens.card;
    final borderColor = selected ? tokens.primary : tokens.border;
    final content = Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_hasHeader) _buildHeader(context),
          if (_hasHeader && child != null) const SizedBox(height: DocUiSpacing.sm),
          if (child != null) child!,
          if (footer != null) ...[
            const SizedBox(height: DocUiSpacing.sm),
            Divider(color: tokens.border),
            const SizedBox(height: DocUiSpacing.sm),
            footer!,
          ],
        ],
      ),
    );

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(DocUiRadii.md),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DocUiRadii.md),
            border: Border.all(color: borderColor),
          ),
          child: content,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final tokens = DocUiThemeTokens.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (leading != null) ...[
          leading!,
          const SizedBox(width: DocUiSpacing.sm),
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
          const SizedBox(width: DocUiSpacing.xs),
          Wrap(
            spacing: DocUiSpacing.xs,
            children: actions,
          ),
        ],
      ],
    );
  }
}
