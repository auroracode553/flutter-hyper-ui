import 'package:flutter/material.dart';
import '../theme/hy_ui_theme_tokens.dart';

class HyCheckbox extends StatelessWidget {
  const HyCheckbox({super.key, required this.value, this.onChanged, this.label,
    this.tristate = false});
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final String? label;
  final bool tristate;
  @override
  Widget build(BuildContext context) => label == null
    ? Checkbox(value: value, onChanged: onChanged, tristate: tristate,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)))
    : CheckboxListTile(value: value, onChanged: onChanged, tristate: tristate,
        contentPadding: EdgeInsets.zero, title: Text(label!),
        controlAffinity: ListTileControlAffinity.leading);
}

class HyRadio<T> extends StatelessWidget {
  const HyRadio({super.key, required this.value, required this.groupValue,
    this.onChanged, required this.label});
  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;
  final String label;
  @override
  Widget build(BuildContext context) => Semantics(checked: value == groupValue,
    inMutuallyExclusiveGroup: true, enabled: onChanged != null,
    child: ListTile(contentPadding: EdgeInsets.zero,
      onTap: onChanged == null ? null : () => onChanged!(value),
      leading: Icon(value == groupValue ? Icons.radio_button_checked : Icons.radio_button_off,
        color: onChanged == null ? HyUiThemeTokens.of(context).mutedForeground
          : HyUiThemeTokens.of(context).primary), title: Text(label)));
}

class HySwitch extends StatelessWidget {
  const HySwitch({super.key, required this.value, this.onChanged, this.label});
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  @override
  Widget build(BuildContext context) => label == null
    ? Switch.adaptive(value: value, onChanged: onChanged)
    : SwitchListTile.adaptive(value: value, onChanged: onChanged,
        title: Text(label!), contentPadding: EdgeInsets.zero);
}

class HySlider extends StatelessWidget {
  const HySlider({super.key, required this.value, this.onChanged, this.onChangeEnd,
    this.min = 0, this.max = 100, this.divisions, this.showValue = true}) : assert(max > min);
  final double value, min, max;
  final int? divisions;
  final bool showValue;
  final ValueChanged<double>? onChanged, onChangeEnd;
  @override
  Widget build(BuildContext context) => Slider(value: value.clamp(min, max).toDouble(),
    min: min, max: max, divisions: divisions, onChanged: onChanged,
    onChangeEnd: onChangeEnd, label: showValue ? value.toStringAsFixed(0) : null);
}

class HyRate extends StatelessWidget {
  const HyRate({super.key, required this.value, this.onChanged, this.count = 5,
    this.size = 26}) : assert(count > 0);
  final double value, size;
  final int count;
  final ValueChanged<double>? onChanged;
  @override
  Widget build(BuildContext context) => Wrap(children: [
    for (var i = 0; i < count; i++) Semantics(selected: value >= i + 1,
      child: IconButton(tooltip: '${i + 1} 星', iconSize: size,
        onPressed: onChanged == null ? null : () => onChanged!(i + 1.0),
        color: HyUiThemeTokens.of(context).warning,
        disabledColor: HyUiThemeTokens.of(context).warning,
        icon: Icon(value >= i + 1 ? Icons.star_rounded : value > i
          ? Icons.star_half_rounded : Icons.star_outline_rounded))),
  ]);
}
