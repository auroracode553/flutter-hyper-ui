import 'package:flutter/material.dart';
import 'hy_glass.dart';
import 'hy_layout.dart';

class HyMenuGroup extends StatelessWidget {
  const HyMenuGroup({super.key, required this.children, this.title, this.subtitle});
  final List<Widget> children;
  final String? title, subtitle;
  @override
  Widget build(BuildContext context) => HySpace(children: [
    if (title != null) Padding(padding: const EdgeInsetsDirectional.only(start: 8),
      child: Text(title!, style: Theme.of(context).textTheme.titleSmall)),
    HyGlass(blur: 0, radius: 24, child: Column(mainAxisSize: MainAxisSize.min, children: [
      for (var i = 0; i < children.length; i++) ...[
        if (i > 0) const HyDivider(indent: 64, endIndent: 16), children[i],
      ],
    ])),
    if (subtitle != null) Padding(padding: const EdgeInsetsDirectional.only(start: 8),
      child: Text(subtitle!, style: Theme.of(context).textTheme.bodySmall)),
  ]);
}

class HyPullRefresh extends StatelessWidget {
  const HyPullRefresh({super.key, required this.onRefresh, required this.child});
  final Future<void> Function() onRefresh;
  final Widget child;
  @override
  Widget build(BuildContext context) => RefreshIndicator(onRefresh: onRefresh, child: child);
}

/// 监听滚动尾部，串行请求；失败后由用户重试，避免重复触发接口。
class HyLoadMore extends StatefulWidget {
  const HyLoadMore({super.key, required this.child, required this.onLoadMore,
    required this.hasMore, this.threshold = 160});
  final Widget child;
  final Future<void> Function() onLoadMore;
  final bool hasMore;
  final double threshold;
  @override
  State<HyLoadMore> createState() => _HyLoadMoreState();
}

class _HyLoadMoreState extends State<HyLoadMore> {
  bool _loading = false;
  Object? _error;
  Future<void> _load() async {
    if (_loading || !widget.hasMore) return;
    setState(() { _loading = true; _error = null; });
    try { await widget.onLoadMore(); }
    catch (error) { if (mounted) _error = error; }
    finally { if (mounted) setState(() => _loading = false); }
  }
  @override
  Widget build(BuildContext context) => Column(children: [
    Expanded(child: NotificationListener<ScrollNotification>(onNotification: (notification) {
      if (notification.depth == 0 && notification.metrics.axis == Axis.vertical &&
          notification.metrics.extentAfter < widget.threshold && _error == null && !_loading) {
        // 延迟到帧末，避免滚动布局期间触发 setState。
        WidgetsBinding.instance.addPostFrameCallback((_) { if (mounted) _load(); });
      }
      return false;
    }, child: widget.child)),
    if (_loading) const Padding(padding: EdgeInsets.all(16),
      child: SizedBox.square(dimension: 22, child: CircularProgressIndicator(strokeWidth: 2)))
    else if (_error != null) TextButton(onPressed: _load, child: const Text('加载失败，点击重试'))
    else if (!widget.hasMore) const Padding(padding: EdgeInsets.all(12), child: Text('没有更多了'))
    else TextButton(onPressed: _load, child: const Text('加载更多')),
  ]);
}

class HySticky extends StatelessWidget {
  const HySticky({super.key, required this.child, this.height = 52});
  final Widget child;
  final double height;
  @override
  Widget build(BuildContext context) => SliverPersistentHeader(pinned: true,
    delegate: _HyStickyDelegate(child, height));
}

class _HyStickyDelegate extends SliverPersistentHeaderDelegate {
  _HyStickyDelegate(this.child, this.height);
  final Widget child;
  final double height;
  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) =>
    SizedBox.expand(child: HyGlass(radius: 0, child: child));
  @override
  bool shouldRebuild(covariant _HyStickyDelegate old) => old.child != child || old.height != height;
}
