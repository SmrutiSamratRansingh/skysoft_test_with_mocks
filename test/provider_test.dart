import 'package:dart_ping/dart_ping.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skysoft_tdd/provider/ping_provider.dart';
import 'package:skysoft_tdd/repository/ping_repository.dart';

class MockPingRepository extends Mock implements PingRepository {}

void main() {
  late Duration duration;
  late PingResponse pingResponse;
  late PingData pingData;

  late PingData nullData;

  late MockPingRepository mockPingRepository;

  late PingEventsData pingEventsData;
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
    pingEventsData = PingEventsData(mockPingRepository);
  });
  tearDown(() {});
  test('test provider class when first event occurs on Ping', () async {
    when(mockPingRepository.pingStreamProvider())
        .thenAnswer((_) => streamContinues);
    pingEventsData.pingGoogle();

    await Future.delayed(Duration());
    expect(pingEventsData.hasData, true);
    expect(pingEventsData.isPinged, true);
    expect(pingEventsData.responsetimeList.length, 3);
    expect(pingEventsData.pingDataList.length, 1);
    expect(pingEventsData.ip, '173.334.4545:112');
    verify(mockPingRepository.pingStreamProvider()).called(1);
  });

  test('test data when stream has ended', () async {
    when(mockPingRepository.pingStreamProvider())
        .thenAnswer((_) => streamEnded);
    pingEventsData.pingGoogle();
    await Future.delayed(Duration());
    expect(pingEventsData.hasData, true);
    expect(pingEventsData.isPinged, false);
    expect(pingEventsData.responsetimeList.length, 5);
    expect(pingEventsData.pingDataList.length, 1);
    expect(pingEventsData.ip, '173.334.4545:112');
    verify(mockPingRepository.pingStreamProvider()).called(1);
  });

  test('test data with a new ping on button', () async {
    when(mockPingRepository.pingStreamProvider())
        .thenAnswer((_) => streamEnded);
    pingEventsData.pingGoogle();
    await Future.delayed(Duration());
    expect(pingEventsData.hasData, true);
    expect(pingEventsData.isPinged, false);
    expect(pingEventsData.responsetimeList.length, 5);
    expect(pingEventsData.pingDataList.length, 1);
    expect(pingEventsData.ip, '173.334.4545:112');

    when(mockPingRepository.pingStreamProvider())
        .thenAnswer((_) => streamContinues);
    pingEventsData.pingGoogle();
    await Future.delayed(Duration());
    expect(pingEventsData.hasData, true);
    expect(pingEventsData.isPinged, true);
    expect(pingEventsData.responsetimeList.length, 3);
    expect(pingEventsData.pingDataList.length, 2);
    expect(pingEventsData.ip, '173.334.4545:112');
    verify(mockPingRepository.pingStreamProvider()).called(2);
  });
}
