import 'package:flutter/widgets.dart';

import 'hyper_ui_theme_tokens.dart';
import 'hyper_glass_theme.dart';

extension HyperUiBuildContext on BuildContext {
  HyperUiThemeTokens get hyperUi => HyperUiThemeTokens.of(this);
  HyperGlassTheme get hyperGlass => HyperGlassTheme.of(this);
}
