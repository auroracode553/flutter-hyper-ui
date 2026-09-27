import 'package:flutter/material.dart';
import 'package:flutter_hyper_ui/hy_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_hyper_ui_preview/src/preview_app.dart';
import 'package:flutter_hyper_ui_preview/src/preview_catalog.dart';
import 'package:flutter_hyper_ui_preview/src/preview_view_configuration.dart';

void main() {
  for (final componentId in ['component-nav-bar', 'component-nav-bar-page']) {
    for (final brightness in Brightness.values) {
      testWidgets('$componentId 在 $brightness 下直接占满手机屏幕并滚动', (tester) async {
        await tester.binding.setSurfaceSize(const Size(320, 680));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.runAsync(PreviewCatalog.byId(componentId).loadLibrary);
        await tester.pumpWidget(
          PreviewApp(
            configuration: PreviewViewConfiguration(
              componentId: componentId,
              embedded: true,
              themeMode: brightness == Brightness.dark
                  ? ThemeMode.dark
                  : ThemeMode.light,
              safeAreaPadding: const EdgeInsets.only(top: 52, bottom: 24),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.byType(SingleChildScrollView), findsNothing);
        expect(find.text('查看穿透效果'), findsNothing);
        expect(find.text('回到首屏'), findsNothing);
        expect(find.text('9:41'), findsNothing);
        expect(find.byType(HyButton), findsNothing);
        expect(tester.getSize(find.byType(HyNavBarPage)), const Size(320, 680));
        expect(tester.getTopLeft(find.byType(CustomScrollView)), Offset.zero);
        expect(
          tester.getSize(find.byType(CustomScrollView)),
          const Size(320, 680),
        );
        final navRect = tester.getRect(find.byType(HyNavBar));
        expect(navRect.height, 96);
        expect(tester.getTopLeft(find.text('今日灵感')).dy, greaterThan(52));
        final heading = find.text('让内容延伸到\n屏幕的每一寸');
        final initialHeadingTop = tester.getTopLeft(heading).dy;
        final position = tester
            .state<ScrollableState>(find.byType(Scrollable))
            .position;
        position.jumpTo(112);
        await tester.pump();
        expect(tester.getTopLeft(heading).dy, initialHeadingTop - 112);
        expect(tester.getRect(find.byType(HyNavBar)), navRect);

        await tester.drag(find.byType(CustomScrollView), const Offset(0, -120));
        await tester.pumpAndSettle();
        expect(position.pixels, greaterThan(112));
        expect(tester.getRect(find.byType(HyNavBar)), navRect);
        position.jumpTo(0);
        await tester.pump();
        expect(tester.getTopLeft(heading).dy, initialHeadingTop);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
