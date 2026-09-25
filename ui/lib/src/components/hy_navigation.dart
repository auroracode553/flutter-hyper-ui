import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hy_glass_theme.dart';
import '../theme/hy_ui_effects.dart';
import '../theme/hy_ui_theme_tokens.dart';
import 'hy_glass.dart';
import 'hy_layout.dart';
import 'hy_pressable.dart';

class HyTabItem {
  const HyTabItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

/// 可点击、可拖拽选择的悬浮底部导航。
///
/// 指示胶囊与手指保持 1:1 跟随，释放时继承速度并吸附到最近菜单项；越界拖动
/// 使用渐进阻力。页面切换仍由业务层通过 [onSelected] 管理。
class HyTabBar extends StatefulWidget {
  const HyTabBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    this.safeArea = true,
    this.enableHaptics = true,
    this.margin = const EdgeInsets.fromLTRB(16, 8, 16, 10),
  }) : assert(items.length >= 2),
       assert(selectedIndex >= 0 && selectedIndex < items.length);

  static const double height = 50;

  final List<HyTabItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final bool safeArea;
  final bool enableHaptics;
  final EdgeInsetsGeometry margin;

  @override
  State<HyTabBar> createState() => _HyTabBarState();
}

class _HyTabBarState extends State<HyTabBar> with TickerProviderStateMixin {
  static const double _releaseProjectionSeconds = 0.09;

  late final AnimationController _position;
  late final AnimationController _pressDepth;
  late final Listenable _animations;
  VelocityTracker? _velocityTracker;
  int? _activePointer;
  int? _pendingSelection;
  double _grabOffsetX = 0;
  bool _reduceMotion = false;
  bool _rtl = false;

  @override
  void initState() {
    super.initState();
    _position = AnimationController.unbounded(
      value: widget.selectedIndex.toDouble(),
      vsync: this,
    );
    _pressDepth = AnimationController(
      duration: HyUiEffects.pressInDuration,
      reverseDuration: HyUiEffects.pressOutDuration,
      vsync: this,
    );
    _animations = Listenable.merge(<Listenable>[_position, _pressDepth]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final nextRtl = Directionality.of(context) == TextDirection.rtl;
    if (_rtl != nextRtl && _activePointer == null) {
      _rtl = nextRtl;
      _position.value = _visualIndex(widget.selectedIndex).toDouble();
    } else {
      _rtl = nextRtl;
    }
    if (_reduceMotion) {
      _position.value = _visualIndex(widget.selectedIndex).toDouble();
      _pressDepth.value = _activePointer == null ? 0 : 1;
    }
  }

  @override
  void didUpdateWidget(covariant HyTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex == widget.selectedIndex) return;
    final alreadySettlingThere = _pendingSelection == widget.selectedIndex;
    _pendingSelection = null;
    if (!alreadySettlingThere && _activePointer == null) {
      _settleAt(_visualIndex(widget.selectedIndex));
    }
  }

