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

  /// A ready-to-use app host. Supply [brightness] only when overriding the system.
  static Widget app({
    required Widget home,
    String title = 'Hyper UI',
    Brightness? brightness,
    Color? primary,
    String? fontFamily,
    TransitionBuilder? builder,
  }) => _HyperApp(
    home: home,
    title: title,
    brightness: brightness,
    primary: primary,
    fontFamily: fontFamily,
    builder: builder,
  );

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

class _HyperApp extends StatelessWidget {
  const _HyperApp({
    required this.home,
    required this.title,
    this.brightness,
    this.primary,
    this.fontFamily,
    this.builder,
  });

  final Widget home;
  final String title;
  final Brightness? brightness;
  final Color? primary;
  final String? fontFamily;
  final TransitionBuilder? builder;

  @override
  Widget build(BuildContext context) {
    final resolvedBrightness =
        brightness ??
        MediaQuery.maybePlatformBrightnessOf(context) ??
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final theme = resolvedBrightness == Brightness.dark
        ? HyperUiTheme.dark(primary: primary, fontFamily: fontFamily)
        : HyperUiTheme.light(primary: primary, fontFamily: fontFamily);
    return HyperUiTheme(
      data: theme,
      child: WidgetsApp(
        title: title,
        debugShowCheckedModeBanner: false,
        color: theme.tokens.background,
        textStyle: TextStyle(
          color: theme.tokens.foreground,
          fontFamily: theme.fontFamily,
        ),
        pageRouteBuilder: <T>(settings, page) => PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) =>
              page(context),
        ),
        builder: builder,
        home: home,
      ),
    );
  }
}
