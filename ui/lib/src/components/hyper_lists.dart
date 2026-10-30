import 'package:flutter/widgets.dart';

import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_glass.dart';
import 'hyper_layout.dart';
import 'hyper_section_title.dart';

class HyperMenuGroup extends StatelessWidget {
  const HyperMenuGroup({
    super.key,
    required this.children,
    this.title,
    this.subtitle,
  });

  final List<Widget> children;
  final String? title;
  final String? subtitle;

  /// Tiles inside this group share its glass surface automatically.
  static bool contains(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_HyperMenuGroupScope>() !=
      null;

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (title != null) HyperSectionTitle(title!),
        HyperGlass.card(
          radius: 18,
          // 标题、分隔线和条目共享调用方的一层水平留白。
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
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