  @override
  void dispose() {
    _position.dispose();
    _pressDepth.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    final glass = HyGlassTheme.of(context);
    final textHeight = MediaQuery.textScalerOf(context).scale(11) * 1.1;
    final barHeight = math.max(HyTabBar.height, textHeight + 34);

    final bar = Padding(
      padding: widget.margin,
      child: SizedBox(
        height: barHeight,
        child: HyGlass(
          radius: barHeight / 2,
          blur: 22,
          weight: HyGlassWeight.prominent,
          padding: const EdgeInsets.all(3),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final barWidth = constraints.maxWidth;
              // 选中背景接近整格宽度，留出细小间隙，呼应日历底栏的浅灰圆角块。
              final pillWidth = math.min(
                112.0,
                (barWidth / widget.items.length) - 8,
              );
              return Listener(
                behavior: HitTestBehavior.opaque,
                onPointerDown: (event) =>
                    _handlePointerDown(event, barWidth, pillWidth),
                onPointerMove: (event) =>
                    _handlePointerMove(event, barWidth, pillWidth),
                onPointerUp: (event) =>
                    _handlePointerUp(event, barWidth, pillWidth),
                onPointerCancel: _handlePointerCancel,
                child: AnimatedBuilder(
                  animation: _animations,
                  builder: (context, _) {
                    final position = _position.value;
                    final pressDepth = Curves.easeOutCubic.transform(
                      _pressDepth.value,
                    );
                    return Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        _HyTabIndicator(
                          position: position,
                          itemCount: widget.items.length,
                          pressDepth: pressDepth,
                          pillWidth: pillWidth,
                          color: Color.lerp(
                            tokens.muted,
                            Color.alphaBlend(glass.pressed, tokens.muted),
                            pressDepth * 0.5,
                          )!,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          textDirection: TextDirection.ltr,
                          children: <Widget>[
                            for (
                              var visual = 0;
                              visual < widget.items.length;
                              visual++
                            )
                              SizedBox(
                                width: pillWidth,
                                child: _HyTabButton(
                                  item: widget.items[_logicalIndex(visual)],
                                  selected:
                                      widget.selectedIndex ==
                                      _logicalIndex(visual),
                                  selectionStrength:
                                      (1 - (position - visual).abs()).clamp(
                                        0.0,
                                        1.0,
                                      ),
                                  activeColor: tokens.foreground,
                                  inactiveColor: tokens.mutedForeground,
                                  onTap: () => _selectFromSemantics(visual),
                                ),
                              ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );

    return widget.safeArea
        ? SafeArea(top: false, minimum: EdgeInsets.zero, child: bar)
        : bar;
  }

  int _visualIndex(int logicalIndex) =>
      _rtl ? widget.items.length - logicalIndex - 1 : logicalIndex;

  int _logicalIndex(int visualIndex) =>
      _rtl ? widget.items.length - visualIndex - 1 : visualIndex;

  void _selectFromSemantics(int visualIndex) {
    final logicalIndex = _logicalIndex(visualIndex);
    _settleAt(visualIndex);
    if (logicalIndex != widget.selectedIndex && widget.enableHaptics) {
      HapticFeedback.selectionClick();
    }
    widget.onSelected(logicalIndex);
  }

  void _handlePointerDown(
    PointerDownEvent event,
    double barWidth,
    double pillWidth,
  ) {
    if (_activePointer != null || !barWidth.isFinite || barWidth <= 0) return;
    final visual = _nearestVisualIndex(
      event.localPosition.dx,
      barWidth,
      pillWidth,
    );
    final centerX =
        pillWidth / 2 + _step(barWidth, pillWidth) * visual.toDouble();
    _activePointer = event.pointer;
    _grabOffsetX = event.localPosition.dx - centerX;
    _velocityTracker = VelocityTracker.withKind(event.kind)
      ..addPosition(event.timeStamp, event.localPosition);
    _position.value = visual.toDouble();
    if (_reduceMotion) {
      _pressDepth.value = 1;
    } else {
      _pressDepth.forward();
    }
  }

  void _handlePointerMove(
    PointerMoveEvent event,
    double barWidth,
    double pillWidth,
  ) {
    if (_activePointer != event.pointer || barWidth <= 0) return;
    _velocityTracker?.addPosition(event.timeStamp, event.localPosition);
    final step = _step(barWidth, pillWidth);
    final firstCenter = pillWidth / 2;
    final desiredCenter = event.localPosition.dx - _grabOffsetX;
    final visualCenter = _applyHorizontalResistance(
      desiredCenter,
      firstCenter,
      firstCenter + step * (widget.items.length - 1),
      math.max(step, pillWidth),
    );
    _position.value = (visualCenter - firstCenter) / step;
  }

  void _handlePointerUp(
    PointerUpEvent event,
    double barWidth,
    double pillWidth,
  ) {
    if (_activePointer != event.pointer || barWidth <= 0) return;
    _velocityTracker?.addPosition(event.timeStamp, event.localPosition);
    final step = _step(barWidth, pillWidth);
    final velocityX = _velocityTracker?.getVelocity().pixelsPerSecond.dx ?? 0.0;
    final normalizedVelocity = velocityX / step;
    final projected =
        _position.value + normalizedVelocity * _releaseProjectionSeconds;
    final visualIndex = projected
        .round()
        .clamp(0, widget.items.length - 1)
        .toInt();
    final logicalIndex = _logicalIndex(visualIndex);

    _clearPointer();
    _releasePress();
    _settleAt(visualIndex, initialVelocity: normalizedVelocity);
    if (logicalIndex != widget.selectedIndex) {
      if (widget.enableHaptics) HapticFeedback.selectionClick();
      _pendingSelection = logicalIndex;
    }
    widget.onSelected(logicalIndex);
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    if (_activePointer != event.pointer) return;
    _clearPointer();
    _releasePress();
    _settleAt(_visualIndex(widget.selectedIndex));
  }

  void _clearPointer() {
    _activePointer = null;
    _velocityTracker = null;
    _grabOffsetX = 0;
  }

  void _releasePress() {
    if (_reduceMotion) {
      _pressDepth.value = 0;
    } else {
      _pressDepth.reverse();
    }
  }

  void _settleAt(int index, {double initialVelocity = 0}) {
    if (_reduceMotion) {
      _position.value = index.toDouble();
      return;
    }
    _position.animateWith(
      SpringSimulation(
        HyUiEffects.settleSpring,
        _position.value,
        index.toDouble(),
        initialVelocity,
      ),
    );
  }

  int _nearestVisualIndex(double x, double barWidth, double pillWidth) {
    final position = (x - pillWidth / 2) / _step(barWidth, pillWidth);
    return position.round().clamp(0, widget.items.length - 1).toInt();
  }

  double _step(double barWidth, double pillWidth) {
    return math.max(1, (barWidth - pillWidth) / (widget.items.length - 1));
  }

  static double _applyHorizontalResistance(
    double value,
    double minimum,
    double maximum,
    double dimension,
  ) {
    if (value < minimum) {
      return minimum - _rubberBand(minimum - value, dimension);
    }
    if (value > maximum) {
      return maximum + _rubberBand(value - maximum, dimension);
    }
    return value;
  }

  static double _rubberBand(double overshoot, double dimension) {
    const resistance = 0.32;
    return (overshoot * dimension * resistance) /
        (dimension + resistance * overshoot.abs());
  }
}

class _HyTabIndicator extends StatelessWidget {
  const _HyTabIndicator({
    required this.position,
    required this.itemCount,
    required this.pressDepth,
    required this.pillWidth,
    required this.color,
  });

  final double position;
  final int itemCount;
  final double pressDepth;
  final double pillWidth;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = pillWidth + 5 * pressDepth;
          // 内容区之外还有玻璃内边距；按压放大时也保留可见的四周留白。
          final height = constraints.maxHeight - 4 + 2 * pressDepth;
          final step = (constraints.maxWidth - pillWidth) / (itemCount - 1);
          final centerX = pillWidth / 2 + step * position;
          final left = (centerX - width / 2)
              .clamp(2.0, constraints.maxWidth - width - 2)
              .toDouble();
          return Stack(
            children: <Widget>[
              Positioned(
                left: left,
                top: (constraints.maxHeight - height) / 2,
                width: width,
                height: height,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(height / 2),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HyTabButton extends StatelessWidget {
  const _HyTabButton({
    required this.item,
    required this.selected,
    required this.selectionStrength,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  final HyTabItem item;
  final bool selected;
  final double selectionStrength;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = Color.lerp(
      inactiveColor,
      activeColor,
      selectionStrength,
    );
    return Semantics(
      selected: selected,
      button: true,
      label: item.label,
      onTap: onTap,
      child: ExcludeSemantics(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(item.icon, color: foreground, size: 20),
            const SizedBox(height: 2),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: foreground,
                fontSize: 11,
                height: 1.1,
                letterSpacing: 0.1,
                fontWeight: FontWeight.lerp(
                  FontWeight.w500,
                  FontWeight.w600,
                  selectionStrength,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 顶部或内容区使用的玻璃胶囊标签栏。
class HyTabs extends StatelessWidget implements PreferredSizeWidget {
  const HyTabs({
    super.key,
    required this.tabs,
    this.controller,
    this.scrollable = false,
    this.onTap,
  });

  final List<Widget> tabs;
  final TabController? controller;
  final bool scrollable;
  final ValueChanged<int>? onTap;

  @override
  Size get preferredSize => Size.fromHeight(_tabHeight + 6);

  double get _tabHeight {
    var height = 48.0;
    for (final tab in tabs) {
      if (tab is PreferredSizeWidget) {
        height = math.max(height, tab.preferredSize.height);
      }
    }
    return height;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    final tabController = controller ?? DefaultTabController.of(context);
    assert(tabController.length == tabs.length);
    final tabHeight = _tabHeight;
    if (tabs.isEmpty) {
      return HyGlass(
        radius: preferredSize.height / 2,
        weight: HyGlassWeight.subtle,
        child: SizedBox(height: tabHeight),
      );
    }
    return HyGlass(
      radius: preferredSize.height / 2,
      blur: 12,
      weight: HyGlassWeight.subtle,
      padding: const EdgeInsets.all(3),
      child: SizedBox(
        height: tabHeight,
        child: AnimatedBuilder(
          animation: tabController.animation ?? tabController,
          builder: (context, _) {
            final position = (tabController.animation?.value ??
                    tabController.index.toDouble())
                .clamp(0.0, (tabs.length - 1).toDouble());
            if (scrollable) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    for (var index = 0; index < tabs.length; index++)
                      _buildItem(
                        context,
                        tabController,
                        tokens,
                        index,
                        position,
                        tabHeight,
                        showSelection: true,
                      ),
                  ],
                ),
              );
            }
            return LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = constraints.maxWidth / tabs.length;
                return Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    // 指示器只画一次，跟随控制器位置，不叠加旧标签的背景。
                    Positioned(
                      left: itemWidth * position + 2,
                      top: 2,
                      width: math.max(0, itemWidth - 4),
                      height: tabHeight - 4,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: tokens.muted,
                          borderRadius: BorderRadius.circular(tabHeight / 2),
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        for (var index = 0; index < tabs.length; index++)
                          Expanded(
                            child: _buildItem(
                              context,
                              tabController,
                              tokens,
                              index,
                              position,
                              tabHeight,
                              showSelection: false,
                            ),
                          ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    TabController tabController,
    HyUiThemeTokens tokens,
    int index,
    double position,
    double tabHeight, {
    required bool showSelection,
  }) {
    final selected = tabController.index == index;
    final strength = (1 - (position - index).abs()).clamp(0.0, 1.0);
    final foreground = Color.lerp(
      tokens.mutedForeground,
      tokens.foreground,
      strength,
    )!;
    final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    void selectTab() {
      tabController.animateTo(
        index,
        duration: reduceMotion ? Duration.zero : null,
      );
      onTap?.call(index);
    }

    return FocusableActionDetector(
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
      },
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            selectTab();
            return null;
          },
        ),
      },
      child: Semantics(
        selected: selected,
        child: HyPressable(
          onPressed: selectTab,
          pressedScale: 0.985,
          borderRadius: BorderRadius.circular(tabHeight / 2),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: AnimatedContainer(
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 160),
              curve: Curves.easeOutCubic,
              height: tabHeight - 4,
              constraints: showSelection
                  ? const BoxConstraints(minWidth: 72)
                  : null,
              padding: EdgeInsets.symmetric(horizontal: showSelection ? 16 : 4),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: showSelection && selected
                    ? tokens.muted
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(tabHeight / 2),
              ),
              child: DefaultTextStyle.merge(
                style: TextStyle(
                  color: foreground,
                  fontWeight: FontWeight.lerp(
                    FontWeight.w500,
                    FontWeight.w600,
                    strength,
                  ),
                ),
                child: IconTheme.merge(
                  data: IconThemeData(color: foreground),
                  child: _tabContent(tabs[index]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tabContent(Widget tab) {
    if (tab is! Tab) return tab;
    final label = tab.child ??
        (tab.text == null
            ? null
            : Text(tab.text!, maxLines: 1, overflow: TextOverflow.ellipsis));
    if (tab.icon == null) return label ?? const SizedBox.shrink();
    if (label == null) return tab.icon!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        tab.icon!,
        const SizedBox(height: 4),
        label,
      ],
    );
  }
}

class HyTabBarView extends StatelessWidget {
  const HyTabBarView({
    super.key,
    required this.children,
    this.controller,
    this.physics,
  });

  final List<Widget> children;
  final TabController? controller;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) =>
      TabBarView(controller: controller, physics: physics, children: children);
}

class HyStep {
  const HyStep(this.title, {this.subtitle});

  final String title;
  final String? subtitle;
}

class HySteps extends StatelessWidget {
  const HySteps({
    super.key,
    required this.steps,
    required this.current,
    this.vertical = false,
  });

  final List<HyStep> steps;
  final int current;
  final bool vertical;

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    final glass = HyGlassTheme.of(context);

    Widget indicator(int index) => AnimatedContainer(
      duration: HyUiEffects.selectionDuration,
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: index <= current ? tokens.primary : glass.controlTrack,
        border: Border.all(color: glass.edgeHighlight),
      ),
      alignment: Alignment.center,
      child: index < current
          ? Icon(LucideIcons.check, size: 14, color: tokens.primaryForeground)
          : Text(
              '${index + 1}',
              style: TextStyle(
                fontSize: 11,
                color: index <= current
                    ? tokens.primaryForeground
                    : tokens.mutedForeground,
              ),
            ),
    );

    Widget label(int index) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: vertical
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: <Widget>[
        Text(steps[index].title),
        if (steps[index].subtitle != null)
          Text(
            steps[index].subtitle!,
            style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
          ),
      ],
    );

    if (vertical) {
      return Column(
        children: <Widget>[
          for (var index = 0; index < steps.length; index++)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: <Widget>[
                  indicator(index),
                  const SizedBox(width: 12),
                  Expanded(child: label(index)),
                ],
              ),
            ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (var index = 0; index < steps.length; index++)
          Expanded(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: HyDivider(
                        color: index == 0 ? Colors.transparent : tokens.border,
                      ),
                    ),
                    indicator(index),
                    Expanded(
                      child: HyDivider(
                        color: index == steps.length - 1
                            ? Colors.transparent
                            : tokens.border,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                label(index),
              ],
            ),
          ),
      ],
    );
  }
}

class HyProgress extends StatelessWidget {
  const HyProgress({
    super.key,
    this.value,
    this.circular = false,
    this.size = 64,
    this.showLabel = true,
    this.strokeWidth = 6,
  });

  final double? value;
  final bool circular;
  final bool showLabel;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final amount = value?.clamp(0.0, 1.0).toDouble();
    final label = amount == null ? null : '${(amount * 100).round()}%';
    final glass = HyGlassTheme.of(context);
    if (circular) {
      return SizedBox.square(
        dimension: size,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SizedBox.expand(
              child: CircularProgressIndicator(
                value: amount,
                strokeWidth: strokeWidth,
                backgroundColor: glass.controlTrack,
              ),
            ),
            if (showLabel && label != null)
              Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      );
    }
    return Row(
      children: <Widget>[
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: amount,
              minHeight: strokeWidth,
              backgroundColor: glass.controlTrack,
            ),
          ),
        ),
        if (showLabel && label != null)
          Padding(padding: const EdgeInsets.only(left: 12), child: Text(label)),
      ],
    );
  }
}
