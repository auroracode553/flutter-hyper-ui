import 'package:flutter/widgets.dart';

import '../theme/hyper_ui_effects.dart';

/// 内部浮层生命周期：退出绘制完成后移除，反向操作沿用当前进度。
class HyperOverlayMotion {
  HyperOverlayMotion({
    required TickerProvider vsync,
    required VoidCallback onShow,
    required VoidCallback onHide,
    required Duration duration,
  }) : _onShow = onShow,
       _onHide = onHide,
       _duration = duration,
       _controller = AnimationController(vsync: vsync, duration: duration) {
    _controller.addStatusListener(_handleStatus);
  }

  final VoidCallback _onShow;
  final VoidCallback _onHide;
  final Duration _duration;
  final AnimationController _controller;
  bool _isOpen = false;
  bool _reduceMotion = false;
  bool _instant = false;

  bool get isOpen => _isOpen;
  Animation<double> get animation => _controller;

  void setReducedMotion(bool value) {
    _reduceMotion = value;
    _controller.duration = value ? HyperUiEffects.reducedDuration : _duration;
  }

  void setOpen(bool open, {bool instant = false}) {
    if (_isOpen == open) {
      if (instant && open) {
        _instant = true;
        _controller.value = 1;
      }
      return;
    }
    _isOpen = open;
    _instant = instant;
    if (open) _onShow();
    if (_instant) {
      _controller.value = open ? 1 : 0;
    } else if (open) {
      _controller.animateTo(
        1,
        curve: _reduceMotion ? Curves.linear : HyperUiEffects.overlayCurve,
      );
    } else {
      _controller.animateBack(
        0,
        curve: _reduceMotion ? Curves.linear : HyperUiEffects.overlayCurve,
      );
    }
  }

  void close() => setOpen(false, instant: _instant);

  void _handleStatus(AnimationStatus status) {
    if (status == AnimationStatus.dismissed && !_isOpen) _onHide();
  }

  void dispose() {
    _controller.dispose();
  }
}

/// 只动画浮层表面，避免逐帧重建玻璃内容与滚动区域。
Widget buildHySurfaceTransition({
  required Animation<double> animation,
  required Widget child,
  Alignment Function()? origin,
  Offset offset = Offset.zero,
  double beginScale = 0.96,
  Curve? curve,
}) => _HyperSurfaceTransition(
  animation: animation,
  child: child,
  origin: origin,
  offset: offset,
  beginScale: beginScale,
  curve: curve,
);

class _HyperSurfaceTransition extends StatefulWidget {
  const _HyperSurfaceTransition({
    required this.animation,
    required this.child,
    required this.origin,
    required this.offset,
    required this.beginScale,
    required this.curve,
  });

  final Animation<double> animation;
  final Widget child;
  final Alignment Function()? origin;
  final Offset offset;
  final double beginScale;
  final Curve? curve;

  @override
  State<_HyperSurfaceTransition> createState() => _HyperSurfaceTransitionState();
}

class _HyperSurfaceTransitionState extends State<_HyperSurfaceTransition> {
  CurvedAnimation? _curved;

  void _configureCurve() {
    _curved?.dispose();
    final curve = widget.curve;
    // 路由中途反向时沿用正在使用的曲线，避免切换曲线造成位置跳变。
    _curved = curve == null
        ? null
        : CurvedAnimation(
            parent: widget.animation,
            curve: curve,
            reverseCurve: curve.flipped,
          );
  }

  @override
  void initState() {
    super.initState();
    _configureCurve();
  }

  @override
  void didUpdateWidget(_HyperSurfaceTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animation != widget.animation ||
        oldWidget.curve != widget.curve) {
      _configureCurve();
    }
  }

  @override
  void dispose() {
    _curved?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _curved ?? widget.animation,
    child: widget.child,
    builder: (context, child) {
      final reduceMotion =
          MediaQuery.maybeOf(context)?.disableAnimations ?? false;
      final progress = reduceMotion
          ? widget.animation.value
          : (_curved ?? widget.animation).value;
      return Opacity(
        opacity: progress,
        child: Transform.translate(
          offset: reduceMotion ? Offset.zero : widget.offset * (1 - progress),
          child: Transform.scale(
            alignment: widget.origin?.call() ?? Alignment.center,
            scale: reduceMotion
                ? 1
                : widget.beginScale + (1 - widget.beginScale) * progress,
            child: child,
          ),
        ),
      );
    },
  );
}
