import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'hyper_progress_painters.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/hyper_glass_theme.dart';
import '../theme/hyper_ui_theme_tokens.dart';
import 'hyper_action_sheet.dart';
import 'hyper_badge.dart';
import 'hyper_button.dart';
import 'hyper_glass.dart';
import 'hyper_image.dart';
import 'hyper_navigation.dart';
import 'hyper_tone.dart';

enum HyperUploadSource { gallery, camera, file }

enum HyperUploadStatus { ready, uploading, success, error }

class HyperUploadFile {
  const HyperUploadFile({
    required this.id,
    required this.name,
    required this.bytes,
    this.isImage = true,
  });
  final String id, name;
  final Uint8List bytes;
  final bool isImage;
}

/// 上传适配器需要观察此令牌，并在底层 HTTP 客户端取消传输。
class HyperUploadCancellation {
  bool _cancelled = false;
  bool get isCancelled => _cancelled;
  void cancel() => _cancelled = true;
}

class HyperUploadItem {
  const HyperUploadItem({
    required this.file,
    this.status = HyperUploadStatus.ready,
    this.progress = 0,
    this.url,
    this.error,
  });
  final HyperUploadFile file;
  final HyperUploadStatus status;
  final double progress;
  final String? url;
  final Object? error;
}

typedef HyperFilePicker =
    Future<List<HyperUploadFile>> Function(HyperUploadSource source);
typedef HyperFileUpload =
    Future<String> Function(
      HyperUploadFile file,
      ValueChanged<double> onProgress,
      HyperUploadCancellation cancellation,
    );

/// 平台选择与 HTTP 上传通过入参注入。组件负责 UI 和请求生命周期。
class HyperUploader extends StatefulWidget {
  const HyperUploader({
    super.key,
    required this.pick,
    required this.upload,
    this.onChanged,
    this.onError,
    this.initialItems = const [],
    this.maxCount = 9,
    this.maxBytes = 10 * 1024 * 1024,
    this.enabled = true,
    this.sources = const [HyperUploadSource.gallery, HyperUploadSource.camera],
  }) : assert(maxCount > 0),
       assert(maxBytes > 0);
  final HyperFilePicker pick;
  final HyperFileUpload upload;
  final ValueChanged<List<HyperUploadItem>>? onChanged;
  final ValueChanged<Object>? onError;
  final List<HyperUploadItem> initialItems;
  final int maxCount, maxBytes;
  final bool enabled;
  final List<HyperUploadSource> sources;
  @override
  State<HyperUploader> createState() => _HyperUploaderState();
}

class _HyperUploaderState extends State<HyperUploader> {
  late final List<HyperUploadItem> _items = List.of(widget.initialItems);
  final Map<String, HyperUploadCancellation> _requests = {};
  bool _picking = false;
  String? _pickError;
  void _emit() => widget.onChanged?.call(List.unmodifiable(_items));
  void _replace(String id, HyperUploadItem item) {
    final index = _items.indexWhere((entry) => entry.file.id == id);
    if (!mounted || index < 0) return;
    setState(() => _items[index] = item);
    _emit();
  }

