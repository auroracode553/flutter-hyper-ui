import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'hy_bottom_sheet.dart';
import 'hy_glass.dart';
import 'hy_image.dart';

enum HyUploadSource { gallery, camera, file }
enum HyUploadStatus { ready, uploading, success, error }

class HyUploadFile {
  const HyUploadFile({required this.id, required this.name, required this.bytes,
    this.isImage = true});
  final String id, name;
  final Uint8List bytes;
  final bool isImage;
}

/// 上传适配器需要观察此令牌，并在底层 HTTP 客户端取消传输。
class HyUploadCancellation {
  bool _cancelled = false;
  bool get isCancelled => _cancelled;
  void cancel() => _cancelled = true;
}

class HyUploadItem {
  const HyUploadItem({required this.file, this.status = HyUploadStatus.ready,
    this.progress = 0, this.url, this.error});
  final HyUploadFile file;
  final HyUploadStatus status;
  final double progress;
  final String? url;
  final Object? error;
}

typedef HyFilePicker = Future<List<HyUploadFile>> Function(HyUploadSource source);
typedef HyFileUpload = Future<String> Function(HyUploadFile file,
  ValueChanged<double> onProgress, HyUploadCancellation cancellation);

/// 平台选择与 HTTP 上传通过入参注入。组件负责 UI 和请求生命周期。
class HyUploader extends StatefulWidget {
  const HyUploader({super.key, required this.pick, required this.upload,
    this.onChanged, this.onError, this.initialItems = const [], this.maxCount = 9,
    this.maxBytes = 10 * 1024 * 1024, this.enabled = true,
    this.sources = const [HyUploadSource.gallery, HyUploadSource.camera]})
    : assert(maxCount > 0), assert(maxBytes > 0);
  final HyFilePicker pick;
  final HyFileUpload upload;
  final ValueChanged<List<HyUploadItem>>? onChanged;
  final ValueChanged<Object>? onError;
  final List<HyUploadItem> initialItems;
  final int maxCount, maxBytes;
  final bool enabled;
  final List<HyUploadSource> sources;
  @override
  State<HyUploader> createState() => _HyUploaderState();
}

class _HyUploaderState extends State<HyUploader> {
  late final List<HyUploadItem> _items = List.of(widget.initialItems);
  final Map<String, HyUploadCancellation> _requests = {};
  bool _picking = false;
  String? _pickError;
  void _emit() => widget.onChanged?.call(List.unmodifiable(_items));
  void _replace(String id, HyUploadItem item) {
    final index = _items.indexWhere((entry) => entry.file.id == id);
    if (!mounted || index < 0) return;
    setState(() => _items[index] = item); _emit();
  }
  Future<void> _select() async {
    if (_picking || !widget.enabled) return;
    setState(() { _picking = true; _pickError = null; });
    try {
      final source = await HyActionSheet.show<HyUploadSource>(context,
        title: '添加文件', actions: widget.sources.map((source) => HyAction(
          value: source, label: switch (source) {
            HyUploadSource.gallery => '从相册选择', HyUploadSource.camera => '拍照',
            HyUploadSource.file => '选择文件',
          }, icon: source == HyUploadSource.camera ? Icons.photo_camera_outlined : Icons.add_photo_alternate_outlined)).toList());
      if (source == null || !mounted) return;
      final files = await widget.pick(source);
      if (!mounted) return;
      for (final file in files) {
        if (_items.length >= widget.maxCount) break;
        if (_items.any((item) => item.file.id == file.id)) continue;
        if (file.bytes.length > widget.maxBytes) {
          throw StateError('${file.name} 超出文件大小限制');
        }
        setState(() => _items.add(HyUploadItem(file: file))); _emit();
        _send(file);
      }
    } catch (error) {
      if (mounted) { setState(() => _pickError = '无法添加文件：$error'); widget.onError?.call(error); }
    } finally { if (mounted) setState(() => _picking = false); }
  }
  Future<void> _send(HyUploadFile file) async {
    if (_requests.containsKey(file.id)) return;
    final token = HyUploadCancellation();
    _requests[file.id] = token;
    _replace(file.id, HyUploadItem(file: file, status: HyUploadStatus.uploading));
    try {
      final url = await widget.upload(file, (progress) {
        if (!token.isCancelled && progress.isFinite) _replace(file.id,
          HyUploadItem(file: file, status: HyUploadStatus.uploading,
            progress: progress.clamp(0.0, 1.0).toDouble()));
      }, token);
      if (!token.isCancelled) _replace(file.id,
        HyUploadItem(file: file, status: HyUploadStatus.success, progress: 1, url: url));
    } catch (error) {
      if (!token.isCancelled && mounted) {
        _replace(file.id, HyUploadItem(file: file, status: HyUploadStatus.error, error: error));
        widget.onError?.call(error);
      }
    } finally { if (identical(_requests[file.id], token)) _requests.remove(file.id); }
  }
  void _remove(HyUploadItem item) {
    _requests.remove(item.file.id)?.cancel();
    setState(() => _items.remove(item)); _emit();
  }
  @override
  void dispose() { for (final token in _requests.values) { token.cancel(); } super.dispose(); }
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Wrap(spacing: 12, runSpacing: 12, children: [
      for (final item in _items) SizedBox(width: 112, child: HyGlass(blur: 0, radius: 16,
        child: Column(children: [
          Stack(children: [
            if (item.file.isImage) HyImage(provider: MemoryImage(item.file.bytes),
              width: 112, height: 90, preview: true)
            else const SizedBox(width: 112, height: 90, child: Icon(Icons.insert_drive_file_outlined, size: 32)),
            if (widget.enabled) Positioned(right: 0, top: 0, child: IconButton.filledTonal(
              tooltip: '删除 ${item.file.name}', onPressed: () => _remove(item),
              icon: const Icon(Icons.close, size: 16))),
          ]),
          Padding(padding: const EdgeInsets.all(6), child: Text(item.file.name, maxLines: 1,
            overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11))),
          if (item.status == HyUploadStatus.uploading) LinearProgressIndicator(value: item.progress),
          if (item.status == HyUploadStatus.success) const Padding(padding: EdgeInsets.all(4), child: Text('已上传')),
          if (item.status == HyUploadStatus.error || item.status == HyUploadStatus.ready)
            TextButton(onPressed: widget.enabled ? () => _send(item.file) : null,
              child: Text(item.status == HyUploadStatus.error ? '失败 · 重试' : '上传')),
        ]))),
      if (_items.length < widget.maxCount) SizedBox(width: 112, height: 112,
        child: HyGlass(blur: 0, radius: 16, onTap: widget.enabled && !_picking ? _select : null,
          child: Center(child: _picking ? const CircularProgressIndicator(strokeWidth: 2)
            : const Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.add_rounded),
              SizedBox(height: 8), Text('添加文件')])))),
    ]),
    if (_pickError != null) Padding(padding: const EdgeInsets.only(top: 8),
      child: Text(_pickError!, style: TextStyle(color: Theme.of(context).colorScheme.error))),
  ]);
}
