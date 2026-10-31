// 沙漏轮廓、守恒沙形和细颗粒绘制；由 LoadingRenderer 调用。
import 'dart:math' as math;
import 'dart:ui';
import 'loading_geometry.dart';

class LoadingHourglass {
  final outer = motionPath(
    'M16 5 C5 5 4 10 7 22 C10 35 24 38 27 42 C24 46 10 49 7 62 C4 74 5 79 16 79 H48 C59 79 60 74 57 62 C54 49 40 46 37 42 C40 38 54 35 57 22 C60 10 59 5 48 5 Z',
  );
  final inner = motionPath(
    'M17 7 C8 7 6 12 9 23 C12 34 26 38 29 42 C26 46 12 50 9 61 C6 72 8 77 17 77 H47 C56 77 58 72 55 61 C52 50 38 46 35 42 C38 38 52 34 55 23 C58 12 56 7 47 7 Z',
  );
  late final rim = Path()
    ..fillType = PathFillType.evenOdd
    ..addPath(outer, Offset.zero)
    ..addPath(inner, Offset.zero);
  Picture? _sandTexture;

  // 一次录制纹理；每帧只裁切沙形，避免重复创建数百个颗粒。
  Picture _texture(Color a, Color b) {
    if (_sandTexture != null) return _sandTexture!;
    final recorder = PictureRecorder();
    final c = Canvas(recorder);
    const rect = Rect.fromLTWH(0, 0, 64, 84);
    c.drawRect(
      rect,
      Paint()
        ..shader = cssGradient(
          rect,
          90,
          [const Color(0xffb69764), b, a],
          [0, .48, 1],
        ),
    );
    for (var y = 1.75; y < 84; y += 3.5) {
      for (var x = 1.5; x < 64; x += 3) {
        c.drawCircle(
          Offset(x, y),
          .7,
          Paint()
            ..shader = Gradient.radial(
              Offset(x, y),
              .7,
              [
                const Color(0x52ffffff),
                const Color(0x52ffffff),
                const Color(0x00ffffff),
              ],
              [0, .4 / .7, 1],
            ),
        );
      }
    }
    for (var y = 2.5; y < 84; y += 3) {
      for (var x = 3.0; x < 64; x += 4) {
        c.drawCircle(
          Offset(x, y),
          .7,
          Paint()
            ..shader = Gradient.radial(
              Offset(x, y),
              .7,
              [
                const Color(0x266c502a),
                const Color(0x266c502a),
                const Color(0x006c502a),
              ],
              [0, .5, 1],
            ),
        );
      }
    }
    return _sandTexture = recorder.endRecording();
  }

  void dispose() => _sandTexture?.dispose();

