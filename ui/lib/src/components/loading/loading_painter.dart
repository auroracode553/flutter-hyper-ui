// 十款动画的平面原生绘制；时钟和公开 API 位于 hyper_loading.dart。
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'hyper_loading_type.dart';
import 'loading_geometry.dart';
import 'loading_hourglass.dart';

Size loadingSize(HyperLoadingType type) => switch (type) {
  HyperLoadingType.travelingPulse ||
  HyperLoadingType.flexRaster => const Size(108, 80),
  HyperLoadingType.wovenSignal => const Size(108, 84),
  HyperLoadingType.ribbonDuet => const Size(82, 68),
  HyperLoadingType.threeBody => const Size(80, 80),
  HyperLoadingType.cometExchange => const Size(104, 84),
  HyperLoadingType.photonRelay => const Size(86, 64),
  HyperLoadingType.elasticSpark => const Size(92, 92),
  HyperLoadingType.goldenHourglass => const Size(100, 100),
  HyperLoadingType.frequencyFins => const Size(82, 66),
};

(Color, Color) loadingColors(HyperLoadingType type) => switch (type) {
  HyperLoadingType.travelingPulse => (
    const Color(0xff4f78e4),
    const Color(0xff4dc5bf),
  ),
  HyperLoadingType.wovenSignal => (
    const Color(0xff4c7cdb),
    const Color(0xff51c2b5),
  ),
  HyperLoadingType.ribbonDuet => (
    const Color(0xfff18c68),
    const Color(0xfff7c17b),
  ),
  HyperLoadingType.threeBody => (
    const Color(0xff4c7aeb),
    const Color(0xff67c9e1),
  ),
  HyperLoadingType.cometExchange => (
    const Color(0xff4978e5),
    const Color(0xff50c7bb),
  ),
  HyperLoadingType.photonRelay => (
    const Color(0xff418aca),
    const Color(0xff65cbb8),
  ),
  HyperLoadingType.elasticSpark => (
    const Color(0xff5b7fe0),
    const Color(0xff67c9c0),
  ),
  HyperLoadingType.goldenHourglass => (
    const Color(0xffc5a774),
    const Color(0xffe3d0ab),
  ),
  HyperLoadingType.frequencyFins => (
    const Color(0xff427fd1),
    const Color(0xff69c5c7),
  ),
  HyperLoadingType.flexRaster => (
    const Color(0xff5084db),
    const Color(0xff6bc8bb),
  ),
};

class LoadingRenderer {
  late final paths = LoadingPaths();
  LoadingHourglass? _hourglass;

  void dispose() => _hourglass?.dispose();

