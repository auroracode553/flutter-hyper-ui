import 'package:flutter/material.dart';
import '../theme/hy_ui_theme_tokens.dart';
import 'hy_glass.dart';
import 'hy_tone.dart';

abstract final class HyToast {
  static void show(BuildContext context, String message, {
    HyUiTone tone = HyUiTone.neutral, Duration duration = const Duration(seconds: 2)}) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(duration: duration, content: Row(children: [
      Icon(tone == HyUiTone.success ? Icons.check_circle_outline
        : tone == HyUiTone.error ? Icons.error_outline : Icons.info_outline,
        color: HyUiThemeTokens.of(context).background, size: 20),
      const SizedBox(width: 10), Expanded(child: Text(message)),
    ])));
  }
}

abstract final class HyDialog {
  static Future<bool?> confirm(BuildContext context, {required String title,
    String? message, Widget? content, String confirmLabel = '确定',
    String cancelLabel = '取消', bool dangerous = false, bool showCancel = true}) =>
    showDialog<bool>(context: context, builder: (dialogContext) => Dialog(
      backgroundColor: Colors.transparent, elevation: 0,
      child: HyGlass(padding: const EdgeInsets.all(24), child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16), content ?? Text(message ?? ''),
            const SizedBox(height: 24), Wrap(alignment: WrapAlignment.end, spacing: 8, children: [
              if (showCancel) TextButton(onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(cancelLabel)),
              FilledButton(style: dangerous ? FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error) : null,
                onPressed: () => Navigator.pop(dialogContext, true), child: Text(confirmLabel)),
            ]),
          ])))));
}

class HyLoading extends StatelessWidget {
  const HyLoading({super.key, this.label, this.size = 24});
  final String? label;
  final double size;
  @override
  Widget build(BuildContext context) => Semantics(label: label ?? '正在加载',
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      SizedBox.square(dimension: size, child: const CircularProgressIndicator(strokeWidth: 2.5)),
      if (label != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(label!)),
    ]));
  /// 任务结束时仅移除自己的浮层，不操作业务页面路由。
  static Future<T> during<T>(BuildContext context, Future<T> Function() task,
    {String label = '请稍候'}) async {
    final entry = OverlayEntry(builder: (_) => Stack(children: [
      const ModalBarrier(dismissible: false, color: Color(0x33000000)),
      Center(child: HyGlass(padding: const EdgeInsets.all(28), child: HyLoading(label: label))),
    ]));
    Overlay.of(context, rootOverlay: true).insert(entry);
    try { return await task(); } finally { entry.remove(); entry.dispose(); }
  }
}

class HyAlert extends StatelessWidget {
  const HyAlert({super.key, required this.message, this.title,
    this.tone = HyUiTone.info, this.onClose});
  final String message;
  final String? title;
  final HyUiTone tone;
  final VoidCallback? onClose;
  @override
  Widget build(BuildContext context) {
    final color = tone.color(HyUiThemeTokens.of(context));
    return HyGlass(radius: 18, blur: 0, borderColor: color.withAlpha(60),
      color: Color.alphaBlend(color.withAlpha(18), HyUiThemeTokens.of(context).card),
      padding: const EdgeInsets.all(14), child: Row(children: [
        Icon(tone == HyUiTone.success ? Icons.check_circle_outline
          : tone == HyUiTone.error ? Icons.error_outline : Icons.info_outline, color: color),
        const SizedBox(width: 12), Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (title != null) Text(title!, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(message),
          ])),
        if (onClose != null) IconButton(tooltip: '关闭通知', onPressed: onClose,
          icon: const Icon(Icons.close, size: 18)),
      ]));
  }
}
