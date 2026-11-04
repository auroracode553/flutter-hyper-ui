import 'package:flutter/widgets.dart';

import 'hyper_glass.dart';
import 'hyper_layout.dart';

import '../theme/hyper_ui_spacing.dart';
import '../theme/hyper_ui_theme_tokens.dart';
import '../theme/hyper_surface_theme.dart';

/// 带标题、操作区和正文的交互内容卡片。
class HyperCard extends StatelessWidget {
  /// 承载的正文内容。
  final Widget? child;
  /// 标题文字。
  final String? title;
  /// 副标题文字。
  final String? subtitle;
  /// 前置自定义内容。
  final Widget? leading;
  /// 标题右侧的操作组件。
  final List<Widget> actions;
  /// 底部补充内容。
  final Widget? footer;
  /// 内容内边距。
  final EdgeInsetsGeometry padding;
  /// 点击时触发，可独立于长按启用。
  final VoidCallback? onPressed;
  /// 长按卡片时触发，可独立于点击启用。
  final VoidCallback? onLongPressed;
  /// 是否显示选中状态。
  final bool selected;

  /// 创建内容卡片，点击与长按回调由调用方注入。
  const HyperCard({
    super.key,
    this.child,
    this.title,
    this.subtitle,
    this.leading,
    this.actions = const [],
    this.footer,
    this.padding = const EdgeInsets.all(HyperUiSpacing.cardPadding),
    this.onPressed,
    this.onLongPressed,
    this.selected = false,
  });

  /// 是否需要展示卡片标题区域。
  bool get _hasHeader {
    return title != null ||
        subtitle != null ||
        leading != null ||
        actions.isNotEmpty;
  }

  /// 根据当前主题和参数构建组件界面。
  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    final glass = HyperSurfaceTheme.of(context);
    final content = Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_hasHeader) _buildHeader(context),
          if (_hasHeader && child != null)
            const SizedBox(height: HyperUiSpacing.sm),
          if (child != null) child!,
          if (footer != null) ...[
            const SizedBox(height: HyperUiSpacing.sm),
            HyperDivider(color: tokens.border),
            const SizedBox(height: HyperUiSpacing.sm),
            footer!,
          ],
        ],
      ),
    );

    return HyperGlass.card(
      onPressed: onPressed,
      onLongPressed: onLongPressed,
      showBorder: selected,
      color: selected ? glass.surfaceStrong : null,
      borderColor: selected ? tokens.primary : null,
      child: content,
    );
  }

  /// 根据当前主题构建卡片标题与操作区域。
  Widget _buildHeader(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (leading != null) ...[
          leading!,
          const SizedBox(width: HyperUiSpacing.sm),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null)
                Text(
                  title!,
                  style: TextStyle(
                    color: tokens.cardForeground,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: TextStyle(
                    color: tokens.mutedForeground,
                    fontSize: 13,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        if (actions.isNotEmpty) ...[
          const SizedBox(width: HyperUiSpacing.xs),
          Wrap(spacing: HyperUiSpacing.xs, children: actions),
        ],
      ],
    );
  }
}
