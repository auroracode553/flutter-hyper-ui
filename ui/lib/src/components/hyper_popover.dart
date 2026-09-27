import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_action_sheet.dart';
import 'hyper_anchored_surface.dart';
import 'hyper_button.dart';
import 'hyper_list_tile.dart';
import 'hyper_pressable.dart';

/// 锚定控件的补充内容。
class HyperPopover extends StatelessWidget {
  const HyperPopover({super.key, required this.child, required this.content});

  final Widget child;
  final Widget content;

  @override
  Widget build(BuildContext context) => buildHyAnchoredSurface(
    width: (MediaQuery.sizeOf(context).width - 32).clamp(0.0, 280.0).toDouble(),
    maxHeight: MediaQuery.sizeOf(context).height * .4,
    padding: const EdgeInsets.all(14),
    triggerBuilder: (_, controller) => HyperPressable(
      onPressed: () =>
          controller.isOpen ? controller.close() : controller.open(),
      child: child,
    ),
    contentBuilder: (_) => content,
  );
}

/// 与 HyperPopover 共用玻璃锚点表面，菜单项使用 HyperListTile 的统一交互样式。
class HyperPopupMenu<T> extends StatelessWidget {
  const HyperPopupMenu({
    super.key,
    required this.actions,
    required this.onSelected,
    this.icon = LucideIcons.ellipsis,
    this.tooltip = '更多操作',
  });

  final List<HyperAction<T>> actions;
  final ValueChanged<T> onSelected;
  final IconData icon;
  final String tooltip;

  @override
  Widget build(BuildContext context) => buildHyAnchoredSurface(
    width: (MediaQuery.sizeOf(context).width - 32).clamp(0.0, 240.0).toDouble(),
    maxHeight: MediaQuery.sizeOf(context).height * .4,
    padding: const EdgeInsets.all(5),
    triggerBuilder: (_, controller) => HyperButton.icon(
      icon: icon,
      tooltip: tooltip,
      onPressed: () =>
          controller.isOpen ? controller.close() : controller.open(),
    ),
    contentBuilder: (menuContext) {
      final tokens = HyperUiThemeTokens.of(menuContext);
      if (actions.isEmpty) {
        return Padding(
          padding: const EdgeInsets.all(14),
          child: Text('暂无操作', style: TextStyle(color: tokens.mutedForeground)),
        );
      }
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final action in actions)
            HyperListTile(
              title: action.label,
              leadingIcon: action.icon,
              leadingColor: action.destructive ? tokens.error : tokens.primary,
              titleColor: action.destructive ? tokens.error : null,
              grouped: true,
              enabled: action.enabled,
              showChevron: false,
              onTap: () {
                hyperMenuOf(menuContext)?.close();
                onSelected(action.value);
              },
            ),
        ],
      );
    },
  );
}
