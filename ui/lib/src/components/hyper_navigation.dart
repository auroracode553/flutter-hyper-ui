import 'package:flutter_hyper_ui/src/theme/hyper_palette.dart';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'hyper_progress_painters.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hyper_glass_theme.dart';
import '../theme/hyper_ui_effects.dart';
import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_glass.dart';
import 'hyper_layout.dart';
import 'hyper_pressable.dart';
import 'hyper_tab_controller.dart';

export 'hyper_tab_bar.dart';
export 'hyper_tab_controller.dart';

/// 顶部或内容区使用的玻璃胶囊标签栏。
class HyperTabs extends StatelessWidget implements PreferredSizeWidget {
  const HyperTabs({
    super.key,
    required this.tabs,
    this.controller,
    this.scrollable = false,
    this.onTap,
  });

  final List<Widget> tabs;
  final HyperTabController? controller;
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
    final tokens = HyperUiThemeTokens.of(context);
    final tabController = controller ?? HyperTabHost.of(context);
    assert(tabController.length == tabs.length);
    final tabHeight = _tabHeight;
    if (tabs.isEmpty) {
      return HyperGlass(
        radius: preferredSize.height / 2,
        weight: HyperGlassWeight.subtle,
        child: SizedBox(height: tabHeight),
      );
    }
    return HyperGlass(
      radius: preferredSize.height / 2,
      blur: 12,
      weight: HyperGlassWeight.subtle,
      padding: const EdgeInsets.all(3),
      child: SizedBox(
        height: tabHeight,
        child: AnimatedBuilder(
          animation: tabController,
          builder: (context, _) {
            final position = tabController.index.toDouble().clamp(
              0.0,
              (tabs.length - 1).toDouble(),
            );
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
    HyperTabController tabController,
    HyperUiThemeTokens tokens,
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
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
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
      child: HyperPressable(
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
                  : HyperPalette.transparent,
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
                child: tabs[index],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HyperStep {
  const HyperStep(this.title, {this.subtitle});

  final String title;
  final String? subtitle;
}

class HyperSteps extends StatelessWidget {
  const HyperSteps({
    super.key,
    required this.steps,
    required this.current,
    this.vertical = false,
  });

  final List<HyperStep> steps;
  final int current;
  final bool vertical;

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    final glass = HyperGlassTheme.of(context);

    Widget indicator(int index) => AnimatedContainer(
      duration: HyperUiEffects.selectionDuration,
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
                      child: HyperDivider(
                        color: index == 0
                            ? HyperPalette.transparent
                            : tokens.border,
                      ),
                    ),
                    indicator(index),
                    Expanded(
                      child: HyperDivider(
                        color: index == steps.length - 1
                            ? HyperPalette.transparent
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

class HyperProgress extends StatelessWidget {
  const HyperProgress({
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
    final glass = HyperGlassTheme.of(context);
    if (circular) {
      return SizedBox.square(
        dimension: size,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SizedBox.expand(
              child: HyperSpinner(
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
            child: HyperProgressTrack(
              value: amount,
              height: strokeWidth,
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
