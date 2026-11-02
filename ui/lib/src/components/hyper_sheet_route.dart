import 'package:flutter/widgets.dart';
import '../theme/hyper_surface_theme.dart';
import '../theme/hyper_ui_spacing.dart';
import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_glass.dart';
import 'hyper_control_surface.dart';
import 'hyper_surface_scope.dart';
import 'hyper_modal.dart';

/// 内部底部面板路由：动作面板与日期选择复用尺寸、滚动、IME 和退出生命周期。
Future<T?> showHySheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  String? title,
  bool dismissible = true,
  bool fixedGlass = false,
}) {
  final glass = HyperSurfaceTheme.of(context);
  return showHyperModal<T>(
    context,
    alignment: Alignment.bottomCenter,
    dismissible: dismissible,
    scrim: glass.scrim,
    builder: (sheetContext) {
      final tokens = HyperUiThemeTokens.of(sheetContext);
      return LayoutBuilder(
        builder: (context, constraints) {
          final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
          final availableHeight = (constraints.maxHeight - keyboardInset).clamp(
            0.0,
            constraints.maxHeight,
          );
          return Padding(
            padding: EdgeInsets.only(bottom: keyboardInset),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: availableHeight * .85),
              child: _sheetSurface(
                fixedGlass,
                SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Container(
                            width: 32,
                            height: 4,
                            margin: const EdgeInsets.only(
                              bottom: HyperUiSpacing.md,
                            ),
                            decoration: BoxDecoration(
                              color: tokens.border,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        if (title != null)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: HyperUiSpacing.md,
                            ),
                            child: Text(
                              title,
                              style: TextStyle(
                                color: tokens.foreground,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        builder(sheetContext),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _sheetSurface(bool glass, Widget child) => glass
    ? HyperSurfaceScope(
        child: HyperControlSurface(
          radius: 30,
          role: HyperControlSurfaceRole.dialog,
          child: Padding(
            padding: const EdgeInsets.all(HyperUiSpacing.md),
            child: child,
          ),
        ),
      )
    : HyperGlass(
        radius: 30,
        type: 'prominent',
        padding: const EdgeInsets.all(HyperUiSpacing.md),
        child: child,
      );
