import 'package:flutter/widgets.dart';

/// Coordinates a Hyper tab strip and its content without a platform tab bar.
class HyperTabController extends ChangeNotifier {
  HyperTabController({required this.length, int initialIndex = 0})
    : assert(length >= 0),
      assert(length == 0 || (initialIndex >= 0 && initialIndex < length)),
      _index = initialIndex;

  final int length;
  int _index;
  Duration? _transitionDuration;

  int get index => _index;

  void animateTo(int index, {Duration? duration}) {
    if (duration?.isNegative ?? false) {
      throw ArgumentError.value(duration, 'duration', 'Must not be negative');
    }
    if (index < 0 || index >= length || index == _index) return;
    _transitionDuration = duration;
    _index = index;
    notifyListeners();
  }
}

class HyperTabHost extends StatefulWidget {
  const HyperTabHost({
    super.key,
    required this.length,
    required this.child,
    this.initialIndex = 0,
    this.selectedIndex,
    this.onChanged,
  });

  final int length;
  final int initialIndex;
  final int? selectedIndex;
  final ValueChanged<int>? onChanged;
  final Widget child;

  @override
  State<HyperTabHost> createState() => _HyperTabHostState();

  static HyperTabController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_HyperTabScope>()!.controller;
}

class _HyperTabHostState extends State<HyperTabHost> {
  late HyperTabController _controller = HyperTabController(
    length: widget.length,
    initialIndex: widget.selectedIndex ?? widget.initialIndex,
  );
  bool _syncingExternal = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_reportIndex);
  }

  void _reportIndex() {
    if (!_syncingExternal) widget.onChanged?.call(_controller.index);
  }

  @override
  void didUpdateWidget(HyperTabHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.length != widget.length) {
      final previous = _controller;
      _controller = HyperTabController(
        length: widget.length,
        initialIndex: widget.length == 0
            ? 0
            : (widget.selectedIndex ?? previous.index).clamp(
                0,
                widget.length - 1,
              ),
      );
      _controller.addListener(_reportIndex);
      previous.dispose();
      return;
    }
    if (widget.selectedIndex != null &&
        widget.selectedIndex != _controller.index) {
      _syncingExternal = true;
      _controller.animateTo(widget.selectedIndex!);
      _syncingExternal = false;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_reportIndex);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      _HyperTabScope(controller: _controller, child: widget.child);
}

class _HyperTabScope extends InheritedWidget {
  const _HyperTabScope({required this.controller, required super.child});

  final HyperTabController controller;

  @override
  bool updateShouldNotify(_HyperTabScope oldWidget) =>
      controller != oldWidget.controller;
}

class HyperTabView extends StatefulWidget {
  const HyperTabView({super.key, required this.children});

  final List<Widget> children;

  @override
  State<HyperTabView> createState() => _HyperTabViewState();
}

class _HyperTabViewState extends State<HyperTabView> {
  HyperTabController? _tabs;
  PageController? _pages;
  bool _updatingFromPage = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final next = HyperTabHost.of(context);
    if (identical(next, _tabs)) return;
    _tabs?.removeListener(_syncPage);
    _pages?.dispose();
    _tabs = next;
    _pages = PageController(initialPage: next.index);
    next.addListener(_syncPage);
  }

  void _syncPage() {
    if (_updatingFromPage || !(_pages?.hasClients ?? false)) return;
    final pages = _pages!;
    final target = _tabs!.index;
    if (pages.page?.round() == target) return;
    if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) {
      pages.jumpToPage(target);
    } else {
      final duration =
          _tabs!._transitionDuration ?? const Duration(milliseconds: 220);
      if (duration == Duration.zero) {
        pages.jumpToPage(target);
        return;
      }
      pages.animateToPage(
        target,
        duration: duration,
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _tabs?.removeListener(_syncPage);
    _pages?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(_tabs!.length == widget.children.length);
    return PageView(
      controller: _pages,
      onPageChanged: (index) {
        _updatingFromPage = true;
        _tabs!.animateTo(index);
        _updatingFromPage = false;
      },
      children: widget.children,
    );
  }
}
