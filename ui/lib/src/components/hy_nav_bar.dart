import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hy_ui_theme_tokens.dart';
import 'hy_button.dart';

/// 紧凑的透明导航栏，不绘制背景、模糊、边框或阴影。
///
/// [height] 不包含顶部安全区。配合 HyNavBarPage 让内容滚入状态栏区域；
/// 单独放入 Scaffold.appBar 仍然是普通的占位导航栏。
class HyNavBar extends StatelessWidget implements PreferredSizeWidget {
  const HyNavBar({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions = const <Widget>[],
    this.height = 44,
    this.safeArea = true,
    this.automaticallyImplyLeading = true,
    this.centerTitle = false,
  }) : assert(height >= 44 && height < double.infinity);

  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget> actions;

  /// 导航内容高度，默认 44；大字号或较高的自定义插槽可增加此值。
  final double height;
  final bool safeArea;
  final bool automaticallyImplyLeading;
  final bool centerTitle;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final effectiveLeading =
        leading ??
        (automaticallyImplyLeading && Navigator.canPop(context)
            ? const _BackButton()
            : null);
    final content = SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        // NavigationToolbar 按整个栏宽居中，并在左右操作区较宽时避让。
        child: NavigationToolbar(
          centerMiddle: centerTitle,
          middleSpacing: 8,
          leading: effectiveLeading,
          middle: _buildTitle(context),
          trailing: actions.isEmpty
              ? null
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    for (var index = 0; index < actions.length; index++) ...[
                      if (index > 0) const SizedBox(width: 4),
                      actions[index],
                    ],
                  ],
                ),
        ),
      ),
    );

    return safeArea ? SafeArea(bottom: false, child: content) : content;
  }

  Widget _buildTitle(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    return Semantics(
      header: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: centerTitle
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
            textAlign: centerTitle ? TextAlign.center : TextAlign.start,
            style: TextStyle(
              color: tokens.foreground,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.2,
              letterSpacing: -0.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (subtitle != null) ...<Widget>[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              textAlign: centerTitle ? TextAlign.center : TextAlign.start,
              style: TextStyle(
                color: tokens.mutedForeground,
                fontSize: 11,
                height: 1.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) => HyButton.icon(
    icon: LucideIcons.chevronLeft,
    variant: HyButtonVariant.ghost,
    height: 44,
    iconSize: 20,
    tooltip: MaterialLocalizations.of(context).backButtonTooltip,
    onPressed: () => Navigator.maybePop(context),
  );
}
