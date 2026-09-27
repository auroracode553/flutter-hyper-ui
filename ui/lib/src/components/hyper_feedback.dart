import 'package:flutter/widgets.dart';
import 'hyper_progress_painters.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hyper_glass_theme.dart';
import '../theme/hyper_ui_theme_tokens.dart';
import '../theme/hyper_ui_theme.dart';
import 'hyper_button.dart';
import 'hyper_glass.dart';
import 'hyper_modal.dart';
import 'hyper_pressable.dart';
import 'hyper_tone.dart';

/// 无全局状态的玻璃轻提示。
abstract final class HyperToast {
  static void show(
    BuildContext context,
    String message, {
    HyperUiTone tone = HyperUiTone.neutral,
    Duration duration = const Duration(seconds: 2),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final tokens = HyperUiThemeTokens.of(context);
    final toneColor = tone.color(tokens);
    final theme = HyperUiTheme.of(context);
    late final OverlayEntry entry;
    var visible = true;
    void hide() {
      if (!visible) return;
      visible = false;
      entry.remove();
      entry.dispose();
    }

    entry = OverlayEntry(
      builder: (overlayContext) => HyperUiTheme(
        data: theme,
        child: Positioned(
          left: 16,
          right: 16,
          bottom: 96,
          child: Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 180, maxWidth: 420),
              child: HyperGlass(
                radius: 18,
                blur: 28,
                weight: HyperGlassWeight.prominent,
                color: Color.alphaBlend(toneColor.withAlpha(10), tokens.card),
                borderColor: toneColor.withAlpha(105),
                padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: toneColor.withAlpha(24),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(_iconFor(tone), color: toneColor, size: 17),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        message,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: tokens.foreground,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.35,
                        ),
                      ),
                    ),
                    if (actionLabel != null && onAction != null)
                      HyperPressable(
                        onPressed: () {
                          hide();
                          onAction();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          child: Text(
                            actionLabel,
                            style: TextStyle(
                              color: toneColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(entry);
    Future<void>.delayed(duration, hide);
  }

  static IconData _iconFor(HyperUiTone tone) => switch (tone) {
    HyperUiTone.primary => LucideIcons.sparkles,
    HyperUiTone.success => LucideIcons.check,
    HyperUiTone.warning => LucideIcons.circleAlert,
    HyperUiTone.error => LucideIcons.x,
    HyperUiTone.info => LucideIcons.info,
    HyperUiTone.neutral => LucideIcons.bell,
  };
}

abstract final class HyperDialog {
  static Future<bool?> confirm(
    BuildContext context, {
    required String title,
    String? message,
    Widget? content,
    String confirmLabel = '确定',
    String cancelLabel = '取消',
    bool dangerous = false,
    bool showCancel = true,
  }) {
    return showHyperModal<bool>(
      context,
      builder: (dialogContext) => ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: HyperGlass(
          radius: 26,
          blur: 30,
          weight: HyperGlassWeight.prominent,
          padding: const EdgeInsets.all(18),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    color: HyperUiThemeTokens.of(context).foreground,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (content != null ||
                    (message?.isNotEmpty ?? false)) ...<Widget>[
                  const SizedBox(height: 10),
                  content ?? Text(message!),
                ],
                const SizedBox(height: 18),
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 8,
                  runSpacing: 8,
                  children: <Widget>[
                    if (showCancel)
                      HyperButton.ghost(
                        label: cancelLabel,
                        onPressed: () => Navigator.pop(dialogContext, false),
                      ),
                    dangerous
                        ? HyperButton.danger(
                            label: confirmLabel,
                            onPressed: () => Navigator.pop(dialogContext, true),
                          )
                        : HyperButton.filled(
                            label: confirmLabel,
                            onPressed: () => Navigator.pop(dialogContext, true),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HyperLoading extends StatelessWidget {
  const HyperLoading({super.key, this.label, this.size = 24});

  final String? label;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox.square(
          dimension: size,
          child: const HyperSpinner(strokeWidth: 2.5),
        ),
        if (label != null)
          Padding(padding: const EdgeInsets.only(top: 12), child: Text(label!)),
      ],
    );
  }

  /// 任务结束时只移除自己的浮层，不操作业务路由。
  static Future<T> during<T>(
    BuildContext context,
    Future<T> Function() task, {
    String label = '请稍候',
  }) async {
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (overlayContext) => Stack(
        children: <Widget>[
          ModalBarrier(
            dismissible: false,
            color: HyperGlassTheme.of(overlayContext).scrim,
          ),
          Center(
            child: HyperGlass(
              radius: 24,
              blur: 30,
              weight: HyperGlassWeight.prominent,
              padding: const EdgeInsets.all(20),
              child: HyperLoading(label: label),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(entry);
    try {
      return await task();
    } finally {
      entry.remove();
      entry.dispose();
    }
  }
}
