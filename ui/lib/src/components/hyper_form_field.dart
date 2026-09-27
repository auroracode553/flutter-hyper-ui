import 'package:flutter/material.dart';

import '../theme/hyper_ui_spacing.dart';
import '../theme/hyper_ui_theme_tokens.dart';

/// 为任意输入控件统一提供标题、辅助文字和错误提示。
///
/// 校验状态由业务或子控件持有；[HyperFormField] 只负责字段布局。
class HyperFormField extends StatelessWidget {
  const HyperFormField({
    super.key,
    required this.label,
    required this.child,
    this.helperText,
    this.errorText,
    this.isRequired = false,
    this.trailing,
  });

  final String label;
  final Widget child;
  final String? helperText;
  final String? errorText;
  final bool isRequired;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    final hasError = errorText != null && errorText!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: <InlineSpan>[
                    TextSpan(text: label),
                    if (isRequired)
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: tokens.error),
                      ),
                  ],
                ),
                style: TextStyle(
                  color: tokens.foreground,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
        const SizedBox(height: HyperUiSpacing.xs),
        child,
        if (hasError) ...<Widget>[
          const SizedBox(height: HyperUiSpacing.xxs),
          Text(
            errorText!,
            style: TextStyle(color: tokens.error, fontSize: 12, height: 1.3),
          ),
        ] else if (helperText != null && helperText!.isNotEmpty) ...<Widget>[
          const SizedBox(height: HyperUiSpacing.xxs),
          Text(
            helperText!,
            style: TextStyle(
              color: tokens.mutedForeground,
              fontSize: 12,
              height: 1.3,
            ),
          ),
        ],
      ],
    );
  }
}
