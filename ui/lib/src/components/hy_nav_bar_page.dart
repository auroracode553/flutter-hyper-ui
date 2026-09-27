import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/hy_ui_theme_tokens.dart';
import 'hy_nav_bar.dart';

/// 透明导航栏的全面屏滚动布局：导航固定，首屏留白随内容一起滚走。
///
/// 放在 Scaffold.body 中，不要在外层包顶部 SafeArea 或另设 appBar。
/// [slivers] 直接传 SliverList / SliverPadding 等，避免嵌套滚动视图。
class HyNavBarPage extends StatelessWidget {
  const HyNavBarPage({
    super.key,
    required this.navBar,
    required this.slivers,
    this.controller,
    this.physics,
    this.backgroundColor,
    this.systemOverlayStyle,
    this.bottomSafeArea = true,
  });

  final HyNavBar navBar;
  final List<Widget> slivers;

  /// 由调用方持有与释放；不绑定页面业务或全局滚动状态。
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final Color? backgroundColor;

  /// 可按内容对比度定制系统图标；默认使用主题并请求透明状态栏。
  /// 实际系统边缘显示仍受宿主平台的 edge-to-edge 配置约束。
  final SystemUiOverlayStyle? systemOverlayStyle;
  final bool bottomSafeArea;

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    final padding = MediaQuery.paddingOf(context);
    final topInset = navBar.safeArea ? padding.top : 0.0;
    final overlayStyle =
        systemOverlayStyle ??
        (Theme.of(context).brightness == Brightness.dark
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark)
            .copyWith(
              statusBarColor: Colors.transparent,
              systemStatusBarContrastEnforced: false,
            );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: ColoredBox(
        color: backgroundColor ?? tokens.background,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            // 安全区是滚动内容中的留白，不是视口外的固定 Padding。
            MediaQuery.removePadding(
              context: context,
              removeTop: true,
              removeBottom: true,
              child: CustomScrollView(
                controller: controller,
                physics: physics,
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: SizedBox(height: topInset + navBar.height),
                  ),
                  ...slivers,
                  if (bottomSafeArea && padding.bottom > 0)
                    SliverToBoxAdapter(child: SizedBox(height: padding.bottom)),
                ],
              ),
            ),
            Positioned(top: 0, left: 0, right: 0, child: navBar),
          ],
        ),
      ),
    );
  }
}
