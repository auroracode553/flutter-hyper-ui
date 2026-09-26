import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hy_ui_theme_tokens.dart';
import 'hy_form_field.dart';
import 'hy_glass.dart';

/// Select 与 Dropdown 共用的字段触发器；弹层方式由调用方决定。
Widget buildHySelectionField(
  BuildContext context, {
  required String value,
  required bool isPlaceholder,
  String? label,
  VoidCallback? onTap,
  IconData trailingIcon = LucideIcons.chevronDown,
}) {
  final tokens = HyUiThemeTokens.of(context);
  final field = HyGlass(
    radius: 16,
    blur: 14,
    weight: HyGlassWeight.subtle,
    borderColor: tokens.input,
    onTap: onTap,
    child: ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.3,
                  fontWeight: FontWeight.w500,
                  color: isPlaceholder
                      ? tokens.mutedForeground
                      : tokens.foreground,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Icon(trailingIcon, size: 18, color: tokens.mutedForeground),
          ],
        ),
      ),
    ),
  );
  return label == null ? field : HyFormField(label: label, child: field);
}
