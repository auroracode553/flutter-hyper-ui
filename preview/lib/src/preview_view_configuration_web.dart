import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

import 'preview_catalog.dart';

extension type _PreviewInitialData._(JSObject _) implements JSObject {
  external String get componentId;
  external bool get embedded;
  external String get theme;
  external JSFunction? get onFirstFrame;
}

class PreviewViewConfiguration {
  const PreviewViewConfiguration({
    required this.componentId,
    required this.embedded,
    required this.themeMode,
    this.onFirstFrame,
  });

  final String componentId;
  final bool embedded;
  final ThemeMode themeMode;
  final VoidCallback? onFirstFrame;

  factory PreviewViewConfiguration.forView(int viewId) {
    final data = ui_web.views.getInitialData(viewId) as _PreviewInitialData?;
    final requestedId = data?.componentId;
    final callback = data?.onFirstFrame;
    return PreviewViewConfiguration(
      componentId: requestedId != null && PreviewCatalog.contains(requestedId)
          ? requestedId
          : PreviewCatalog.defaultId,
      embedded: data?.embedded ?? true,
      onFirstFrame: callback == null ? null : () { callback.callAsFunction(); },
      themeMode: switch (data?.theme) {
        'dark' => ThemeMode.dark,
        'light' => ThemeMode.light,
        _ => ThemeMode.system,
      },
    );
  }
}
