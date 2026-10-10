import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;

import '../theme/hyper_ui_effects.dart';
import '../theme/hyper_ui_theme_tokens.dart';
import '../utils/hyper_overlay_motion.dart';
import 'hyper_glass.dart';

/// 自绘玻璃提示：悬停、长按或键盘聚焦时显示。
class HyperTooltip extends StatefulWidget {
  const HyperTooltip({
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
  State<HyperTooltip> createState() => _HyperTooltipState();
}

class _HyperTooltipState extends State<HyperTooltip>
    with SingleTickerProviderStateMixin {
  final OverlayPortalController _overlay = OverlayPortalController();
  late final HyperOverlayMotion _motion = HyperOverlayMotion(
    vsync: this,
    onShow: _overlay.show,
    onHide: _overlay.hide,
    duration: HyperUiEffects.tooltipDuration,
  );
  final GlobalKey _anchorKey = GlobalKey();
  Timer? _hoverTimer;
  Offset _position = Offset.zero;
  double _availableWidth = 240;
  bool _showBelow = false;
  bool _hovering = false;
  bool _focused = false;
  bool _longPressed = false;
  double _originX = 0;

  void _show({bool instant = false}) {
    if (!mounted || widget.message.isEmpty) return;
    final box = _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final origin = box.localToGlobal(Offset.zero);
    final screen = MediaQuery.sizeOf(context);
    final maximumWidth = math.min(
      widget.maxWidth,
      math.max(24.0, screen.width - 24),
    );
    final painter = TextPainter(
      text: TextSpan(
        text: widget.message,
        style: const TextStyle(fontSize: 12, height: 1.3),
      ),
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
      _originX = ((origin.dx + box.size.width / 2 - left) / width * 2 - 1)
          .clamp(-1.0, 1.0)
          .toDouble();
    });
    _motion.setOpen(true, instant: instant);
  }

  void _hideIfInactive() {
    if (!_hovering && !_focused && !_longPressed) _motion.close();
  }

  void _cancelHover() {
    _hoverTimer?.cancel();
    _hoverTimer = null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _motion.setReducedMotion(
      MediaQuery.maybeOf(context)?.disableAnimations ?? false,
    );
  }

  @override
  void dispose() {
    _cancelHover();
    _motion.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant HyperTooltip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.message.isEmpty && oldWidget.message.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _motion.close();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    return OverlayPortal(
      controller: _overlay,
      overlayChildBuilder: (context) => Positioned(
        left: _position.dx,
        top: _position.dy,
        child: IgnorePointer(
          child: FractionalTranslation(
            translation: Offset(0, _showBelow ? 0 : -1),
            child: buildHySurfaceTransition(
              animation: _motion.animation,
              beginScale: 0.97,
              origin: () => Alignment(_originX, _showBelow ? -1 : 1),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: _availableWidth),
                child: HyperGlass(
                  radius: 12,
                  type: 'prominent',
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
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
      ),
      child: Focus(
        onFocusChange: (focused) {
          _focused = focused;
          if (focused) {
            _show(instant: true);
          } else {
            _hideIfInactive();
          }
        },
        child: MouseRegion(
          onEnter: (event) {
            if (event.kind != PointerDeviceKind.mouse &&
                event.kind != PointerDeviceKind.stylus) {
              return;
            }
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
    );
  }
}
