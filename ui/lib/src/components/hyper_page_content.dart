import 'package:flutter/material.dart';

/// 页面内容 sliver：统一内容边距，并在宽屏（桌面/平板）下居中限宽。
///
/// 可作为 CustomScrollView 的内容 sliver。
class HyperPageContentSliver extends StatelessWidget {
  const HyperPageContentSliver({
    super.key,
    required this.child,
    this.padding = _defaultPadding,
    this.maxWidth = 800,
  });

  static const EdgeInsets _defaultPadding = EdgeInsets.fromLTRB(16, 12, 16, 40);

  /// 页面内容。
  final Widget child;

  /// 内容区边距。
  final EdgeInsets padding;

  /// 宽屏下内容居中的最大宽度；手机端屏幕更窄，此约束不生效。
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: padding,
      sliver: SliverToBoxAdapter(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: child,
          ),
        ),
      ),
    );
  }
}
