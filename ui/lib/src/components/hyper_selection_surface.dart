import 'package:flutter/widgets.dart';
import '../theme/hyper_surface_theme.dart';
import '../theme/hyper_ui_effects.dart';
import '../theme/hyper_ui_theme.dart';
import 'hyper_control_surface.dart';

/// 选择标记的内部玻璃与动画边界；尺寸、点击与受控值仍由选择组件管理。
class HyperSelectionSurface extends StatelessWidget {
  const HyperSelectionSurface({
    super.key,
    required this.enabled,
    required this.radius,
    required this.borderColor,
    required this.borderWidth,
    required this.child,
    this.color,
  });
  final bool enabled;
  final double radius, borderWidth;
  final Color borderColor;
  final Color? color;
  final Widget child;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<Border?>(
    tween: BorderTween(
      end: Border.all(color: borderColor, width: borderWidth),
    ),
    duration: HyperUiEffects.durationOf(context, HyperUiEffects.stateDuration),
    curve: HyperUiEffects.selectionCurve,
    builder: (context, border, _) => TweenAnimationBuilder<Color?>(
      tween: ColorTween(
        end:
            color ??
            (enabled
                ? Color.fromRGBO(
                    255,
                    255,
                    255,
                    HyperUiTheme.of(context).brightness == Brightness.light
                        ? 0.4
                        : 0.136,
                  )
                : HyperSurfaceTheme.of(context).controlTrack),
      ),
      duration: HyperUiEffects.durationOf(
        context,
        HyperUiEffects.stateDuration,
      ),
      curve: HyperUiEffects.selectionCurve,
      builder: (context, fill, _) => enabled
          ? HyperControlSurface(
              radius: radius,
              role: HyperControlSurfaceRole.compact,
              color: fill,
              border: border,
              child: child,
            )
          : DecoratedBox(
              decoration: BoxDecoration(
                color: fill,
                borderRadius: BorderRadius.circular(radius),
                border: border,
              ),
              child: child,
            ),
    ),
  );
}
