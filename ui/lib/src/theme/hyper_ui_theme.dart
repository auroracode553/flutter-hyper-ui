import 'package:flutter/widgets.dart';

import 'hyper_glass_theme.dart';
import 'hyper_ui_theme_tokens.dart';

/// Hyper UI's own visual configuration.
@immutable
class HyperUiThemeData {
  const HyperUiThemeData({
    required this.brightness,
    required this.tokens,
    required this.glass,
    this.fontFamily,
  });

  final Brightness brightness;
  final HyperUiThemeTokens tokens;
  final HyperGlassTheme glass;
  final String? fontFamily;

  HyperUiThemeData copyWith({
    Brightness? brightness,
    HyperUiThemeTokens? tokens,
    HyperGlassTheme? glass,
    String? fontFamily,
  }) => HyperUiThemeData(
    brightness: brightness ?? this.brightness,
    tokens: tokens ?? this.tokens,
    glass: glass ?? this.glass,
    fontFamily: fontFamily ?? this.fontFamily,
  );
}

/// Provides Hyper colors and glass surfaces to descendant widgets.
class HyperUiTheme extends InheritedWidget {
  const HyperUiTheme({super.key, required this.data, required super.child});

  final HyperUiThemeData data;

  static HyperUiThemeData light({Color? primary, String? fontFamily}) =>
      HyperUiThemeData(
        brightness: Brightness.light,
        tokens: HyperUiThemeTokens.light(primary: primary),
        glass: HyperGlassTheme.light(),
        fontFamily: fontFamily,
      );

  static HyperUiThemeData dark({Color? primary, String? fontFamily}) =>
      HyperUiThemeData(
        brightness: Brightness.dark,
        tokens: HyperUiThemeTokens.dark(primary: primary),
        glass: HyperGlassTheme.dark(),
        fontFamily: fontFamily,
      );

  static HyperUiThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<HyperUiTheme>()?.data ??
      light();

  @override
  bool updateShouldNotify(HyperUiTheme oldWidget) => data != oldWidget.data;
}
