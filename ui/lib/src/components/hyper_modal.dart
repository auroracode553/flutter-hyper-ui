import 'package:flutter/widgets.dart';

import '../theme/hyper_ui_theme.dart';

/// Hosts a Hyper surface in a route and keeps the caller's theme available.
Future<T?> showHyperModal<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  Alignment alignment = Alignment.center,
  bool dismissible = true,
  Color? scrim,
}) async {
  final theme = HyperUiTheme.of(context);
  final barrier = scrim ?? theme.glass.scrim;
  final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
  final route = RawDialogRoute<T>(
    barrierDismissible: false,
    barrierColor: const Color(0x00000000),
    transitionDuration: reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 220),
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
        AnimatedBuilder(
          animation: animation,
          builder: (context, _) => IgnorePointer(
            // 退出中的路由仍参与绘制，但不再接受点击或操作底下的路由。
            ignoring:
                animation.status == AnimationStatus.reverse ||
                animation.status == AnimationStatus.dismissed,
            child: FadeTransition(opacity: animation, child: child),
          ),
        ),
  );
  final result = await Navigator.of(context, rootNavigator: true).push(route);
  // 返回结果与退出动画是两个阶段；调用方继续导航前，先释放旧弹层。
  await route.completed;
  return result;
}
