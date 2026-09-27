import 'package:flutter/widgets.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

Widget _host(Widget child, {EdgeInsets padding = EdgeInsets.zero}) =>
    HyperUiTheme(
      data: HyperUiTheme.light(),
      child: WidgetsApp(
        color: const Color(0xFFFFFFFF),
        pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
        ),
        home: MediaQuery(
          data: MediaQueryData(padding: padding, viewPadding: padding),
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(width: double.infinity, child: child),
          ),
        ),
      ),
    );

void main() {
  testWidgets('默认标题从左侧 16px 开始，不预留缺失的 leading', (tester) async {
    await tester.pumpWidget(
      _host(const HyperNavBar(title: Text('左对齐'), safeArea: false)),
    );
    expect(tester.getTopLeft(find.text('左对齐')).dx, 16);
    expect(tester.takeException(), isNull);
  });

  testWidgets('标题、副标题、前导和尾部均支持自定义 Widget 与交互', (tester) async {
    var tapped = 0;
    const subtitleKey = ValueKey('custom-subtitle');
    await tester.pumpWidget(
      _host(
        HyperNavBar(
          height: 64,
          safeArea: false,
          leading: const Icon(LucideIcons.menu),
          title: const Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(LucideIcons.heart, size: 16),
              SizedBox(width: 6),
              Text(
                '自定义内容',
                style: TextStyle(fontSize: 22, color: Color(0xFF800080)),
              ),
            ],
          ),
          subtitle: const SizedBox(
            key: subtitleKey,
            width: 80,
            height: 10,
            child: ColoredBox(color: Color(0xFF008000)),
          ),
          trailing: HyperButton.ghost(label: '保存', onPressed: () => tapped++),
        ),
      ),
    );
    expect(find.byKey(subtitleKey), findsOneWidget);
    expect(find.byIcon(LucideIcons.heart), findsOneWidget);
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
        const HyperNavBar(
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
                child: Icon(LucideIcons.search, size: 16),
              ),
            ],
          ),
        ),
      ),
    );
    expect(
      tester.getRect(find.byKey(contentKey)),
      tester.getRect(find.byType(HyperNavBar)),
    );
    expect(tester.getTopLeft(find.text('任意布局')), Offset.zero);
    expect(tester.getSize(find.byType(HyperNavBar)).height, 32);
    expect(find.byType(NavigationToolbar), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('标题可省略，尾部插槽仍从右侧排列', (tester) async {
    await tester.pumpWidget(
      _host(
        const HyperNavBar(
          safeArea: false,
          trailing: SizedBox(
            width: 24,
            height: 24,
            child: Icon(LucideIcons.search),
          ),
        ),
      ),
    );
    expect(
      tester.getTopRight(find.byIcon(LucideIcons.search)).dx,
      tester.getTopRight(find.byType(HyperNavBar)).dx - 16,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('完整布局插槽可以直接承载可编辑搜索框', (tester) async {
    var query = '';
    await tester.pumpWidget(
      _host(
        HyperNavBar(
          height: 52,
          safeArea: false,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: HyperTextField(
            hintText: '搜索灵感',
            onChanged: (value) => query = value,
          ),
        ),
      ),
    );
    await tester.enterText(find.byType(HyperTextField), '灵感');
    await tester.pump();
    expect(query, '灵感');
    expect(tester.takeException(), isNull);
  });

  test('互斥插槽配置及时报错，避免内容被覆盖', () {
    expect(
      () => HyperNavBar(title: const Text('标题'), child: const Text('整行')),
      throwsAssertionError,
    );
  });

  testWidgets('尾部与 actions 冲突时不会静默覆盖内容', (tester) async {
    await tester.pumpWidget(
      _host(
        const HyperNavBar(trailing: Text('尾部'), actions: <Widget>[Text('操作')]),
      ),
    );
    expect(tester.takeException(), isAssertionError);
  });

  testWidgets('透明导航保持 44px，副标题不增加高度', (tester) async {
    await tester.pumpWidget(
      _host(
        const HyperNavBar(
          title: Text('标题'),
          subtitle: Text('说明'),
          safeArea: false,
        ),
      ),
    );
    expect(tester.getSize(find.byType(HyperNavBar)).height, 44);
    expect(find.byType(HyperGlass), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('不对称操作区下标题仍按整栏居中', (tester) async {
    await tester.pumpWidget(
      _host(
        const HyperNavBar(
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
      tester.getCenter(find.byType(HyperNavBar)).dx,
    );
  });
}
