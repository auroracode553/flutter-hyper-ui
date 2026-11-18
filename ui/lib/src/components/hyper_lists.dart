import 'package:flutter/widgets.dart';

import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_glass.dart';
import 'hyper_layout.dart';
import 'hyper_surface_scope.dart';

class HyperMenuGroup extends StatelessWidget {
  // 普通分组与 sliver 分组共用四边等距的外框，不与行内留白混用。
  static const _contentPadding = EdgeInsets.all(4);

  const HyperMenuGroup({
    super.key,
    required this.children,
    this.title,
    this.subtitle,
  }) : _sliver = null;

  /// 在 CustomScrollView 中为懒加载列表或网格提供一层共用分组表面。
  /// 条目、分隔线及稳定键由传入的 sliver 管理，不创建嵌套滚动区域。
  const HyperMenuGroup.sliver({
    super.key,
    required Widget sliver,
    this.title,
    this.subtitle,
  }) : _sliver = sliver,
       children = const [];

  final List<Widget> children;
  final String? title;
  final String? subtitle;
  final Widget? _sliver;

  /// Tiles inside this group share its card surface automatically.
  static bool contains(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_HyperMenuGroupScope>() !=
      null;

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    if (_sliver != null) {
      return SliverMainAxisGroup(
        slivers: [
          if (title != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  title!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          DecoratedSliver(
            decoration: HyperGlass.cardDecoration(context, radius: 18),
            sliver: HyperSurfaceScope(
              child: _HyperMenuGroupScope(
                child: SliverPadding(padding: _contentPadding, sliver: _sliver),
              ),
            ),
          ),
          if (subtitle != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  subtitle!,
                  style: TextStyle(
                    color: tokens.mutedForeground,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ),
            ),
        ],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (title != null)
          Text(
            title!,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
        HyperGlass.card(
          radius: 18,
          // 分组边缘留白保护行背景，不替代条目背景内部的内容留白。
          padding: _contentPadding,
          child: _HyperMenuGroupScope(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for (
                  var index = 0;
                  index < children.length;
                  index++
                ) ...<Widget>[
                  if (index > 0) const HyperDivider(),
                  children[index],
                ],
              ],
            ),
          ),
        ),
        if (subtitle != null)
          Text(
            subtitle!,
            style: TextStyle(
              color: tokens.mutedForeground,
              fontSize: 12,
              height: 1.35,
            ),
          ),
      ],
    );
  }
}

class _HyperMenuGroupScope extends InheritedWidget {
  const _HyperMenuGroupScope({required super.child});

  @override
  bool updateShouldNotify(_HyperMenuGroupScope oldWidget) => false;
}
