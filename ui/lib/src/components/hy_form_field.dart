import 'package:flutter/material.dart';

import '../theme/hy_ui_spacing.dart';
import '../theme/hy_ui_theme_tokens.dart';

/// 为任意输入控件统一提供标题、辅助文字和错误提示。
///
/// 校验状态由业务或子控件持有；[HyFormField] 只负责字段布局。
class HyFormField extends StatelessWidget {
  const HyFormField({
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
    final tokens = HyUiThemeTokens.of(context);
    final hasError = errorText != null && errorText!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Semantics(
                label: isRequired ? '$label，必填' : label,
                child: ExcludeSemantics(
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
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
        const SizedBox(height: HyUiSpacing.xs),
        child,
        if (hasError) ...<Widget>[
          const SizedBox(height: HyUiSpacing.xxs),
          Semantics(
            liveRegion: true,
            child: Text(
              errorText!,
              style: TextStyle(color: tokens.error, fontSize: 12, height: 1.3),
            ),
          ),
        ] else if (helperText != null && helperText!.isNotEmpty) ...<Widget>[
          const SizedBox(height: HyUiSpacing.xxs),
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
