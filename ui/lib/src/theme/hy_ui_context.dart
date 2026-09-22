import 'package:flutter/widgets.dart';

import 'hy_ui_theme_tokens.dart';
import 'hy_glass_theme.dart';

extension HyUiBuildContext on BuildContext {
  HyUiThemeTokens get hyUi => HyUiThemeTokens.of(this);
  HyGlassTheme get hyGlass => HyGlassTheme.of(this);
}
