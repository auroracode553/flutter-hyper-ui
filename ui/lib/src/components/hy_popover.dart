import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hy_ui_theme_tokens.dart';
import 'hy_action_sheet.dart';
import 'hy_anchored_surface.dart';
import 'hy_button.dart';
import 'hy_list_tile.dart';
import 'hy_pressable.dart';

/// 锚定控件的补充内容。
class HyPopover extends StatelessWidget {
  const HyPopover({super.key, required this.child, required this.content});

  final Widget child;
  final Widget content;

  @override
  Widget build(BuildContext context) => buildHyAnchoredSurface(
    width: (MediaQuery.sizeOf(context).width - 32)
        .clamp(0.0, 280.0)
        .toDouble(),
    maxHeight: MediaQuery.sizeOf(context).height * .4,
    padding: const EdgeInsets.all(14),
    triggerBuilder: (_, controller) => HyPressable(
      onPressed: () => controller.isOpen
          ? controller.close()
          : controller.open(),
      child: child,
    ),
    contentBuilder: (_) => content,
  );
}

/// 与 HyPopover 共用玻璃锚点表面，菜单项使用 HyListTile 的统一交互样式。
class HyPopupMenu<T> extends StatelessWidget {
  const HyPopupMenu({
    super.key,
    required this.actions,
    required this.onSelected,
    this.icon = LucideIcons.ellipsis,
    this.tooltip = '更多操作',
  });

  final List<HyAction<T>> actions;
  final ValueChanged<T> onSelected;
  final IconData icon;
  final String tooltip;

  @override
  Widget build(BuildContext context) => buildHyAnchoredSurface(
    width: (MediaQuery.sizeOf(context).width - 32)
        .clamp(0.0, 240.0)
        .toDouble(),
    maxHeight: MediaQuery.sizeOf(context).height * .4,
    padding: const EdgeInsets.all(5),
    triggerBuilder: (_, controller) => HyButton.icon(
      icon: icon,
      tooltip: tooltip,
      onPressed: () => controller.isOpen
          ? controller.close()
          : controller.open(),
    ),
    contentBuilder: (menuContext) {
      final tokens = HyUiThemeTokens.of(menuContext);
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
            HyListTile(
              title: action.label,
              leadingIcon: action.icon,
              leadingColor: action.destructive ? tokens.error : tokens.primary,
              titleColor: action.destructive ? tokens.error : null,
              grouped: true,
              enabled: action.enabled,
              showChevron: false,
              onTap: () {
                MenuController.maybeOf(menuContext)?.close();
                onSelected(action.value);
              },
            ),
        ],
      );
    },
  );
}
