import 'dart:math' as math;

import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

/// TabBar 内部绘制动画；目标与手势由组件注入，不持有业务选中状态。
class HyperTabBarMotion extends StatefulWidget {
  const HyperTabBarMotion({
    super.key,
    required this.target,
    required this.count,
    required this.pressed,
    required this.travel,
    required this.builder,
  });

  final double target;
  final int count;
  final bool pressed;
  final double travel;
  final Widget Function(BuildContext, HyperTabBarMotionFrame) builder;

  @override
  State<HyperTabBarMotion> createState() => _HyperTabBarMotionState();
}

class HyperTabBarMotionFrame {
  const HyperTabBarMotionFrame(
    this.position,
    this.progress,
    this.scaleX,
    this.scaleY,
    this.travel,
  );
  final double position, progress, scaleX, scaleY, travel;

  double panelOffset(double width) {
    final fraction = (travel / width).clamp(-1.0, 1.0);
    return 4 * fraction.sign * Curves.easeOut.transform(fraction.abs());
  }
}

class _HyperTabBarMotionState extends State<HyperTabBarMotion>
    with TickerProviderStateMixin {
  late final _position = AnimationController.unbounded(
    vsync: this,
    value: widget.target,
  )..addListener(_positionTick);
  late final _press = AnimationController.unbounded(vsync: this);
  late final _scaleX = AnimationController.unbounded(vsync: this, value: 1);
  late final _scaleY = AnimationController.unbounded(vsync: this, value: 1);
  late final _velocity = AnimationController.unbounded(vsync: this);
  late final _travel = AnimationController.unbounded(vsync: this);
  bool _active = false;
  bool _reducedMotion = false;
  double _velocityTarget = 0;

  void _spring(
    AnimationController controller,
    double target,
    double damping,
    double stiffness, {
    double threshold = 0.001,
  }) {
    if (_reducedMotion) {
      controller.value = target;
      return;
    }
    controller.animateWith(
      SpringSimulation(
        SpringDescription(
          mass: 1,
          stiffness: stiffness,
          damping: 2 * damping * math.sqrt(stiffness),
        ),
        controller.value,
        target,
        controller.velocity,
        tolerance: Tolerance(distance: threshold, velocity: threshold),
      ),
    );
  }

  void _syncPress() {
    // 点击切换时保持镜片缩放，接近受控目标后再释放，避免抬手瞬间收缩。
    final active =
        !_reducedMotion &&
        (widget.pressed ||
            (_position.value - widget.target).abs() >
                (widget.count - 1) * 0.025);
    if (active == _active) return;
    _active = active;
    _spring(_press, active ? 1 : 0, 1, 1000);
    _spring(_scaleX, active ? 1.04 : 1, 0.85, 400);
    _spring(_scaleY, active ? 1.08 : 1, 0.9, 400);
  }

  void _positionTick() {
    _syncPress();
    final velocity = _active && !_reducedMotion
        ? _position.velocity / math.max(1, widget.count - 1)
        : 0.0;
    if ((velocity - _velocityTarget).abs() > 0.01) {
      _velocityTarget = velocity;
      _spring(_velocity, velocity, 0.85, 400, threshold: 0.01);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reducedMotion = MediaQuery.disableAnimationsOf(context);
    if (_reducedMotion) {
      _position.value = widget.target;
      _velocity.value = 0;
      _travel.value = 0;
    }
    _syncPress();
  }

  @override
  void didUpdateWidget(HyperTabBarMotion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.target != oldWidget.target)
      _spring(_position, widget.target, 1, 1000);
    _syncPress();
    if (widget.pressed && !_reducedMotion) {
      _travel.value = widget.travel;
    } else if (oldWidget.pressed) {
      _spring(_travel, 0, 1, 300, threshold: 0.5);
      _velocityTarget = 0;
      _spring(_velocity, 0, 0.85, 400, threshold: 0.01);
    }
  }

  @override
  void dispose() {
    for (final controller in [
      _position,
      _press,
      _scaleX,
      _scaleY,
      _velocity,
      _travel,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: Listenable.merge([
      _position,
      _press,
      _scaleX,
      _scaleY,
      _velocity,
      _travel,
    ]),
    builder: (context, _) {
      // 形变只取速度大小，双向一致；按压与速度叠加后仍限制幅度，避免跨项切换时拉长镜片。
      final speed = (_velocity.value.abs() / 10).clamp(0.0, 1.0);
      return widget.builder(
        context,
        HyperTabBarMotionFrame(
          _position.value,
          _press.value.clamp(0, 1),
          (_scaleX.value * (1 + 0.03 * speed)).clamp(0.98, 1.08),
          (_scaleY.value * (1 - 0.015 * speed)).clamp(0.98, 1.10),
          _travel.value,
        ),
      );
    },
  );
}

/// 交互高光跟随连续镜片位置，绘制在容器内，不扩展点击区域。
class HyperTabBarHighlight extends CustomPainter {
  const HyperTabBarHighlight(
    this.progress,
    this.position,
    this.count,
    this.inset,
  );
  final double progress, position, inset;
  final int count;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final bounds = Offset.zero & size;
    canvas.drawRect(
      bounds,
      Paint()..color = Color.fromRGBO(255, 255, 255, 0.08 * progress),
    );
    canvas.drawRect(
      bounds,
      Paint()
        ..shader =
            RadialGradient(
              colors: [
                Color.fromRGBO(255, 255, 255, 0.15 * progress),
                const Color.fromRGBO(255, 255, 255, 0),
              ],
            ).createShader(
              Rect.fromCircle(
                center: Offset(
                  inset + (position + 0.5) * (size.width - 2 * inset) / count,
                  size.height / 2,
                ),
                radius: size.shortestSide * 1.5,
              ),
            ),
    );
  }

  @override
  bool shouldRepaint(HyperTabBarHighlight oldDelegate) =>
      progress != oldDelegate.progress ||
      position != oldDelegate.position ||
      count != oldDelegate.count ||
      inset != oldDelegate.inset;
}
