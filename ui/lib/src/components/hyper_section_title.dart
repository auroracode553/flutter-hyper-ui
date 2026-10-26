import 'package:flutter/widgets.dart';

import '../theme/hyper_ui_theme_tokens.dart';

/// 独立分组标题与菜单标题共用排版；页面负责外部间距。
class HyperSectionTitle extends StatelessWidget {
  const HyperSectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      color: HyperUiThemeTokens.of(context).cardForeground,
      fontSize: 14,
      fontWeight: FontWeight.w700,
    ),
  );
}
