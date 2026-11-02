import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hyper_ui_theme_tokens.dart';
import '../theme/hyper_ui_effects.dart';
import 'hyper_form_field.dart';
import 'hyper_glass.dart';
import 'hyper_control_surface.dart';
import '../interaction/press_feedback.dart';

/// Select 与 Dropdown 共用的字段触发器；弹层方式由调用方决定。
Widget buildHySelectionField(
  BuildContext context, {
  required String value,
  required bool isPlaceholder,
  String? label,
  VoidCallback? onTap,
  IconData trailingIcon = LucideIcons.chevronDown,
  bool expanded = false,
  bool fixedGlass = false,
}) {
  final tokens = HyperUiThemeTokens.of(context);
  final content = ConstrainedBox(
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
          AnimatedRotation(
            turns: expanded ? 0.5 : 0,
            duration: MediaQuery.maybeOf(context)?.disableAnimations == true
                ? Duration.zero
                : HyperUiEffects.menuDuration,
            curve: HyperUiEffects.overlayCurve,
            child: Icon(trailingIcon, size: 18, color: tokens.mutedForeground),
          ),
        ],
      ),
    ),
  );
  final field = fixedGlass && onTap != null
      ? PressFeedback(
          onPressed: onTap,
          child: HyperControlSurface(
            radius: 16,
            role: HyperControlSurfaceRole.field,
            border: Border.all(color: tokens.input),
            child: content,
          ),
        )
      : HyperGlass(
          radius: 16,
          type: 'subtle',
          borderColor: tokens.input,
          onPressed: onTap,
          child: content,
        );
  return label == null ? field : HyperFormField(label: label, child: field);
}
