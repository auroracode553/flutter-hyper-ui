import 'package:flutter/material.dart';

import 'hy_glass.dart';

/// 逻辑方向；在 RTL 布局中 start 位于右侧，end 位于左侧。
enum HyDrawerPlacement { start, end }

/// 柔光抽屉面板。直接使用时，父级需提供有限高度。
class HyDrawer extends StatelessWidget {
  const HyDrawer({
    super.key,
    required this.child,
    this.title,
    this.footer,
    this.onClose,
    this.scrollable = true,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final String? title;
  final Widget? footer;
  final VoidCallback? onClose;

  /// ListView 等自带滚动的内容应设为 false，以获得有限高度。
  final bool scrollable;
  final EdgeInsetsGeometry padding;

  /// 打开模态抽屉，通过 Navigator.pop(drawerContext, result) 返回结果。
  /// dismissible 仅控制遮罩点击，系统返回键仍可关闭抽屉。
  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    String? title,
    WidgetBuilder? footerBuilder,
    HyDrawerPlacement placement = HyDrawerPlacement.end,
    double width = 360,
    bool dismissible = true,
    bool showCloseButton = true,
    bool scrollable = true,
    bool useRootNavigator = true,
    EdgeInsetsGeometry padding = const EdgeInsets.all(20),
    Color barrierColor = const Color(0x66000000),
    String? barrierLabel,
    RouteSettings? routeSettings,
  }) {
    assert(width > 0 && width.isFinite);
    final direction = Directionality.of(context);
    final isLeft = (placement == HyDrawerPlacement.start) ==
        (direction == TextDirection.ltr);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final navigator = Navigator.of(context, rootNavigator: useRootNavigator);
    final themes = InheritedTheme.capture(from: context, to: navigator.context);

    return showGeneralDialog<T>(
      context: context,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      barrierDismissible: dismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel ??
          MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: reduceMotion
          ? Duration.zero
          : const Duration(milliseconds: 260),
      pageBuilder: (routeContext, animation, secondaryAnimation) => themes.wrap(
        Directionality(
          textDirection: direction,
          child: Builder(builder: (drawerContext) {
            // 在路由内读取键盘和安全区，随窗口尺寸变化重新约束宽度。
            return Padding(
              padding: MediaQuery.viewInsetsOf(drawerContext),
              child: SafeArea(
                minimum: const EdgeInsets.all(12),
                child: Align(
                  alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
                  child: SizedBox(
                    width: width,
                    height: double.infinity,
                    child: Semantics(
                      scopesRoute: true,
                      namesRoute: true,
                      label: title ?? MaterialLocalizations.of(drawerContext).dialogLabel,
                      explicitChildNodes: true,
                      child: HyDrawer(
                        title: title,
                        footer: footerBuilder?.call(drawerContext),
                        onClose: showCloseButton
                            ? () { Navigator.of(drawerContext).pop(); }
                            : null,
                        scrollable: scrollable,
                        padding: padding,
                        child: builder(drawerContext),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(isLeft ? -1 : 1, 0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(animation),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => HyGlass(
    radius: 28,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null || onClose != null)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 8, 8),
            child: Row(children: [
              Expanded(child: title == null
                  ? const SizedBox.shrink()
                  : Text(title!, style: Theme.of(context).textTheme.titleLarge)),
              if (onClose != null)
                IconButton(
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  onPressed: onClose,
                  icon: const Icon(Icons.close_rounded),
                ),
            ]),
          ),
        Expanded(
          child: scrollable
              ? SingleChildScrollView(padding: padding, child: child)
              : Padding(padding: padding, child: child),
        ),
        if (footer != null) ...[
          const Divider(height: 1),
          Padding(padding: padding, child: footer),
        ],
      ],
    ),
  );
}
