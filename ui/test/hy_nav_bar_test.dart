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
  testWidgets('默认标题从左侧 16px 开始，不预留缺失的 leading', (tester) async {
    await tester.pumpWidget(
      _host(const HyNavBar(title: Text('左对齐'), safeArea: false)),
    );
    expect(tester.getTopLeft(find.text('左对齐')).dx, 16);
    expect(tester.takeException(), isNull);
  });

  testWidgets('标题、副标题、前导和尾部均支持自定义 Widget 与交互', (tester) async {
    var tapped = 0;
    const subtitleKey = ValueKey('custom-subtitle');
    await tester.pumpWidget(
      _host(
        HyNavBar(
          height: 64,
          safeArea: false,
          leading: const Icon(Icons.menu),
          title: const Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.favorite, size: 16),
              SizedBox(width: 6),
              Text(
                '自定义内容',
                style: TextStyle(fontSize: 22, color: Colors.purple),
              ),
            ],
          ),
          subtitle: const SizedBox(
            key: subtitleKey,
            width: 80,
            height: 10,
            child: ColoredBox(color: Colors.green),
          ),
          trailing: HyButton.ghost(label: '保存', onPressed: () => tapped++),
        ),
      ),
    );
    expect(find.byKey(subtitleKey), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(tester.widget<Text>(find.text('自定义内容')).style!.fontSize, 22);
    await tester.tap(find.text('保存'));
    await tester.pump();
    expect(tapped, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('child 接管整行布局，允许独立高度和零边距', (tester) async {
    const contentKey = ValueKey('custom-layout');
    await tester.pumpWidget(
      _host(
        const HyNavBar(
          height: 32,
          padding: EdgeInsets.zero,
          safeArea: false,
          child: Stack(
            key: contentKey,
            fit: StackFit.expand,
            children: <Widget>[
              Positioned(left: 0, top: 0, child: Text('任意布局')),
              Positioned(
                right: 0,
                bottom: 0,
                child: Icon(Icons.search, size: 16),
              ),
            ],
          ),
        ),
      ),
    );
    expect(
      tester.getRect(find.byKey(contentKey)),
      tester.getRect(find.byType(HyNavBar)),
    );
    expect(tester.getTopLeft(find.text('任意布局')), Offset.zero);
    expect(tester.getSize(find.byType(HyNavBar)).height, 32);
    expect(find.byType(NavigationToolbar), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('标题可省略，尾部插槽仍从右侧排列', (tester) async {
    await tester.pumpWidget(
      _host(
        const HyNavBar(
          safeArea: false,
          trailing: SizedBox(width: 24, height: 24, child: Icon(Icons.search)),
        ),
      ),
    );
    expect(
      tester.getTopRight(find.byIcon(Icons.search)).dx,
      tester.getTopRight(find.byType(HyNavBar)).dx - 16,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('完整布局插槽可以直接承载可编辑搜索框', (tester) async {
    var query = '';
    await tester.pumpWidget(
      _host(
        HyNavBar(
          height: 52,
          safeArea: false,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: HyTextField(
            hintText: '搜索灵感',
            onChanged: (value) => query = value,
          ),
        ),
      ),
    );
    await tester.enterText(find.byType(HyTextField), '灵感');
    await tester.pump();
    expect(query, '灵感');
    expect(tester.takeException(), isNull);
  });

  test('互斥插槽配置及时报错，避免内容被覆盖', () {
    expect(
      () => HyNavBar(title: const Text('标题'), child: const Text('整行')),
      throwsAssertionError,
    );
  });

  testWidgets('尾部与 actions 冲突时不会静默覆盖内容', (tester) async {
    await tester.pumpWidget(
      _host(
        const HyNavBar(trailing: Text('尾部'), actions: <Widget>[Text('操作')]),
      ),
    );
    expect(tester.takeException(), isAssertionError);
  });

  testWidgets('透明导航保持 44px，副标题不增加高度', (tester) async {
    await tester.pumpWidget(
      _host(
        const HyNavBar(
          title: Text('标题'),
          subtitle: Text('说明'),
          safeArea: false,
        ),
      ),
    );
    expect(tester.getSize(find.byType(HyNavBar)).height, 44);
    expect(find.byType(HyGlass), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('不对称操作区下标题仍按整栏居中', (tester) async {
    await tester.pumpWidget(
      _host(
        const HyNavBar(
          title: Text('居中标题'),
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
            title: const Text('固定导航'),
            actions: <Widget>[
              HyButton.icon(
                icon: Icons.add,
                type: 'ghost',
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
          navBar: HyNavBar(title: Text('自定义'), height: 60, safeArea: false),
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
                    navBar: HyNavBar(title: Text('第二页')),
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
    expect(back.type, 'ghost');
    expect(back.height, 44);
    await tester.tap(find.byType(HyButton).last);
    await tester.pumpAndSettle();
    expect(find.text('第二页'), findsNothing);
    expect(find.text('打开页面'), findsOneWidget);
  });
}
