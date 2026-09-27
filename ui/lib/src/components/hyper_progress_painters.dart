import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../theme/hyper_glass_theme.dart';
import '../theme/hyper_ui_theme_tokens.dart';

/// Draws a Hyper progress arc without a platform visual control.
class HyperSpinner extends StatefulWidget {
  const HyperSpinner({
    super.key,
    this.value,
    this.strokeWidth = 2,
    this.color,
    this.backgroundColor,
  });

  final double? value;
  final double strokeWidth;
  final Color? color;
  final Color? backgroundColor;

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
        widget.value == null &&
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
    final glass = HyperGlassTheme.of(context);
    return AnimatedBuilder(
      animation: _rotation,
      builder: (context, child) => CustomPaint(
        painter: _ArcPainter(
          amount: widget.value?.clamp(0, 1).toDouble() ?? .72,
          rotation: widget.value == null ? _rotation.value : 0,
          strokeWidth: widget.strokeWidth,
          foreground: widget.color ?? tokens.primary,
          background: widget.backgroundColor ?? glass.controlTrack,
        ),
        child: child,
      ),
      child: const SizedBox.expand(),
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
  });

  final double amount;
  final double rotation;
  final double strokeWidth;
  final Color foreground;
  final Color background;

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
    canvas.drawArc(arcRect, 0, math.pi * 2, false, track);
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
      oldDelegate.background != background;
}

/// Draws a rounded progress track using Hyper tokens.
class HyperProgressTrack extends StatefulWidget {
  const HyperProgressTrack({
    super.key,
    this.value,
    this.height = 6,
    this.color,
    this.backgroundColor,
  });

  final double? value;
  final double height;
  final Color? color;
  final Color? backgroundColor;

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
        widget.value == null &&
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

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    final glass = HyperGlassTheme.of(context);
    return SizedBox(
      height: widget.height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.height / 2),
        child: LayoutBuilder(
          builder: (context, constraints) => AnimatedBuilder(
            animation: _motion,
            builder: (context, child) {
              final progress = widget.value?.clamp(0, 1).toDouble();
              final trackWidth = constraints.maxWidth;
              final segmentWidth = progress == null
                  ? trackWidth * .32
                  : trackWidth * progress;
              final segmentLeft = progress == null
                  ? (trackWidth + segmentWidth) * _motion.value - segmentWidth
                  : 0.0;
              return Stack(
                children: <Widget>[
                  ColoredBox(
                    color: widget.backgroundColor ?? glass.controlTrack,
                    child: const SizedBox.expand(),
                  ),
                  Positioned(
                    left: segmentLeft,
                    width: segmentWidth,
                    top: 0,
                    bottom: 0,
                    child: ColoredBox(color: widget.color ?? tokens.primary),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
