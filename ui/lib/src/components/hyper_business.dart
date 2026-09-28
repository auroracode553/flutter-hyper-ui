import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hyper_ui_theme_tokens.dart';
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

class _HyperCollapseState extends State<HyperCollapse> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    return HyperGlass(
      radius: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          HyperPressable(
            onPressed: () {
              setState(() => _expanded = !_expanded);
              widget.onChanged?.call(_expanded);
            },
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
                    duration: const Duration(milliseconds: 180),
                    child: const Icon(LucideIcons.chevronDown, size: 18),
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: widget.child,
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
