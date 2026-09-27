import 'package:flutter/widgets.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

void main() {
  Widget wrap(Widget child) => HyperUiTheme(
    data: HyperUiTheme.light(),
    child: WidgetsApp(
      color: const Color(0xFFFFFFFF),
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) =>
            builder(context),
      ),
      home: Center(child: child),
    ),
  );

  testWidgets('按钮内长 label 缩小适配而非溢出', (tester) async {
    await tester.pumpWidget(
      wrap(
        HyperButton.outline(
          label: '圆形胶囊',
          icon: LucideIcons.heart,
          onPressed: () {},
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('图标按钮渲染且点击回调触发', (tester) async {
    var tapped = 0;
    await tester.pumpWidget(
      wrap(HyperButton.icon(icon: LucideIcons.plus, onPressed: () => tapped++)),
    );
    await tester.tap(find.byType(HyperButton));
    await tester.pump();
    expect(tapped, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('默认按内容收缩（inline-block），非通栏', (tester) async {
    await tester.pumpWidget(
      wrap(HyperButton.filled(label: '导出', onPressed: () {})),
    );
    final size = tester.getSize(find.byType(HyperButton));
    expect(size.width, lessThan(300), reason: '未显式 expanded 时不应占满父级宽度');
    expect(tester.takeException(), isNull);
  });

  testWidgets('expanded 时铺满父级宽度', (tester) async {
    await tester.pumpWidget(
      wrap(
        SizedBox(
          width: 320,
          child: HyperButton.filled(
            label: '通栏按钮',
            expanded: true,
            onPressed: () {},
          ),
        ),
      ),
    );
    final size = tester.getSize(find.byType(HyperButton));
    expect(size.width, moreOrLessEquals(320));
    expect(tester.takeException(), isNull);
  });
}
