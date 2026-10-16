import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hyper_ui_theme_tokens.dart';
import '../utils/hyper_menu_width.dart';
import 'hyper_action_sheet.dart';
import 'hyper_anchored_surface.dart';
import 'hyper_button.dart';
import 'hyper_list_tile.dart';
import 'hyper_pressable.dart';

/// 锚定控件的补充内容。
class HyperPopover extends StatelessWidget {
  const HyperPopover({
    super.key,
    required this.child,
    required this.content,
    this.maxWidth = 280,
    this.width,
  }) : assert(maxWidth > 0 && maxWidth < double.infinity),
       assert(width == null || (width > 0 && width < double.infinity));

  final Widget child;
  final Widget content;
  final double maxWidth;
  final double? width;

  @override
  Widget build(BuildContext context) => buildHyAnchoredSurface(
    width: (width ?? 180).clamp(0.0, maxWidth).toDouble(),
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
    required this.onChanged,
    this.icon = LucideIcons.ellipsis,
    this.tooltip = '更多操作',
    this.enabled = true,
  });

  final List<HyperAction<T>> actions;
  final ValueChanged<T> onChanged;
  final IconData icon;
  final String tooltip;

  /// 禁用时阻止打开菜单。
  final bool enabled;

  @override
  Widget build(BuildContext context) => buildHyAnchoredSurface(
    width: measureHyperMenuWidth(
      context,
      labels: actions.map((action) => action.label),
      horizontalSpace: actions.any((action) => action.icon != null) ? 84 : 38,
    ),
    maxHeight: MediaQuery.sizeOf(context).height * .4,
    padding: const EdgeInsets.all(5),
    triggerBuilder: (_, controller) => HyperButton(
      type: 'icon',
      icon: icon,
      tooltip: tooltip,
      onPressed: enabled
          ? () => controller.isOpen ? controller.close() : controller.open()
          : null,
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
              type: 'plain',
              title: action.label,
              leadingIcon: action.icon,
              leadingColor: action.isDanger ? tokens.error : tokens.primary,
              titleColor: action.isDanger ? tokens.error : null,
              enabled: enabled && action.enabled,
              selected: action.selected,
              trailing: action.selected
                  ? Icon(LucideIcons.check, size: 18, color: tokens.primary)
                  : null,
              showChevron: false,
              onPressed: () {
                if (!enabled || !action.enabled) return;
                hyperMenuOf(menuContext)?.close();
                onChanged(action.value);
              },
            ),
        ],
      );
    },
  );
}
