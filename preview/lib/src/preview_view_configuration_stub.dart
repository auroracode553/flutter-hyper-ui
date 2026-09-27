import 'package:flutter/widgets.dart';
import 'package:flutter_hyper_ui/hyper_ui_preview_core.dart';

import 'preview_catalog.dart';

class PreviewViewConfiguration {
  const PreviewViewConfiguration({
    required this.componentId,
    required this.embedded,
    required this.themeMode,
    this.safeAreaPadding = EdgeInsets.zero,
    this.onFirstFrame,
    this.onComponentReady,
    this.onComponentError,
  });

  final String componentId;
  final bool embedded;
  final HyperThemeMode themeMode;
  final EdgeInsets safeAreaPadding;
  final VoidCallback? onFirstFrame;
  final VoidCallback? onComponentReady;
  final ValueChanged<String>? onComponentError;

  factory PreviewViewConfiguration.forView(int viewId) {
    final requestedId = Uri.base.queryParameters['component'];
    return PreviewViewConfiguration(
      componentId: requestedId != null && PreviewCatalog.contains(requestedId)
          ? requestedId
          : PreviewCatalog.defaultId,
      embedded: Uri.base.queryParameters['mode'] == 'docs',
      themeMode: HyperThemeMode.system,
    );
  }
}
