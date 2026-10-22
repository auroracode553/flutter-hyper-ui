part of 'hyper_nav_bar.dart';

/// 模糊和底色在导航自身范围内渐隐，底边之外不参与绘制。
class _NavBarScrollSurface extends StatelessWidget {
  const _NavBarScrollSurface({
    required this.scrolledUnder,
    required this.child,
  });

  final bool scrolledUnder;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.maybeOf(context);
    final tokens = HyperUiThemeTokens.of(context);
    final highContrast = media?.highContrast ?? false;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: scrolledUnder ? 1 : 0),
      duration: media?.disableAnimations == true
          ? Duration.zero
          : HyperUiEffects.stateDuration,
      curve: Curves.easeOutCubic,
      child: child,
      builder: (context, progress, child) => Stack(
        fit: StackFit.passthrough,
        clipBehavior: Clip.none,
        children: [
          if (progress > 0)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: IgnorePointer(
                child: ClipRect(
                  child: highContrast
                      ? ColoredBox(
                          color: tokens.background.withValues(alpha: progress),
                        )
                      : _NavBarFadingBackdrop(
                          color: tokens.background,
                          progress: progress,
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

class _NavBarFadingBackdrop extends StatelessWidget {
  const _NavBarFadingBackdrop({required this.color, required this.progress});

  final Color color;
  final double progress;

  @override
  Widget build(BuildContext context) => ShaderMask(
    // Fade the complete background layer, rather than only its tint.
    blendMode: BlendMode.dstIn,
    shaderCallback: (bounds) => LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: const [0, 0.6, 0.78, 0.92, 1],
      colors: [
        for (final opacity in const [1.0, 1.0, 0.8, 0.3, 0.0])
          const Color.fromRGBO(
            255,
            255,
            255,
            1,
          ).withValues(alpha: opacity * progress),
      ],
    ).createShader(bounds),
    child: BackdropFilter(
      blendMode: BlendMode.src,
      filter: ImageFilter.blur(sigmaX: 20 * progress, sigmaY: 20 * progress),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0, 0.55, 0.78, 1],
            colors: [
              for (final opacity in const [0.96, 0.94, 0.74, 0.0])
                color.withValues(alpha: opacity),
            ],
          ),
        ),
      ),
    ),
  );
}
