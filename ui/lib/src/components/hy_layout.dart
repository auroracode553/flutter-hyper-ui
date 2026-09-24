import 'package:flutter/material.dart';

import '../theme/hy_glass_theme.dart';
import '../theme/hy_ui_theme_tokens.dart';

class HySpace extends StatelessWidget {
  const HySpace({
    super.key,
    required this.children,
    this.direction = Axis.vertical,
    this.spacing = 12,
    this.alignment = CrossAxisAlignment.start,
  });
  final List<Widget> children;
  final Axis direction;
  final double spacing;
  final CrossAxisAlignment alignment;
  @override
  Widget build(BuildContext context) => Flex(
    direction: direction,
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: alignment,
    children: [
      for (var i = 0; i < children.length; i++) ...[
        if (i > 0)
          SizedBox(
            width: direction == Axis.horizontal ? spacing : 0,
            height: direction == Axis.vertical ? spacing : 0,
          ),
        children[i],
      ],
    ],
  );
}

class HyWrap extends StatelessWidget {
  const HyWrap({
    super.key,
    required this.children,
    this.spacing = 8,
    this.runSpacing = 8,
  });
  final List<Widget> children;
  final double spacing, runSpacing;
  @override
  Widget build(BuildContext context) =>
      Wrap(spacing: spacing, runSpacing: runSpacing, children: children);
}

class HyGrid extends StatelessWidget {
  const HyGrid({
    super.key,
    required this.children,
    this.columns = 3,
    this.spacing = 12,
    this.childAspectRatio = 1,
  }) : assert(columns > 0);
  final List<Widget> children;
  final int columns;
  final double spacing, childAspectRatio;
  @override
  Widget build(BuildContext context) => GridView.count(
    crossAxisCount: columns,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: EdgeInsets.zero,
    mainAxisSpacing: spacing,
    crossAxisSpacing: spacing,
    childAspectRatio: childAspectRatio,
    children: children,
  );
}

class HyDivider extends StatelessWidget {
  const HyDivider({
    super.key,
    this.axis = Axis.horizontal,
    this.indent = 0,
    this.endIndent = 0,
    this.dashed = false,
    this.length,
    this.color,
  });
  final Axis axis;
  final double indent, endIndent;
  final double? length;
  final bool dashed;
  final Color? color;
  @override
  Widget build(BuildContext context) => Padding(
    padding: axis == Axis.horizontal
        ? EdgeInsetsDirectional.only(start: indent, end: endIndent)
        : EdgeInsets.only(top: indent, bottom: endIndent),
    child: SizedBox(
      width: axis == Axis.vertical ? 1 : length,
      height: axis == Axis.horizontal ? 1 : (length ?? 24),
      child: CustomPaint(
        painter: _DividerPainter(
          axis,
          dashed,
          color ?? HyUiThemeTokens.of(context).border,
        ),
      ),
    ),
  );
}

class _DividerPainter extends CustomPainter {
  _DividerPainter(this.axis, this.dashed, this.color);
  final Axis axis;
  final bool dashed;
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    final length = axis == Axis.horizontal ? size.width : size.height;
    if (length <= 0) return;
    for (double p = 0; p < length; p += dashed ? 8 : length) {
      final end = dashed ? (p + 4).clamp(0.0, length).toDouble() : length;
      canvas.drawLine(
        axis == Axis.horizontal ? Offset(p, .5) : Offset(.5, p),
        axis == Axis.horizontal ? Offset(end, .5) : Offset(.5, end),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DividerPainter old) =>
      old.axis != axis || old.dashed != dashed || old.color != color;
}

class HySkeleton extends StatefulWidget {
  const HySkeleton({super.key, this.rows = 3, this.card = false});
  final int rows;
  final bool card;

  @override
  State<HySkeleton> createState() => _HySkeletonState();
}

class _HySkeletonState extends State<HySkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmer = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  bool _reduceMotion = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (_reduceMotion) {
      _shimmer
        ..stop()
        ..value = 0.5;
    } else if (!_shimmer.isAnimating) {
      _shimmer.repeat();
    }
  }

  @override
  void dispose() {
    _shimmer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    final glass = HyGlassTheme.of(context);
    Widget block(double height, {double? width}) => _SkeletonBlock(
      animation: _shimmer,
      height: height,
      width: width,
      color: Color.alphaBlend(glass.controlTrack, tokens.muted),
      highlight: glass.surfaceStrong,
    );
    return Semantics(
      label: '正在加载',
      child: HySpace(
        children: [
          if (widget.card) block(140),
          for (var i = 0; i < widget.rows; i++)
            Row(
              children: [
                block(40, width: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: HySpace(
                    spacing: 8,
                    children: [
                      block(14),
                      FractionallySizedBox(widthFactor: .6, child: block(12)),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _SkeletonBlock extends StatelessWidget {
  const _SkeletonBlock({
    required this.animation,
    required this.height,
    required this.color,
    required this.highlight,
    this.width,
  });
  final Animation<double> animation;
  final double height;
  final double? width;
  final Color color, highlight;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: animation,
    builder: (context, child) {
      final position = animation.value * 3 - 1.5;
      return ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (bounds) => LinearGradient(
          begin: Alignment(position - 1, 0),
          end: Alignment(position + 1, 0),
          colors: [color, highlight, color],
          stops: const [.2, .5, .8],
        ).createShader(bounds),
        child: child,
      );
    },
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
