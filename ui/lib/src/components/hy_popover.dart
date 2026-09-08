import 'package:flutter/material.dart';
import 'hy_bottom_sheet.dart';
import 'hy_glass.dart';

class HyPopover extends StatelessWidget {
  const HyPopover({super.key, required this.child, required this.content});
  final Widget child, content;
  @override
  Widget build(BuildContext context) => MenuAnchor(
    style: const MenuStyle(backgroundColor: WidgetStatePropertyAll(Colors.transparent),
      elevation: WidgetStatePropertyAll(0), padding: WidgetStatePropertyAll(EdgeInsets.zero)),
    menuChildren: [SizedBox(width: (MediaQuery.sizeOf(context).width - 32).clamp(0.0, 280.0).toDouble(),
      child: HyGlass(radius: 18, padding: const EdgeInsets.all(16),
        child: ConstrainedBox(constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * .4),
          child: SingleChildScrollView(child: content))))],
    builder: (_, controller, child) => TextButton(
      onPressed: () => controller.isOpen ? controller.close() : controller.open(), child: this.child));
}

class HyPopupMenu<T> extends StatelessWidget {
  const HyPopupMenu({super.key, required this.actions, required this.onSelected,
    this.icon = Icons.more_horiz_rounded, this.tooltip = '更多操作'});
  final List<HyAction<T>> actions;
  final ValueChanged<T> onSelected;
  final IconData icon;
  final String tooltip;
  @override
  Widget build(BuildContext context) => PopupMenuButton<T>(
    tooltip: tooltip, icon: Icon(icon), onSelected: onSelected,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    itemBuilder: (_) => actions.map((action) => PopupMenuItem<T>(
      value: action.value, enabled: action.enabled,
      child: Row(children: [if (action.icon != null) ...[
        Icon(action.icon, size: 20), const SizedBox(width: 12)],
        Flexible(child: Text(action.label, style: TextStyle(
          color: action.destructive ? Theme.of(context).colorScheme.error : null))),
      ]))).toList());
}
