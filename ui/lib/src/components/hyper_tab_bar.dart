import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import '../theme/hyper_glass_theme.dart';
import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_badge.dart';
import 'hyper_glass.dart';
import 'hyper_pressable.dart';

/// 底栏中的导航项；页面与图标含义由调用方决定。
class HyperTabItem {
  const HyperTabItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

/// 内容收缩的悬浮导航。点击和横向拖动共用一个选择出口。
class HyperTabBar extends StatefulWidget {
  const HyperTabBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    this.type = 'multiple',
    this.badgeCount = 0,
    this.safeArea = true,
    EdgeInsetsGeometry? margin,
    this.color,
  }) : assert(type == 'multiple' || type == 'single'),
       assert(type == 'single' ? items.length == 1 : items.length >= 2),
       assert(selectedIndex >= 0 && selectedIndex < items.length),
       margin =
           margin ??
           (type == 'single'
               ? EdgeInsets.zero
               : const EdgeInsets.fromLTRB(20, 8, 20, 0));

  static const double height = 56;
  final List<HyperTabItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final String type;
  final int badgeCount;
  final bool safeArea;
  final Color? color;
  final EdgeInsetsGeometry margin;

  @override
  State<HyperTabBar> createState() => _HyperTabBarState();
}

class _HyperTabBarState extends State<HyperTabBar> {
  static const double _inset = 4;
  int? _dragIndex;

  bool get _rtl => Directionality.of(context) == TextDirection.rtl;
  int _visual(int logical) =>
      _rtl ? widget.items.length - logical - 1 : logical;
  int _logical(int visual) => _rtl ? widget.items.length - visual - 1 : visual;

  void _select(int index) {
    if (index == widget.selectedIndex) return;
    HapticFeedback.selectionClick();
    widget.onSelected(index);
  }

  void _drag(double x, double width) {
    final index = ((x - _inset) / (width - 2 * _inset) * widget.items.length)
        .floor()
        .clamp(0, widget.items.length - 1);
    if (_dragIndex != index) setState(() => _dragIndex = index);
  }

  @override
  void didUpdateWidget(covariant HyperTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items.length != widget.items.length) _dragIndex = null;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    final glass = HyperGlassTheme.of(context);
    final activeColor = widget.color ?? tokens.primary;
    Widget bar;
    if (widget.type == 'single') {
      bar = HyperBadge(
        type: 'count',
        count: widget.badgeCount,
        child: HyperPressable(
          borderRadius: BorderRadius.circular(height / 2),
          onPressed: () => widget.onSelected(0),
          child: HyperGlass(
            radius: height / 2,
            child: SizedBox.square(
              dimension: height,
              child: Icon(
                widget.items.single.icon,
                size: 22,
                color: activeColor,
              ),
            ),
          ),
        ),
      );
    } else {
      var itemWidth = 76.0;
      for (final item in widget.items) {
        final label = TextPainter(
          text: TextSpan(
            text: item.label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
        )..layout();
        itemWidth = math.max(itemWidth, label.width + 32);
        label.dispose();
      }
      final barHeight = math.max(
        height,
        MediaQuery.textScalerOf(context).scale(12) * 1.08 + 36,
      );
      bar = SizedBox(
        width: itemWidth * widget.items.length + 2 * _inset,
        height: barHeight,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            if (!width.isFinite ||
                width <= 2 * _inset + widget.items.length * 2) {
              return const SizedBox.shrink();
            }
            final cellWidth = (width - 2 * _inset) / widget.items.length;
            final selected = _dragIndex ?? _visual(widget.selectedIndex);
            return RepaintBoundary(
              child: GestureDetector(
                onHorizontalDragStart: (details) =>
                    _drag(details.localPosition.dx, width),
                onHorizontalDragUpdate: (details) =>
                    _drag(details.localPosition.dx, width),
                onHorizontalDragCancel: () => setState(() => _dragIndex = null),
                onHorizontalDragEnd: (_) {
                  final index = _dragIndex;
                  setState(() => _dragIndex = null);
                  if (index != null) _select(_logical(index));
                },
                child: HyperGlass(
                  radius: barHeight / 2,
                  type: 'prominent',
                  child: Stack(
                    children: [
                      // 只移动一个选中块，不再逐帧重建文字或执行矩阵折射滤镜。
                      AnimatedPositioned(
                        duration: MediaQuery.disableAnimationsOf(context)
                            ? Duration.zero
                            : const Duration(milliseconds: 160),
                        curve: Curves.easeOutCubic,
                        left: _inset + selected * cellWidth + 1,
                        top: _inset,
                        width: cellWidth - 2,
                        height: barHeight - 2 * _inset,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: glass.selection,
                            borderRadius: BorderRadius.circular(barHeight / 2),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        left: _inset,
                        right: _inset,
                        child: Row(
                          textDirection: TextDirection.ltr,
                          children: [
                            for (
                              var index = 0;
                              index < widget.items.length;
                              index++
                            )
                              Expanded(
                                child: HyperPressable(
                                  pressedScale: 1,
                                  borderRadius: BorderRadius.circular(
                                    barHeight / 2,
                                  ),
                                  onPressed: () => _select(_logical(index)),
                                  child: _TabLabel(
                                    item: widget.items[_logical(index)],
                                    selected: index == selected,
                                    color: index == selected
                                        ? activeColor
                                        : tokens.foreground,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
    bar = Padding(padding: widget.margin, child: bar);
    return widget.safeArea ? SafeArea(top: false, child: bar) : bar;
  }

  static const double height = HyperTabBar.height;
}

class _TabLabel extends StatelessWidget {
  const _TabLabel({
    required this.item,
    required this.selected,
    required this.color,
  });
  final HyperTabItem item;
  final bool selected;
  final Color color;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(item.icon, color: color, size: 23),
      const SizedBox(height: 1),
      Text(
        item.label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 12,
          height: 1.08,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    ],
  );
}
