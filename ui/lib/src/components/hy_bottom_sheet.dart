import 'package:flutter/material.dart';
import 'hy_glass.dart';

abstract final class HyBottomSheet {
  static Future<T?> show<T>(BuildContext context, {required WidgetBuilder builder,
    String? title, bool dismissible = true}) => showModalBottomSheet<T>(
    context: context, isScrollControlled: true, useSafeArea: true,
    isDismissible: dismissible, enableDrag: dismissible,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(sheetContext).bottom),
      child: ConstrainedBox(constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(sheetContext).height * .85),
        child: HyGlass(radius: 28, padding: const EdgeInsets.all(20),
          child: SafeArea(top: false, child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Center(child: Container(width: 32, height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(color: Theme.of(sheetContext).dividerColor,
                  borderRadius: BorderRadius.circular(4)))),
              if (title != null) Padding(padding: const EdgeInsets.only(bottom: 16),
                child: Text(title, style: Theme.of(sheetContext).textTheme.titleLarge)),
              builder(sheetContext),
            ])))))));
}

class HyAction<T> {
  const HyAction({required this.value, required this.label, this.icon,
    this.destructive = false, this.enabled = true});
  final T value;
  final String label;
  final IconData? icon;
  final bool destructive, enabled;
}

abstract final class HyActionSheet {
  static Future<T?> show<T>(BuildContext context, {required List<HyAction<T>> actions,
    String? title, String cancelLabel = '取消'}) => HyBottomSheet.show<T>(context,
      title: title, builder: (sheetContext) => Column(mainAxisSize: MainAxisSize.min,
        children: [for (final action in actions) ListTile(
          enabled: action.enabled,
          leading: action.icon == null ? null : Icon(action.icon),
          textColor: action.destructive ? Theme.of(context).colorScheme.error : null,
          title: Text(action.label), onTap: () => Navigator.pop(sheetContext, action.value)),
          TextButton(onPressed: () => Navigator.pop(sheetContext), child: Text(cancelLabel)),
        ]));
}
