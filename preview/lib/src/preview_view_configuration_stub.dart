import 'package:flutter/material.dart';

import 'preview_catalog.dart';

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
    final requestedId = Uri.base.queryParameters['component'];
    return PreviewViewConfiguration(
      componentId: requestedId != null && PreviewCatalog.contains(requestedId)
          ? requestedId
          : PreviewCatalog.defaultId,
      embedded: Uri.base.queryParameters['mode'] == 'docs',
      themeMode: ThemeMode.system,
    );
  }
}
