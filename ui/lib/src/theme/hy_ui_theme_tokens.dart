import 'package:flutter/material.dart';

import 'hy_ui_colors.dart';

@immutable
class HyUiThemeTokens extends ThemeExtension<HyUiThemeTokens> {
  final Color background;
  final Color foreground;
  final Color card;
  final Color cardForeground;
  final Color primary;
  final Color primaryForeground;
  final Color muted;
  final Color mutedForeground;
  final Color border;
  final Color input;
  final Color selectionBackground;
  final Color success;
  final Color warning;
  final Color error;
  final Color info;

  const HyUiThemeTokens({
    required this.background,
    required this.foreground,
    required this.card,
    required this.cardForeground,
    required this.primary,
    required this.primaryForeground,
    required this.muted,
    required this.mutedForeground,
    required this.border,
    required this.input,
    required this.selectionBackground,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
  });

  factory HyUiThemeTokens.light({Color? primary}) {
    final effectivePrimary = primary ?? HyUiColors.primary;
    return HyUiThemeTokens(
      background: HyUiColors.background,
      foreground: HyUiColors.foreground,
      card: HyUiColors.card,
      cardForeground: HyUiColors.cardForeground,
      primary: effectivePrimary,
      primaryForeground: HyUiColors.primaryForeground,
      muted: HyUiColors.muted,
      mutedForeground: HyUiColors.mutedForeground,
      border: HyUiColors.border,
      input: HyUiColors.input,
      selectionBackground: HyUiColors.selectionBackground,
      success: HyUiColors.success,
      warning: HyUiColors.warning,
      error: HyUiColors.error,
      info: HyUiColors.info,
    );
  }

  factory HyUiThemeTokens.dark({Color? primary}) {
    final effectivePrimary = primary ?? HyUiColors.primary;
    return HyUiThemeTokens(
      background: HyUiColors.darkBackground,
      foreground: HyUiColors.darkForeground,
      card: HyUiColors.darkCard,
      cardForeground: HyUiColors.darkForeground,
      primary: effectivePrimary,
      primaryForeground: HyUiColors.primaryForeground,
      muted: HyUiColors.darkMuted,
      mutedForeground: HyUiColors.darkMutedForeground,
      border: HyUiColors.darkBorder,
      input: HyUiColors.darkBorder,
      selectionBackground: const Color(0xFF142544),
      success: HyUiColors.success,
      warning: HyUiColors.warning,
      error: HyUiColors.error,
      info: HyUiColors.info,
    );
  }

  static HyUiThemeTokens of(BuildContext context) {
    return Theme.of(context).extension<HyUiThemeTokens>() ??
        HyUiThemeTokens.light();
  }

  @override
  HyUiThemeTokens copyWith({
    Color? background,
    Color? foreground,
    Color? card,
    Color? cardForeground,
    Color? primary,
    Color? primaryForeground,
    Color? muted,
    Color? mutedForeground,
    Color? border,
    Color? input,
    Color? selectionBackground,
    Color? success,
    Color? warning,
    Color? error,
    Color? info,
  }) {
    return HyUiThemeTokens(
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
      card: card ?? this.card,
      cardForeground: cardForeground ?? this.cardForeground,
      primary: primary ?? this.primary,
      primaryForeground: primaryForeground ?? this.primaryForeground,
      muted: muted ?? this.muted,
      mutedForeground: mutedForeground ?? this.mutedForeground,
      border: border ?? this.border,
      input: input ?? this.input,
      selectionBackground: selectionBackground ?? this.selectionBackground,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      info: info ?? this.info,
    );
  }

  @override
  HyUiThemeTokens lerp(ThemeExtension<HyUiThemeTokens>? other, double t) {
    if (other is! HyUiThemeTokens) {
      return this;
    }

    return HyUiThemeTokens(
      background: Color.lerp(background, other.background, t)!,
      foreground: Color.lerp(foreground, other.foreground, t)!,
      card: Color.lerp(card, other.card, t)!,
      cardForeground: Color.lerp(cardForeground, other.cardForeground, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryForeground:
          Color.lerp(primaryForeground, other.primaryForeground, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      mutedForeground: Color.lerp(mutedForeground, other.mutedForeground, t)!,
      border: Color.lerp(border, other.border, t)!,
      input: Color.lerp(input, other.input, t)!,
      selectionBackground:
          Color.lerp(selectionBackground, other.selectionBackground, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      info: Color.lerp(info, other.info, t)!,
    );
  }
}
