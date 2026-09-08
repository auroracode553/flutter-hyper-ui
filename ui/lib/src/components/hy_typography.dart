import 'package:flutter/material.dart';
import '../theme/hy_ui_theme_tokens.dart';

enum HyTextStyle { display, title, heading, body, caption, hint }

class HyText extends StatelessWidget {
  const HyText(this.data, {super.key, this.variant = HyTextStyle.body,
    this.color, this.weight, this.maxLines, this.textAlign});
  final String data;
  final HyTextStyle variant;
  final Color? color;
  final FontWeight? weight;
  final int? maxLines;
  final TextAlign? textAlign;
  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    final size = switch (variant) {
      HyTextStyle.display => 36.0, HyTextStyle.title => 28.0,
      HyTextStyle.heading => 20.0, HyTextStyle.body => 15.0,
      HyTextStyle.caption => 13.0, HyTextStyle.hint => 12.0,
    };
    return Text(data, maxLines: maxLines, textAlign: textAlign,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
      style: TextStyle(fontSize: size, height: 1.4,
        fontWeight: weight ?? (size >= 20 ? FontWeight.w700 : FontWeight.w400),
        color: color ?? (size < 15 ? tokens.mutedForeground : tokens.foreground)));
  }
}

abstract final class HyIcons {
  static const home = Icons.home_rounded;
  static const search = Icons.search_rounded;
  static const settings = Icons.settings_rounded;
  static const profile = Icons.person_rounded;
  static const cart = Icons.shopping_bag_rounded;
  static const back = Icons.arrow_back_ios_new_rounded;
  static const close = Icons.close_rounded;
  static const success = Icons.check_circle_rounded;
  static const warning = Icons.warning_amber_rounded;
  static const image = Icons.image_rounded;
}

class HyIcon extends StatelessWidget {
  const HyIcon(this.icon, {super.key, this.size = 24, this.color, this.label});
  final IconData icon;
  final double size;
  final Color? color;
  final String? label;
  @override
  Widget build(BuildContext context) => Icon(icon, size: size,
    color: color ?? HyUiThemeTokens.of(context).foreground, semanticLabel: label);
}
