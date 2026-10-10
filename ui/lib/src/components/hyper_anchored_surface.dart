import 'package:flutter/widgets.dart';

import '../theme/hyper_ui_effects.dart';
import '../utils/hyper_overlay_motion.dart';
import 'hyper_glass.dart';
import 'hyper_anchored_layout.dart';

/// Controls a Hyper anchored surface without a platform menu widget.
class HyperMenuController {
  HyperMenuController(this._setOpen, this._isOpen);

  final void Function(bool) _setOpen;
  final bool Function() _isOpen;

  bool get isOpen => _isOpen();
  void open() => _setOpen(true);
  void close() => _setOpen(false);
}

class _HyperMenuScope extends InheritedWidget {
  const _HyperMenuScope({required this.controller, required super.child});

  final HyperMenuController controller;

  static HyperMenuController? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_HyperMenuScope>()?.controller;

  @override
  bool updateShouldNotify(_HyperMenuScope oldWidget) =>
      controller != oldWidget.controller;
}

HyperMenuController? hyperMenuOf(BuildContext context) =>
    _HyperMenuScope.maybeOf(context);

/// An anchored glass surface shared by dropdowns and popovers.
Widget buildHyAnchoredSurface({
  required double width,
  required double maxHeight,
  required EdgeInsetsGeometry padding,
  required WidgetBuilder contentBuilder,
  required Widget Function(BuildContext, HyperMenuController) triggerBuilder,
}) => _HyperAnchoredSurface(
  width: width,
  maxHeight: maxHeight,
  padding: padding,
  contentBuilder: contentBuilder,
  triggerBuilder: triggerBuilder,
);

class _HyperAnchoredSurface extends StatefulWidget {
  const _HyperAnchoredSurface({
    required this.width,
    required this.maxHeight,
    required this.padding,
    required this.contentBuilder,
    required this.triggerBuilder,
  });

  final double width;
  final double maxHeight;
  final EdgeInsetsGeometry padding;
  final WidgetBuilder contentBuilder;
  final Widget Function(BuildContext, HyperMenuController) triggerBuilder;

  @override
  State<_HyperAnchoredSurface> createState() => _HyperAnchoredSurfaceState();
}

class _HyperAnchoredSurfaceState extends State<_HyperAnchoredSurface>
    with SingleTickerProviderStateMixin {
  final GlobalKey _anchorKey = GlobalKey();
  final OverlayPortalController _portal = OverlayPortalController();
  late final HyperOverlayMotion _motion = HyperOverlayMotion(
    vsync: this,
    onShow: _portal.show,
    onHide: _portal.hide,
    duration: HyperUiEffects.menuDuration,
  );
  Alignment _origin = Alignment.topCenter;
  late final HyperMenuController _controller = HyperMenuController(
    _setOpen,
    () => _motion.isOpen,
  );

  void _setOpen(bool open) {
    if (!mounted) return;
    if (open == _motion.isOpen) return;
    _motion.setOpen(open);
    setState(() {});
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
    _motion.dispose();
    super.dispose();
  }

  Rect _anchorRect(BuildContext overlayContext) {
    final anchor = _anchorKey.currentContext?.findRenderObject();
    final overlay = Overlay.of(overlayContext).context.findRenderObject();
    if (anchor is! RenderBox || overlay is! RenderBox || !anchor.hasSize) {
      return Rect.zero;
    }
    return anchor.localToGlobal(Offset.zero, ancestor: overlay) & anchor.size;
  }

  @override
  Widget build(BuildContext context) => OverlayPortal(
    controller: _portal,
    overlayChildBuilder: (overlayContext) => Stack(
      children: <Widget>[
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _controller.close,
          ),
        ),
        Positioned.fill(
          child: CustomSingleChildLayout(
            delegate: HyperAnchoredLayout(
              anchor: _anchorRect(overlayContext),
              insets: EdgeInsets.fromLTRB(
                MediaQuery.paddingOf(overlayContext).left + 12,
                MediaQuery.paddingOf(overlayContext).top + 12,
                MediaQuery.paddingOf(overlayContext).right + 12,
                MediaQuery.paddingOf(overlayContext).bottom +
                    MediaQuery.viewInsetsOf(overlayContext).bottom +
                    12,
              ),
              width: widget.width,
              maxHeight: widget.maxHeight,
              onPositioned: (origin) => _origin = origin,
            ),
            child: IgnorePointer(
              ignoring: !_motion.isOpen,
              child: buildHySurfaceTransition(
                animation: _motion.animation,
                origin: () => _origin,
                child: ExcludeFocus(
                  excluding: !_motion.isOpen,
                  child: _HyperMenuScope(
                    controller: _controller,
                    child: SizedBox(
                      width: widget.width,
                      child: HyperGlass(
                        radius: 18,
                        type: 'prominent',
                        padding: widget.padding,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: widget.maxHeight,
                          ),
                          child: SingleChildScrollView(
                            child: Builder(builder: widget.contentBuilder),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
    child: SizedBox(
      key: _anchorKey,
      child: Builder(
        builder: (anchorContext) =>
            widget.triggerBuilder(anchorContext, _controller),
      ),
    ),
  );
}
