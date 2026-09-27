import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hyper_ui_theme_tokens.dart';

class HyperText extends StatelessWidget {
  const HyperText(
    this.data, {
    super.key,
    this.type = 'h4',
    this.color,
    this.weight,
    this.maxLines,
    this.textAlign,
  });
  final String data;
  final String type;
  final Color? color;
  final FontWeight? weight;
  final int? maxLines;
  final TextAlign? textAlign;
  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    final size = switch (type) {
      'h1' => 36.0,
      'h2' => 28.0,
      'h3' => 20.0,
      'h4' => 14.0,
      'h5' => 13.0,
      'h6' => 12.0,
      _ => throw ArgumentError.value(type, 'type', '不支持的 HyperText type'),
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
  const HyperIcon(this.icon, {super.key, this.size = 24, this.color});
  final IconData icon;
  final double size;
  final Color? color;
  @override
  Widget build(BuildContext context) => Icon(
    icon,
    size: size,
    color: color ?? HyperUiThemeTokens.of(context).foreground,
  );
}
