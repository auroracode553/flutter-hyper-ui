import 'package:flutter/widgets.dart';

import '../theme/hyper_ui_theme.dart';

/// Hosts a Hyper surface in a route and keeps the caller's theme available.
Future<T?> showHyperModal<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  Alignment alignment = Alignment.center,
  bool dismissible = true,
  Color? scrim,
}) {
  final theme = HyperUiTheme.of(context);
  final barrier = scrim ?? theme.glass.scrim;
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: false,
    barrierColor: const Color(0x00000000),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (routeContext, animation, secondaryAnimation) => HyperUiTheme(
      data: theme,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: dismissible ? () => Navigator.pop(routeContext) : null,
              child: ColoredBox(color: barrier),
            ),
          ),
          Align(
            alignment: alignment,
            child: Builder(builder: builder),
          ),
        ],
      ),
    ),
    transitionBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}
