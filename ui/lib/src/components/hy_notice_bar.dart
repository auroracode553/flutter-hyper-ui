import 'package:flutter/material.dart';
import '../theme/hy_ui_theme_tokens.dart';
import 'hy_glass.dart';

/// 短文本静止；长文本匀速滚动，触摸按住或减少动画时停止。
class HyNoticeBar extends StatefulWidget {
  const HyNoticeBar({super.key, required this.message, this.onTap, this.onClose,
    this.speed = 28}) : assert(speed > 0);
  final String message;
  final VoidCallback? onTap, onClose;
  final double speed;
  @override
  State<HyNoticeBar> createState() => _HyNoticeBarState();
}

class _HyNoticeBarState extends State<HyNoticeBar> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this);
  double _distance = 0;
  bool _paused = false;
  bool? _lastReduced;
  double? _lastSpeed;
  void _configure(double distance, bool reduce) {
    if (_distance == distance && _lastReduced == reduce && _lastSpeed == widget.speed &&
        (_controller.isAnimating || _paused || reduce || distance == 0)) return;
    _lastReduced = reduce;
    _lastSpeed = widget.speed;
    _distance = distance;
    _controller.stop();
    if (reduce || distance == 0) { _controller.value = 0; return; }
    _controller.duration = Duration(milliseconds: (distance / widget.speed * 1000).round().clamp(1, 3600000).toInt());
    if (!_paused) _controller.repeat();
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    final reduce = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final style = TextStyle(fontSize: 14, color: tokens.primary);
    return HyGlass(radius: 16, blur: 0, color: tokens.selectionBackground,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(children: [Icon(Icons.campaign_outlined, color: tokens.primary),
        const SizedBox(width: 10), Expanded(child: LayoutBuilder(builder: (context, constraints) {
          final painter = TextPainter(text: TextSpan(text: widget.message, style: style),
            textDirection: Directionality.of(context), textScaler: MediaQuery.textScalerOf(context))..layout();
          final textWidth = painter.width;
          final height = painter.height;
          painter.dispose();
          final distance = textWidth > constraints.maxWidth ? textWidth + 48 : 0.0;
          WidgetsBinding.instance.addPostFrameCallback((_) { if (mounted) _configure(distance, reduce); });
          if (reduce) return Text(widget.message, style: style);
          return Semantics(label: widget.message, child: ExcludeSemantics(child: GestureDetector(
            onTap: widget.onTap,
            onTapDown: (_) { _paused = true; _controller.stop(); },
            onTapUp: (_) { _paused = false; _configure(distance, reduce); },
            onTapCancel: () { _paused = false; _configure(distance, reduce); },
            child: ClipRect(child: SizedBox(height: height, child: AnimatedBuilder(
              animation: _controller, builder: (_, __) => Stack(children: [
                for (var i = 0; i < (distance > 0 ? 2 : 1); i++) Positioned(
                  left: i * distance - _controller.value * distance, width: textWidth + 1,
                  child: Text(widget.message, style: style, maxLines: 1)),
              ])))))));
        })),
        if (widget.onClose != null) IconButton(tooltip: '关闭公告', onPressed: widget.onClose,
          icon: const Icon(Icons.close, size: 18)),
      ]));
  }
}
