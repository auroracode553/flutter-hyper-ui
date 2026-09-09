import 'package:flutter/material.dart';

import 'src/preview_multi_view_app.dart';

void main() {
  // Multi-view 模式没有 implicitView，必须使用 runWidget。
  runWidget(const PreviewMultiViewApp());
}
