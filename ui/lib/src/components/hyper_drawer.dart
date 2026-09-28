import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hyper_glass_theme.dart';
import '../theme/hyper_ui_effects.dart';
import '../theme/hyper_ui_theme.dart';
import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_glass.dart';
import 'hyper_button.dart';
import 'hyper_layout.dart';

/// 逻辑方向；在 RTL 布局中 start 位于右侧，end 位于左侧。
enum HyperDrawerPlacement { start, end }

/// 柔光抽屉面板。直接使用时，父级需提供有限高度。
class HyperDrawer extends StatelessWidget {
  const HyperDrawer({
    super.key,
    required this.child,
    this.title,
    this.footer,
    this.onClose,
    this.scrollable = true,
  });

  final Widget child;
  final String? title;
  final Widget? footer;
  final VoidCallback? onClose;

  /// ListView 等自带滚动的内容应设为 false，以获得有限高度。
  final bool scrollable;

  /// 打开模态抽屉，通过 Navigator.pop(drawerContext, result) 返回结果。
  /// dismissible 仅控制遮罩点击，系统返回键仍可关闭抽屉。
  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    String? title,
    WidgetBuilder? footerBuilder,
    HyperDrawerPlacement placement = HyperDrawerPlacement.end,
    double width = 320,
    bool dismissible = true,
    bool scrollable = true,
  }) {
    assert(width > 0 && width.isFinite);
    final direction = Directionality.of(context);
    final isLeft =
        (placement == HyperDrawerPlacement.start) ==
        (direction == TextDirection.ltr);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final theme = HyperUiTheme.of(context);
    final scrim = HyperGlassTheme.of(context).scrim;
    final navigator = Navigator.of(context, rootNavigator: true);
    final themes = InheritedTheme.capture(from: context, to: navigator.context);

    return showGeneralDialog<T>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      barrierColor: const Color(0x00000000),
      transitionDuration: reduceMotion
          ? Duration.zero
          : HyperUiEffects.overlayDuration,
      pageBuilder: (routeContext, animation, secondaryAnimation) =>
          HyperUiTheme(
            data: theme,
            child: themes.wrap(
              Directionality(
                textDirection: direction,
                child: Builder(
                  builder: (drawerContext) {
                    // 在路由内读取键盘和安全区，随窗口尺寸变化重新约束宽度。
                    return LayoutBuilder(
                      builder: (context, constraints) => Padding(
                        padding: MediaQuery.viewInsetsOf(drawerContext),
                        child: SafeArea(
                          minimum: const EdgeInsets.all(12),
                          child: Align(
                            alignment: isLeft
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: SizedBox(
                              width: math.max(
                                0,
                                math.min(width, constraints.maxWidth - 24),
                              ),
                              height: double.infinity,
                              child: HyperDrawer(
                                title: title,
                                footer: footerBuilder?.call(drawerContext),
                                onClose: () =>
                                    Navigator.of(drawerContext).pop(),
                                scrollable: scrollable,
                                child: builder(drawerContext),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: HyperUiEffects.overlayCurve,
          reverseCurve: Curves.easeInCubic,
        );
        return Stack(
          children: <Widget>[
            Positioned.fill(
              child: FadeTransition(
                opacity: curved,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: dismissible ? () => Navigator.pop(context) : null,
                  child: ColoredBox(color: scrim),
                ),
              ),
            ),
            FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(isLeft ? -0.12 : 0.12, 0),
                  end: Offset.zero,
                ).animate(curved),
                child: child,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => HyperGlass(
    radius: 30,
    type: 'prominent',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null || onClose != null)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 8, 8),
            child: Row(
              children: [
                Expanded(
                  child: title == null
                      ? const SizedBox.shrink()
                      : Text(
                          title!,
                          style: TextStyle(
                            color: HyperUiThemeTokens.of(context).foreground,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
                if (onClose != null)
                  HyperButton(
                    type: 'tonal',
                    tooltip: '关闭',
                    onPressed: onClose,
                    icon: LucideIcons.x,
                  ),
              ],
            ),
          ),
        Expanded(
          child: scrollable
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: child,
                )
              : Padding(padding: const EdgeInsets.all(16), child: child),
        ),
        if (footer != null) ...[
          const HyperDivider(),
          Padding(padding: const EdgeInsets.all(16), child: footer),
        ],
      ],
    ),
  );
}
