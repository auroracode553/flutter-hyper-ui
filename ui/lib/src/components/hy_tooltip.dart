import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/hy_ui_theme_tokens.dart';
import 'hy_glass.dart';

/// 自绘玻璃提示：悬停、长按或键盘聚焦时显示。
class HyTooltip extends StatefulWidget {
  const HyTooltip({
    super.key,
    required this.message,
    required this.child,
    this.hoverDelay = const Duration(milliseconds: 500),
    this.maxWidth = 240,
  }) : assert(maxWidth > 0);

  final String message;
  final Widget child;
  final Duration hoverDelay;
  final double maxWidth;

  @override
  State<HyTooltip> createState() => _HyTooltipState();
}

class _HyTooltipState extends State<HyTooltip> {
  final OverlayPortalController _overlay = OverlayPortalController();
  final GlobalKey _anchorKey = GlobalKey();
  Timer? _hoverTimer;
  Offset _position = Offset.zero;
  double _availableWidth = 240;
  bool _showBelow = false;
  bool _hovering = false;
  bool _focused = false;
  bool _longPressed = false;

  void _show() {
    if (!mounted || widget.message.isEmpty) return;
    final box = _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final origin = box.localToGlobal(Offset.zero);
    final screen = MediaQuery.sizeOf(context);
    final maximumWidth = math.min(widget.maxWidth, math.max(24.0, screen.width - 24));
    final painter = TextPainter(
      text: TextSpan(text: widget.message, style: const TextStyle(fontSize: 12, height: 1.3)),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      textWidthBasis: TextWidthBasis.longestLine,
    )..layout(maxWidth: math.max(1.0, maximumWidth - 20));
    final width = math.min(maximumWidth, painter.width + 20);
    final tooltipHeight = painter.height + 14;
    painter.dispose();
    final left = (origin.dx + (box.size.width - width) / 2)
        .clamp(12.0, screen.width - width - 12)
        .toDouble();
    final below = origin.dy < tooltipHeight + 8;
    final top = below ? origin.dy + box.size.height + 8 : origin.dy - 8;
    setState(() {
      _position = Offset(left, top);
      _availableWidth = width;
      _showBelow = below;
    });
    _overlay.show();
  }

  void _hideIfInactive() {
    if (!_hovering && !_focused && !_longPressed) _overlay.hide();
  }

  void _cancelHover() {
    _hoverTimer?.cancel();
    _hoverTimer = null;
  }

  @override
  void dispose() {
    _cancelHover();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant HyTooltip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.message.isEmpty && oldWidget.message.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _overlay.hide();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    return OverlayPortal(
      controller: _overlay,
      overlayChildBuilder: (context) => Positioned(
        left: _position.dx,
        top: _position.dy,
        child: IgnorePointer(
          child: FractionalTranslation(
            translation: Offset(0, _showBelow ? 0 : -1),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: _availableWidth),
              child: HyGlass(
                radius: 12,
                blur: 18,
                weight: HyGlassWeight.prominent,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                child: Text(
                  widget.message,
                  style: TextStyle(
                    color: tokens.foreground,
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      child: Semantics(
        hint: widget.message,
        child: Focus(
          onFocusChange: (focused) {
            _focused = focused;
            if (focused) {
              _show();
            } else {
              _hideIfInactive();
            }
          },
          child: MouseRegion(
            onEnter: (_) {
              _hovering = true;
              _cancelHover();
              _hoverTimer = Timer(widget.hoverDelay, _show);
            },
            onExit: (_) {
              _hovering = false;
              _cancelHover();
              _hideIfInactive();
            },
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onLongPressStart: (_) {
                _longPressed = true;
                _show();
              },
              onLongPressEnd: (_) {
                _longPressed = false;
                _hideIfInactive();
              },
              child: KeyedSubtree(key: _anchorKey, child: widget.child),
            ),
          ),
        ),
      ),
    );
  }
}
