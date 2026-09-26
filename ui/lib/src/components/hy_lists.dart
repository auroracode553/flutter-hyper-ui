import 'package:flutter/material.dart';

import '../theme/hy_ui_theme_tokens.dart';
import 'hy_button.dart';
import 'hy_glass.dart';
import 'hy_layout.dart';
import 'hy_list_tile.dart';

class HyMenuGroup extends StatelessWidget {
  const HyMenuGroup({
    super.key,
    required this.children,
    this.title,
    this.subtitle,
  });

  final List<Widget> children;
  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    return HySpace(
      spacing: 8,
      alignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (title != null)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 8),
            child: Text(
              title!,
              style: TextStyle(
                color: tokens.cardForeground,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        HyGlass(
          radius: 18,
          blur: 18,
          weight: HyGlassWeight.regular,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (var index = 0; index < children.length; index++) ...<Widget>[
                if (index > 0) const HyDivider(indent: 14, endIndent: 14),
                children[index],
              ],
            ],
          ),
        ),
        if (subtitle != null)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 8, end: 8),
            child: Text(
              subtitle!,
              style: TextStyle(
                color: tokens.mutedForeground,
                fontSize: 12,
                height: 1.35,
              ),
            ),
          ),
      ],
    );
  }
}

class HyPullRefresh extends StatelessWidget {
  const HyPullRefresh({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      RefreshIndicator(onRefresh: onRefresh, child: child);
}

/// 监听滚动尾部并串行请求；失败后等待用户重试，避免重复触发接口。
class HyLoadMore extends StatefulWidget {
  const HyLoadMore({
    super.key,
    required this.child,
    required this.onLoadMore,
    required this.hasMore,
    this.threshold = 160,
  });

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
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await widget.onLoadMore();
    } catch (error) {
      if (mounted) _error = error;
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.depth == 0 &&
                  notification.metrics.axis == Axis.vertical &&
                  notification.metrics.extentAfter < widget.threshold &&
                  _error == null &&
                  !_loading) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) _load();
                });
              }
              return false;
            },
            child: widget.child,
          ),
        ),
        if (_loading)
          const Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox.square(
              dimension: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        else if (_error != null)
          HyButton.ghost(
            label: '加载失败，点击重试',
            height: 32,
            onPressed: _load,
          )
        else if (!widget.hasMore)
          const Padding(padding: EdgeInsets.all(12), child: Text('没有更多了'))
        else
          HyButton.ghost(
            label: '加载更多',
            height: 32,
            onPressed: _load,
          ),
      ],
    );
  }
}

class HySticky extends StatelessWidget {
  const HySticky({super.key, required this.child, this.height = 46});

  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) => SliverPersistentHeader(
    pinned: true,
    delegate: _HyStickyDelegate(child, height),
  );
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
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(
      child: HyGlass(radius: 0, weight: HyGlassWeight.regular, child: child),
    );
  }

  @override
  bool shouldRebuild(covariant _HyStickyDelegate oldDelegate) {
    return oldDelegate.child != child || oldDelegate.height != height;
  }
}
