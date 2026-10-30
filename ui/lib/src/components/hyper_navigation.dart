import 'package:flutter_hyper_ui/src/theme/hyper_palette.dart';


import 'package:flutter/widgets.dart';

import 'hyper_progress_painters.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hyper_glass_theme.dart';
import '../theme/hyper_ui_effects.dart';
import '../theme/hyper_ui_theme_tokens.dart';
import '../utils/hyper_progress_value.dart';
import 'hyper_layout.dart';

export 'hyper_tab_bar.dart';

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
    this.type = 'horizontal',
  }) : assert(type == 'horizontal' || type == 'vertical');

  final List<HyperStep> steps;
  final int current;
  final String type;
  bool get vertical => type == 'vertical';

  @override
  Widget build(BuildContext context) {
    if (type != 'horizontal' && type != 'vertical') {
      throw ArgumentError.value(type, 'type', 'Invalid steps type');
    }
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
    this.type = 'linear',
    this.value,
    this.showLabel = true,

    this.color,
    this.backgroundColor,
  }) : assert(
         type == 'linear' || type == 'circular',
         'HyperProgress.type must be linear or circular.',
       );

  final String type;
  final double? value;
  final bool showLabel;

  final Color? color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    if (type != 'linear' && type != 'circular') {
      throw ArgumentError.value(type, 'type', 'Invalid progress type');
    }
    final amount = normalizeHyperProgress(value);
    final label = amount == null ? null : '${hyperProgressPercentage(amount)}%';
    final glass = HyperGlassTheme.of(context);
    if (type == 'circular') {
      return SizedBox.square(
        dimension: 64,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SizedBox.expand(
              child: HyperSpinner(
                value: amount,
                strokeWidth: 6,
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
              height: 6,
              backgroundColor: backgroundColor ?? glass.controlTrack,
              color: color,
            ),
          ),
        ),
        if (showLabel && label != null)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 12),
            child: Text(label),
          ),
      ],
    );
  }
}
