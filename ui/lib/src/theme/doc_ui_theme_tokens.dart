import 'package:flutter/material.dart';

import 'doc_ui_colors.dart';

@immutable
class DocUiThemeTokens extends ThemeExtension<DocUiThemeTokens> {
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

  const DocUiThemeTokens({
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

  factory DocUiThemeTokens.light({Color? primary}) {
    final effectivePrimary = primary ?? DocUiColors.primary;
    return DocUiThemeTokens(
      background: DocUiColors.background,
      foreground: DocUiColors.foreground,
      card: DocUiColors.card,
      cardForeground: DocUiColors.cardForeground,
      primary: effectivePrimary,
      primaryForeground: DocUiColors.primaryForeground,
      muted: DocUiColors.muted,
      mutedForeground: DocUiColors.mutedForeground,
      border: DocUiColors.border,
      input: DocUiColors.input,
      selectionBackground: DocUiColors.selectionBackground,
      success: DocUiColors.success,
      warning: DocUiColors.warning,
      error: DocUiColors.error,
      info: DocUiColors.info,
    );
  }

  factory DocUiThemeTokens.dark({Color? primary}) {
    final effectivePrimary = primary ?? DocUiColors.primary;
    return DocUiThemeTokens(
      background: DocUiColors.darkBackground,
      foreground: DocUiColors.darkForeground,
      card: DocUiColors.darkCard,
      cardForeground: DocUiColors.darkForeground,
      primary: effectivePrimary,
      primaryForeground: DocUiColors.primaryForeground,
      muted: DocUiColors.darkMuted,
      mutedForeground: DocUiColors.darkMutedForeground,
      border: DocUiColors.darkBorder,
      input: DocUiColors.darkBorder,
      selectionBackground: const Color(0xFF142544),
      success: DocUiColors.success,
      warning: DocUiColors.warning,
      error: DocUiColors.error,
      info: DocUiColors.info,
    );
  }

  static DocUiThemeTokens of(BuildContext context) {
    return Theme.of(context).extension<DocUiThemeTokens>() ??
        DocUiThemeTokens.light();
  }

  @override
  DocUiThemeTokens copyWith({
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
    return DocUiThemeTokens(
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
  DocUiThemeTokens lerp(ThemeExtension<DocUiThemeTokens>? other, double t) {
    if (other is! DocUiThemeTokens) {
      return this;
    }

    return DocUiThemeTokens(
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
