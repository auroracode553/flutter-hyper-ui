import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hyper_ui_theme_tokens.dart';
import '../theme/hyper_ui_size.dart';

class HyperText extends StatelessWidget {
  const HyperText(
    this.data, {
    super.key,
    this.size = 'default',
    this.color,
    this.weight,
    this.maxLines,
    this.textAlign,
  }) : assert(
         size == 'large' || size == 'default' || size == 'small',
         'HyperText.size must be large, default, or small.',
       );
  final String data;
  final String size;
  final Color? color;
  final FontWeight? weight;
  final int? maxLines;
  final TextAlign? textAlign;
  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    final fontSize = hyperUiSizeValue(size, small: 12, normal: 14, large: 18);
    return Text(
      data,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: fontSize,
        height: 1.4,
        fontWeight:
            weight ?? (size == 'large' ? FontWeight.w700 : FontWeight.w400),
        color:
            color ??
            (size == 'small' ? tokens.mutedForeground : tokens.foreground),
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
  const HyperIcon(this.icon, {super.key, this.size = 'default', this.color});
  final IconData icon;
  final String size;
  final Color? color;
  @override
  Widget build(BuildContext context) => Icon(
    icon,
    size: hyperUiSizeValue(size, small: 18, normal: 24, large: 32),
    color: color ?? HyperUiThemeTokens.of(context).foreground,
  );
}
