import 'package:flutter/widgets.dart';

class HyperScreen {
  const HyperScreen(this.context, {this.designWidth = 375});
  final BuildContext context;
  final double designWidth;
  double get width => MediaQuery.sizeOf(context).width;
  double dp(double value) => value * (width / designWidth).clamp(.75, 1.4);
  double rpx(double value) => value * width / 750;
  bool get compact => width < 600;
}

abstract final class HyperKeyboard {
  static void dismiss(BuildContext context) => FocusScope.of(context).unfocus();
  static double inset(BuildContext context) =>
      MediaQuery.viewInsetsOf(context).bottom;
}

class HyperSafeArea extends StatelessWidget {
  const HyperSafeArea({
    super.key,
    required this.child,
    this.top = true,
    this.bottom = true,
    this.minimum = EdgeInsets.zero,
  });
  final Widget child;
  final bool top, bottom;
  final EdgeInsets minimum;
  @override
  Widget build(BuildContext context) =>
      SafeArea(top: top, bottom: bottom, minimum: minimum, child: child);
}

abstract final class HyperRoute {
  static Future<T?> push<T>(
    BuildContext context,
    WidgetBuilder builder, {
    String? name,
  }) => Navigator.of(context).push<T>(
    PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      settings: RouteSettings(name: name),
    ),
  );
  static Future<bool> back<T>(BuildContext context, [T? result]) =>
      Navigator.of(context).maybePop<T>(result);
}

/// 由应用持有并释放，通过 ListenableBuilder 连接 HyperUiTheme。
enum HyperThemeMode { system, light, dark }

class HyperThemeController extends ChangeNotifier {
  HyperThemeController({
    HyperThemeMode mode = HyperThemeMode.system,
    Color? primary,
  }) : _mode = mode,
       _primary = primary;
  HyperThemeMode _mode;
  Color? _primary;
  HyperThemeMode get mode => _mode;
  Color? get primary => _primary;
  void setMode(HyperThemeMode value) {
    if (_mode == value) return;
    _mode = value;
    notifyListeners();
  }

  void setPrimary(Color? value) {
    if (_primary == value) return;
    _primary = value;
    notifyListeners();
  }
}
