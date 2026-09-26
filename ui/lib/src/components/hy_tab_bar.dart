import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';

/// 底栏中的一个导航项；页面与图标含义由调用方决定。
class HyTabItem {
  const HyTabItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

/// 带液态放大镜的悬浮底部导航。
///
/// 按下时选中块膨胀成透明水珠，拖动时水珠跟手移动并放大其下方的图文；
/// 松手后收缩为灰色选中块，并通过 [onSelected] 提交最终索引。
class HyTabBar extends StatefulWidget {
  const HyTabBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    this.safeArea = true,
    this.enableHaptics = true,
    this.activeColor = const Color(0xFF079D62),
    this.margin = const EdgeInsets.fromLTRB(20, 8, 20, 0),
  }) : assert(items.length >= 2),
       assert(selectedIndex >= 0 && selectedIndex < items.length);

  static const double height = 56;

  final List<HyTabItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final bool safeArea;
  final bool enableHaptics;
  final Color activeColor;
  final EdgeInsetsGeometry margin;

  @override
  State<HyTabBar> createState() => _HyTabBarState();
}

class _HyTabBarState extends State<HyTabBar> with TickerProviderStateMixin {
  static const double _inset = 4;
  static const double _projectionSeconds = 0.09;
  static const SpringDescription _snapSpring = SpringDescription(
    mass: 1,
    stiffness: 520,
    damping: 38,
  );

  late final AnimationController _position;
  late final AnimationController _lensExpansion;
  late final Listenable _animations;
  VelocityTracker? _velocityTracker;
  int? _activePointer;
  int? _pressedVisualIndex;
  int? _pendingSelection;
  int? _lastHapticVisualIndex;
  double _pointerDownX = 0;
  double _grabOffsetX = 0;
  double _dragVelocity = 0;
  bool _dragging = false;
  bool _rtl = false;

  @override
  void initState() {
    super.initState();
    _position = AnimationController.unbounded(
      value: widget.selectedIndex.toDouble(),
      vsync: this,
    );
    _lensExpansion = AnimationController(
      duration: const Duration(milliseconds: 180),
      reverseDuration: const Duration(milliseconds: 230),
      vsync: this,
    );
    _animations = Listenable.merge(<Listenable>[_position, _lensExpansion]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final nextRtl = Directionality.of(context) == TextDirection.rtl;
    if (_rtl != nextRtl && _activePointer == null) {
      _rtl = nextRtl;
      _position.value = _visualIndex(widget.selectedIndex).toDouble();
    } else {
      _rtl = nextRtl;
    }
  }

  @override
  void didUpdateWidget(covariant HyTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex == widget.selectedIndex &&
        oldWidget.items.length == widget.items.length) {
      return;
    }
    final alreadySettlingThere = _pendingSelection == widget.selectedIndex;
    _pendingSelection = null;
    if (_activePointer == null && !alreadySettlingThere) {
      _settleAt(_visualIndex(widget.selectedIndex));
    }
  }

