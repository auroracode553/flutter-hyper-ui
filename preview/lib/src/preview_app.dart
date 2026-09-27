import 'package:flutter_hyper_ui/hyper_ui_preview_core.dart';
import 'package:flutter/widgets.dart';

import 'preview_shell.dart';
import 'preview_view_configuration.dart';

class PreviewApp extends StatefulWidget {
  const PreviewApp({super.key, required this.configuration});

  final PreviewViewConfiguration configuration;

  @override
  State<PreviewApp> createState() => _PreviewAppState();
}

class _PreviewAppState extends State<PreviewApp> {
  late final _theme = HyperThemeController(
    mode: widget.configuration.themeMode,
  );

  @override
  void initState() {
    super.initState();
    // 框架占位首帧先显示；当前组件的完成信号由异步内容单独发送。
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.configuration.onFirstFrame?.call();
    });
  }

  @override
  void dispose() {
    _theme.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _theme,
      builder: (_, _) {
        final dark = switch (_theme.mode) {
          HyperThemeMode.dark => true,
          HyperThemeMode.light => false,
          HyperThemeMode.system =>
            MediaQuery.platformBrightnessOf(context) == Brightness.dark,
        };
        return HyperUiTheme.app(
          title: 'Flutter Hyper UI Preview',
          brightness: dark ? Brightness.dark : Brightness.light,
          primary: _theme.primary,
          builder: (context, child) {
            final media = MediaQuery.of(context);
            final padding = widget.configuration.safeAreaPadding;
            if (padding == EdgeInsets.zero) return child!;
            return MediaQuery(
              data: media.copyWith(padding: padding, viewPadding: padding),
              child: child!,
            );
          },
          home: PreviewShell(
            componentId: widget.configuration.componentId,
            embedded: widget.configuration.embedded,
            onToggleTheme: () => _theme.setMode(
              _theme.mode == HyperThemeMode.dark
                  ? HyperThemeMode.light
                  : HyperThemeMode.dark,
            ),
            onComponentReady: widget.configuration.onComponentReady,
            onComponentError: widget.configuration.onComponentError,
          ),
        );
      },
    );
  }
}
