/// 所有进度绘制层共用的边界规则；未知和异常数值使用不定进度。
double? normalizeHyperProgress(double? value) =>
    value?.isFinite == true ? value!.clamp(0.0, 1.0).toDouble() : null;

/// 补偿百分比边界的浮点误差；进度到达 1 才显示 100%。
int? hyperProgressPercentage(double? value) {
  final amount = normalizeHyperProgress(value);
  if (amount == null) return null;
  if (amount >= 1) return 100;
  return (amount * 100 + 1e-9).floor().clamp(0, 99);
}
