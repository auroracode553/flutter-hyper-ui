import 'package:flutter/material.dart';

import '../theme/doc_ui_spacing.dart';
import '../theme/doc_ui_theme_tokens.dart';

class DocTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool enabled;
  final bool obscureText;
  final int maxLines;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const DocTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffix,
    this.enabled = true,
    this.obscureText = false,
    this.maxLines = 1,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = DocUiThemeTokens.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              color: tokens.foreground,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: DocUiSpacing.xs),
        ],
        TextField(
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,
          obscureText: obscureText,
          maxLines: maxLines,
          keyboardType: keyboardType,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          style: TextStyle(
            color: tokens.foreground,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
            prefixIcon: prefixIcon == null
                ? null
                : Icon(prefixIcon, size: 20, color: tokens.mutedForeground),
            suffixIcon: suffix,
          ),
        ),
        if (helperText != null && errorText == null) ...[
          const SizedBox(height: DocUiSpacing.xs),
          Text(
            helperText!,
            style: TextStyle(
              color: tokens.mutedForeground,
              fontSize: 12,
              height: 1.35,
            ),
          ),
        ],
      ],
    );
  }
}
