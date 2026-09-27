import 'package:flutter/material.dart';

import 'hyper_ui_radii.dart';
import 'hyper_ui_spacing.dart';
import 'hyper_ui_theme_tokens.dart';
import 'hyper_glass_theme.dart';

class HyperUiTheme {
  const HyperUiTheme._();

  static ThemeData light({Color? primary, String? fontFamily}) {
    return _buildTheme(
      brightness: Brightness.light,
      tokens: HyperUiThemeTokens.light(primary: primary),
      fontFamily: fontFamily,
    );
  }

  static ThemeData dark({Color? primary, String? fontFamily}) {
    return _buildTheme(
      brightness: Brightness.dark,
      tokens: HyperUiThemeTokens.dark(primary: primary),
      fontFamily: fontFamily,
    );
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required HyperUiThemeTokens tokens,
    String? fontFamily,
  }) {
    final glass = brightness == Brightness.dark
        ? HyperGlassTheme.dark()
        : HyperGlassTheme.light();
    final colorScheme =
        ColorScheme.fromSeed(
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
      extensions: <ThemeExtension<dynamic>>[tokens, glass],
      appBarTheme: AppBarTheme(
        backgroundColor: tokens.background,
        foregroundColor: tokens.foreground,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: glass.surfaceSubtle,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(HyperUiRadii.sm),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(HyperUiRadii.sm),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(HyperUiRadii.sm),
          borderSide: BorderSide(color: tokens.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(HyperUiRadii.sm),
          borderSide: BorderSide(color: tokens.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: HyperUiSpacing.sm,
          vertical: HyperUiSpacing.sm,
        ),
        hintStyle: TextStyle(color: tokens.mutedForeground, fontSize: 14),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        contentTextStyle: TextStyle(color: tokens.foreground, fontSize: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HyperUiRadii.sm),
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
