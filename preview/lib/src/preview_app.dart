import 'package:flutter_hyper_ui/hy_ui.dart';
import 'package:flutter/material.dart';

import 'preview_shell.dart';
import 'preview_view_configuration.dart';

class PreviewApp extends StatefulWidget {
  const PreviewApp({super.key, required this.configuration});

  final PreviewViewConfiguration configuration;

  @override
  State<PreviewApp> createState() => _PreviewAppState();
}

class _PreviewAppState extends State<PreviewApp> {
  late final _theme = HyThemeController(mode: widget.configuration.themeMode);

  @override
  void dispose() {
    _theme.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _theme,
      builder: (_, __) => MaterialApp(
        title: 'Flutter Hyper UI Preview',
        debugShowCheckedModeBanner: false,
        theme: HyUiTheme.light(),
        darkTheme: HyUiTheme.dark(),
        themeMode: _theme.mode,
        home: PreviewShell(
          componentId: widget.configuration.componentId,
          embedded: widget.configuration.embedded,
          onToggleTheme: () => _theme.setMode(
            _theme.mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
          ),
        ),
      ),
    );
  }
}
