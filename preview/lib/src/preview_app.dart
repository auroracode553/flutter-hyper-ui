import 'package:flutter_hyper_ui/hy_ui.dart';
import 'package:flutter/material.dart';

import 'preview_shell.dart';

class PreviewApp extends StatefulWidget {
  const PreviewApp({super.key});

  @override
  State<PreviewApp> createState() => _PreviewAppState();
}

class _PreviewAppState extends State<PreviewApp> {
  final _theme = HyThemeController();
  @override
  void dispose() { _theme.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final componentId = Uri.base.queryParameters['component'] ?? 'atoms';
    final embedded = Uri.base.queryParameters['mode'] == 'docs';

    return ListenableBuilder(listenable: _theme, builder: (_, __) => MaterialApp(
      title: 'Flutter Hyper UI Preview',
      debugShowCheckedModeBanner: false,
      theme: HyUiTheme.light(),
      darkTheme: HyUiTheme.dark(),
      themeMode: _theme.mode,
      home: PreviewShell(
        componentId: componentId,
        embedded: embedded,
        onToggleTheme: () => _theme.setMode(_theme.mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark),
      ),
    ));
  }
}
