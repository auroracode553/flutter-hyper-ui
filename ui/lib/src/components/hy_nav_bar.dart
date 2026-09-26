import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hy_glass_theme.dart';
import '../theme/hy_ui_spacing.dart';
import '../theme/hy_ui_theme_tokens.dart';
import 'hy_glass.dart';
import 'hy_button.dart';

/// 页面顶部导航栏。默认透明，仅保留导航内容本身；需要玻璃背景时开启 [opaque]。
class HyNavBar extends StatelessWidget implements PreferredSizeWidget {
  const HyNavBar({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions = const <Widget>[],
    this.safeArea = true,
    this.automaticallyImplyLeading = true,
    this.centerTitle = false,
    this.floating = false,
    this.opaque = false,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget> actions;
  final bool safeArea;
  final bool automaticallyImplyLeading;
  final bool centerTitle;

  /// 为 true 时使用四周圆角与外边距，适合沉浸式页面。
  final bool floating;

  /// 为 true 时启用玻璃背景（底色 / 模糊 / 阴影）。
  ///
  /// 默认透明：仅保留标题与操作按钮，背景由页面底色直接透出，适合贴在
  /// 页面同色背景上的导航场景。一般不建议开启不透明背景，仅在确实需要
  /// 玻璃材质兜底时作为备用。
  final bool opaque;

  @override
  Size get preferredSize => Size.fromHeight(subtitle == null ? 56 : 68);

  @override
  Widget build(BuildContext context) {
    final glass = HyGlassTheme.of(context);
    final content = SizedBox(
      height: preferredSize.height,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: HyUiSpacing.pagePadding,
          vertical: HyUiSpacing.xs,
        ),
        child: Row(
          children: <Widget>[
            if (leading == null &&
                automaticallyImplyLeading &&
                Navigator.canPop(context))
              const _BackButton(),
            if (leading != null) leading!,
            if (leading != null ||
                (automaticallyImplyLeading && Navigator.canPop(context)))
              const SizedBox(width: HyUiSpacing.sm),
            Expanded(child: _buildTitle(context)),
            if (actions.isNotEmpty) ...<Widget>[
              const SizedBox(width: HyUiSpacing.xs),
              Wrap(spacing: HyUiSpacing.xs, children: actions),
            ],
          ],
        ),
      ),
    );

    // 默认透明：不渲染玻璃材质，仅保留导航内容，背景由页面底色直接透出。
    if (!opaque) {
      return safeArea ? SafeArea(bottom: false, child: content) : content;
    }

    final bar = Padding(
      padding: floating
          ? const EdgeInsets.fromLTRB(12, 8, 12, 4)
          : EdgeInsets.zero,
      child: HyGlass(
        radius: floating ? 24 : 0,
        blur: 24,
        weight: HyGlassWeight.regular,
        shadows: floating
            ? null
            : <BoxShadow>[
                BoxShadow(
                  color: glass.shadow,
                  blurRadius: 18,
                  spreadRadius: -10,
                  offset: const Offset(0, 9),
                ),
              ],
        child: content,
      ),
    );

    return safeArea ? SafeArea(bottom: false, child: bar) : bar;
  }

  Widget _buildTitle(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    return Column(
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
            fontSize: 18,
            fontWeight: FontWeight.w700,
            height: 1.15,
            letterSpacing: -0.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (subtitle != null) ...<Widget>[
          const SizedBox(height: 3),
          Text(
            subtitle!,
            textAlign: centerTitle ? TextAlign.center : TextAlign.start,
            style: TextStyle(
              color: tokens.mutedForeground,
              fontSize: 12,
              height: 1.25,
              letterSpacing: 0.05,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    // 返回按钮与其他图标操作共用 HyButton 的玻璃表面。
    return HyButton.icon(
      icon: LucideIcons.chevronLeft,
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: () => Navigator.maybePop(context),
    );
  }
}
