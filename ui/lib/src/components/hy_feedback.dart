import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hy_glass_theme.dart';
import '../theme/hy_ui_theme_tokens.dart';
import 'hy_button.dart';
import 'hy_glass.dart';
import 'hy_icon_button.dart';
import 'hy_pressable.dart';
import 'hy_tone.dart';

/// 无全局状态的玻璃轻提示。
abstract final class HyToast {
  static void show(
    BuildContext context,
    String message, {
    HyUiTone tone = HyUiTone.neutral,
    Duration duration = const Duration(seconds: 2),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final tokens = HyUiThemeTokens.of(context);
    final toneColor = tone.color(tokens);
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: duration,
          backgroundColor: Colors.transparent,
          elevation: 0,
          padding: EdgeInsets.zero,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          behavior: SnackBarBehavior.floating,
          dismissDirection: DismissDirection.down,
          content: HyGlass(
            radius: 18,
            blur: 28,
            weight: HyGlassWeight.prominent,
            borderColor: toneColor.withAlpha(65),
            padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
            child: Row(
              children: <Widget>[
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: toneColor.withAlpha(28),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(_iconFor(tone), color: toneColor, size: 16),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: tokens.foreground,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (actionLabel != null && onAction != null)
                  HyPressable(
                    onPressed: () {
                      messenger.hideCurrentSnackBar();
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
      );
  }

  static IconData _iconFor(HyUiTone tone) => switch (tone) {
    HyUiTone.primary => LucideIcons.sparkles,
    HyUiTone.success => LucideIcons.check,
    HyUiTone.warning => LucideIcons.circleAlert,
    HyUiTone.error => LucideIcons.x,
    HyUiTone.info => LucideIcons.info,
    HyUiTone.neutral => LucideIcons.bell,
  };
}

abstract final class HyDialog {
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
    return showDialog<bool>(
      context: context,
      barrierColor: HyGlassTheme.of(context).scrim,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: HyGlass(
          radius: 26,
          blur: 30,
          weight: HyGlassWeight.prominent,
          padding: const EdgeInsets.all(18),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(title, style: Theme.of(context).textTheme.titleLarge),
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
                      HyButton.ghost(
                        label: cancelLabel,
                        onPressed: () => Navigator.pop(dialogContext, false),
                      ),
                    dangerous
                        ? HyButton.danger(
                            label: confirmLabel,
                            onPressed: () => Navigator.pop(dialogContext, true),
                          )
                        : HyButton.filled(
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

class HyLoading extends StatelessWidget {
  const HyLoading({super.key, this.label, this.size = 24});

  final String? label;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label ?? '正在加载',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox.square(
            dimension: size,
            child: const CircularProgressIndicator(strokeWidth: 2.5),
          ),
          if (label != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(label!),
            ),
        ],
      ),
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
            color: HyGlassTheme.of(overlayContext).scrim,
          ),
          Center(
            child: HyGlass(
              radius: 24,
              blur: 30,
              weight: HyGlassWeight.prominent,
              padding: const EdgeInsets.all(20),
              child: HyLoading(label: label),
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

class HyAlert extends StatelessWidget {
  const HyAlert({
    super.key,
    required this.message,
    this.title,
    this.tone = HyUiTone.info,
    this.onClose,
  });

  final String message;
  final String? title;
  final HyUiTone tone;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final tokens = HyUiThemeTokens.of(context);
    final color = tone.color(tokens);
    return HyGlass(
      radius: 18,
      blur: 14,
      weight: HyGlassWeight.subtle,
      borderColor: color.withAlpha(60),
      color: Color.alphaBlend(
        color.withAlpha(16),
        HyGlassTheme.of(context).surface,
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: <Widget>[
          Icon(HyToast._iconFor(tone), color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (title != null)
                  Text(
                    title!,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                Text(message),
              ],
            ),
          ),
          if (onClose != null)
            HyIconButton(
              icon: LucideIcons.x,
              size: 28,
              iconSize: 18,
              tooltip: '关闭通知',
              onPressed: onClose,
            ),
        ],
      ),
    );
  }
}
