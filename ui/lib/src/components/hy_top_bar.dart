import 'package:flutter/material.dart';

import '../theme/hy_ui_spacing.dart';
import '../theme/hy_ui_theme_tokens.dart';

class HyTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget> actions;
  final bool safeArea;
  final bool automaticallyImplyLeading;

  const HyTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions = const [],
    this.safeArea = true,
    this.automaticallyImplyLeading = true,
  });

  @override
  Size get preferredSize => Size.fromHeight(subtitle == null ? 56 : 68);

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: HyUiSpacing.pagePadding,
        vertical: HyUiSpacing.xs,
      ),
      child: Row(
        children: [
          if (leading == null && automaticallyImplyLeading && Navigator.canPop(context))
            BackButton(onPressed: () => Navigator.maybePop(context)),
          if (leading != null) ...[
            leading!,
            const SizedBox(width: HyUiSpacing.sm),
          ],
          Expanded(child: _buildTitle(context)),
          if (actions.isNotEmpty) ...[
            const SizedBox(width: HyUiSpacing.xs),
            Wrap(
              spacing: HyUiSpacing.xs,
              children: actions,
            ),
          ],
        ],
      ),
    );

    if (!safeArea) {
      return content;
    }

    return SafeArea(
      bottom: false,
      child: content,
    );
  }

  Widget _buildTitle(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            color: tokens.foreground,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            height: 1.2,
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
              height: 1.25,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}
