import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';

/// 示例页持有的模拟任务；弹层关闭只移除视图，取消按钮才终止下载。
/// 由 component_update_dialog_example.dart 注入视图，不参与 UI 库实现。
class UpdateDemoController extends ChangeNotifier {
  static const release = HyperUpdateRelease(
    version: '2.8.0',
    releaseDate: '2026.10.10',
    sizeLabel: '48.6 MB',
    highlights: <String>[
      '全新的柔光界面，交互细节更自然。',
      '优化启动与页面切换，让每一次操作更流畅。',
      '修复已知问题，提升使用稳定性。',
    ],
  );

  static const _totalBytes = 48600000;
  static const _bytesPerSecond = 4800000.0;
  HyperUpdateStatus _status = HyperUpdateStatus.available;
  Timer? _timer;
  int _downloadedBytes = 0;
  double? _installProgress;
  bool _unknownTotal = false;
  bool _updated = false;
  bool _latest = false;

  HyperUpdateStatus get status => _status;
  String get currentVersion => _updated ? release.version : '2.7.3';
  double? get installProgress => _installProgress;
  bool get unknownTotal => _unknownTotal;
  bool get busy =>
      _status == HyperUpdateStatus.checking ||
      _status == HyperUpdateStatus.downloading ||
      _status == HyperUpdateStatus.installing;

  HyperUpdateDownloadProgress get downloadProgress =>
      HyperUpdateDownloadProgress(
        downloadedBytes: _downloadedBytes,
        totalBytes: _unknownTotal ? null : _totalBytes,
        bytesPerSecond: _bytesPerSecond,
      );

  void setUnknownTotal(bool value) {
    if (_unknownTotal == value) return;
    _unknownTotal = value;
    notifyListeners();
  }

  void check({bool latest = false, bool fail = false}) {
    if (busy) return;
    _timer?.cancel();
    _latest = latest;
    _status = HyperUpdateStatus.checking;
    _installProgress = null;
    notifyListeners();
    _timer = Timer(const Duration(milliseconds: 1400), () {
      _timer = null;
      _status = fail
          ? HyperUpdateStatus.error
          : latest || _updated
          ? HyperUpdateStatus.upToDate
          : HyperUpdateStatus.available;
      notifyListeners();
    });
  }

  void download() {
    if (_status != HyperUpdateStatus.available) return;
    _timer?.cancel();
    _status = HyperUpdateStatus.downloading;
    _downloadedBytes = 0;
    _installProgress = null;
    notifyListeners();
    // 与系统下载快照类似，按字节更新；显示未知总量时任务仍可完成。
    _timer = Timer.periodic(const Duration(milliseconds: 700), (timer) {
      _downloadedBytes = (_downloadedBytes + (_bytesPerSecond * .7).round())
          .clamp(0, _totalBytes);
      if (_downloadedBytes >= _totalBytes) {
        timer.cancel();
        _timer = null;
        _status = HyperUpdateStatus.readyToInstall;
      }
      notifyListeners();
    });
  }

  void install() {
    if (_status != HyperUpdateStatus.readyToInstall) return;
    _timer?.cancel();
    _status = HyperUpdateStatus.installing;
    _installProgress = 0;
    notifyListeners();
    _timer = Timer.periodic(const Duration(milliseconds: 250), (timer) {
      _installProgress = ((_installProgress ?? 0) + .08).clamp(0.0, 1.0);
      if (_installProgress! >= 1) {
        timer.cancel();
        _timer = null;
        _status = HyperUpdateStatus.completed;
        _updated = true;
      }
      notifyListeners();
    });
  }

  void retry() => check(latest: _latest);

  void cancel() {
    if (_status != HyperUpdateStatus.checking &&
        _status != HyperUpdateStatus.downloading) {
      return;
    }
    final downloading = _status == HyperUpdateStatus.downloading;
    _timer?.cancel();
    _timer = null;
    _status = downloading
        ? HyperUpdateStatus.available
        : HyperUpdateStatus.idle;
    _downloadedBytes = 0;
    notifyListeners();
  }

  /// 状态切片保持静止以便观察；只能在任务停止时切换。
  void preview(HyperUpdateStatus value) {
    if (busy && _timer != null) return;
    _status = value;
    _downloadedBytes = value == HyperUpdateStatus.downloading
        ? (_totalBytes * .64).round()
        : 0;
    _installProgress = value == HyperUpdateStatus.installing ? .35 : null;
    _updated = value == HyperUpdateStatus.completed;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
