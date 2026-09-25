import 'package:flutter/material.dart';
import 'package:flutter_hyper_ui/hy_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
    home: Scaffold(
      body: Center(child: child),
    ),
  );

  testWidgets('圆形按钮内长 label 缩小适配而非溢出', (tester) async {
    await tester.pumpWidget(
      wrap(
        HyButton.outline(
          label: '圆形胶囊',
          icon: LucideIcons.heart,
          circle: true,
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
      wrap(
        HyButton.icon(
          icon: Icons.add,
          onPressed: () => tapped++,
        ),
      ),
    );
    await tester.tap(find.byType(HyButton));
    await tester.pump();
    expect(tapped, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('默认按内容收缩（inline-block），非通栏', (tester) async {
    await tester.pumpWidget(
      wrap(
        HyButton.filled(
          label: '导出',
          onPressed: () {},
        ),
      ),
    );
    final size = tester.getSize(find.byType(HyButton));
    expect(size.width, lessThan(300), reason: '未显式 expanded 时不应占满父级宽度');
    expect(tester.takeException(), isNull);
  });

  testWidgets('expanded 时铺满父级宽度', (tester) async {
    await tester.pumpWidget(
      wrap(
        SizedBox(
          width: 320,
          child: HyButton.filled(
            label: '通栏按钮',
            expanded: true,
            onPressed: () {},
          ),
        ),
      ),
    );
    final size = tester.getSize(find.byType(HyButton));
    expect(size.width, moreOrLessEquals(320));
    expect(tester.takeException(), isNull);
  });
}
