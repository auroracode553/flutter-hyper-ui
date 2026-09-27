import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';

/// 展示页使用明确标记的模拟适配器；不请求系统相册权限或真实上传服务。
class UploadExample extends StatefulWidget {
  const UploadExample({super.key});
  @override
  State<UploadExample> createState() => _UploadExampleState();
}

class _UploadExampleState extends State<UploadExample> {
  bool _fail = false;
  bool _disabled = false;
  int _sequence = 0;
  Future<List<HyperUploadFile>> _pick(HyperUploadSource source) async => [
    HyperUploadFile(
      id: 'sample-${_sequence++}',
      name: '示例图片.png',
      bytes: base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+aN1sAAAAASUVORK5CYII=',
      ),
    ),
  ];
  Future<String> _upload(
    HyperUploadFile file,
    ValueChanged<double> progress,
    HyperUploadCancellation cancellation,
  ) async {
    for (var i = 1; i <= 10; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 150));
      if (cancellation.isCancelled) throw StateError('已取消');
      progress(i / 10);
    }
    if (_fail) throw StateError('模拟上传失败');
    return 'demo://${file.id}';
  }

  @override
  Widget build(BuildContext context) => HyperCard(
    title: '文件上传',
    subtitle: '演示适配器：生成本地示例图片，模拟进度；不上传到服务器。',
    child: Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HyperSwitch(
          label: '模拟上传失败',
          value: _fail,
          onChanged: (value) => setState(() => _fail = value),
        ),
        HyperSwitch(
          label: '禁用上传',
          value: _disabled,
          onChanged: (value) => setState(() => _disabled = value),
        ),
        HyperUploader(
          pick: _pick,
          upload: _upload,
          maxCount: 4,
          enabled: !_disabled,
          sources: const [
            HyperUploadSource.gallery,
            HyperUploadSource.camera,
            HyperUploadSource.file,
          ],
        ),
      ],
    ),
  );
}
