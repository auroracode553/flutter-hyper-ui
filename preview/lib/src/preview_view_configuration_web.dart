import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

import 'preview_catalog.dart';

extension type _PreviewInitialData._(JSObject _) implements JSObject {
  external String get componentId;
  external bool get embedded;
  external String get theme;
  external JSFunction? get onFirstFrame;
  external JSFunction? get onComponentReady;
  external JSFunction? get onComponentError;
}

class PreviewViewConfiguration {
  const PreviewViewConfiguration({
    required this.componentId,
    required this.embedded,
    required this.themeMode,
    this.onFirstFrame,
    this.onComponentReady,
    this.onComponentError,
  });

  final String componentId;
  final bool embedded;
  final ThemeMode themeMode;
  final VoidCallback? onFirstFrame;
  final VoidCallback? onComponentReady;
  final ValueChanged<String>? onComponentError;

  factory PreviewViewConfiguration.forView(int viewId) {
    final data = ui_web.views.getInitialData(viewId) as _PreviewInitialData?;
    final requestedId = data?.componentId;
    final callback = data?.onFirstFrame;
    final readyCallback = data?.onComponentReady;
    final errorCallback = data?.onComponentError;
    return PreviewViewConfiguration(
      componentId: requestedId != null && PreviewCatalog.contains(requestedId)
          ? requestedId
          : PreviewCatalog.defaultId,
      embedded: data?.embedded ?? true,
      onFirstFrame: callback == null ? null : () { callback.callAsFunction(); },
      onComponentReady: readyCallback == null ? null : () { readyCallback.callAsFunction(); },
      onComponentError: errorCallback == null
          ? null
          : (message) { errorCallback.callAsFunction(null, message.toJS); },
      themeMode: switch (data?.theme) {
        'dark' => ThemeMode.dark,
        'light' => ThemeMode.light,
        _ => ThemeMode.system,
      },
    );
  }
}
