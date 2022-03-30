import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:skysoft_tdd/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('tap on the elevated button starts ping session',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final pingButton = find.byKey(ValueKey('ping button'));
      final appBar = find.byKey(ValueKey('appBar'));
      final scaffold = find.byKey(ValueKey('scaffold'));
      final appBarText = find.byKey(ValueKey('appbar text'));
      final text = find.widgetWithText(AppBar, 'Response Timer');

      //check initial widgets on screen
      expect(pingButton, findsOneWidget);
      expect(appBar, findsOneWidget);
      expect(scaffold, findsOneWidget);
      expect(appBarText, findsOneWidget);
      expect(text, findsOneWidget);

      final ipText = find.byKey(ValueKey('ip'));
      final outerListView = find.byKey(ValueKey('outerListView'));
      final innerListView = find.byKey(ValueKey('innerListView'));
      final totalResponseTime = find.byKey(ValueKey('totalResponseTimeText'));
      final responseTimeText = find.byKey(ValueKey('responseTimeText'));

      await tester.tap(pingButton);
      //await tester.pump(Duration(seconds: 6));
      await tester.pumpAndSettle();
      //check the widgets on screen after first tap
      expect(ipText, findsOneWidget);
      expect(outerListView, findsOneWidget);
      expect(innerListView, findsOneWidget);
      expect(totalResponseTime, findsOneWidget);
      expect(responseTimeText, findsNWidgets(5));

      await tester.tap(pingButton);
      //await tester.pump(Duration(seconds: 6));
      await tester.pumpAndSettle();
      //check the widgets on screen after second tap
      expect(ipText, findsOneWidget);
      expect(outerListView, findsOneWidget);
      expect(innerListView, findsNWidgets(2));
      expect(totalResponseTime, findsNWidgets(2));
      expect(responseTimeText, findsNWidgets(10));
    });
  });
}

//run command:flutter test integration_test/app_test.dart
//run on real device