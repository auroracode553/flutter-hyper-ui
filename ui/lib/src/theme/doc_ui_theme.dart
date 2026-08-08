import 'package:flutter/material.dart';

import 'doc_ui_radii.dart';
import 'doc_ui_spacing.dart';
import 'doc_ui_theme_tokens.dart';

class DocUiTheme {
  const DocUiTheme._();

  static ThemeData light({
    Color? primary,
    String? fontFamily,
  }) {
    return _buildTheme(
      brightness: Brightness.light,
      tokens: DocUiThemeTokens.light(primary: primary),
      fontFamily: fontFamily,
    );
  }

  static ThemeData dark({
    Color? primary,
    String? fontFamily,
  }) {
    return _buildTheme(
      brightness: Brightness.dark,
      tokens: DocUiThemeTokens.dark(primary: primary),
      fontFamily: fontFamily,
    );
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required DocUiThemeTokens tokens,
    String? fontFamily,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: tokens.primary,
      brightness: brightness,
    ).copyWith(
      primary: tokens.primary,
      onPrimary: tokens.primaryForeground,
      surface: tokens.card,
      onSurface: tokens.cardForeground,
      surfaceContainerHighest: tokens.muted,
      onSurfaceVariant: tokens.mutedForeground,
      outline: tokens.border,
      outlineVariant: tokens.border,
      error: tokens.error,
      onError: tokens.primaryForeground,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: tokens.background,
      extensions: <ThemeExtension<dynamic>>[tokens],
      appBarTheme: AppBarTheme(
        backgroundColor: tokens.background,
        foregroundColor: tokens.foreground,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
      ),
      cardTheme: CardThemeData(
        color: tokens.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DocUiRadii.md),
          side: BorderSide(color: tokens.border),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: tokens.border,
        space: 1,
        thickness: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: tokens.muted,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DocUiRadii.sm),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DocUiRadii.sm),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DocUiRadii.sm),
          borderSide: BorderSide(color: tokens.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DocUiRadii.sm),
          borderSide: BorderSide(color: tokens.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DocUiSpacing.sm,
          vertical: DocUiSpacing.sm,
        ),
        hintStyle: TextStyle(
          color: tokens.mutedForeground,
          fontSize: 15,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: tokens.foreground,
        contentTextStyle: TextStyle(
          color: tokens.background,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DocUiRadii.sm),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: tokens.primary,
        foregroundColor: tokens.primaryForeground,
        elevation: 4,
        shape: const CircleBorder(),
      ),
    );
  }
}
