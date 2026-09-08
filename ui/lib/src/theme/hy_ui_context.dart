import 'package:flutter/widgets.dart';

import 'hy_ui_theme_tokens.dart';

extension HyUiBuildContext on BuildContext {
  HyUiThemeTokens get hyUi => HyUiThemeTokens.of(this);
}
