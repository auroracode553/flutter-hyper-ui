import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import '../theme/hy_glass_theme.dart';
import '../theme/hy_ui_effects.dart';
import '../theme/hy_ui_theme_tokens.dart';
import 'hy_glass.dart';

@immutable
class HySlideAction {
  const HySlideAction({
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
    this.foregroundColor,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? color;
  final Color? foregroundColor;
}

/// 可跟手拖拽的列表侧滑菜单。
///
/// [startActions] 与 [endActions] 使用逻辑方向，因此在 RTL 环境中会自动镜像。
/// 释放时依据当前位置和速度投影决定展开或闭合，并在边界提供渐进阻力。
class HySlideMenu extends StatefulWidget {
  const HySlideMenu({
    super.key,
    required this.child,
    this.startActions = const <HySlideAction>[],
    this.endActions = const <HySlideAction>[],
    this.actionExtent = 64,
    this.radius = 18,
    this.enabled = true,
    this.decorateChild = true,
  }) : assert(actionExtent > 0),
       assert(startActions.length + endActions.length > 0);

  final Widget child;
  final List<HySlideAction> startActions;
  final List<HySlideAction> endActions;
  final double actionExtent;
  final double radius;
  final bool enabled;
  final bool decorateChild;

  @override
  State<HySlideMenu> createState() => _HySlideMenuState();
}

class _HySlideMenuState extends State<HySlideMenu>
    with SingleTickerProviderStateMixin {
  static const double _projectionSeconds = 0.09;
  late final AnimationController _offset;
  bool _reduceMotion = false;

  double get _startExtent => widget.startActions.length * widget.actionExtent;
  double get _endExtent => widget.endActions.length * widget.actionExtent;

  @override
  void initState() {
    super.initState();
    _offset = AnimationController.unbounded(vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
  }

  @override
  void dispose() {
    _offset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final direction = Directionality.of(context);
    final directionFactor = direction == TextDirection.rtl ? -1.0 : 1.0;
    final radius = BorderRadius.circular(widget.radius);
    final tokens = HyUiThemeTokens.of(context);

    return ClipRRect(
      borderRadius: radius,
      child: AnimatedBuilder(
        animation: _offset,
        builder: (context, _) {
          final opened = _offset.value.abs() > 1;
          return Stack(
            children: <Widget>[
              Positioned.fill(
                child: ColoredBox(
                  color: HyGlassTheme.of(context).controlTrack,
                  child: Stack(
                    children: <Widget>[
                      if (widget.startActions.isNotEmpty)
                        PositionedDirectional(
                          start: 0,
                          top: 0,
                          bottom: 0,
                          child: ExcludeSemantics(
                            excluding: _offset.value <= 1,
                            child: _ActionStrip(
                              actions: widget.startActions,
                              extent: widget.actionExtent,
                              fallbackColor: tokens.primary,
                              onSelected: _runAction,
                            ),
                          ),
                        ),
                      if (widget.endActions.isNotEmpty)
                        PositionedDirectional(
                          end: 0,
                          top: 0,
                          bottom: 0,
                          child: ExcludeSemantics(
                            excluding: _offset.value >= -1,
                            child: _ActionStrip(
                              actions: widget.endActions,
                              extent: widget.actionExtent,
                              fallbackColor: tokens.error,
                              onSelected: _runAction,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(_offset.value * directionFactor, 0),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: opened ? _close : null,
                  onHorizontalDragStart: widget.enabled
                      ? (_) => _offset.stop()
                      : null,
                  onHorizontalDragUpdate: widget.enabled
                      ? (details) => _dragBy(details.delta.dx * directionFactor)
                      : null,
                  onHorizontalDragEnd: widget.enabled
                      ? (details) => _release(
                          details.velocity.pixelsPerSecond.dx * directionFactor,
                        )
                      : null,
                  onHorizontalDragCancel: widget.enabled ? _close : null,
                  child: AbsorbPointer(
                    absorbing: opened,
                    child: widget.decorateChild
                        ? HyGlass(
                            radius: widget.radius,
                            blur: 14,
                            weight: HyGlassWeight.regular,
                            child: widget.child,
                          )
                        : widget.child,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _dragBy(double delta) {
    var next = _offset.value + delta;
    if (next > _startExtent) {
      next = _startExtent + _rubberBand(next - _startExtent);
    } else if (next < -_endExtent) {
      next = -_endExtent - _rubberBand(-_endExtent - next);
    }
    if (_startExtent == 0 && next > 0) next = _rubberBand(next);
    if (_endExtent == 0 && next < 0) next = -_rubberBand(-next);
    _offset.value = next;
  }

  double _rubberBand(double overshoot) {
    final dimension = math.max(widget.actionExtent, 1);
    const resistance = 0.32;
    return (overshoot * dimension * resistance) /
        (dimension + resistance * overshoot.abs());
  }

  void _release(double velocity) {
    final projected = _offset.value + velocity * _projectionSeconds;
    var target = 0.0;
    if (_startExtent > 0 && projected > _startExtent * 0.35) {
      target = _startExtent;
    } else if (_endExtent > 0 && projected < -_endExtent * 0.35) {
      target = -_endExtent;
    }
    _settle(target, velocity: velocity);
  }

  void _close() => _settle(0);

  void _runAction(HySlideAction action) {
    _close();
    action.onPressed();
  }

  void _settle(double target, {double velocity = 0}) {
    if (_reduceMotion) {
      _offset.value = target;
      return;
    }
    _offset.animateWith(
      SpringSimulation(
        HyUiEffects.settleSpring,
        _offset.value,
        target,
        velocity,
      ),
    );
  }
}

class _ActionStrip extends StatelessWidget {
  const _ActionStrip({
    required this.actions,
    required this.extent,
    required this.fallbackColor,
    required this.onSelected,
  });

  final List<HySlideAction> actions;
  final double extent;
  final Color fallbackColor;
  final ValueChanged<HySlideAction> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (final action in actions)
          SizedBox(
            width: extent,
            height: double.infinity,
            child: Container(
              color: action.color ?? fallbackColor,
              child: GestureDetector(
                onTap: () => onSelected(action),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (action.icon != null) ...<Widget>[
                        Icon(
                          action.icon,
                          size: 18,
                          color: action.foregroundColor ?? Colors.white,
                        ),
                        const SizedBox(height: 4),
                      ],
                      Text(
                        action.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: action.foregroundColor ?? Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
