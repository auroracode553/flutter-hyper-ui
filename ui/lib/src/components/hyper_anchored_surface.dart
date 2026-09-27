import 'package:flutter/widgets.dart';

import 'hyper_glass.dart';

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

class _HyperAnchoredSurfaceState extends State<_HyperAnchoredSurface> {
  final LayerLink _layerLink = LayerLink();
  final OverlayPortalController _portal = OverlayPortalController();
  late final HyperMenuController _controller = HyperMenuController(
    _setOpen,
    () => _portal.isShowing,
  );

  void _setOpen(bool open) {
    if (open == _portal.isShowing) return;
    if (open) {
      _portal.show();
    } else {
      _portal.hide();
    }
    setState(() {});
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
        CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          targetAnchor: Alignment.bottomLeft,
          followerAnchor: Alignment.topLeft,
          offset: const Offset(0, 6),
          child: _HyperMenuScope(
            controller: _controller,
            child: SizedBox(
              width: widget.width,
              child: HyperGlass(
                radius: 18,
                blur: 28,
                weight: HyperGlassWeight.prominent,
                padding: widget.padding,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: widget.maxHeight),
                  child: SingleChildScrollView(
                    child: Builder(builder: widget.contentBuilder),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
    child: CompositedTransformTarget(
      link: _layerLink,
      child: Builder(
        builder: (anchorContext) =>
            widget.triggerBuilder(anchorContext, _controller),
      ),
    ),
  );
}