  @override
  void dispose() {
    _position.dispose();
    _lensExpansion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final textHeight = MediaQuery.textScalerOf(context).scale(12) * 1.08;
    final barHeight = math.max(HyTabBar.height, textHeight + 36);
    final bar = Padding(
      padding: widget.margin,
      child: SizedBox(
        height: barHeight,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final barWidth = constraints.maxWidth;
            final contentWidth = math.max(1.0, barWidth - _inset * 2);
            final cellWidth = contentWidth / widget.items.length;
            final pillWidth = math
                .min(112.0, cellWidth - 2)
                .clamp(1.0, cellWidth)
                .toDouble();
            return Listener(
              behavior: HitTestBehavior.opaque,
              onPointerDown: (event) => _handlePointerDown(event, contentWidth),
              onPointerMove: (event) => _handlePointerMove(event, contentWidth),
              onPointerUp: (event) => _handlePointerUp(event, contentWidth),
              onPointerCancel: _handlePointerCancel,
              child: AnimatedBuilder(
                animation: _animations,
                builder: (context, _) {
                  final position = _position.value;
                  final expansion = Curves.easeOutCubic.transform(
                    _lensExpansion.value,
                  );
                  final velocity = math.max(
                    _position.velocity.abs(),
                    _dragVelocity.abs(),
                  );
                  final centerX = _inset + (position + 0.5) * cellWidth;
                  final selectedLeft = (centerX - pillWidth / 2)
                      .clamp(_inset, barWidth - _inset - pillWidth)
                      .toDouble();
                  final lensWidth =
                      pillWidth +
                      38 * expansion +
                      math.min(14.0, velocity * 1.1) * expansion;
                  final lensHeight = barHeight - 8 + 18 * expansion;
                  final lensLeft = (centerX - lensWidth / 2)
                      .clamp(-12.0, math.max(-12.0, barWidth + 12 - lensWidth))
                      .toDouble();
                  final lensTop = (barHeight - lensHeight) / 2;
                  final foreground = dark
                      ? Colors.white
                      : const Color(0xFF101010);
                  final content = _buildTabRow(
                    position: position,
                    foreground: foreground,
                  );

                  return Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Positioned.fill(child: _HyTabSurface(dark: dark)),
                      Positioned(
                        left: selectedLeft,
                        top: _inset,
                        width: pillWidth,
                        height: barHeight - _inset * 2,
                        child: Opacity(
                          opacity: (1 - expansion * 1.5)
                              .clamp(0.0, 1.0)
                              .toDouble(),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: dark
                                  ? const Color(0x33FFFFFF)
                                  : const Color(0x20000000),
                              borderRadius: BorderRadius.circular(
                                barHeight / 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        left: _inset,
                        right: _inset,
                        child: content,
                      ),
                      if (expansion > 0.001)
                        Positioned(
                          left: lensLeft,
                          top: lensTop,
                          width: lensWidth,
                          height: lensHeight,
                          child: IgnorePointer(
                            child: _HyLiquidLens(
                              expansion: expansion,
                              velocity: _dragVelocity == 0
                                  ? _position.velocity
                                  : _dragVelocity,
                              dark: dark,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
    return widget.safeArea
        ? SafeArea(top: false, minimum: EdgeInsets.zero, child: bar)
        : bar;
  }

  Widget _buildTabRow({required double position, required Color foreground}) {
    return Row(
      textDirection: TextDirection.ltr,
      children: <Widget>[
        for (var visual = 0; visual < widget.items.length; visual++)
          Expanded(
            child: _HyTabLabel(
              item: widget.items[_logicalIndex(visual)],
              selected: widget.selectedIndex == _logicalIndex(visual),
              strength: (1 - (position - visual).abs() * 1.6)
                  .clamp(0.0, 1.0)
                  .toDouble(),
              activeColor: widget.activeColor,
              inactiveColor: foreground,
              onTap: () => _selectFromSemantics(visual),
            ),
          ),
      ],
    );
  }

  int _visualIndex(int logicalIndex) =>
      _rtl ? widget.items.length - logicalIndex - 1 : logicalIndex;

  int _logicalIndex(int visualIndex) =>
      _rtl ? widget.items.length - visualIndex - 1 : visualIndex;

  double _step(double contentWidth) => contentWidth / widget.items.length;

  double _firstCenter(double contentWidth) => _step(contentWidth) / 2;

  int _nearestIndex(double x, double contentWidth) {
    final index =
        ((x - _inset - _firstCenter(contentWidth)) / _step(contentWidth))
            .round();
    return index.clamp(0, widget.items.length - 1).toInt();
  }

  void _selectFromSemantics(int visualIndex) {
    _settleAt(visualIndex);
    final logicalIndex = _logicalIndex(visualIndex);
    if (logicalIndex != widget.selectedIndex && widget.enableHaptics) {
      HapticFeedback.selectionClick();
    }
    widget.onSelected(logicalIndex);
  }

  void _handlePointerDown(PointerDownEvent event, double contentWidth) {
    if (_activePointer != null || !contentWidth.isFinite || contentWidth <= 0) {
      return;
    }
    final visual = _nearestIndex(event.localPosition.dx, contentWidth);
    final center =
        _inset + _firstCenter(contentWidth) + _step(contentWidth) * visual;
    _activePointer = event.pointer;
    _pressedVisualIndex = visual;
    _lastHapticVisualIndex = visual;
    _pointerDownX = event.localPosition.dx;
    _grabOffsetX = event.localPosition.dx - center;
    _dragging = false;
    _dragVelocity = 0;
    _velocityTracker = VelocityTracker.withKind(event.kind)
      ..addPosition(event.timeStamp, event.localPosition);
    _settleAt(visual);
    _lensExpansion.forward();
  }

  void _handlePointerMove(PointerMoveEvent event, double contentWidth) {
    if (_activePointer != event.pointer) return;
    _velocityTracker?.addPosition(event.timeStamp, event.localPosition);
    if (!_dragging && (event.localPosition.dx - _pointerDownX).abs() < 6) {
      return;
    }
    _dragging = true;
    final step = _step(contentWidth);
    _dragVelocity =
        (_velocityTracker?.getVelocity().pixelsPerSecond.dx ?? 0) / step;
    final first = _firstCenter(contentWidth);
    final desired = event.localPosition.dx - _inset - _grabOffsetX;
    final resisted = _resist(
      desired,
      first,
      first + step * (widget.items.length - 1),
      step,
    );
    _position.value = (resisted - first) / step;
    final nearest = _position.value
        .round()
        .clamp(0, widget.items.length - 1)
        .toInt();
    if (nearest != _lastHapticVisualIndex && widget.enableHaptics) {
      HapticFeedback.selectionClick();
    }
    _lastHapticVisualIndex = nearest;
  }

  void _handlePointerUp(PointerUpEvent event, double contentWidth) {
    if (_activePointer != event.pointer) return;
    _velocityTracker?.addPosition(event.timeStamp, event.localPosition);
    final velocity =
        (_velocityTracker?.getVelocity().pixelsPerSecond.dx ?? 0) /
        _step(contentWidth);
    final projected = _position.value + velocity * _projectionSeconds;
    final visual = _dragging
        ? projected.round().clamp(0, widget.items.length - 1).toInt()
        : _pressedVisualIndex!;
    final logical = _logicalIndex(visual);
    final alreadyHapticallySelected =
        _dragging && _lastHapticVisualIndex == visual;
    _clearPointer();
    _lensExpansion.reverse();
    _settleAt(visual, initialVelocity: velocity);
    if (logical != widget.selectedIndex) {
      _pendingSelection = logical;
      if (widget.enableHaptics && !alreadyHapticallySelected) {
        HapticFeedback.selectionClick();
      }
    }
    widget.onSelected(logical);
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    if (_activePointer != event.pointer) return;
    _clearPointer();
    _lensExpansion.reverse();
    _settleAt(_visualIndex(widget.selectedIndex));
  }

  void _clearPointer() {
    _activePointer = null;
    _pressedVisualIndex = null;
    _lastHapticVisualIndex = null;
    _velocityTracker = null;
    _pointerDownX = 0;
    _grabOffsetX = 0;
    _dragVelocity = 0;
    _dragging = false;
  }

  void _settleAt(int visualIndex, {double initialVelocity = 0}) {
    _position.animateWith(
      SpringSimulation(
        _snapSpring,
        _position.value,
        visualIndex.toDouble(),
        initialVelocity,
      ),
    );
  }

  static double _resist(
    double value,
    double minimum,
    double maximum,
    double dimension,
  ) {
    if (value < minimum) {
      final overshoot = minimum - value;
      return minimum -
          overshoot * dimension * 0.32 / (dimension + overshoot * 0.32);
    }
    if (value > maximum) {
      final overshoot = value - maximum;
      return maximum +
          overshoot * dimension * 0.32 / (dimension + overshoot * 0.32);
    }
    return value;
  }
}

class _HyTabSurface extends StatelessWidget {
  const _HyTabSurface({required this.dark});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(28);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withAlpha(dark ? 80 : 24),
            blurRadius: 26,
            spreadRadius: -4,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: dark ? const Color(0xE6292A2C) : const Color(0xE6FFFFFF),
              borderRadius: radius,
              border: Border.all(
                color: dark ? const Color(0x45FFFFFF) : const Color(0xD9FFFFFF),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HyTabLabel extends StatelessWidget {
  const _HyTabLabel({
    required this.item,
    required this.selected,
    required this.strength,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  final HyTabItem item;
  final bool selected;
  final double strength;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = Color.lerp(inactiveColor, activeColor, strength)!;
    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      onTap: onTap,
      child: ExcludeSemantics(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(item.icon, color: foreground, size: 23),
            const SizedBox(height: 1),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: foreground,
                fontSize: 12,
                height: 1.08,
                fontWeight: FontWeight.lerp(
                  FontWeight.w500,
                  FontWeight.w700,
                  strength,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HyLiquidLens extends StatelessWidget {
  const _HyLiquidLens({
    required this.expansion,
    required this.velocity,
    required this.dark,
  });

  final double expansion;
  final double velocity;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final tilt = (velocity / 8).clamp(-1.0, 1.0).toDouble();
    final clipper = _HyLensShape(tilt: tilt);
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final scaleX = 1 + 0.15 * expansion;
        final scaleY = 1 + 0.09 * expansion;
        // BackdropFilter 的矩阵直接放大水珠后的真实画面，包括底栏与页面。
        final matrix = Float64List.fromList(<double>[
          scaleX,
          0,
          0,
          0,
          0,
          scaleY,
          0,
          0,
          0,
          0,
          1,
          0,
          (1 - scaleX) * width / 2,
          (1 - scaleY) * height / 2,
          0,
          1,
        ]);
        final refraction = ui.ImageFilter.compose(
          inner: ui.ImageFilter.matrix(matrix),
          outer: ui.ImageFilter.blur(sigmaX: 0.7, sigmaY: 0.7),
        );
        return RepaintBoundary(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(height / 2),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withAlpha((29 * expansion).round()),
                  blurRadius: 22 * expansion,
                  spreadRadius: -3,
                  offset: Offset(0, 5 * expansion),
                ),
              ],
            ),
            child: CustomPaint(
              foregroundPainter: _HyLensRimPainter(
                clipper: clipper,
                opacity: expansion,
              ),
              child: ClipPath(
                clipper: clipper,
                child: BackdropFilter(
                  filter: refraction,
                  child: ColoredBox(
                    color: dark
                        ? Color.fromARGB((36 * expansion).round(), 85, 89, 94)
                        : Color.fromARGB(
                            (44 * expansion).round(),
                            255,
                            255,
                            255,
                          ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HyLensShape extends CustomClipper<Path> {
  const _HyLensShape({required this.tilt});

  final double tilt;

  @override
  Path getClip(Size size) {
    final width = size.width;
    final height = size.height;
    final radius = height / 2;
    final pull = tilt * 5;
    return Path()
      ..moveTo(radius, 0)
      ..cubicTo(
        width * 0.42,
        -pull.abs() * 0.12,
        width * 0.72,
        0,
        width - radius,
        0,
      )
      ..cubicTo(
        width - radius * 0.25 + pull,
        0,
        width,
        radius * 0.36,
        width,
        radius,
      )
      ..cubicTo(
        width,
        height - radius * 0.36,
        width - radius * 0.25 - pull,
        height,
        width - radius,
        height,
      )
      ..lineTo(radius, height)
      ..cubicTo(
        radius * 0.25 + pull,
        height,
        0,
        height - radius * 0.36,
        0,
        radius,
      )
      ..cubicTo(0, radius * 0.36, radius * 0.25 - pull, 0, radius, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant _HyLensShape oldClipper) =>
      oldClipper.tilt != tilt;
}

class _HyLensRimPainter extends CustomPainter {
  const _HyLensRimPainter({required this.clipper, required this.opacity});

  final _HyLensShape clipper;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    final path = clipper.getClip(size);
    final rim = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..shader = ui.Gradient.sweep(bounds.center, <Color>[
        Colors.white.withAlpha((205 * opacity).round()),
        const Color(0xFF9FE7F8).withAlpha((125 * opacity).round()),
        Colors.white.withAlpha((220 * opacity).round()),
        const Color(0xFFFFD7EC).withAlpha((110 * opacity).round()),
        Colors.white.withAlpha((205 * opacity).round()),
      ]);
    canvas.drawPath(path, rim);
    final highlight = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withAlpha((110 * opacity).round());
    canvas.drawArc(
      Rect.fromLTWH(3, 2, size.width - 6, size.height * 0.8),
      math.pi * 1.07,
      math.pi * 0.84,
      false,
      highlight,
    );
  }

  @override
  bool shouldRepaint(covariant _HyLensRimPainter oldDelegate) =>
      oldDelegate.opacity != opacity ||
      oldDelegate.clipper.tilt != clipper.tilt;
}
