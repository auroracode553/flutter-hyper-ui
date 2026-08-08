import 'package:flutter/widgets.dart';

import 'doc_ui_theme_tokens.dart';

extension DocUiBuildContext on BuildContext {
  DocUiThemeTokens get docUi => DocUiThemeTokens.of(this);
}
