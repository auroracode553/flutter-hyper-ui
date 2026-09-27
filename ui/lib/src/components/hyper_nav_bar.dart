import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_button.dart';

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
    this.spacing = 8,
    this.titleSpacing = 2,
    this.actionSpacing = 4,
    this.safeArea = true,
    this.automaticallyImplyLeading = true,
    this.centerTitle = false,
  }) : assert(height > 0 && height < double.infinity),
       assert(spacing >= 0 && spacing < double.infinity),
       assert(titleSpacing >= 0 && titleSpacing < double.infinity),
       assert(actionSpacing >= 0 && actionSpacing < double.infinity),
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

  /// 主内容与左右插槽之间的间距，不为缺失的插槽额外占位。
  final double spacing;
  final double titleSpacing;
  final double actionSpacing;
  final bool safeArea;
  final bool automaticallyImplyLeading;

  /// 仅对默认插槽布局有效。默认 false，沿文字方向从起始侧排列。
  final bool centerTitle;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    // 集合校验放在构建阶段，保证自定义插槽仍可使用 const 构造。
    assert(
      trailing == null || actions.isEmpty,
      'trailing 与 actions 二选一，避免插槽内容被静默覆盖。',
    );
    assert(child == null || actions.isEmpty, 'child 接管整行布局，不能同时设置 actions。');
    final content = SizedBox(
      height: height,
      child: Padding(padding: padding, child: child ?? _buildSlots(context)),
    );
    return safeArea ? SafeArea(bottom: false, child: content) : content;
  }

  Widget _buildSlots(BuildContext context) {
    final effectiveLeading =
        leading ??
        (automaticallyImplyLeading &&
                (Navigator.maybeOf(context)?.canPop() ?? false)
            ? const _BackButton()
            : null);
    final effectiveTrailing = trailing ?? _buildActions();
    final middle = _buildTitle(context);
    if (centerTitle) {
      // 居中按整个栏宽计算，并在左右插槽较宽时避让。
      return NavigationToolbar(
        centerMiddle: true,
        middleSpacing: spacing,
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
          if (middle != null) SizedBox(width: spacing),
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
          if (middle != null) SizedBox(width: spacing),
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
          if (index > 0) SizedBox(width: actionSpacing),
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
          if (title != null) SizedBox(height: titleSpacing),
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
  const _BackButton();

  @override
  Widget build(BuildContext context) => HyperButton.icon(
    icon: LucideIcons.chevronLeft,
    type: 'ghost',
    height: 44,
    iconSize: 20,
    tooltip: '返回',
    onPressed: () => Navigator.maybePop(context),
  );
}