  void draw(Canvas c, double seconds, Color a, Color b) {
    final p = cycle(seconds, 12);
    c.drawOval(
      const Rect.fromLTWH(23, 92, 54, 4),
      fill(const Color(0x1a3a3a36))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1),
    );
    c.save();
    c.translate(18, 5);
    pivot(
      c,
      32,
      42,
      track(p, [0, .42, .5, .92, 1], [0, 0, 180, 180, 360], turnEase),
    );
    const rect = Rect.fromLTWH(0, 0, 64, 84);
    c.drawPath(
      outer,
      Paint()
        ..shader = cssGradient(
          rect,
          90,
          [
            const Color(0x218e9aa3),
            const Color(0x0dffffff),
            const Color(0x0dffffff),
            const Color(0x2672808b),
          ],
          [0, .26, .68, 1],
        ),
    );
    for (var run = 0; run < 2; run++) {
      final q = cycle(seconds, 12, run * 6);
      final alpha = track(q, [0, .43, .49, .93, .99, 1], [1, 1, 0, 0, 1, 1]);
      if (alpha <= 0) continue;
      c.save();
      pivot(c, 32, 42, run * 180);
      c.clipPath(inner);
      c.saveLayer(rect, fill(Color.fromRGBO(255, 255, 255, alpha)));
      _drawSand(c, q, seconds, _texture(a, b));
      c.restore();
      c.restore();
    }
    c.save();
    c.clipPath(inner);
    c.drawRect(
      rect,
      Paint()
        ..shader = cssGradient(
          rect,
          99,
          [
            const Color(0x00ffffff),
            const Color(0x00ffffff),
            const Color(0x7affffff),
            const Color(0x00ffffff),
            const Color(0x00ffffff),
            const Color(0x5cffffff),
            const Color(0x00ffffff),
            const Color(0x00ffffff),
          ],
          [0, .18, .21, .26, .72, .76, .8, 1],
        ),
    );
    c.restore();
    c.drawPath(
      rim,
      Paint()
        ..shader = cssGradient(
          rect,
          110,
          [
            const Color(0xffb7c1c8),
            const Color(0xfff4f6f5),
            const Color(0xffb6c0c6),
            const Color(0xff84929c),
            const Color(0xffe4e8e9),
          ],
          [.08, .28, .52, .78, 1],
        ),
    );
    for (final top in [2.0, 77.0]) {
      final capRect = Rect.fromLTWH(8, top, 48, 5);
      final shape = RRect.fromRectAndRadius(
        capRect,
        const Radius.elliptical(18.461538, 2.5),
      );
      c.drawRRect(
        shape.shift(const Offset(0, 1)),
        fill(const Color(0x123d4446))
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, .5),
      );
      c.drawRRect(
        shape,
        Paint()
          ..shader = cssGradient(
            capRect,
            180,
            [
              const Color(0xfff0efeb),
              const Color(0xffb2b5b3),
              const Color(0xffe1e1db),
            ],
            [0, .65, 1],
          ),
      );
      c.drawRRect(shape.deflate(.5), stroke(const Color(0x42747b7c), 1));
    }
    c.restore();
  }

  void _drawSand(Canvas c, double p, double seconds, Picture texture) {
    const times = [
      0.0,
      .03,
      .066,
      .102,
      .138,
      .174,
      .21,
      .246,
      .282,
      .318,
      .354,
      .39,
      .49,
      .5,
      1.0,
    ];
    final level = track(p, times, [
      24.45,
      24.45,
      25.55,
      26.65,
      27.75,
      28.95,
      30.15,
      31.465,
      32.933,
      34.703,
      36.987,
      41.936,
      41.936,
      24.45,
      24.45,
    ]);
    // 凹陷顶点也逐帧插值，保持网页原始关键帧的沙量变化。
    final dip = track(p, times, [
      27.65,
      27.65,
      28.75,
      29.85,
      30.95,
      32.15,
      33.35,
      34.665,
      36.106,
      37.257,
      38.742,
      41.958,
      41.958,
      27.65,
      27.65,
    ]);
    final height = track(p, times, [
      0,
      0,
      5.69,
      8.047,
      9.856,
      11.382,
      12.744,
      14,
      15.181,
      16.309,
      17.397,
      18.455,
      18.455,
      0,
      0,
    ]);
    final radius = height / math.tan(34 * math.pi / 180);
    for (final path in [
      polygon([
        Offset(0, level),
        Offset(24, level),
        Offset(32, dip),
        Offset(40, level),
        Offset(64, level),
        const Offset(64, 42),
        const Offset(0, 42),
      ]),
      polygon([
        Offset(32 - radius, 77),
        Offset(32, 77 - height),
        Offset(32 + radius, 77),
        const Offset(64, 84),
        const Offset(0, 84),
      ]),
    ]) {
      c.save();
      c.clipPath(path);
      c.drawPicture(texture);
      c.restore();
    }
    final streamAlpha = track(p, [0, .01, .03, .37, .4, 1], [0, 0, 1, 1, 0, 0]);
    if (streamAlpha <= 0) return;
    final length = 35 - height;
    c.saveLayer(
      const Rect.fromLTWH(27, 41, 11, 38),
      fill(Color.fromRGBO(255, 255, 255, streamAlpha)),
    );
    c.save();
    c.clipRect(Rect.fromLTWH(31.4, 42, 1.2, length));
    final shift = cycle(seconds, .22) * 7;
    for (var y = 42 + shift - 7; y < 78; y += 3.5) {
      c.drawRect(
        Rect.fromLTWH(31.4, y + 1, 1.2, 1.6),
        fill(const Color(0xffc7a974)),
      );
      c.drawRect(
        Rect.fromLTWH(31.4, y + 2.6, 1.2, .9),
        fill(const Color(0xffe2cda7)),
      );
    }
    c.restore();
    final impact = bezier(cycle(seconds, .18), 0, 0, .58, 1);
    c.save();
    c.translate(31.9, 42 + length - .5 + mix(-1, 1, impact));
    c.scale(mix(.7, 1.3, impact));
    for (final (point, radius, color) in [
      (const Offset(-1.5, .6), .8, const Color(0xffc5a36b)),
      (const Offset(1.1, -.3), .7, const Color(0xffddc395)),
    ]) {
      final opaque = color.withValues(alpha: .7 * (1 - impact));
      c.drawCircle(
        point,
        radius,
        Paint()
          ..shader = Gradient.radial(
            point,
            radius,
            [opaque, opaque, opaque.withValues(alpha: 0)],
            [0, .65, 1],
          ),
      );
    }
    c.restore();
    c.restore();
  }
}
