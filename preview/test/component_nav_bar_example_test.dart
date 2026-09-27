import 'package:flutter/material.dart';
import 'package:flutter_hyper_ui/hyper_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_hyper_ui_preview/src/preview_app.dart';
import 'package:flutter_hyper_ui_preview/src/preview_catalog.dart';
import 'package:flutter_hyper_ui_preview/src/preview_view_configuration.dart';

void main() {
  for (final brightness in Brightness.values) {
    testWidgets('HyperNavBar 示例在 $brightness 下显示并滚动', (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 680));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.runAsync(
        PreviewCatalog.byId('component-nav-bar').loadLibrary,
      );
      await tester.pumpWidget(
        PreviewApp(
          configuration: PreviewViewConfiguration(
            componentId: 'component-nav-bar',
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
      expect(find.byType(HyperNavBar), findsOneWidget);
      expect(find.text('今日灵感'), findsOneWidget);

      final navRect = tester.getRect(find.byType(HyperNavBar));
      final heading = find.text('让内容自然流动');
      final headingTop = tester.getTopLeft(heading).dy;
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -120));
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(heading).dy, lessThan(headingTop));
      expect(tester.getRect(find.byType(HyperNavBar)), navRect);
      expect(tester.takeException(), isNull);
    });
  }
}
