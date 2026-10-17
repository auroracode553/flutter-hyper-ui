part of 'hyper_nav_bar.dart';

// HyperNavBarScrollScope 的内部滚动状态与继承通知；由 hyper_nav_bar.dart 引入。
class _HyperNavBarScrollScopeState extends State<HyperNavBarScrollScope> {
  bool _scrolledUnder = false;

  @override
  void didUpdateWidget(covariant HyperNavBarScrollScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scrollKey != oldWidget.scrollKey) _scrolledUnder = false;
  }

  void _update(ScrollMetrics metrics) {
    if (metrics.axis != Axis.vertical) return;
    final next = metrics.axisDirection == AxisDirection.up
        ? metrics.extentAfter > 0.5
        : metrics.extentBefore > 0.5;
    if (_scrolledUnder != next) setState(() => _scrolledUnder = next);
  }

  @override
  Widget build(BuildContext context) =>
      NotificationListener<ScrollMetricsNotification>(
        onNotification: (notification) {
          // 布局恢复、窗口尺寸变化和程序滚动均同步；忽略横向与嵌套视口。
          if (notification.depth == 0) _update(notification.metrics);
          return false;
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.depth == 0) _update(notification.metrics);
            return false;
          },
          child: _NavBarScrollState(
            scrolledUnder: _scrolledUnder,
            child: widget.child,
          ),
        ),
      );
}

class _NavBarScrollState extends InheritedWidget {
  const _NavBarScrollState({required this.scrolledUnder, required super.child});

  final bool scrolledUnder;

  static bool read(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_NavBarScrollState>()
          ?.scrolledUnder ??
      false;

  @override
  bool updateShouldNotify(_NavBarScrollState oldWidget) =>
      scrolledUnder != oldWidget.scrolledUnder;
}
