import 'package:flutter/widgets.dart';

import '../theme/hyper_ui_effects.dart';
import '../theme/hyper_ui_theme_tokens.dart';

part 'hyper_scroll_gradient_surface.dart';
part 'hyper_nav_bar_scroll_scope.dart';
part 'hyper_nav_bar_scroll_observer.dart';

/// Flutter 滚动宿主：包装主滚动视口与导航栏，不接管 ScrollController。
class HyperNavBarScrollScope extends StatefulWidget {
  const HyperNavBarScrollScope({super.key, required this.child, this.scrollKey})
    : _scrollController = null,
      active = true;

  /// 分页或嵌套滚动中绑定已有主控制器，由库向最近的作用域提供真实位置。
  factory HyperNavBarScrollScope.source({
    Key? key,
    required ScrollController scrollController,
    bool active = true,
    required Widget child,
  }) => _HyperNavBarScrollSource(
    key: key,
    scrollController: scrollController,
    active: active,
    child: child,
  );

  const HyperNavBarScrollScope._source({
    super.key,
    required ScrollController scrollController,
    required this.active,
    required this.child,
  }) : _scrollController = scrollController,
       scrollKey = null;

  final Widget child;

  /// 当前逻辑页面的标识；变化时重置滚动状态，不重建子树或接管控制器。
  final Object? scrollKey;
  final ScrollController? _scrollController;

  /// source 所在逻辑页是否活动；隐藏页不能驱动外层导航。
  final bool active;

  @override
  State<HyperNavBarScrollScope> createState() => _HyperNavBarScrollScopeState();
}

/// 滚动时渐显、向下渐隐的背景材质，不增加栏高、安全区或手势处理。
/// 优先使用已有滚动作用域，否则复用 Scaffold 的主滚动观察者。
class HyperScrollGradient extends StatelessWidget {
  const HyperScrollGradient({
    super.key,
    this.scrolledUnder = false,
    this.child,
  });

  /// true 强制显示；默认读取主滚动作用域或框架观察者。
  final bool scrolledUnder;

  /// 清晰的前景内容；纯覆盖层由父级约束实际范围。
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return _NavBarScrollBinding(
      scrolledUnder: scrolledUnder,
      child: child ?? const SizedBox.shrink(),
    );
  }
}
