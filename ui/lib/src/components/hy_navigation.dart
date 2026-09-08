import 'package:flutter/material.dart';
import '../theme/hy_ui_theme_tokens.dart';
import '../theme/hy_ui_effects.dart';
import 'hy_glass.dart';

class HyTabItem {
  const HyTabItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

/// 受控悬浮导航；内容页面由业务层管理。
class HyTabBar extends StatelessWidget {
  const HyTabBar({super.key, required this.items, required this.selectedIndex,
    required this.onSelected, this.safeArea = true})
    : assert(items.length >= 2), assert(selectedIndex >= 0 && selectedIndex < items.length);
  final List<HyTabItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final bool safeArea;
  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    final reduce = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final height = (MediaQuery.textScalerOf(context).scale(11) * 1.4 + 36).clamp(54.0, double.infinity).toDouble();
    final content = HyGlass(radius: 32, padding: const EdgeInsets.all(5),
      child: LayoutBuilder(builder: (context, constraints) {
        final width = constraints.maxWidth / items.length;
        final rtl = Directionality.of(context) == TextDirection.rtl;
        final visualIndex = rtl ? items.length - selectedIndex - 1 : selectedIndex;
        return SizedBox(height: height, child: Stack(children: [
          TweenAnimationBuilder<double>(tween: Tween(end: visualIndex.toDouble()),
            duration: reduce ? Duration.zero : HyUiEffects.selectionDuration,
            curve: HyUiEffects.selectionCurve,
            builder: (_, position, child) => Transform.translate(
              offset: Offset(position * width, 0), child: child),
            child: SizedBox(width: width, height: height, child: HyGlass(radius: 27,
              blur: 0, color: tokens.selectionBackground.withAlpha(210),
              borderColor: tokens.primary.withAlpha(35), child: const SizedBox.expand()))),
          Row(children: [for (var i = 0; i < items.length; i++) Expanded(
            child: Semantics(selected: selectedIndex == i, button: true,
              child: InkWell(borderRadius: BorderRadius.circular(27),
                onTap: () => onSelected(i), child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(items[i].icon, size: 22,
                      color: i == selectedIndex ? tokens.primary : tokens.mutedForeground),
                    Text(items[i].label, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                        color: i == selectedIndex ? tokens.primary : tokens.mutedForeground)),
                  ])))))])
        ]));
      }));
    return SafeArea(top: false, bottom: safeArea,
      minimum: const EdgeInsets.fromLTRB(20, 8, 20, 12), child: content);
  }
}

class HyTabs extends StatelessWidget implements PreferredSizeWidget {
  const HyTabs({super.key, required this.tabs, this.controller, this.scrollable = false,
    this.onTap});
  final List<Widget> tabs;
  final TabController? controller;
  final bool scrollable;
  final ValueChanged<int>? onTap;
  @override
  Size get preferredSize => const Size.fromHeight(48);
  @override
  Widget build(BuildContext context) => TabBar(controller: controller, tabs: tabs,
    isScrollable: scrollable, onTap: onTap, dividerColor: Colors.transparent,
    labelColor: HyUiThemeTokens.of(context).primary,
    unselectedLabelColor: HyUiThemeTokens.of(context).mutedForeground,
    indicatorSize: TabBarIndicatorSize.label);
}

class HyTabBarView extends StatelessWidget {
  const HyTabBarView({super.key, required this.children, this.controller, this.physics});
  final List<Widget> children;
  final TabController? controller;
  final ScrollPhysics? physics;
  @override
  Widget build(BuildContext context) => TabBarView(controller: controller,
    physics: physics, children: children);
}

class HyStep {
  const HyStep(this.title, {this.subtitle});
  final String title;
  final String? subtitle;
}

class HySteps extends StatelessWidget {
  const HySteps({super.key, required this.steps, required this.current, this.vertical = false});
  final List<HyStep> steps;
  final int current;
  final bool vertical;
  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    Widget indicator(int i) => CircleAvatar(radius: 14,
      backgroundColor: i <= current ? tokens.primary : tokens.muted,
      child: i < current ? Icon(Icons.check, size: 16, color: tokens.primaryForeground)
        : Text('${i + 1}', style: TextStyle(fontSize: 12,
          color: i <= current ? tokens.primaryForeground : tokens.mutedForeground)));
    Widget label(int i) => Column(mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: vertical ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [Text(steps[i].title, textAlign: vertical ? TextAlign.start : TextAlign.center),
        if (steps[i].subtitle != null) Text(steps[i].subtitle!,
          style: TextStyle(fontSize: 12, color: tokens.mutedForeground))]);
    if (vertical) return Column(children: [for (var i = 0; i < steps.length; i++)
      Padding(padding: const EdgeInsets.only(bottom: 16), child: Row(children: [indicator(i),
        const SizedBox(width: 12), Expanded(child: label(i))]))]);
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      for (var i = 0; i < steps.length; i++) Expanded(child: Column(children: [
        Row(children: [Expanded(child: Divider(color: i == 0 ? Colors.transparent : tokens.border)),
          indicator(i), Expanded(child: Divider(color: i == steps.length - 1 ? Colors.transparent : tokens.border))]),
        const SizedBox(height: 8), label(i),
      ])),
    ]);
  }
}

class HyProgress extends StatelessWidget {
  const HyProgress({super.key, this.value, this.circular = false, this.size = 64,
    this.showLabel = true, this.strokeWidth = 6});
  final double? value;
  final bool circular, showLabel;
  final double size, strokeWidth;
  @override
  Widget build(BuildContext context) {
    final amount = value?.clamp(0.0, 1.0).toDouble();
    final label = amount == null ? null : '${(amount * 100).round()}%';
    if (circular) return SizedBox.square(dimension: size, child: Stack(alignment: Alignment.center,
      children: [SizedBox.expand(child: CircularProgressIndicator(value: amount,
        strokeWidth: strokeWidth, backgroundColor: HyUiThemeTokens.of(context).muted)),
        if (showLabel && label != null) Text(label, style: const TextStyle(fontSize: 12)),
      ]));
    return Row(children: [Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(99),
      child: LinearProgressIndicator(value: amount, minHeight: strokeWidth))),
      if (showLabel && label != null) Padding(padding: const EdgeInsets.only(left: 12), child: Text(label)),
    ]);
  }
}
