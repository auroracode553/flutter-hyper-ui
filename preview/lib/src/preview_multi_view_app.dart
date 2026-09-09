import 'dart:ui' show FlutterView;

import 'package:flutter/widgets.dart';

import 'preview_app.dart';
import 'preview_view_configuration.dart';

/// 为宿主页面动态添加的每个 FlutterView 创建独立组件预览。
class PreviewMultiViewApp extends StatefulWidget {
  const PreviewMultiViewApp({super.key});

  @override
  State<PreviewMultiViewApp> createState() => _PreviewMultiViewAppState();
}

class _PreviewMultiViewAppState extends State<PreviewMultiViewApp>
    with WidgetsBindingObserver {
  Map<Object, Widget> _views = <Object, Widget>{};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _updateViews();
  }

  @override
  void didChangeMetrics() => _updateViews();

  void _updateViews() {
    final nextViews = <Object, Widget>{};
    for (final view in WidgetsBinding.instance.platformDispatcher.views) {
      nextViews[view.viewId] = _views[view.viewId] ?? _buildView(view);
    }
    setState(() => _views = nextViews);
  }

  Widget _buildView(FlutterView view) {
    final configuration = PreviewViewConfiguration.forView(view.viewId);
    return View(
      view: view,
      child: PreviewApp(configuration: configuration),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewCollection(views: _views.values.toList(growable: false));
  }
}