  Future<void> _select() async {
    if (_picking || !widget.enabled) return;
    setState(() {
      _picking = true;
      _pickError = null;
    });
    try {
      final source = await HyperActionSheet.choose<HyperUploadSource>(
        context,
        title: '添加文件',
        actions: widget.sources
            .map(
              (source) => HyperAction(
                value: source,
                label: switch (source) {
                  HyperUploadSource.gallery => '从相册选择',
                  HyperUploadSource.camera => '拍照',
                  HyperUploadSource.file => '选择文件',
                },
                icon: source == HyperUploadSource.camera
                    ? LucideIcons.camera
                    : LucideIcons.imagePlus,
              ),
            )
            .toList(),
      );
      if (source == null || !mounted) return;
      final files = await widget.pick(source);
      if (!mounted) return;
      for (final file in files) {
        if (_items.length >= widget.maxCount) break;
        if (_items.any((item) => item.file.id == file.id)) continue;
        if (file.bytes.length > widget.maxBytes) {
          throw StateError('${file.name} 超出文件大小限制');
        }
        setState(() => _items.add(HyperUploadItem(file: file)));
        _emit();
        _send(file);
      }
    } catch (error) {
      if (mounted) {
        setState(() => _pickError = '无法添加文件：$error');
        widget.onError?.call(error);
      }
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  Future<void> _send(HyperUploadFile file) async {
    if (_requests.containsKey(file.id)) return;
    final token = HyperUploadCancellation();
    _requests[file.id] = token;
    _replace(
      file.id,
      HyperUploadItem(file: file, status: HyperUploadStatus.uploading),
    );
    try {
      final url = await widget.upload(file, (progress) {
        if (!token.isCancelled && progress.isFinite)
          _replace(
            file.id,
            HyperUploadItem(
              file: file,
              status: HyperUploadStatus.uploading,
              progress: progress.clamp(0.0, 1.0).toDouble(),
            ),
          );
      }, token);
      if (!token.isCancelled)
        _replace(
          file.id,
          HyperUploadItem(
            file: file,
            status: HyperUploadStatus.success,
            progress: 1,
            url: url,
          ),
        );
    } catch (error) {
      if (!token.isCancelled && mounted) {
        _replace(
          file.id,
          HyperUploadItem(
            file: file,
            status: HyperUploadStatus.error,
            error: error,
          ),
        );
        widget.onError?.call(error);
      }
    } finally {
      if (identical(_requests[file.id], token)) _requests.remove(file.id);
    }
  }

  void _remove(HyperUploadItem item) {
    _requests.remove(item.file.id)?.cancel();
    setState(() => _items.remove(item));
    _emit();
  }

  @override
  void dispose() {
    for (final token in _requests.values) {
      token.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final item in _items)
              _UploadItemTile(
                item: item,
                enabled: widget.enabled,
                onRemove: () => _remove(item),
                onRetry: () => _send(item.file),
              ),
            if (_items.length < widget.maxCount)
              _UploadAddTile(
                picking: _picking,
                onTap: widget.enabled && !_picking ? _select : null,
              ),
          ],
        ),
        if (_pickError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              _pickError!,
              style: TextStyle(color: tokens.error, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

class _UploadItemTile extends StatelessWidget {
  const _UploadItemTile({
    required this.item,
    required this.enabled,
    required this.onRemove,
    required this.onRetry,
  });

  final HyperUploadItem item;
  final bool enabled;
  final VoidCallback onRemove;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    final glass = HyperGlassTheme.of(context);
    return SizedBox(
      width: 104,
      child: HyperGlass(
        radius: 16,
        type: 'subtle',
        borderColor: tokens.input,
        padding: const EdgeInsets.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                item.file.isImage
                    ? HyperImage(
                        provider: MemoryImage(item.file.bytes),
                        width: 90,
                        height: 72,
                        radius: 12,
                        preview: true,
                      )
                    : SizedBox(
                        width: 90,
                        height: 72,
                        child: Icon(
                          LucideIcons.file,
                          size: 28,
                          color: tokens.primary,
                        ),
                      ),
                if (enabled)
                  Positioned(
                    top: 2,
                    right: 2,
                    child: HyperButton(
                      type: 'tonal',
                      icon: LucideIcons.x,
                      size: 'small',
                      tooltip: '删除 ${item.file.name}',
                      onPressed: onRemove,
                      backgroundColor: glass.surfaceStrong,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              item.file.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: tokens.foreground,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            if (item.status == HyperUploadStatus.uploading)
              HyperProgress(
                value: item.progress,
                size: 'small',
                showLabel: false,
              )
            else if (item.status == HyperUploadStatus.success)
              const HyperBadge(label: '已上传', tone: HyperUiTone.success)
            else
              HyperButton(
                type: 'tonal',
                label: item.status == HyperUploadStatus.error ? '重试' : '上传',
                size: 'small',
                expanded: true,
                onPressed: enabled ? onRetry : null,
              ),
          ],
        ),
      ),
    );
  }
}

class _UploadAddTile extends StatelessWidget {
  const _UploadAddTile({required this.picking, required this.onTap});

  final bool picking;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = HyperUiThemeTokens.of(context);
    return SizedBox(
      width: 104,
      height: 136,
      child: HyperGlass(
        radius: 16,
        type: 'subtle',
        borderColor: tokens.input,
        onTap: onTap,
        child: Center(
          child: picking
              ? const HyperSpinner(strokeWidth: 2)
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.plus, color: tokens.primary),
                    const SizedBox(height: 8),
                    Text(
                      '添加文件',
                      style: TextStyle(
                        color: tokens.mutedForeground,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
