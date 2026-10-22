part of 'hyper_drawer.dart';

/// hyper_drawer.dart 的内部路由内容：布局、滑动关闭和独立遮罩。
class _DrawerSurface extends StatefulWidget {
  const _DrawerSurface({
    required this.animation,
    required this.placement,
    required this.width,
    required this.contentPadding,
    required this.scrollable,
    required this.dismissOnClickOutside,
    required this.dismissOnBackPress,
    required this.gesturesEnabled,
    required this.contentBuilder,
    this.title,
    this.footerBuilder,
  });

  final Animation<double> animation;
  final HyperDrawerPlacement placement;
  final double width;
  final EdgeInsetsGeometry contentPadding;
  final bool scrollable,
      dismissOnClickOutside,
      dismissOnBackPress,
      gesturesEnabled;
  final String? title;
  final WidgetBuilder contentBuilder;
  final WidgetBuilder? footerBuilder;

  @override
  State<_DrawerSurface> createState() => _DrawerSurfaceState();
}

class _DrawerSurfaceState extends State<_DrawerSurface>
    with SingleTickerProviderStateMixin {
  late final AnimationController _drag = AnimationController.unbounded(
    vsync: this,
  );

  void _close() {
    if (widget.animation.status != AnimationStatus.reverse)
      Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _drag.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    final isLeft =
        (widget.placement == HyperDrawerPlacement.start) ==
        (Directionality.of(context) == TextDirection.ltr);
    final sign = isLeft ? -1.0 : 1.0;
    final animation = widget.animation.drive(
      CurveTween(curve: HyperUiEffects.overlayCurve),
    );
    return PopScope(
      canPop: widget.dismissOnBackPress,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // 常规窄屏保留遮罩点击区；显式宽度仍受可用窗口约束。
          final width = math.min(
            widget.width,
            math.max(0.0, constraints.maxWidth - 56),
          );
          final body = HyperSurfaceScope(
            child: ColoredBox(
              color: tokens.card,
              child: Padding(
                padding: MediaQuery.viewInsetsOf(context),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (widget.title != null)
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                            16,
                            8,
                            8,
                            8,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.title!,
                                  style: TextStyle(
                                    color: tokens.foreground,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              HyperButton(
                                type: 'icon',
                                icon: LucideIcons.x,
                                tooltip: '关闭',
                                onPressed: _close,
                              ),
                            ],
                          ),
                        ),
                      Expanded(
                        child: widget.scrollable
                            ? SingleChildScrollView(
                                padding: widget.contentPadding,
                                child: widget.contentBuilder(context),
                              )
                            : Padding(
                                padding: widget.contentPadding,
                                child: widget.contentBuilder(context),
                              ),
                      ),
                      if (widget.footerBuilder != null) ...[
                        const HyperDivider(),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: widget.footerBuilder!(context),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
          return AnimatedBuilder(
            animation: Listenable.merge([animation, _drag]),
            child: body,
            builder: (context, child) {
              final drag = _drag.value.clamp(0.0, width).toDouble();
              final visibility = width == 0
                  ? 0.0
                  : animation.value * (1 - drag / width);
              return Stack(
                children: [
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: widget.dismissOnClickOutside ? _close : null,
                      child: ColoredBox(
                        color: HyperGlassTheme.of(context).scrim.withValues(
                          alpha:
                              HyperGlassTheme.of(context).scrim.a * visibility,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: isLeft
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Transform.translate(
                      offset: Offset(
                        sign * (width * (1 - animation.value) + drag),
                        0,
                      ),
                      child: SizedBox(
                        width: width,
                        height: constraints.maxHeight,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onHorizontalDragStart: widget.gesturesEnabled
                              ? (_) => _drag.stop()
                              : null,
                          onHorizontalDragUpdate: widget.gesturesEnabled
                              ? (details) {
                                  _drag.value =
                                      (_drag.value + details.delta.dx * sign)
                                          .clamp(0.0, width);
                                }
                              : null,
                          onHorizontalDragCancel: widget.gesturesEnabled
                              ? _resetDrag
                              : null,
                          onHorizontalDragEnd: widget.gesturesEnabled
                              ? (details) {
                                  if (_drag.value >= width * .3 ||
                                      details.velocity.pixelsPerSecond.dx *
                                              sign >=
                                          400) {
                                    _close();
                                  } else {
                                    _resetDrag();
                                  }
                                }
                              : null,
                          child: AbsorbPointer(
                            absorbing:
                                widget.animation.status ==
                                AnimationStatus.reverse,
                            child: child!,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  void _resetDrag() {
    _drag.animateTo(
      0,
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 180),
      curve: HyperUiEffects.overlayCurve,
    );
  }
}
