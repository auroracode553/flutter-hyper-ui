import 'package:flutter/material.dart';
import 'package:flutter_hyper_ui/hy_ui_preview_core.dart';

import 'preview_catalog.dart';

/// 只在当前视图需要时加载示例模块，并在真实组件提交首帧后通知宿主。
class PreviewDeferredContent extends StatefulWidget {
  const PreviewDeferredContent({
    super.key,
    required this.item,
    this.onReady,
    this.onError,
  });

  final PreviewItem item;
  final VoidCallback? onReady;
  final ValueChanged<String>? onError;

  @override
  State<PreviewDeferredContent> createState() => _PreviewDeferredContentState();
}

class _PreviewDeferredContentState extends State<PreviewDeferredContent> {
  late Future<void> _loading = widget.item.loadLibrary();
  bool _reportedReady = false;
  bool _reportedError = false;

  @override
  void didUpdateWidget(covariant PreviewDeferredContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.id != widget.item.id) _reload();
  }

  void _reload() {
    _reportedReady = false;
    _reportedError = false;
    _loading = widget.item.loadLibrary();
  }

  void _retry() => setState(_reload);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loading,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _PreviewLoading();
        }
        if (snapshot.hasError) {
          final message = snapshot.error.toString();
          if (!_reportedError) {
            _reportedError = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) widget.onError?.call(message);
            });
          }
          return _PreviewLoadError(message: message, onRetry: _retry);
        }

        final content = widget.item.builder(context);
        if (!_reportedReady) {
          _reportedReady = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) widget.onReady?.call();
          });
        }
        return content;
      },
    );
  }
}

class _PreviewLoading extends StatelessWidget {
  const _PreviewLoading();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 220,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(strokeWidth: 2),
            SizedBox(height: 14),
            Text('正在加载当前组件…'),
          ],
        ),
      ),
    );
  }
}

class _PreviewLoadError extends StatelessWidget {
  const _PreviewLoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('组件加载失败：$message', textAlign: TextAlign.center),
            const SizedBox(height: 12),
            HyButton.tonal(label: '重试加载', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
