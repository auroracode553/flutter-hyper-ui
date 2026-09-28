import 'package:flutter/widgets.dart';

import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_button.dart';
import 'hyper_typography.dart';

/// 透明导航容器，默认从起始侧排列，不绘制背景、模糊、边框或阴影。
///
/// [leading]、[title]、[subtitle]、[trailing] 都接受任意 Widget。
/// [child] 可完全接管内部布局；此时不生成自动返回按钮或默认标题布局。
/// [height] 不包含安全区。
class HyperNavBar extends StatelessWidget implements PreferredSizeWidget {
  const HyperNavBar({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.actions = const <Widget>[],
    this.child,
    this.height = 44,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.safeArea = true,
    this.showBackButton,
    this.onBackPressed,
    this.centerTitle = false,
  }) : assert(height > 0 && height < double.infinity),
       assert(
         child == null ||
             (title == null &&
                 subtitle == null &&
                 leading == null &&
                 trailing == null),
         'child 接管整行布局，不能同时设置其他内容插槽。',
       );

  /// 主内容插槽：文字、图标、搜索框、分段控件或任意组合。
  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;

  /// 完整尾部插槽；与便捷的 [actions] 列表二选一。
  final Widget? trailing;
  final List<Widget> actions;

  /// 完整内部布局插槽；仅保留高度、[padding] 和安全区处理。
  final Widget? child;

  /// 默认 44，调用方按自定义内容高度调整，不限制最小触控高度。
  final double height;
  final EdgeInsetsGeometry padding;

  final bool safeArea;

  /// null 按当前路由自动判断；true 始终显示；false 始终隐藏。
  /// 显式传入 [leading] 时，以自定义前导内容为准。
  final bool? showBackButton;

  /// 返回按钮的点击回调，默认调用 Navigator.maybePop。
  final VoidCallback? onBackPressed;

  /// 仅对默认插槽布局有效。默认 false，沿文字方向从起始侧排列。
  final bool centerTitle;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    if (child != null &&
        (title != null ||
            subtitle != null ||
            leading != null ||
            trailing != null ||
            actions.isNotEmpty)) {
      throw ArgumentError(
        'HyperNavBar.child cannot be combined with content slots.',
      );
    }
    if (trailing != null && actions.isNotEmpty) {
      throw ArgumentError(
        'HyperNavBar.trailing and actions are mutually exclusive.',
      );
    }
    final content = SizedBox(
      height: height,
      child: Padding(padding: padding, child: child ?? _buildSlots(context)),
    );
    return safeArea ? SafeArea(bottom: false, child: content) : content;
  }

  Widget _buildSlots(BuildContext context) {
    final shouldShowBackButton =
        showBackButton ?? (Navigator.maybeOf(context)?.canPop() ?? false);
    final effectiveLeading =
        leading ??
        (shouldShowBackButton ? _BackButton(onPressed: onBackPressed) : null);
    final effectiveTrailing = trailing ?? _buildActions();
    final middle = _buildTitle(context);
    if (centerTitle) {
      // 居中按整个栏宽计算，并在左右插槽较宽时避让。
      return NavigationToolbar(
        centerMiddle: true,
        middleSpacing: 8,
        leading: effectiveLeading,
        middle: middle,
        trailing: effectiveTrailing,
      );
    }
    // 起始侧布局不预留不存在的 leading，标题与页面正文共用 16px 边距。
    return Row(
      children: <Widget>[
        if (effectiveLeading != null) ...<Widget>[
          effectiveLeading,
          if (middle != null) const SizedBox(width: 8),
        ],
        Expanded(
          child: middle == null
              ? const SizedBox.shrink()
              : Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: middle,
                ),
        ),
        if (effectiveTrailing != null) ...<Widget>[
          if (middle != null) const SizedBox(width: 8),
          effectiveTrailing,
        ],
      ],
    );
  }

  Widget? _buildActions() {
    if (actions.isEmpty) return null;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (var index = 0; index < actions.length; index++) ...<Widget>[
          if (index > 0) const SizedBox(width: 4),
          actions[index],
        ],
      ],
    );
  }

  Widget? _buildTitle(BuildContext context) {
    if (title == null && subtitle == null) return null;
    final tokens = HyperUiThemeTokens.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: centerTitle
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: <Widget>[
        if (title != null)
          DefaultTextStyle.merge(
            style: TextStyle(
              color: tokens.foreground,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.2,
              letterSpacing: -0.2,
            ),
            child: title!,
          ),
        if (subtitle != null) ...<Widget>[
          if (title != null) const SizedBox(height: 2),
          DefaultTextStyle.merge(
            style: TextStyle(
              color: tokens.mutedForeground,
              fontSize: 11,
              height: 1.2,
            ),
            child: subtitle!,
          ),
        ],
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => HyperButton(
    type: 'outline',
    icon: HyperIcons.back,
    size: 'small',
    tooltip: '返回',
    onPressed: onPressed ?? () => Navigator.maybePop(context),
  );
}
