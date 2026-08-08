import 'package:flutter/material.dart';

import '../theme/doc_ui_radii.dart';
import '../theme/doc_ui_spacing.dart';
import '../theme/doc_ui_theme_tokens.dart';

class DocSegmentOption<T> {
  final T value;
  final String label;
  final IconData? icon;
  final bool enabled;

  const DocSegmentOption({
    required this.value,
    required this.label,
    this.icon,
    this.enabled = true,
  });
}

class DocSegmentedControl<T> extends StatelessWidget {
  final List<DocSegmentOption<T>> options;
  final T selectedValue;
  final ValueChanged<T> onChanged;
  final bool equalWidth;

  const DocSegmentedControl({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    this.equalWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = DocUiThemeTokens.of(context);
    final children = options.map((option) {
      final item = _DocSegmentItem<T>(
        option: option,
        selected: option.value == selectedValue,
        onSelected: onChanged,
        constrainLabel: equalWidth,
      );
      return equalWidth ? Expanded(child: item) : item;
    }).toList();

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: tokens.muted,
        borderRadius: BorderRadius.circular(DocUiRadii.sm),
      ),
      child: Row(
        mainAxisSize: equalWidth ? MainAxisSize.max : MainAxisSize.min,
        children: children,
      ),
    );
  }
}

class _DocSegmentItem<T> extends StatelessWidget {
  final DocSegmentOption<T> option;
  final bool selected;
  final ValueChanged<T> onSelected;
  final bool constrainLabel;

  const _DocSegmentItem({
    required this.option,
    required this.selected,
    required this.onSelected,
    required this.constrainLabel,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = DocUiThemeTokens.of(context);
    final foreground = selected
        ? tokens.primaryForeground
        : option.enabled
            ? tokens.foreground
            : tokens.mutedForeground;
    final background = selected ? tokens.primary : Colors.transparent;

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(DocUiRadii.sm),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: option.enabled ? () => onSelected(option.value) : null,
        child: Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: DocUiSpacing.sm),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (option.icon != null) ...[
                Icon(option.icon, size: 16, color: foreground),
                const SizedBox(width: DocUiSpacing.xs),
              ],
              if (constrainLabel)
                Flexible(child: _buildLabel(foreground))
              else
                _buildLabel(foreground),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(Color foreground) {
    return Text(
      option.label,
      style: TextStyle(
        color: foreground,
        fontSize: 13,
        fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
