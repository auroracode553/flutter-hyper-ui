import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../theme/hyper_surface_theme.dart';
import '../theme/hyper_ui_theme_tokens.dart';
import '../utils/hyper_progress_value.dart';
import '../utils/hyper_spring_motion.dart';
import 'hyper_control_surface.dart';

/// Draws a Hyper progress arc without a platform visual control.
class HyperSpinner extends StatefulWidget {
  const HyperSpinner({
    super.key,
    this.value,
    this.strokeWidth = 2,
    this.color,
    this.backgroundColor,
    this.glass = false,
  });

  final double? value;
  final double strokeWidth;
  final Color? color;
  final Color? backgroundColor;
  final bool glass;

  @override
  State<HyperSpinner> createState() => _HyperSpinnerState();
}

class _HyperSpinnerState extends State<HyperSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotation = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncAnimation();
  }

  @override
  void didUpdateWidget(HyperSpinner oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncAnimation();
  }

  void _syncAnimation() {
    final animate =
        normalizeHyperProgress(widget.value) == null &&
        !(MediaQuery.maybeOf(context)?.disableAnimations ?? false);
    if (animate && !_rotation.isAnimating) {
      _rotation.repeat();
    } else if (!animate && _rotation.isAnimating) {
      _rotation.stop();
    }
  }

  @override
  void dispose() {
    _rotation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    final glass = HyperSurfaceTheme.of(context);
    final amount = normalizeHyperProgress(widget.value);
    final content = AnimatedBuilder(
      animation: _rotation,
      builder: (context, child) => HyperSpringMotion(
        value: amount ?? 0,
        builder: (context, position) => CustomPaint(
          painter: _ArcPainter(
            amount: amount == null ? .72 : position.clamp(0.0, 1.0),
            rotation: amount == null ? _rotation.value : 0,
            strokeWidth: widget.strokeWidth,
            foreground: widget.color ?? tokens.primary,
            background: widget.backgroundColor ?? glass.controlTrack,
            glass: widget.glass,
          ),
          child: child,
        ),
      ),
      child: const SizedBox.expand(),
    );
    if (!widget.glass) return content;
    // 只裁出空心轨道，不为环形进度新增圆盘背景。
    return ClipPath(
      clipper: _ProgressRingClipper(widget.strokeWidth),
      child: LayoutBuilder(
        builder: (context, constraints) => HyperControlSurface(
          radius: constraints.biggest.shortestSide / 2,
          role: HyperControlSurfaceRole.track,
          color:
              widget.backgroundColor ??
              glass.controlTrack.withValues(alpha: glass.controlTrack.a * 0.65),
          child: content,
        ),
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  const _ArcPainter({
    required this.amount,
    required this.rotation,
    required this.strokeWidth,
    required this.foreground,
    required this.background,
    this.glass = false,
  });

  final double amount;
  final double rotation;
  final double strokeWidth;
  final Color foreground;
  final Color background;
  final bool glass;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final arcRect = rect.deflate(strokeWidth / 2);
    final track = Paint()
      ..color = background
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final active = Paint()
      ..color = foreground
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;
    if (!glass) canvas.drawArc(arcRect, 0, math.pi * 2, false, track);
    if (glass) active.shader = _progressGradient(foreground).createShader(rect);
    canvas.drawArc(
      arcRect,
      -math.pi / 2 + rotation * math.pi * 2,
      math.pi * 2 * amount,
      false,
      active,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter oldDelegate) =>
      oldDelegate.amount != amount ||
      oldDelegate.rotation != rotation ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.foreground != foreground ||
      oldDelegate.background != background ||
      oldDelegate.glass != glass;
}

/// Draws a rounded progress track using Hyper tokens.
class HyperProgressTrack extends StatefulWidget {
  const HyperProgressTrack({
    super.key,
    this.value,
    this.height = 6,
    this.color,
    this.backgroundColor,
    this.glass = false,
  });

  final double? value;
  final double height;
  final Color? color;
  final Color? backgroundColor;
  final bool glass;

  @override
  State<HyperProgressTrack> createState() => _HyperProgressTrackState();
}

class _HyperProgressTrackState extends State<HyperProgressTrack>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motion = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncAnimation();
  }

  @override
  void didUpdateWidget(HyperProgressTrack oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncAnimation();
  }

  void _syncAnimation() {
    final animate =
        normalizeHyperProgress(widget.value) == null &&
        !(MediaQuery.maybeOf(context)?.disableAnimations ?? false);
    if (animate && !_motion.isAnimating) {
      _motion.repeat();
    } else if (!animate && _motion.isAnimating) {
      _motion.stop();
    }
  }

  @override
  void dispose() {
    _motion.dispose();
    super.dispose();
  }

  Widget _trackSurface(BuildContext context, Widget child) => widget.glass
      ? HyperControlSurface(
          radius: widget.height / 2,
          role: HyperControlSurfaceRole.track,
          color:
              widget.backgroundColor ??
              HyperSurfaceTheme.of(context).controlTrack.withValues(
                alpha: HyperSurfaceTheme.of(context).controlTrack.a * 0.65,
              ),
          child: child,
        )
      : ClipRRect(
          borderRadius: BorderRadius.circular(widget.height / 2),
          child: child,
        );

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    final glass = HyperSurfaceTheme.of(context);
    final amount = normalizeHyperProgress(widget.value);
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    return SizedBox(
      height: widget.height,
      child: _trackSurface(
        context,
        LayoutBuilder(
          builder: (context, constraints) {
            final trackWidth = constraints.maxWidth;
            Widget segments(double? value, double phase) {
              final segmentWidth = value == null
                  ? trackWidth * .32
                  : trackWidth * value;
              final segmentStart = value == null
                  ? (trackWidth + segmentWidth) * phase - segmentWidth
                  : 0.0;
              return Stack(
                children: <Widget>[
                  ColoredBox(
                    color: widget.glass
                        ? const Color.fromRGBO(0, 0, 0, 0)
                        : widget.backgroundColor ?? glass.controlTrack,
                    child: const SizedBox.expand(),
                  ),
                  PositionedDirectional(
                    start: segmentStart,
                    width: segmentWidth,
                    top: 0,
                    bottom: 0,
                    child: widget.glass
                        ? HyperControlSurface(
                            radius: widget.height / 2,
                            role: HyperControlSurfaceRole.track,
                            color: widget.color ?? tokens.primary,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: _progressGradient(
                                  widget.color ?? tokens.primary,
                                ),
                              ),
                            ),
                          )
                        : ColoredBox(color: widget.color ?? tokens.primary),
                  ),
                ],
              );
            }

            if (amount == null) {
              return AnimatedBuilder(
                animation: _motion,
                // 减少动画时保留可见的静止片段，避免未知进度看起来为空。
                builder: (_, _) =>
                    segments(null, reduceMotion ? .5 : _motion.value),
              );
            }
            // 下载快照通常间隔数百毫秒到达，使用短过渡避免进度条跳变。
            return HyperSpringMotion(
              value: amount,
              builder: (_, value) => segments(value.clamp(0.0, 1.0), 0),
            );
          },
        ),
      ),
    );
  }
}

LinearGradient _progressGradient(Color color) => LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color.alphaBlend(const Color.fromRGBO(255, 255, 255, 0.24), color),
    color,
    color,
  ],
);

class _ProgressRingClipper extends CustomClipper<Path> {
  const _ProgressRingClipper(this.stroke);
  final double stroke;
  @override
  Path getClip(Size size) {
    final rect = Offset.zero & size;
    final inset = stroke.clamp(0.0, size.shortestSide / 2);
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addOval(rect)
      ..addOval(rect.deflate(inset));
  }

  @override
  bool shouldReclip(_ProgressRingClipper oldClipper) =>
      oldClipper.stroke != stroke;
}
