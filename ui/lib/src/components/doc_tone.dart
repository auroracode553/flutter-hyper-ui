import 'package:flutter/material.dart';

import '../theme/doc_ui_theme_tokens.dart';

enum DocUiTone {
  neutral,
  primary,
  success,
  warning,
  error,
  info,
}

extension DocUiToneResolver on DocUiTone {
  Color color(DocUiThemeTokens tokens) {
    return switch (this) {
      DocUiTone.neutral => tokens.mutedForeground,
      DocUiTone.primary => tokens.primary,
      DocUiTone.success => tokens.success,
      DocUiTone.warning => tokens.warning,
      DocUiTone.error => tokens.error,
      DocUiTone.info => tokens.info,
    };
  }
}
