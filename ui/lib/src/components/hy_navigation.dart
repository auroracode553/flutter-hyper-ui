import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hy_glass_theme.dart';
import '../theme/hy_ui_effects.dart';
import '../theme/hy_ui_theme_tokens.dart';
import 'hy_glass.dart';
import 'hy_layout.dart';
import 'hy_pressable.dart';

export 'hy_tab_bar.dart';

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
    this.color,
    this.backgroundColor,
  });

  final double? value;
  final bool circular;
  final bool showLabel;
  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? backgroundColor;

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
                backgroundColor: backgroundColor ?? glass.controlTrack,
                color: color,
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
              backgroundColor: backgroundColor ?? glass.controlTrack,
              color: color,
            ),
          ),
        ),
        if (showLabel && label != null)
          Padding(padding: const EdgeInsets.only(left: 12), child: Text(label)),
      ],
    );
  }
}
