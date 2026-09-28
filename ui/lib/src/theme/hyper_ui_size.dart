/// Resolves the three public size names used by compact Hyper controls.
double hyperUiSizeValue(
  String size, {
  required double small,
  required double normal,
  required double large,
}) => switch (size) {
  'small' => small,
  'default' => normal,
  'large' => large,
  _ => throw ArgumentError.value(size, 'size', 'Use large, default, or small'),
};
