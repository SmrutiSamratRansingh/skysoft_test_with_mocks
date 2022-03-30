// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:skysoft_tdd/provider/ping_provider.dart';
import 'package:skysoft_tdd/repository/ping_repository.dart';
import 'package:skysoft_tdd/view/ping_screen.dart';

class MockPingRepository extends Mock implements PingRepository {}

void main() {
  late Duration duration;
  late PingResponse pingResponse;
  late PingData pingData;

  late PingData nullData;

  late MockPingRepository mockPingRepository;

  late Stream<PingData> streamContinues;
  late Stream<PingData> streamEnded;
  setUp(() {
    duration = Duration(milliseconds: 987);
    pingResponse = PingResponse(ip: '173.334.4545:112', time: duration);
    pingData = PingData(response: pingResponse);
    nullData = PingData(response: null);
    mockPingRepository = MockPingRepository();
    streamContinues = Stream.fromIterable([pingData, pingData, pingData]);
    streamEnded = Stream.fromIterable(
        [pingData, pingData, pingData, pingData, pingData, nullData]);
  });
  testWidgets('check initial state of the screen', (WidgetTester tester) async {
    final pingButton = find.byKey(ValueKey('ping button'));
    final appBar = find.byKey(ValueKey('appBar'));
    final scaffold = find.byKey(ValueKey('scaffold'));
    final appBarText = find.byKey(ValueKey('appbar text'));
    final text = find.widgetWithText(AppBar, 'Response Timer');

    await tester.pumpWidget(MaterialApp(
      home: ChangeNotifierProvider(
        create: (context) => PingEventsData(mockPingRepository),
        child: PingProviderScreen(),
      ),
    ));
    expect(pingButton, findsOneWidget);
    expect(appBar, findsOneWidget);
    expect(scaffold, findsOneWidget);
    expect(appBarText, findsOneWidget);
    expect(text, findsOneWidget);
  });
  testWidgets('check widgets on screen after button is tapped for first time',
      (WidgetTester tester) async {
    final pingButton = find.byKey(ValueKey('ping button'));
    final ipText = find.byKey(ValueKey('ip'));
    final outerListView = find.byKey(ValueKey('outerListView'));
    final innerListView = find.byKey(ValueKey('innerListView'));
    final totalResponseTime = find.byKey(ValueKey('totalResponseTimeText'));
    final responseTimeText = find.byKey(ValueKey('responseTimeText'));
    await tester.pumpWidget(MaterialApp(
      home: ChangeNotifierProvider(
        create: (context) => PingEventsData(mockPingRepository),
        child: PingProviderScreen(),
      ),
    ));
    when(mockPingRepository.pingStreamProvider())
        .thenAnswer((_) => streamContinues);
    await tester.tap(pingButton);
    await tester.pump(Duration(seconds: 6));
    expect(ipText, findsOneWidget);
    expect(outerListView, findsOneWidget);
    expect(innerListView, findsOneWidget);
    expect(totalResponseTime, findsOneWidget);
    expect(responseTimeText, findsNWidgets(3));
  });
}
