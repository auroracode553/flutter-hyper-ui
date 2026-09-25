import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hy_ui_theme_tokens.dart';

enum HyTextStyle { display, title, heading, body, caption, hint }

class HyText extends StatelessWidget {
  const HyText(
    this.data, {
    super.key,
    this.variant = HyTextStyle.body,
    this.color,
    this.weight,
    this.maxLines,
    this.textAlign,
  });
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
      HyTextStyle.display => 36.0,
      HyTextStyle.title => 28.0,
      HyTextStyle.heading => 20.0,
      HyTextStyle.body => 14.0,
      HyTextStyle.caption => 13.0,
      HyTextStyle.hint => 12.0,
    };
    return Text(
      data,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: size,
        height: 1.4,
        fontWeight: weight ?? (size >= 20 ? FontWeight.w700 : FontWeight.w400),
        color:
            color ?? (size < 14 ? tokens.mutedForeground : tokens.foreground),
      ),
    );
  }
}

abstract final class HyIcons {
  static const home = LucideIcons.house;
  static const search = LucideIcons.search;
  static const settings = LucideIcons.settings;
  static const profile = LucideIcons.user;
  static const cart = LucideIcons.shoppingBag;
  static const back = LucideIcons.chevronLeft;
  static const close = LucideIcons.x;
  static const success = LucideIcons.circleCheckBig;
  static const warning = LucideIcons.triangleAlert;
  static const image = LucideIcons.image;
}

class HyIcon extends StatelessWidget {
  const HyIcon(this.icon, {super.key, this.size = 24, this.color, this.label});
  final IconData icon;
  final double size;
  final Color? color;
  final String? label;
  @override
  Widget build(BuildContext context) => Icon(
    icon,
    size: size,
    color: color ?? HyUiThemeTokens.of(context).foreground,
    semanticLabel: label,
  );
}
