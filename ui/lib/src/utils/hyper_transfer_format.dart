/// 下载量采用十进制单位，与业务提供的字节计数保持一致。
String formatHyperTransferBytes(num bytes) {
  var amount = bytes.isFinite && bytes > 0 ? bytes.toDouble() : 0.0;
  const units = <String>['B', 'KB', 'MB', 'GB', 'TB'];
  var unit = 0;
  while (amount >= 1000 && unit < units.length - 1) {
    amount /= 1000;
    unit++;
  }
  return '${amount.toStringAsFixed(unit == 0 ? 0 : 1)} ${units[unit]}';
}

/// 剩余时间只作为估算提示；速度暂不可用时由调用方省略。
String formatHyperTransferSeconds(double seconds) {
  if (seconds < 60) return '${seconds.ceil()} 秒';
  if (seconds < 3600) return '${(seconds / 60).ceil()} 分钟';
  if (seconds < 86400) return '${(seconds / 3600).ceil()} 小时';
  return '${(seconds / 86400).ceil()} 天';
}
