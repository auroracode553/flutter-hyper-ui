import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hyper_ui/hy_ui.dart';

/// 展示页使用明确标记的模拟适配器；不请求系统相册权限或真实上传服务。
class UploadExample extends StatefulWidget {
  const UploadExample({super.key});
  @override
  State<UploadExample> createState() => _UploadExampleState();
}
class _UploadExampleState extends State<UploadExample> {
  bool _fail = false;
  int _sequence = 0;
  Future<List<HyUploadFile>> _pick(HyUploadSource source) async => [HyUploadFile(
    id: 'sample-${_sequence++}', name: '示例图片.png', bytes: base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+aN1sAAAAASUVORK5CYII='))];
  Future<String> _upload(HyUploadFile file, ValueChanged<double> progress,
    HyUploadCancellation cancellation) async {
    for (var i = 1; i <= 10; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 150));
      if (cancellation.isCancelled) throw StateError('已取消');
      progress(i / 10);
    }
    if (_fail) throw StateError('模拟上传失败');
    return 'demo://${file.id}';
  }
  @override
  Widget build(BuildContext context) => HyCard(title: '文件上传',
    subtitle: '演示适配器：生成本地示例图片，模拟进度；不上传到服务器。',
    child: HySpace(alignment: CrossAxisAlignment.stretch, children: [
      HySwitch(label: '模拟上传失败', value: _fail, onChanged: (value) => setState(() => _fail = value)),
      HyUploader(pick: _pick, upload: _upload, maxCount: 4,
        sources: const [HyUploadSource.gallery, HyUploadSource.camera, HyUploadSource.file]),
    ]));
}
