part of 'hyper_scroll_gradient.dart';

/// 普通 Scaffold 的内置观察者接入；显式作用域存在时不重复订阅。
class _NavBarScrollBinding extends StatefulWidget {
  const _NavBarScrollBinding({
    required this.scrolledUnder,
    required this.child,
  });

  final bool scrolledUnder;
  final Widget child;

  @override
  State<_NavBarScrollBinding> createState() => _NavBarScrollBindingState();
}

class _NavBarScrollBindingState extends State<_NavBarScrollBinding> {
  ScrollNotificationObserverState? _observer;
  bool _scrolledUnder = false;
  bool _pendingScrolledUnder = false;
  bool _publishScheduled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scope = context
        .dependOnInheritedWidgetOfExactType<_NavBarScrollHost>();
    // Scaffold 已将导航和正文放在同一个观察者内，不要求业务逐页套监听。
    final observer = scope == null
        ? ScrollNotificationObserver.maybeOf(context)
        : null;
    if (_observer == observer) return;
    _observer?.removeListener(_onScroll);
    _observer = observer;
    _scrolledUnder = false;
    _pendingScrolledUnder = false;
    _observer?.addListener(_onScroll);
  }

  void _onScroll(ScrollNotification notification) {
    if (notification.depth != 0 || notification.metrics.axis != Axis.vertical) {
      return;
    }
    final next = _navBarHasContentBefore(notification.metrics);
    if (_pendingScrolledUnder == next) return;
    _pendingScrolledUnder = next;
    if (_publishScheduled) return;
    _publishScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _publishScheduled = false;
      if (!mounted ||
          _observer == null ||
          _scrolledUnder == _pendingScrolledUnder) {
        return;
      }
      // 指标通知也覆盖初始位置、恢复和尺寸变化；只重建导航自身。
      setState(() => _scrolledUnder = _pendingScrolledUnder);
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  @override
  void dispose() {
    _observer?.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _ScrollGradientSurface(
    scrolledUnder:
        widget.scrolledUnder ||
        _NavBarScrollState.read(context) ||
        _scrolledUnder,
    child: widget.child,
  );
}
