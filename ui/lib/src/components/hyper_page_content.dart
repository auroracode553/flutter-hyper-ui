import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../theme/hyper_ui_spacing.dart';

/// 库内已提供页面留白的作用域，供固定区、滚动区与弹层避免嵌套重复留白。
class HyperPageInsetScope extends InheritedWidget {
  /// 标记子树已由库宿主提供页面留白。
  const HyperPageInsetScope({super.key, required super.child});

  /// 判断当前位置是否已经处于库的页面留白内。
  static bool contains(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<HyperPageInsetScope>() != null;

  /// 留白标记不持有可变状态，无需通知子树。
  @override
  bool updateShouldNotify(HyperPageInsetScope oldWidget) => false;
}

/// 固定内容区的默认页面留白；用于筛选区和侧栏，内部控件不再各自包裹边距。
class HyperPageSection extends StatelessWidget {
  /// 创建固定内容区，由库统一提供页面水平和垂直留白。
  const HyperPageSection({super.key, required this.child});

  /// 创建纵向固定内容区，子项间距由库统一提供。
  HyperPageSection.column({super.key, required List<Widget> children})
    : child = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: HyperUiSpacing.itemGap,
        children: children,
      );

  /// 内容区主体。
  final Widget child;

  /// 在内容区外统一提供一次默认留白。
  @override
  Widget build(BuildContext context) {
    if (HyperPageInsetScope.contains(context)) return child;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: HyperUiSpacing.pagePadding,
        vertical: HyperUiSpacing.pageVertical,
      ),
      child: HyperPageInsetScope(child: child),
    );
  }
}

/// 页面内容 sliver：统一默认边距与宽屏限宽，支持普通内容和懒加载列表。
class HyperPageContentSliver extends StatelessWidget {
  /// 创建普通页面内容；默认边距为左 16、上 12、右 16、下 40。
  const HyperPageContentSliver({
    super.key,
    required Widget child,
    this.padding = _defaultPadding,
    this.maxWidth = 800,
    this.bottomObstruction = 0,
  }) : child = child,
       sliver = null;

  /// 创建懒加载页面内容；[sliver] 接收原生 sliver，保留滚动控制器与按需构建。
  const HyperPageContentSliver.sliver({
    super.key,
    required Widget sliver,
    this.padding = _defaultPadding,
    this.maxWidth = 800,
    this.bottomObstruction = 0,
  }) : child = null,
       sliver = sliver;

  /// 创建页面分组，组间留白由库负责，消费页只传入实际内容。
  HyperPageContentSliver.sections({
    super.key,
    required List<Widget> children,
    this.maxWidth = 800,
    this.bottomObstruction = 0,
  }) : padding = _defaultPadding,
       sliver = null,
       child = Column(
         mainAxisSize: MainAxisSize.min,
         crossAxisAlignment: CrossAxisAlignment.stretch,
         spacing: HyperUiSpacing.sectionVertical,
         children: children,
       );

  /// 创建按需构建的列表，项目间距由库的默认内容间距统一提供。
  HyperPageContentSliver.list({
    super.key,
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,
    this.maxWidth = 800,
    this.bottomObstruction = 0,
  }) : child = null,
       padding = _defaultPadding,
       sliver = SliverList.separated(
         itemCount: itemCount,
         itemBuilder: itemBuilder,
         separatorBuilder: (_, _) =>
             const SizedBox(height: HyperUiSpacing.itemGap),
       );

  /// 页面正文的默认边距，集中由库维护。
  static const EdgeInsets _defaultPadding = EdgeInsets.fromLTRB(16, 12, 16, 40);

  /// 普通页面内容；懒加载形式为空。
  final Widget? child;

  /// 懒加载内容；普通内容形式为空。
  final Widget? sliver;

  /// 页面内容边距。
  final EdgeInsets padding;

  /// 宽屏内容的最大宽度，手机端不扩展到屏幕之外。
  final double maxWidth;

  /// 业务固定控件造成的额外底部遮挡，只参与滚动末尾避让。
  final double bottomObstruction;

  /// 在 sliver 层处理留白和宽屏限宽，不破坏内部列表的懒加载。
  @override
  Widget build(BuildContext context) => SliverLayoutBuilder(
    builder: (context, constraints) {
      final effectivePadding = HyperPageInsetScope.contains(context)
          ? EdgeInsets.zero
          : padding;
      final availableWidth = math.max(
        0.0,
        constraints.crossAxisExtent - effectivePadding.horizontal,
      );
      final centeringInset = math.max(0.0, availableWidth - maxWidth) / 2;
      return SliverPadding(
        padding: effectivePadding.copyWith(
          left: effectivePadding.left + centeringInset,
          right: effectivePadding.right + centeringInset,
          bottom: effectivePadding.bottom + bottomObstruction,
        ),
        sliver: HyperPageInsetScope(
          child: sliver ?? SliverToBoxAdapter(child: child!),
        ),
      );
    },
  );
}
