import 'package:flutter/widgets.dart';

import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_glass.dart';
import 'hyper_layout.dart';

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

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (title != null)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 8),
            child: Text(
              title!,
              style: TextStyle(
                color: tokens.cardForeground,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        HyperGlass(
          radius: 18,
          blur: 18,
          weight: HyperGlassWeight.regular,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (var index = 0; index < children.length; index++) ...<Widget>[
                if (index > 0) const HyperDivider(indent: 14, endIndent: 14),
                children[index],
              ],
            ],
          ),
        ),
        if (subtitle != null)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 8, end: 8),
            child: Text(
              subtitle!,
              style: TextStyle(
                color: tokens.mutedForeground,
                fontSize: 12,
                height: 1.35,
              ),
            ),
          ),
      ],
    );
  }
}
