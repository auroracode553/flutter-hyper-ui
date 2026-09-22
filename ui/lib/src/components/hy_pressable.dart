import 'package:flutter/material.dart';

import '../theme/hy_ui_effects.dart';

/// 为触控组件提供统一的即时按压反馈。
///
/// 按下时立即响应，松开与取消时从当前展示状态恢复。组件只处理交互状态，
/// 不决定颜色或业务行为，因此可安全复用于按钮、菜单行与卡片。
class HyPressable extends StatefulWidget {
  const HyPressable({
    super.key,
    required this.child,
    this.onPressed,
    this.enabled = true,
    this.pressedScale = 0.975,
    this.pressedOpacity = 0.92,
    this.borderRadius,
    this.semanticLabel,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final bool enabled;
  final double pressedScale;
  final double pressedOpacity;
  final BorderRadiusGeometry? borderRadius;
  final String? semanticLabel;

  @override
  State<HyPressable> createState() => _HyPressableState();
}

class _HyPressableState extends State<HyPressable> {
  bool _pressed = false;

  bool get _interactive => widget.enabled && widget.onPressed != null;

  void _setPressed(bool value) {
    if (_pressed == value || !mounted) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final duration = reduceMotion
        ? Duration.zero
        : (_pressed
              ? HyUiEffects.pressInDuration
              : HyUiEffects.pressOutDuration);

    return Semantics(
      button: widget.onPressed != null,
      enabled: _interactive,
      label: widget.semanticLabel,
      child: MouseRegion(
        cursor: _interactive
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: _interactive ? (_) => _setPressed(true) : null,
          onTapUp: _interactive ? (_) => _setPressed(false) : null,
          onTapCancel: _interactive ? () => _setPressed(false) : null,
          onTap: _interactive ? widget.onPressed : null,
          child: AnimatedScale(
            scale: _pressed ? widget.pressedScale : 1,
            duration: duration,
            curve: Curves.easeOutCubic,
            child: AnimatedOpacity(
              opacity: _pressed ? widget.pressedOpacity : 1,
              duration: duration,
              curve: Curves.easeOutCubic,
              child: ClipRRect(
                borderRadius: widget.borderRadius ?? BorderRadius.zero,
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