  void draw(Canvas c, HyperLoadingType type, double seconds, Color a, Color b) {
    switch (type) {
      case HyperLoadingType.travelingPulse:
        c.drawPath(paths.pulse, stroke(const Color(0xffedf1f6), 3.5));
        for (var i = 0; i < 2; i++) {
          final start = cycle(seconds, 2.8, i * 1.4);
          final end = start + (i == 0 ? .32 : .23);
          final paint = stroke(i == 0 ? a : b, 8.5);
          pathSegment(c, paths.pulseMetric, start, end, paint);
          if (end > 1) pathSegment(c, paths.pulseMetric, 0, end - 1, paint);
        }
      case HyperLoadingType.wovenSignal:
        c.save();
        c.translate(0, (84 - 84 * 108 / 110) / 2);
        c.scale(108 / 110);
        for (var i = 0; i < 2; i++) {
          final offset = track(
            cycle(seconds, 3, i == 0 ? .45 : 1.25),
            [0, .3, .6, .9, 1],
            [1, 0, 0, -1, -1],
            weaveEase,
          );
          pathSegment(
            c,
            i == 0 ? paths.weaveAMetric : paths.weaveBMetric,
            math.max(0, -offset),
            math.min(1, 1 - offset),
            stroke(i == 0 ? a : b, 9),
          );
        }
        c.restore();
      case HyperLoadingType.ribbonDuet:
        for (var i = 0; i < 2; i++) {
          var p = cycle(seconds, 3.2, i * 1.6);
          if (i == 1) p = 1 - p;
          c.save();
          c.translate(5, 12);
          pivot(
            c,
            36,
            22,
            track(p, [0, .5, 1], [-30, 150, 330], duetEase),
            track(p, [0, .5, 1], [.85, 1.1, .85], duetEase),
          );
          c.drawPath(paths.ribbon, fill(i == 0 ? a : b));
          c.restore();
        }
      case HyperLoadingType.threeBody:
        final theta = cycle(seconds, 3.4) * 2 * math.pi;
        final radius = 17 + math.sin(theta) * 7;
        for (var i = 0; i < 3; i++) {
          final angle = theta + i * 2 * math.pi / 3;
          c.drawCircle(
            Offset(
              40 + math.cos(angle) * radius,
              40 + math.sin(angle) * radius,
            ),
            6 * (1 + math.sin(angle) * .22),
            fill(
              i == 0
                  ? a
                  : i == 1
                  ? b
                  : Color.lerp(a, b, .45)!,
            ),
          );
        }
      case HyperLoadingType.cometExchange:
        for (var group = 0; group < 2; group++) {
          for (var i = 0; i < 6; i++) {
            final p = cycle(seconds, 3, i * .065 + group * 1.5);
            final tangent = paths.cometMetric.getTangentForOffset(
              p * paths.cometMetric.length,
            )!;
            final w = 6.0 + i * 2, h = 4.0 + i * 1.25;
            final color = group == 0 ? a : b;
            c.save();
            c.translate(tangent.position.dx, tangent.position.dy);
            c.rotate(math.atan2(tangent.vector.dy, tangent.vector.dx));
            final rect = Rect.fromCenter(
              center: Offset.zero,
              width: w,
              height: h,
            );
            final shape = RRect.fromRectAndCorners(
              rect,
              topLeft: Radius.elliptical(w * .2 / 1.2, h * .4 / 1.2),
              bottomLeft: Radius.elliptical(w * .2 / 1.2, h * .4 / 1.2),
              topRight: Radius.elliptical(w * .75 / 1.2, h * .6 / 1.2),
              bottomRight: Radius.elliptical(w * .75 / 1.2, h * .6 / 1.2),
            );
            c.drawRRect(
              shape,
              fill(color.withValues(alpha: color.a * (.12 + i * .17))),
            );
            if (i == 5) {
              c.drawRRect(
                shape,
                Paint()
                  ..shader = ui.Gradient.linear(
                    rect.topLeft,
                    rect.bottomRight,
                    [const Color(0x59ffffff), const Color(0x00ffffff)],
                    [0, .45],
                  ),
              );
            }
            c.restore();
          }
        }
      case HyperLoadingType.photonRelay:
        c.save();
        pivot(c, 43, 32, -28);
        for (var i = 0; i < 3; i++) {
          final p = cycle(seconds, 1.65, i * .22);
          final dx = track(p, [0, .55, 1], [-20, 10, 24], photonEase);
          final sx = track(p, [0, .55, 1], [.3, 1, .3], photonEase);
          final alpha = track(p, [0, .2, .85, 1], [0, 1, 1, 0], photonEase);
          final color = i == 0
              ? a
              : i == 1
              ? b
              : Color.lerp(a, b, .45)!;
          c.save();
          c.translate(43 + dx, 17 + i * 15);
          c.scale(sx, 1);
          c.drawRRect(
            RRect.fromRectAndRadius(
              const Rect.fromLTWH(-18, -3, 36, 6),
              const Radius.circular(3),
            ),
            fill(color.withValues(alpha: color.a * alpha)),
          );
          c.restore();
        }
        c.restore();
      case HyperLoadingType.elasticSpark:
        final p = cycle(seconds, 2.8);
        const times = [0.0, .48, .68, 1.0];
        c.save();
        pivot(
          c,
          46,
          42,
          track(p, times, [-14, 12, 5, -14], sparkEase),
          track(p, times, [.68, 1, .92, .68], sparkEase),
          track(p, times, [.86, .92, 1.04, .86], sparkEase),
        );
        c.drawPath(paths.spark, fill(a));
        c.restore();
        const echo = [0.0, .45, .7, 1.0];
        c.save();
        c.translate(
          track(p, echo, [72, 77, 75, 72], sparkEase),
          track(p, echo, [15, 17, 19, 15], sparkEase),
        );
        c.rotate(track(p, echo, [15, -8, 8, 15], sparkEase) * math.pi / 180);
        final scale = track(p, echo, [.25, .9, .65, .25], sparkEase);
        c.scale(scale);
        c.drawPath(
          paths.satellite,
          fill(
            b.withValues(
              alpha: b.a * track(p, echo, [.3, 1, .8, .3], sparkEase),
            ),
          ),
        );
        c.restore();
      case HyperLoadingType.goldenHourglass:
        (_hourglass ??= LoadingHourglass()).draw(c, seconds, a, b);
      case HyperLoadingType.frequencyFins:
        c.save();
        pivot(c, 41, 33, -10);
        for (var index = 0; index < 5; index++) {
          final delay = (index - 2) * .16;
          final p = cycle(seconds, 2.4, delay);
          final active = seconds + delay >= 0;
          final dx = 12.0 + index * 12 + 3.5;
          c.save();
          c.translate(
            dx,
            50 + (active ? track(p, [0, .5, 1], [5, -3, 5], easeInOut) : 0),
          );
          if (active) {
            c.rotate(
              track(p, [0, .5, 1], [-13, 13, -13], easeInOut) * math.pi / 180,
            );
            c.scale(1, track(p, [0, .5, 1], [.55, 1.15, .55], easeInOut));
          }
          const rect = Rect.fromLTWH(-3.5, -38, 7, 38);
          c.drawRRect(
            RRect.fromRectAndRadius(rect, const Radius.circular(3.5)),
            index.isOdd
                ? fill(b)
                : (Paint()..shader = cssGradient(rect, 180, [b, a], [0, 1])),
          );
          c.restore();
        }
        c.restore();
      case HyperLoadingType.flexRaster:
        for (var i = 0; i < 6; i++) {
          final p = cycle(seconds, 2.6, i * .15);
          final x = track(p, [0, .5, 1], [-16, 16, -16], easeInOut);
          c.save();
          c.translate(18 + i * 14, 0);
          c.drawPath(
            Path()
              ..moveTo(0, 12)
              ..cubicTo(x, 28, -x, 44, 0, 64),
            stroke(i.isEven ? a : b, 7.5),
          );
          c.restore();
        }
    }
  }
}

class LoadingPainter extends CustomPainter {
  LoadingPainter({
    required this.time,
    required this.renderer,
    required this.type,
    required this.primary,
    required this.secondary,
  }) : super(repaint: time);
  final ValueListenable<double> time;
  final LoadingRenderer renderer;
  final HyperLoadingType type;
  final Color primary, secondary;
  @override
  void paint(Canvas canvas, Size size) {
    final reference = loadingSize(type);
    final scale = math.min(
      size.width / reference.width,
      size.height / reference.height,
    );
    canvas.save();
    canvas.translate(
      (size.width - reference.width * scale) / 2,
      (size.height - reference.height * scale) / 2,
    );
    canvas.scale(scale);
    renderer.draw(canvas, type, time.value, primary, secondary);
    canvas.restore();
  }

  @override
  bool shouldRepaint(LoadingPainter old) =>
      old.type != type ||
      old.primary != primary ||
      old.secondary != secondary ||
      old.time != time;
}
