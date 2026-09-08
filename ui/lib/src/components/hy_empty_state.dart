import 'package:flutter/material.dart';

import '../theme/hy_ui_radii.dart';
import '../theme/hy_ui_spacing.dart';
import '../theme/hy_ui_theme_tokens.dart';

class HyEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;

  const HyEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(HyUiSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: tokens.muted,
                borderRadius: BorderRadius.circular(HyUiRadii.md),
              ),
              child: Icon(
                icon,
                size: 34,
                color: tokens.mutedForeground,
              ),
            ),
            const SizedBox(height: HyUiSpacing.lg),
            Text(
              title,
              style: TextStyle(
                color: tokens.foreground,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 1.25,
              ),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: HyUiSpacing.xs),
              Text(
                message!,
                style: TextStyle(
                  color: tokens.mutedForeground,
                  fontSize: 14,
                  height: 1.45,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: HyUiSpacing.lg),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
