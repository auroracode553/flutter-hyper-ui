import 'package:flutter/widgets.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) {
  final theme = HyperUiTheme.light();
  return HyperUiTheme(
    data: theme,
    child: WidgetsApp(
      color: theme.tokens.background,
      textStyle: TextStyle(color: theme.tokens.foreground),
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) =>
            builder(context),
      ),
      home: Center(child: child),
    ),
  );
}

void main() {
  testWidgets('action sheet returns the selected value from its own route', (
    tester,
  ) async {
    String? result;
    await tester.pumpWidget(
      _host(
        Builder(
          builder: (context) => HyperButton.filled(
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

  testWidgets('tabs and pages stay in sync on tap and swipe', (tester) async {
    await tester.pumpWidget(
      _host(
        SizedBox(
          width: 320,
          height: 220,
          child: HyperTabHost(
            length: 2,
            child: Column(
              children: <Widget>[
                const HyperTabs(tabs: <Widget>[Text('第一页'), Text('第二页')]),
                const Expanded(
                  child: HyperTabView(
                    children: <Widget>[
                      Center(child: Text('内容一')),
                      Center(child: Text('内容二')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    final tabs = HyperTabHost.of(tester.element(find.byType(HyperTabs)));
    await tester.tap(find.text('第二页'));
    await tester.pumpAndSettle();
    expect(tabs.index, 1);
    await tester.drag(find.byType(PageView), const Offset(280, 0));
    await tester.pumpAndSettle();
    expect(tabs.index, 0);
    expect(tester.takeException(), isNull);
  });
}
