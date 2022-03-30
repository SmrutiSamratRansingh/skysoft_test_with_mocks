import 'package:dart_ping/dart_ping.dart';

class PingRepository {
  pingStreamProvider() {
    final ping = Ping('google.com', count: 5);
    return ping.stream;
  }
}
