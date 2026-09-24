import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/hy_glass_theme.dart';
import '../theme/hy_ui_theme_tokens.dart';
import 'hy_pressable.dart';

/// 可独立使用的页码指示器，也可由 [HyCarousel] 自动驱动。
class HyPageIndicator extends StatelessWidget {
  const HyPageIndicator({
    super.key,
    required this.count,
    required this.index,
    this.onSelected,
  }) : assert(count > 0),
       assert(index >= 0 && index < count);

  final int count;
  final int index;
  final ValueChanged<int>? onSelected;

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    final glass = HyGlassTheme.of(context);
    return Wrap(
      alignment: WrapAlignment.center,
      children: <Widget>[
        for (var page = 0; page < count; page++)
          Semantics(
            label: '第 ${page + 1} 页，共 $count 页',
            selected: page == index,
            child: HyPressable(
              onPressed: onSelected == null ? null : () => onSelected!(page),
              child: SizedBox(
                width: 24,
                height: 24,
                child: Center(
                  child: AnimatedContainer(
                    duration: MediaQuery.maybeOf(context)?.disableAnimations == true
                        ? Duration.zero
                        : const Duration(milliseconds: 180),
                    width: page == index ? 18 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: page == index ? tokens.primary : glass.controlTrack,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// 紧凑轮播；页面状态由组件维护，切换通过 [onPageChanged] 通知业务层。
class HyCarousel extends StatefulWidget {
  const HyCarousel({
    super.key,
    required this.items,
    this.height = 180,
    this.initialIndex = 0,
    this.onPageChanged,
    this.showIndicator = true,
    this.autoPlayInterval,
  }) : assert(items.length > 0),
       assert(height > 0),
       assert(autoPlayInterval == null ||
           autoPlayInterval > const Duration(milliseconds: 350)),
       assert(initialIndex >= 0 && initialIndex < items.length);

  final List<Widget> items;
  final double height;
  final int initialIndex;
  final ValueChanged<int>? onPageChanged;
  final bool showIndicator;
  final Duration? autoPlayInterval;

  @override
  State<HyCarousel> createState() => _HyCarouselState();
}

class _HyCarouselState extends State<HyCarousel> {
  late final PageController _controller;
  Timer? _autoPlay;
  late int _index;
  bool _interacting = false;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _controller = PageController(initialPage: _index);
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlay?.cancel();
    final interval = widget.autoPlayInterval;
    if (interval == null || widget.items.length < 2) return;
    _autoPlay = Timer.periodic(interval, (_) {
      if (!mounted ||
          _interacting ||
          !_controller.hasClients ||
          _controller.position.isScrollingNotifier.value ||
          MediaQuery.maybeOf(context)?.disableAnimations == true) return;
      _controller.animateToPage(
        (_index + 1) % widget.items.length,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void didUpdateWidget(covariant HyCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.autoPlayInterval != widget.autoPlayInterval ||
        oldWidget.items.length != widget.items.length) {
      _startAutoPlay();
    }
    if (_index >= widget.items.length) {
      _index = widget.items.length - 1;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _controller.hasClients) _controller.jumpToPage(_index);
      });
    }
  }

  @override
  void dispose() {
    _autoPlay?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: widget.height,
            child: Listener(
              onPointerDown: (_) => _interacting = true,
              onPointerUp: (_) => _interacting = false,
              onPointerCancel: (_) => _interacting = false,
              child: PageView.builder(
                controller: _controller,
                itemCount: widget.items.length,
                onPageChanged: (index) {
                  setState(() => _index = index);
                  widget.onPageChanged?.call(index);
                },
                itemBuilder: (context, index) => widget.items[index],
              ),
            ),
          ),
        ),
        if (widget.showIndicator && widget.items.length > 1) ...<Widget>[
          const SizedBox(height: 6),
          HyPageIndicator(
            count: widget.items.length,
            index: _index,
            onSelected: (index) {
              if (MediaQuery.maybeOf(context)?.disableAnimations == true) {
                _controller.jumpToPage(index);
              } else {
                _controller.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOutCubic,
                );
              }
            },
          ),
        ],
      ],
    );
  }
}
