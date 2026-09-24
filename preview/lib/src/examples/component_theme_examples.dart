import 'package:flutter/material.dart';
import 'package:flutter_hyper_ui/hy_ui.dart';

// doc-region UiThemeComponentExample
class UiThemeComponentExample extends StatelessWidget {
  const UiThemeComponentExample({super.key});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      for (final item in [(HyUiTheme.light(), 'Light'), (HyUiTheme.dark(), 'Dark')])
        Expanded(
          child: Theme(
            data: item.$1,
            child: Builder(
              builder: (context) => Container(
                margin: const EdgeInsets.all(6),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: HyText(item.$2, variant: HyTextStyle.heading),
              ),
            ),
          ),
        ),
    ],
  );
}
// end-doc-region UiThemeComponentExample

// doc-region UiThemeTokensComponentExample
class UiThemeTokensComponentExample extends StatelessWidget {
  const UiThemeTokensComponentExample({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    Widget swatch(String label, Color color) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 52, height: 52, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16))),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
    return HyWrap(children: [
      swatch('Primary', tokens.primary),
      swatch('Card', tokens.card),
      swatch('Muted', tokens.muted),
      swatch('Success', tokens.success),
      swatch('Warning', tokens.warning),
      swatch('Error', tokens.error),
      // input / border 是输入框与描边类组件的轮廓令牌。
      swatch('Input', tokens.input),
      swatch('Border', tokens.border),
    ]);
  }
}
// end-doc-region UiThemeTokensComponentExample

// doc-region GlassThemeComponentExample
class GlassThemeComponentExample extends StatelessWidget {
  const GlassThemeComponentExample({super.key});

  @override
  Widget build(BuildContext context) {
    final glass = HyGlassTheme.of(context);
    Widget swatch(String label, Color color) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 52, height: 52, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16))),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
    return HyWrap(children: [
      swatch('Surface', glass.surface),
      swatch('Strong', glass.surfaceStrong),
      swatch('Subtle', glass.surfaceSubtle),
      swatch('Selection', glass.selection),
      swatch('Pressed', glass.pressed),
      swatch('Scrim', glass.scrim),
    ]);
  }
}
// end-doc-region GlassThemeComponentExample

// doc-region UiColorsComponentExample
class UiColorsComponentExample extends StatelessWidget {
  const UiColorsComponentExample({super.key});

  @override
  Widget build(BuildContext context) {
    Widget swatch(String label, Color color) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 52, height: 52, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16))),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
    return HyWrap(children: [
      swatch('Primary', HyUiColors.primary),
      swatch('Success', HyUiColors.success),
      swatch('Warning', HyUiColors.warning),
      swatch('Error', HyUiColors.error),
      swatch('Info', HyUiColors.info),
    ]);
  }
}
// end-doc-region UiColorsComponentExample

// doc-region UiSpacingComponentExample
class UiSpacingComponentExample extends StatelessWidget {
  const UiSpacingComponentExample({super.key});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (final item in [('xxs', HyUiSpacing.xxs), ('xs', HyUiSpacing.xs), ('sm', HyUiSpacing.sm), ('md', HyUiSpacing.md), ('lg', HyUiSpacing.lg), ('xl', HyUiSpacing.xl)])
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(children: [SizedBox(width: 42, child: Text(item.$1)), Container(width: item.$2 * 4, height: 8, decoration: BoxDecoration(color: context.hyUi.primary, borderRadius: BorderRadius.circular(99))), const SizedBox(width: 10), Text('${item.$2.toInt()} dp')]),
        ),
    ],
  );
}
// end-doc-region UiSpacingComponentExample

// doc-region UiRadiiComponentExample
class UiRadiiComponentExample extends StatelessWidget {
  const UiRadiiComponentExample({super.key});

  @override
  Widget build(BuildContext context) => HyWrap(children: [
    for (final item in [('sm', HyUiRadii.sm), ('md', HyUiRadii.md), ('lg', HyUiRadii.lg), ('full', HyUiRadii.full)])
      Container(width: 76, height: 62, alignment: Alignment.center, decoration: BoxDecoration(color: context.hyUi.selectionBackground, borderRadius: BorderRadius.circular(item.$2)), child: Text(item.$1)),
  ]);
}
// end-doc-region UiRadiiComponentExample

// doc-region UiEffectsComponentExample
class UiEffectsComponentExample extends StatelessWidget {
  const UiEffectsComponentExample({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: context.hyUi.card,
      borderRadius: BorderRadius.circular(HyUiRadii.md),
      boxShadow: HyUiEffects.surfaceShadows(Theme.of(context).brightness),
    ),
    child: const Text('统一阴影 · 20 / 28 模糊 · 快速按压 · 克制吸附'),
  );
}
// end-doc-region UiEffectsComponentExample

// doc-region UiBuildContextComponentExample
class UiBuildContextComponentExample extends StatelessWidget {
  const UiBuildContextComponentExample({super.key});

  @override
  Widget build(BuildContext context) => HyGlass(
    color: context.hyGlass.surfaceStrong,
    borderColor: context.hyUi.border,
    padding: const EdgeInsets.all(20),
    child: Text('context.hyUi / context.hyGlass', style: TextStyle(color: context.hyUi.foreground)),
  );
}
// end-doc-region UiBuildContextComponentExample

// doc-region ThemeControllerComponentExample
class ThemeControllerComponentExample extends StatefulWidget {
  const ThemeControllerComponentExample({super.key});

  @override
  State<ThemeControllerComponentExample> createState() => _ThemeControllerComponentExampleState();
}

class _ThemeControllerComponentExampleState extends State<ThemeControllerComponentExample> {
  late final HyThemeController _controller = HyThemeController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _controller,
    builder: (_, child) => HySegmentedControl<ThemeMode>(
      selectedValue: _controller.mode,
      onChanged: _controller.setMode,
      options: const [
        HySegmentOption(value: ThemeMode.system, label: '系统'),
        HySegmentOption(value: ThemeMode.light, label: '浅色'),
        HySegmentOption(value: ThemeMode.dark, label: '深色'),
      ],
    ),
  );
}
// end-doc-region ThemeControllerComponentExample

// doc-region ScreenComponentExample
class ScreenComponentExample extends StatelessWidget {
  const ScreenComponentExample({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = HyScreen(context);
    return HyCard(
      title: '当前预览视口',
      child: HySpace(children: [
        Text('宽度：${screen.width.toStringAsFixed(0)} px'),
        Text('布局：${screen.compact ? '紧凑' : '宽屏'}'),
        Text('16 dp 自适应结果：${screen.dp(16).toStringAsFixed(1)}'),
      ]),
    );
  }
}
// end-doc-region ScreenComponentExample

// doc-region KeyboardComponentExample
class KeyboardComponentExample extends StatelessWidget {
  const KeyboardComponentExample({super.key});

  @override
  Widget build(BuildContext context) => HySafeArea(
    minimum: const EdgeInsets.all(4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HyTextField(hintText: '输入后可主动收起'),
        const SizedBox(height: 14),
        HyButton.tonal(label: '收起键盘', onPressed: () => HyKeyboard.dismiss(context)),
      ],
    ),
  );
}
// end-doc-region KeyboardComponentExample
