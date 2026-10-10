import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hyper_ui_theme_tokens.dart';
import '../theme/hyper_ui_effects.dart';
import 'hyper_glass.dart';
import 'hyper_pressable.dart';

class HyperCollapse extends StatefulWidget {
  const HyperCollapse({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
    this.onChanged,
  });
  final String title;
  final Widget child;
  final bool initiallyExpanded;
  final ValueChanged<bool>? onChanged;
  @override
  State<HyperCollapse> createState() => _HyperCollapseState();
}

class _HyperCollapseState extends State<HyperCollapse>
    with SingleTickerProviderStateMixin {
  late bool _expanded = widget.initiallyExpanded;
  late bool _hasExpanded = widget.initiallyExpanded;
  late final AnimationController _expansion = AnimationController(
    vsync: this,
    value: _expanded ? 1 : 0,
    duration: HyperUiEffects.collapseDuration,
  );

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded) _hasExpanded = true;
    });
    if (MediaQuery.maybeOf(context)?.disableAnimations == true) {
      _expansion.value = _expanded ? 1 : 0;
    } else if (_expanded) {
      _expansion.animateTo(1, curve: HyperUiEffects.overlayCurve);
    } else {
      _expansion.animateBack(0, curve: HyperUiEffects.overlayCurve);
    }
    widget.onChanged?.call(_expanded);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.maybeOf(context)?.disableAnimations == true) {
      _expansion.value = _expanded ? 1 : 0;
    }
  }

  @override
  void dispose() {
    _expansion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    return HyperGlass(
      radius: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          HyperPressable(
            onPressed: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(color: tokens.foreground),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? .5 : 0,
                    duration:
                        MediaQuery.maybeOf(context)?.disableAnimations == true
                        ? Duration.zero
                        : HyperUiEffects.collapseDuration,
                    curve: HyperUiEffects.overlayCurve,
                    child: const Icon(LucideIcons.chevronDown, size: 18),
                  ),
                ],
              ),
            ),
          ),
          if (_hasExpanded)
            AnimatedBuilder(
              animation: _expansion,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: widget.child,
              ),
              builder: (context, child) => ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: _expansion.value,
                  child: IgnorePointer(
                    ignoring: !_expanded,
                    child: ExcludeFocus(
                      excluding: !_expanded,
                      child: TickerMode(
                        // 收起后保留内容状态，暂停其内部持续动画。
                        enabled: _expansion.value > 0,
                        child: FadeTransition(opacity: _expansion, child: child),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class HyperTimelineItem {
  const HyperTimelineItem({
    required this.title,
    this.description,
    this.time,
    this.icon,
    this.complete = true,
  });
  final String title;
  final String? description, time;
  final IconData? icon;
  final bool complete;
}

class HyperTimeline extends StatelessWidget {
  const HyperTimeline({super.key, required this.items});
  final List<HyperTimelineItem> items;
  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    return Column(
      children: [
        for (var i = 0; i < items.length; i++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 32,
                  child: Column(
                    children: [
                      Icon(
                        items[i].icon ?? LucideIcons.circleCheckBig,
                        size: 20,
                        color: items[i].complete
                            ? tokens.primary
                            : tokens.mutedForeground,
                      ),
                      if (i < items.length - 1)
                        Expanded(
                          child: Center(
                            child: Container(width: 1, color: tokens.border),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          items[i].title,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        if (items[i].description != null)
                          Text(items[i].description!),
                        if (items[i].time != null)
                          Text(
                            items[i].time!,
                            style: TextStyle(
                              fontSize: 12,
                              color: tokens.mutedForeground,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
