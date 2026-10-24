part of 'hyper_nav_bar.dart';

// 导航滚动状态、控制器订阅与继承通知；由 hyper_nav_bar.dart 引入。
bool _navBarHasContentBefore(ScrollMetrics metrics) =>
    metrics.axis == Axis.vertical &&
    (metrics.axisDirection == AxisDirection.up
        ? metrics.extentAfter > 0.5
        : metrics.extentBefore > 0.5);

class _HyperNavBarScrollScopeState extends State<HyperNavBarScrollScope> {
  final _state = ValueNotifier<bool>(false);
  final Map<Object, ({bool active, bool scrolledUnder})> _sources = {};
  bool _notificationScrolledUnder = false;
  bool _publishScheduled = false;
  bool _disposed = false;

  @override
  void didUpdateWidget(covariant HyperNavBarScrollScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scrollKey != oldWidget.scrollKey) {
      _notificationScrolledUnder = false;
      _schedulePublish();
    }
  }

  void _update(ScrollMetrics metrics) {
    if (metrics.axis != Axis.vertical || _sources.isNotEmpty) return;
    final next = _navBarHasContentBefore(metrics);
    if (_notificationScrolledUnder == next) return;
    _notificationScrolledUnder = next;
    _schedulePublish();
  }

  void _updateSource(
    Object token, {
    required bool active,
    required bool scrolledUnder,
  }) {
    final source = (active: active, scrolledUnder: scrolledUnder);
    if (_disposed || _sources[token] == source) return;
    _sources[token] = source;
    _schedulePublish();
  }

  void _removeSource(Object token) {
    if (_disposed || _sources.remove(token) == null) return;
    if (_sources.isEmpty) _notificationScrolledUnder = false;
    _schedulePublish();
  }

  void _schedulePublish() {
    if (_disposed || _publishScheduled) return;
    _publishScheduled = true;
    // 布局通知和分页切换可能发生在构建阶段，帧尾提交最后的活动来源。
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _publishScheduled = false;
      if (_disposed) return;
      if (_sources.isEmpty) {
        _state.value = _notificationScrolledUnder;
      } else {
        final active = _sources.values.where((source) => source.active);
        // 弹层、离场或后台使所有来源暂停时保留材质，恢复后再读真实位置。
        if (active.isNotEmpty) {
          _state.value = active.any((source) => source.scrolledUnder);
        }
      }
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  @override
  void dispose() {
    _disposed = true;
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _NavBarScrollHost(
    owner: this,
    child: NotificationListener<ScrollMetricsNotification>(
      onNotification: (notification) {
        if (notification.depth == 0) _update(notification.metrics);
        return false;
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.depth == 0) _update(notification.metrics);
          return false;
        },
        child: _NavBarScrollState(notifier: _state, child: widget.child),
      ),
    ),
  );
}

// 独立运行时类型使 source 与完整作用域切换时正确释放各自状态。
class _HyperNavBarScrollSource extends HyperNavBarScrollScope {
  const _HyperNavBarScrollSource({
    super.key,
    required super.scrollController,
    required super.active,
    required super.child,
  }) : super._source();

  @override
  State<HyperNavBarScrollScope> createState() =>
      _HyperNavBarScrollSourceState();
}

/// 只订阅已有主控制器，不推测通知深度，也不接管控制器生命周期。
class _HyperNavBarScrollSourceState extends State<HyperNavBarScrollScope> {
  final Object _token = Object();
  _HyperNavBarScrollScopeState? _host;
  bool _reportScheduled = false;
  ScrollController get _controller => widget._scrollController!;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_report);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final host = context
        .dependOnInheritedWidgetOfExactType<_NavBarScrollHost>();
    assert(
      host != null,
      'HyperNavBarScrollScope.source requires an ancestor HyperNavBarScrollScope.',
    );
    if (_host != host?.owner) {
      _host?._removeSource(_token);
      _host = host?.owner;
    }
    _report();
    _scheduleReport();
  }

  @override
  void didUpdateWidget(covariant HyperNavBarScrollScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget._scrollController != widget._scrollController) {
      oldWidget._scrollController!.removeListener(_report);
      _controller.addListener(_report);
    }
    _report();
    _scheduleReport();
  }

  void _report() {
    if (!mounted) return;
    final scrolled = _controller.positions.any(
      (position) =>
          position.hasContentDimensions && _navBarHasContentBefore(position),
    );
    // 隐藏来源保留注册但不贡献状态，避免退回对隐藏视口通知的猜测。
    _host?._updateSource(
      _token,
      active: widget.active,
      scrolledUnder: scrolled,
    );
  }

  void _scheduleReport() {
    if (_reportScheduled) return;
    _reportScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _reportScheduled = false;
      _report();
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  @override
  void dispose() {
    _controller.removeListener(_report);
    _host?._removeSource(_token);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      NotificationListener<ScrollMetricsNotification>(
        onNotification: (notification) {
          if (notification.depth == 0) _scheduleReport();
          return false;
        },
        child: widget.child,
      );
}

class _NavBarScrollHost extends InheritedWidget {
  const _NavBarScrollHost({required this.owner, required super.child});
  final _HyperNavBarScrollScopeState owner;

  @override
  bool updateShouldNotify(_NavBarScrollHost oldWidget) =>
      owner != oldWidget.owner;
}

class _NavBarScrollState extends InheritedNotifier<ValueNotifier<bool>> {
  const _NavBarScrollState({
    required ValueNotifier<bool> notifier,
    required Widget child,
  }) : super(notifier: notifier, child: child);

  static bool read(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_NavBarScrollState>()
          ?.notifier
          ?.value ??
      false;
}
