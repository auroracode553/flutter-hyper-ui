import 'package:flutter/material.dart';

import '../theme/hyper_ui_theme_tokens.dart';

enum HyperUiTone { neutral, primary, success, warning, error, info }

extension HyperUiToneResolver on HyperUiTone {
  Color color(HyperUiThemeTokens tokens) {
    return switch (this) {
      HyperUiTone.neutral => tokens.mutedForeground,
      HyperUiTone.primary => tokens.primary,
      HyperUiTone.success => tokens.success,
      HyperUiTone.warning => tokens.warning,
      HyperUiTone.error => tokens.error,
      HyperUiTone.info => tokens.info,
    };
  }
}
