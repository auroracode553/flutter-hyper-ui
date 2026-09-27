import 'package:flutter/widgets.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => HyperUiTheme.app(home: Center(child: child));

void main() {
  testWidgets('menu group supplies one glass surface for its tiles', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const HyperMenuGroup(
          children: <Widget>[
            HyperListTile(title: '账户'),
            HyperListTile(title: '通知'),
          ],
        ),
      ),
    );
    expect(find.byType(HyperGlass), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('text size and theme color resolve without a type string', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            HyperText('大号', size: 'large'),
            HyperText('默认'),
            HyperText('小号', size: 'small'),
          ],
        ),
      ),
    );
    expect(tester.widget<Text>(find.text('大号')).style!.fontSize, 18);
    expect(tester.widget<Text>(find.text('默认')).style!.fontSize, 14);
    expect(tester.widget<Text>(find.text('小号')).style!.fontSize, 12);
    final tokens = HyperUiThemeTokens.of(tester.element(find.text('小号')));
    expect(
      tester.widget<Text>(find.text('小号')).style!.color,
      tokens.mutedForeground,
    );
  });

  testWidgets('action sheet returns the selected value from its own route', (
    tester,
  ) async {
    String? result;
    await tester.pumpWidget(
      _host(
        Builder(
          builder: (context) => HyperButton(
            label: '打开',
            onPressed: () async {
              result = await HyperActionSheet.choose<String>(
                context,
                actions: const <HyperAction<String>>[
                  HyperAction(value: 'save', label: '保存'),
                ],
              );
            },
          ),
        ),
      ),
    );
    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();
    expect(find.text('保存'), findsOneWidget);
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();
    expect(result, 'save');
    expect(tester.takeException(), isNull);
  });

  testWidgets('dropdown closes after selecting an option', (tester) async {
    String? selected;
    await tester.pumpWidget(
      _host(
        SizedBox(
          width: 260,
          child: HyperDropdown<String>(
            value: selected,
            onChanged: (value) => selected = value,
            options: const <HyperOption<String>>[
              HyperOption(value: 'one', label: '选项一'),
              HyperOption(value: 'two', label: '选项二'),
            ],
          ),
        ),
      ),
    );
    await tester.tap(find.text('请选择'));
    await tester.pumpAndSettle();
    expect(find.text('选项二'), findsOneWidget);
    await tester.tap(find.text('选项二'));
    await tester.pumpAndSettle();
    expect(selected, 'two');
    expect(find.text('选项二'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('single select reports a scalar value', (tester) async {
    String? selected;
    await tester.pumpWidget(
      _host(
        SizedBox(
          width: 260,
          child: HyperSelect<String>(
            label: '工作空间',
            value: selected,
            onChanged: (value) => selected = value,
            options: const <HyperOption<String>>[
              HyperOption(value: 'design', label: '设计'),
              HyperOption(value: 'code', label: '开发'),
            ],
          ),
        ),
      ),
    );
    await tester.tap(find.text('请选择'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('开发'));
    await tester.pumpAndSettle();
    expect(selected, 'code');
    expect(tester.takeException(), isNull);
  });

  testWidgets('tabs and pages stay in sync on tap and swipe', (tester) async {
    var selected = 0;
    await tester.pumpWidget(
      _host(
        SizedBox(
          width: 320,
          height: 220,
          child: HyperTabs(
            tabs: const <Widget>[Text('第一页'), Text('第二页')],
            pages: const <Widget>[
              Center(child: Text('内容一')),
              Center(child: Text('内容二')),
            ],
            pageHeight: 160,
            onChanged: (index) => selected = index,
          ),
        ),
      ),
    );
    await tester.tap(find.text('第二页'));
    await tester.pumpAndSettle();
    expect(selected, 1);
    await tester.drag(find.byType(PageView), const Offset(280, 0));
    await tester.pumpAndSettle();
    expect(selected, 0);
    expect(tester.takeException(), isNull);
  });
}
