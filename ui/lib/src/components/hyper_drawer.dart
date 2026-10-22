import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hyper_glass_theme.dart';
import '../theme/hyper_ui_effects.dart';
import '../theme/hyper_ui_theme.dart';
import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_button.dart';
import 'hyper_layout.dart';
import 'hyper_surface_scope.dart';

part 'hyper_drawer_surface.dart';

/// 逻辑方向；RTL 时 start 在右侧，end 在左侧。
enum HyperDrawerPlacement { start, end }

/// 贴边全高的模态抽屉；内容与返回结果由调用方提供。
abstract final class HyperDrawer {
  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder contentBuilder,
    String? title,
    WidgetBuilder? footerBuilder,
    HyperDrawerPlacement placement = HyperDrawerPlacement.start,
    double width = 320,
    EdgeInsetsGeometry contentPadding = EdgeInsets.zero,
    bool scrollable = true,
    bool dismissOnClickOutside = true,
    bool dismissOnBackPress = true,
    bool gesturesEnabled = true,
  }) {
    if (!width.isFinite || width <= 0) {
      throw ArgumentError.value(width, 'width', 'Must be finite and positive');
    }
    final direction = Directionality.of(context);
    final theme = HyperUiTheme.of(context);
    final navigator = Navigator.of(context, rootNavigator: true);
    final themes = InheritedTheme.capture(from: context, to: navigator.context);
    return showGeneralDialog<T>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      barrierColor: const Color(0x00000000),
      transitionDuration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : HyperUiEffects.overlayDuration,
      pageBuilder: (drawerContext, animation, secondaryAnimation) =>
          HyperUiTheme(
            data: theme,
            child: themes.wrap(
              Directionality(
                textDirection: direction,
                child: _DrawerSurface(
                  animation: animation,
                  placement: placement,
                  width: width,
                  contentPadding: contentPadding,
                  scrollable: scrollable,
                  dismissOnClickOutside: dismissOnClickOutside,
                  dismissOnBackPress: dismissOnBackPress,
                  gesturesEnabled: gesturesEnabled,
                  title: title,
                  contentBuilder: contentBuilder,
                  footerBuilder: footerBuilder,
                ),
              ),
            ),
          ),
      // 面板自身负责平移，遮罩单独淡入；不叠加整页缩放或淡入。
      transitionBuilder: (_, _, _, child) => child,
    );
  }
}
