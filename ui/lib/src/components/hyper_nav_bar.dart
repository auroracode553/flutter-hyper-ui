import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hyper_glass_theme.dart';
import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_button.dart';
import 'hyper_typography.dart';

/// 固定布局类型；custom 保留完整 Widget 插槽。
abstract final class HyperNavBarTypes {
  static const custom = 'custom';
  static const backOnly = 'backOnly';
  static const titleOnly = 'titleOnly';
  static const backWithTitle = 'backWithTitle';
  static const more = 'more';
  static const edit = 'edit';

  static const values = <String>{
    custom,
    backOnly,
    titleOnly,
    backWithTitle,
    more,
    edit,
  };
}

/// 透明导航容器；固定 type 生成常见布局，custom 使用完整插槽。
///
/// [leading]、[title]、[subtitle]、[trailing] 都接受任意 Widget。
/// [child] 可完全接管内部布局；此时不生成自动返回按钮或默认标题布局。
/// [height] 不包含安全区。
class HyperNavBar extends StatelessWidget implements PreferredSizeWidget {
  const HyperNavBar({
    super.key,
    this.type = HyperNavBarTypes.custom,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.actions = const <Widget>[],
    this.child,
    this.height = 44,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.safeArea = true,
    this.onBackPressed,
    this.onMorePressed,
    this.onSavePressed,
    this.centerTitle = false,
  }) : assert(height > 0 && height < double.infinity);

  final String type;

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

  /// 固定返回类型的回调；未传入时调用 Navigator.maybePop。
  final VoidCallback? onBackPressed;
  final VoidCallback? onMorePressed;
  final VoidCallback? onSavePressed;

  /// 仅对默认插槽布局有效。默认 false，沿文字方向从起始侧排列。
  final bool centerTitle;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    if (!HyperNavBarTypes.values.contains(type)) {
      throw ArgumentError.value(type, 'type', 'Unsupported HyperNavBar type');
    }
    if (type != HyperNavBarTypes.custom &&
        (leading != null ||
            trailing != null ||
            actions.isNotEmpty ||
            child != null ||
            subtitle != null ||
            centerTitle)) {
      throw ArgumentError(
        'Fixed HyperNavBar types accept title and callbacks only; use custom for slots.',
      );
    }
    if (type == HyperNavBarTypes.backOnly && title != null) {
      throw ArgumentError('backOnly does not accept title.');
    }
    if (type != HyperNavBarTypes.custom &&
        type != HyperNavBarTypes.backOnly &&
        title == null) {
      throw ArgumentError('This HyperNavBar type requires title.');
    }
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
    final fixed = type != HyperNavBarTypes.custom;
    final effectiveLeading = fixed
        ? type == HyperNavBarTypes.titleOnly
              ? null
              : _BackButton(onPressed: onBackPressed)
        : leading;
    final effectiveTrailing = fixed
        ? switch (type) {
            HyperNavBarTypes.more => HyperButton(
              type: 'ghost',
              icon: LucideIcons.ellipsis,
              tooltip: '更多',
              backgroundColor: HyperGlassTheme.of(context).surfaceStrong,
              onPressed: onMorePressed ?? () {},
            ),
            HyperNavBarTypes.edit => HyperButton(
              type: 'ghost',
              label: '保存',
              size: 'small',
              onPressed: onSavePressed ?? () {},
            ),
            _ => null,
          }
        : trailing ?? _buildActions();
    final middle = type == HyperNavBarTypes.backOnly
        ? null
        : _buildTitle(context);
    if (centerTitle) {
      // 居中按整个栏宽计算，并在左右插槽较宽时避让。
      return NavigationToolbar(
        centerMiddle: true,
        middleSpacing: 8,
        // NavigationToolbar 会收紧 leading 的高度；先居中，避免圆形按钮被拉伸。
        leading: effectiveLeading == null
            ? null
            : Align(
                alignment: AlignmentDirectional.centerStart,
                widthFactor: 1,
                child: effectiveLeading,
              ),
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
    // 固定类型使用连续玻璃表面，保持与 Compose 预览相同的白色浮层效果。
    type: 'ghost',
    icon: HyperIcons.back,
    tooltip: '返回',
    backgroundColor: HyperGlassTheme.of(context).surfaceStrong,
    onPressed: onPressed ?? () => Navigator.maybePop(context),
  );
}
