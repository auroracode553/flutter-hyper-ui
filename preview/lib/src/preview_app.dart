import 'package:flutter_hyper_ui/doc_ui.dart';
import 'package:flutter/material.dart';

import 'preview_shell.dart';

class PreviewApp extends StatelessWidget {
  const PreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    final componentId = Uri.base.queryParameters['component'] ?? 'overview';
    final embedded = Uri.base.queryParameters['mode'] == 'docs';

    return MaterialApp(
      title: 'Flutter Hyper UI Preview',
      debugShowCheckedModeBanner: false,
      theme: DocUiTheme.light(),
      darkTheme: DocUiTheme.dark(),
      home: PreviewShell(
        componentId: componentId,
        embedded: embedded,
      ),
    );
  }
}
