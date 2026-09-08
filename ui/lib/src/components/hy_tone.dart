import 'package:flutter/material.dart';

import '../theme/hy_ui_theme_tokens.dart';

enum HyUiTone {
  neutral,
  primary,
  success,
  warning,
  error,
  info,
}

extension HyUiToneResolver on HyUiTone {
  Color color(HyUiThemeTokens tokens) {
    return switch (this) {
      HyUiTone.neutral => tokens.mutedForeground,
      HyUiTone.primary => tokens.primary,
      HyUiTone.success => tokens.success,
      HyUiTone.warning => tokens.warning,
      HyUiTone.error => tokens.error,
      HyUiTone.info => tokens.info,
    };
  }
}
