import 'package:flutter/foundation.dart';

import '../utils/hyper_progress_value.dart';
import '../utils/hyper_transfer_format.dart';

/// 更新流程的展示状态；业务层负责检查、下载和安装之间的切换。
enum HyperUpdateStatus {
  idle,
  checking,
  available,
  upToDate,
  downloading,
  readyToInstall,
  installing,
  completed,
  error,
}

/// 供更新对话框展示的版本信息，不包含平台更新或网络实现。
@immutable
class HyperUpdateRelease {
  const HyperUpdateRelease({
    required this.version,
    this.releaseDate,
    this.sizeLabel,
    this.highlights = const <String>[],
  }) : assert(version != '');

  final String version;
  final String? releaseDate;
  final String? sizeLabel;
  final List<String> highlights;
}

/// 下载服务回传的单次快照；纯展示模型，不持有下载任务或定时器。
@immutable
class HyperUpdateDownloadProgress {
  const HyperUpdateDownloadProgress({
    required this.downloadedBytes,
    this.totalBytes,
    this.bytesPerSecond,
  });

  final int downloadedBytes;
  final int? totalBytes;
  final double? bytesPerSecond;

  int get _received => downloadedBytes < 0 ? 0 : downloadedBytes;
  bool get _hasTotal => totalBytes != null && totalBytes! > 0;
  bool get _hasSpeed =>
      bytesPerSecond != null && bytesPerSecond!.isFinite && bytesPerSecond! > 0;

  /// 总大小未知时保持不定进度，不把已下载量当作百分比。
  double? get fraction =>
      _hasTotal ? normalizeHyperProgress(_received / totalBytes!) : null;

  String get sizeLabel => _hasTotal
      ? '${formatHyperTransferBytes(_received)} / '
            '${formatHyperTransferBytes(totalBytes!)}'
      : '已下载 ${formatHyperTransferBytes(_received)}';

  String? get speedLabel =>
      _hasSpeed ? '${formatHyperTransferBytes(bytesPerSecond!)} / s' : null;

  String? get remainingLabel {
    if (!_hasTotal || !_hasSpeed || _received >= totalBytes!) return null;
    final seconds = (totalBytes! - _received) / bytesPerSecond!;
    return seconds.isFinite
        ? '预计剩余 ${formatHyperTransferSeconds(seconds)}'
        : null;
  }
}
