part of 'hyper_scroll_gradient.dart';

/// 仅绘制主题渐变，不录制或采样正文；背景层透传手势，前景保持清晰。
class _ScrollGradientSurface extends StatelessWidget {
  const _ScrollGradientSurface({
    required this.scrolledUnder,
    required this.child,
  });

  final bool scrolledUnder;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.maybeOf(context);
    final color = HyperUiThemeTokens.of(context).background;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: scrolledUnder ? 1 : 0),
      duration: media?.disableAnimations == true
          ? Duration.zero
          : HyperUiEffects.stateDuration,
      curve: Curves.easeOutCubic,
      child: child,
      builder: (context, progress, child) => Stack(
        fit: StackFit.passthrough,
        children: [
          if (progress > 0)
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0, 0.55, 0.78, 1],
                      colors: [
                        for (final opacity in const [0.96, 0.94, 0.74, 0.0])
                          color.withValues(alpha: opacity * progress),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          child!,
        ],
      ),
    );
  }
}
