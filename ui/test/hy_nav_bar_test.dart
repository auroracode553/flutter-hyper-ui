import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hyper_ui/hy_ui.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child, {EdgeInsets padding = EdgeInsets.zero}) =>
    MaterialApp(
      home: Scaffold(
        body: MediaQuery(
          data: MediaQueryData(padding: padding, viewPadding: padding),
          child: child,
        ),
      ),
    );

void main() {
  testWidgets('透明导航保持 44px，副标题不增加高度', (tester) async {
    await tester.pumpWidget(
      _host(const HyNavBar(title: '标题', subtitle: '说明', safeArea: false)),
    );
    expect(tester.getSize(find.byType(HyNavBar)).height, 44);
    expect(find.byType(HyGlass), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('不对称操作区下标题仍按整栏居中', (tester) async {
    await tester.pumpWidget(
      _host(
        const HyNavBar(
          title: '居中标题',
          centerTitle: true,
          safeArea: false,
          leading: SizedBox(width: 44),
          actions: <Widget>[SizedBox(width: 100)],
        ),
      ),
    );
    expect(
      tester.getCenter(find.text('居中标题')).dx,
      tester.getCenter(find.byType(HyNavBar)).dx,
    );
  });

  testWidgets('首屏避让安全区，滚动后内容进入状态栏，导航固定且可操作', (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    var tapped = 0;
    const firstKey = ValueKey('first-content');
    await tester.pumpWidget(
      _host(
        HyNavBarPage(
          controller: controller,
          navBar: HyNavBar(
            title: '固定导航',
            actions: <Widget>[
              HyButton.icon(
                icon: Icons.add,
                variant: HyButtonVariant.ghost,
                height: 44,
                onPressed: () => tapped++,
              ),
            ],
          ),
          slivers: <Widget>[
            SliverList.builder(
              itemCount: 20,
              itemBuilder: (_, index) => SizedBox(
                key: index == 0 ? firstKey : null,
                height: 120,
                child: ColoredBox(color: Colors.teal, child: Text('内容 $index')),
              ),
            ),
          ],
        ),
        padding: const EdgeInsets.only(top: 28, bottom: 20),
      ),
    );
    final initialNavRect = tester.getRect(find.byType(HyNavBar));
    expect(tester.getTopLeft(find.byKey(firstKey)).dy, 72);
    expect(tester.getTopLeft(find.text('固定导航')).dy, greaterThan(28));
    expect(
      tester.getTopLeft(find.byType(CustomScrollView)).dy,
      0,
      reason: '滚动视口必须从屏幕顶部开始，不能被安全区限制',
    );
    final region = tester.widget<AnnotatedRegion<SystemUiOverlayStyle>>(
      find.byType(AnnotatedRegion<SystemUiOverlayStyle>).first,
    );
    expect(region.value.statusBarColor, Colors.transparent);

    controller.jumpTo(60);
    await tester.pump();
    expect(tester.getTopLeft(find.byKey(firstKey)).dy, 12);
    expect(tester.getRect(find.byType(HyNavBar)), initialNavRect);
    // 验证位于状态栏内的正文确实参与命中测试，而非只改变布局坐标。
    final contentBox = tester.renderObject<RenderBox>(find.byKey(firstKey));
    expect(
      tester
          .hitTestOnBinding(const Offset(200, 16))
          .path
          .any((entry) => identical(entry.target, contentBox)),
      isTrue,
    );
    await tester.tap(find.byType(HyButton));
    await tester.pump();
    expect(tapped, 1);

    controller.jumpTo(0);
    await tester.pump();
    expect(tester.getTopLeft(find.byKey(firstKey)).dy, 72);
    expect(tester.takeException(), isNull);
  });

  testWidgets('自定义高度和关闭顶部安全区同步首屏留白', (tester) async {
    await tester.pumpWidget(
      _host(
        const HyNavBarPage(
          navBar: HyNavBar(title: '自定义', height: 60, safeArea: false),
          slivers: <Widget>[SliverToBoxAdapter(child: Text('首屏内容'))],
        ),
        padding: const EdgeInsets.only(top: 28),
      ),
    );
    expect(tester.getTopLeft(find.text('首屏内容')).dy, 60);
    expect(tester.getSize(find.byType(HyNavBar)).height, 60);
    expect(tester.takeException(), isNull);
  });

  testWidgets('路由自动返回按钮为透明且能够返回', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => HyButton.ghost(
            label: '打开页面',
            onPressed: () => Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => const Scaffold(
                  body: HyNavBarPage(
                    navBar: HyNavBar(title: '第二页'),
                    slivers: <Widget>[SliverToBoxAdapter(child: Text('详情'))],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('打开页面'));
    await tester.pumpAndSettle();
    final back = tester.widget<HyButton>(find.byType(HyButton).last);
    expect(back.variant, HyButtonVariant.ghost);
    expect(back.height, 44);
    await tester.tap(find.byType(HyButton).last);
    await tester.pumpAndSettle();
    expect(find.text('第二页'), findsNothing);
    expect(find.text('打开页面'), findsOneWidget);
  });
}
