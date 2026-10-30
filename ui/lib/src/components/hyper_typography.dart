import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hyper_ui_theme_tokens.dart';

class HyperText extends StatelessWidget {
  const HyperText(
    this.text, {
    super.key,

    this.color,
    this.fontWeight,
    this.maxLines,
    this.textAlign,
  });
  final String text;

  final Color? color;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextAlign? textAlign;
  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    // 默认档继承宿主插槽排版，独立使用时回落到组件基准。
    final inheritedStyle = context
        .dependOnInheritedWidgetOfExactType<DefaultTextStyle>()
        ?.style;
    final fontSize = inheritedStyle?.fontSize ?? 14;
    return Text(
      text,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: fontSize,
        height: inheritedStyle?.height ?? 1.4,
        fontWeight: fontWeight ?? inheritedStyle?.fontWeight ?? FontWeight.w400,
        color: color ?? inheritedStyle?.color ?? tokens.foreground,
      ),
    );
  }
}

abstract final class HyperIcons {
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

class HyperIcon extends StatelessWidget {
  const HyperIcon(this.icon, {super.key, this.color});
  final IconData icon;

  final Color? color;
  @override
  Widget build(BuildContext context) {
    final inheritedTheme = context
        .dependOnInheritedWidgetOfExactType<IconTheme>()
        ?.data;
    return Icon(
      icon,
      size: inheritedTheme?.size ?? 24,
      color:
          color ??
          inheritedTheme?.color ??
          HyperUiThemeTokens.of(context).foreground,
    );
  }
}
