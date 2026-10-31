// 内部几何与时间插值，由 LoadingPainter 和 HourglassPainter 共用。
import 'dart:math' as math;
import 'dart:ui';

double cycle(double seconds, double duration, [double delay = 0]) =>
    ((seconds + delay) / duration) % 1;

double mix(double a, double b, double t) => a + (b - a) * t;

double bezier(double t, double x1, double y1, double x2, double y2) {
  if (t <= 0 || t >= 1) return t.clamp(0, 1);
  double sample(double u, double a, double b) =>
      3 * (1 - u) * (1 - u) * u * a + 3 * (1 - u) * u * u * b + u * u * u;
  var low = 0.0;
  var high = 1.0;
  for (var i = 0; i < 22; i++) {
    final mid = (low + high) / 2;
    if (sample(mid, x1, x2) < t) {
      low = mid;
    } else {
      high = mid;
    }
  }
  return sample((low + high) / 2, y1, y2);
}

typedef MotionEase = double Function(double);
double linear(double t) => t;
double easeInOut(double t) => bezier(t, .42, 0, .58, 1);
double weaveEase(double t) => bezier(t, .45, 0, .25, 1);
double duetEase(double t) => bezier(t, .5, 0, .25, 1);
double photonEase(double t) => bezier(t, .4, 0, .3, 1);
double sparkEase(double t) => bezier(t, .4, 0, .2, 1);
double turnEase(double t) => bezier(t, .65, 0, .3, 1);

/// CSS 按属性分别插值，每个关键帧区间重新应用 easing。
double track(
  double phase,
  List<double> times,
  List<double> values, [
  MotionEase ease = linear,
]) {
  for (var i = 1; i < times.length; i++) {
    if (phase <= times[i]) {
      return mix(
        values[i - 1],
        values[i],
        ease(((phase - times[i - 1]) / (times[i] - times[i - 1])).clamp(0, 1)),
      );
    }
  }
  return values.last;
}

Paint fill(Color color) => Paint()..color = color;
Paint stroke(Color color, double width) => Paint()
  ..color = color
  ..style = PaintingStyle.stroke
  ..strokeWidth = width
  ..strokeCap = StrokeCap.round
  ..strokeJoin = StrokeJoin.round;

void pivot(
  Canvas canvas,
  double x,
  double y,
  double degrees, [
  double sx = 1,
  double sy = 1,
]) {
  canvas.translate(x, y);
  canvas.rotate(degrees * math.pi / 180);
  canvas.scale(sx, sy);
  canvas.translate(-x, -y);
}

Shader cssGradient(
  Rect rect,
  double angle,
  List<Color> colors,
  List<double> stops,
) {
  final radians = angle * math.pi / 180;
  final direction = Offset(math.sin(radians), -math.cos(radians));
  final length =
      rect.width * direction.dx.abs() + rect.height * direction.dy.abs();
  return Gradient.linear(
    rect.center - direction * length / 2,
    rect.center + direction * length / 2,
    colors,
    stops,
  );
}

Path polygon(List<Offset> points) => Path()..addPolygon(points, true);

/// 仅解析本组件的绝对坐标路径，在 renderer 创建时缓存，不在每帧解析。
Path motionPath(String source) {
  final tokens = RegExp(
    r'[MLCQHVZ]|-?\d+(?:\.\d+)?',
  ).allMatches(source).map((match) => match[0]!).toList();
  final result = Path();
  var index = 0;
  var x = 0.0;
  var y = 0.0;
  double number() => double.parse(tokens[index++]);
  while (index < tokens.length) {
    switch (tokens[index++]) {
      case 'M':
        x = number();
        y = number();
        result.moveTo(x, y);
      case 'L':
        x = number();
        y = number();
        result.lineTo(x, y);
      case 'H':
        x = number();
        result.lineTo(x, y);
      case 'V':
        y = number();
        result.lineTo(x, y);
      case 'C':
        final x1 = number(), y1 = number(), x2 = number(), y2 = number();
        x = number();
        y = number();
        result.cubicTo(x1, y1, x2, y2, x, y);
      case 'Q':
        final x1 = number(), y1 = number();
        x = number();
        y = number();
        result.quadraticBezierTo(x1, y1, x, y);
      case 'Z':
        result.close();
      default:
        throw FormatException('Unsupported loading path: $source');
    }
  }
  return result;
}

class LoadingPaths {
  final pulse = motionPath(
    'M9 44 C21 44 17 13 31 13 C47 13 38 64 54 64 C70 64 61 23 77 23 C89 23 85 44 99 44',
  );
  final weaveA = motionPath(
    'M12 28 C12 8 42 8 42 28 C42 52 70 52 70 28 C70 8 98 8 98 28',
  );
  final weaveB = motionPath(
    'M12 56 C12 76 42 76 42 56 C42 32 70 32 70 56 C70 76 98 76 98 56',
  );
  final ribbon = motionPath(
    'M4 27 C14 4 48 3 66 24 C69 28 64 33 60 29 C46 12 24 12 12 31 C9 35 1 32 4 27 Z',
  );
  final comet = motionPath(
    'M12 50 C-2 14 32 3 47 30 C65 66 89 76 94 46 C100 15 76 8 56 38 C35 74 15 78 12 50 Z',
  );
  final spark = motionPath(
    'M44 10 Q46 6 48 10 C52 30 56 34 78 38 Q84 40 78 42 C56 46 52 50 48 72 Q46 78 44 72 C40 50 36 46 14 42 Q8 40 14 38 C36 34 40 30 44 10 Z',
  );
  final satellite = motionPath(
    'M0 -12 Q2 -2 12 0 Q2 2 0 12 Q-2 2 -12 0 Q-2 -2 0 -12 Z',
  );
  late final pulseMetric = pulse.computeMetrics().first;
  late final weaveAMetric = weaveA.computeMetrics().first;
  late final weaveBMetric = weaveB.computeMetrics().first;
  late final cometMetric = comet.computeMetrics().first;
}

void pathSegment(
  Canvas canvas,
  PathMetric metric,
  double start,
  double end,
  Paint paint,
) {
  final from = start.clamp(0.0, 1.0);
  final to = end.clamp(0.0, 1.0);
  if (to > from)
    canvas.drawPath(
      metric.extractPath(from * metric.length, to * metric.length),
      paint,
    );
}
