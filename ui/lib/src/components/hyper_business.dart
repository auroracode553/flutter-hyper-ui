import 'dart:async';
import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_glass.dart';

/// 使用绝对截止时间，应用进入后台后不会积累计时漂移。
class HyperCountDown extends StatefulWidget {
  const HyperCountDown({
    super.key,
    required this.endTime,
    this.onFinished,
    this.builder,
  });
  final DateTime endTime;
  final VoidCallback? onFinished;
  final Widget Function(BuildContext, Duration)? builder;
  @override
  State<HyperCountDown> createState() => _HyperCountDownState();
}

class _HyperCountDownState extends State<HyperCountDown> with WidgetsBindingObserver {
  Timer? _timer;
  Duration _remaining = Duration.zero;
  bool _finished = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _start();
  }

  @override
  void didUpdateWidget(covariant HyperCountDown old) {
    super.didUpdateWidget(old);
    if (old.endTime != widget.endTime) {
      _finished = false;
      _start();
    }
  }

  void _start() {
    _timer?.cancel();
    _update();
    if (!_finished)
      _timer = Timer.periodic(
        const Duration(milliseconds: 250),
        (_) => _update(),
      );
  }

  void _update() {
    final difference = widget.endTime.difference(DateTime.now());
    _remaining = difference.isNegative ? Duration.zero : difference;
    if (mounted) setState(() {});
    if (_remaining == Duration.zero && !_finished) {
      _finished = true;
      _timer?.cancel();
      final deadline = widget.endTime;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.endTime == deadline) widget.onFinished?.call();
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed)
      _start();
    else
      _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final seconds = (_remaining.inMilliseconds / 1000).ceil();
    String pad(int n) => n.toString().padLeft(2, '0');
    return widget.builder?.call(context, _remaining) ??
        Text(
          '${pad(seconds ~/ 3600)}:${pad(seconds ~/ 60 % 60)}:${pad(seconds % 60)}',
          style: const TextStyle(
            fontFeatures: [FontFeature.tabularFigures()],
            fontWeight: FontWeight.w600,
          ),
        );
  }
}

class HyperCollapse extends StatelessWidget {
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
  Widget build(BuildContext context) => HyperGlass(
    blur: 0,
    radius: 20,
    child: ExpansionTile(
      title: Text(title),
      initiallyExpanded: initiallyExpanded,
      onExpansionChanged: onChanged,
      shape: const Border(),
      collapsedShape: const Border(),
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      children: [child],
    ),
  );
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
