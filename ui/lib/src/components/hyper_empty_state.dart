import 'package:flutter/widgets.dart';

import '../theme/hyper_ui_radii.dart';
import '../theme/hyper_ui_spacing.dart';
import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_glass.dart';

class HyperEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;

  const HyperEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(HyperUiSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HyperGlass(
              radius: HyperUiRadii.md,
              type: 'subtle',
              borderColor: tokens.input,
              child: SizedBox.square(
                dimension: 56,
                child: Icon(icon, size: 24, color: tokens.primary),
              ),
            ),
            const SizedBox(height: HyperUiSpacing.sm),
            Text(
              title,
              style: TextStyle(
                color: tokens.foreground,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.25,
              ),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: HyperUiSpacing.xs),
              Text(
                message!,
                style: TextStyle(
                  color: tokens.mutedForeground,
                  fontSize: 13,
                  height: 1.45,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: HyperUiSpacing.sm),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
