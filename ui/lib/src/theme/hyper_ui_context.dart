import 'package:flutter/widgets.dart';

import 'hyper_ui_theme_tokens.dart';
import 'hyper_surface_theme.dart';

extension HyperUiBuildContext on BuildContext {
  HyperUiThemeTokens get hyperUi => HyperUiThemeTokens.of(this);
  HyperSurfaceTheme get hyperSurfaces => HyperSurfaceTheme.of(this);
}
