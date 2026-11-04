import 'dart:ui' as ui;
import 'package:flutter/widgets.dart';
import 'hyper_glass_source.dart';

/// 合成独立背景源后执行圆角镜片；不捕获镜片或其前景，避免递归采样。
class HyperGlassPainter extends CustomPainter {
  HyperGlassPainter({
    required this.sources,
    required this.targetKey,
    required this.shader,
    required this.radius,
    required this.blur,
    required this.edge,
    required this.amount,
    required this.dispersion,
    required this.depth,
    required this.saturation,
    required this.brightness,
    required this.highlight,
    required this.baseColor,
    this.dialogBaseColor,
    this.tintSource,
    this.tint,
    this.scaleSource,
    this.sourceScale = const Offset(1, 1),
    this.compactSampling = false,
  }) : super(repaint: Listenable.merge(sources));
  final List<HyperGlassSourceController> sources;
  final GlobalKey targetKey;
  final ui.FragmentShader? shader;
  final double radius,
      blur,
      edge,
      amount,
      dispersion,
      depth,
      saturation,
      brightness,
      highlight;
  final Color baseColor;
  final Color? dialogBaseColor;
  final HyperGlassSourceController? tintSource, scaleSource;
  final Color? tint;
  final Offset sourceScale;
  final bool compactSampling;
  ui.Image? _sample;
  void disposeSample() {
    _sample?.dispose();
    _sample = null;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final bounds = Offset.zero & size;
    final dialogColor = dialogBaseColor;
    final target = targetKey.currentContext?.findRenderObject();
    if (target is! RenderBox ||
        !target.attached ||
        (dialogColor != null && sources.isEmpty)) {
      if (dialogColor != null) {
        canvas.drawRect(bounds, Paint()..color = dialogColor);
      }
      return;
    }
    final padding = compactSampling ? 0.0 : (blur * 3 + edge).ceilToDouble();
    final extent = Size(size.width + padding * 2, size.height + padding * 2);
    final recording = ui.PictureRecorder();
    final sampleCanvas = Canvas(recording);
    const ratio = 2.0;
    sampleCanvas.scale(ratio);
    sampleCanvas.drawRect(Offset.zero & extent, Paint()..color = baseColor);
    if (blur > 0)
      sampleCanvas.saveLayer(
        Offset.zero & extent,
        Paint()..imageFilter = ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
      );
    var hasSample = false;
    for (final source in sources) {
      final image = source.image;
      final boundary = source.boundary;
      if (image == null ||
          boundary == null ||
          !boundary.attached ||
          !boundary.hasSize)
        continue;
      hasSample = true;
      final paint = Paint()..filterQuality = FilterQuality.medium;
      if (source == tintSource && tint != null)
        paint.colorFilter = ColorFilter.mode(tint!, BlendMode.srcIn);
      sampleCanvas.save();
      if (source == scaleSource) {
        sampleCanvas.translate(extent.width / 2, extent.height / 2);
        sampleCanvas.scale(sourceScale.dx, sourceScale.dy);
        sampleCanvas.translate(-extent.width / 2, -extent.height / 2);
      }
      // 同时抵消镜片自身缩放并应用图像源的变换，弹性运动时标签仍与底层对齐。
      sampleCanvas.translate(padding, padding);
      sampleCanvas.transform(boundary.getTransformTo(target).storage);
      sampleCanvas.drawImageRect(
        image,
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        Offset.zero & boundary.size,
        paint,
      );
      sampleCanvas.restore();
    }
    if (blur > 0) sampleCanvas.restore();
    final picture = recording.endRecording();
    if (dialogColor != null && !hasSample) {
      picture.dispose();
      disposeSample();
      canvas.drawRect(bounds, Paint()..color = dialogColor);
      return;
    }
    final image = picture.toImageSync(
      (extent.width * ratio).ceil(),
      (extent.height * ratio).ceil(),
    );
    picture.dispose();
    final previous = _sample;
    _sample = image;
    if (shader != null) {
      final values = [
        size.width,
        size.height,
        padding,
        radius,
        radius,
        radius,
        radius,
        edge,
        amount,
        dispersion,
        depth,
        saturation,
        brightness,
        highlight,
        0.5,
        0.0,
      ];
      for (var index = 0; index < values.length; index++) {
        shader!.setFloat(index, values[index]);
      }
      shader!.setImageSampler(0, image);
      canvas.drawRect(bounds, Paint()..shader = shader);
    } else {
      canvas.drawImageRect(
        image,
        Rect.fromLTWH(
          padding * ratio,
          padding * ratio,
          size.width * ratio,
          size.height * ratio,
        ),
        bounds,
        Paint(),
      );
    }
    if (dialogColor != null) {
      // 只混入已模糊的取样，避免将原页面文字直接透到面板中。
      canvas.drawRect(
        bounds,
        Paint()..color = dialogColor.withValues(alpha: 0.88),
      );
    }
    previous?.dispose();
  }

  @override
  bool shouldRepaint(HyperGlassPainter oldDelegate) => true;
}
