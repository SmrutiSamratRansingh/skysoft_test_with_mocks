import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/cupertino.dart';
import 'package:skysoft_tdd/models/ping_model.dart';
import 'package:skysoft_tdd/repository/ping_repository.dart';

class PingEventsData extends ChangeNotifier {
  late List<Duration?> responsetimeList;
  late PingDataModel pingData;
  List<PingDataModel> pingDataList = [];
  late String ip;

  late int count; //check event number
  bool isPinged = false; //check if button is pressed
  bool hasData = false; //check if we have data from events

  final PingRepository pingRepository;
  late Ping ping;
  late Stream<PingData> stream;

  PingEventsData(this.pingRepository);
  void pingGoogle() {
    resetCountAndListOfResponseTime(); // reset list
    // Duration duration = Duration(milliseconds: 987);
    // PingResponse pingResponse =
    //     PingResponse(ip: '173.334.4545:112', time: duration);
    // PingData pingData = PingData(response: pingResponse);
    // this.stream = Stream.fromIterable([pingData, pingData]);
    this.stream = this.pingRepository.pingStreamProvider();

    this.stream.listen((event) {
      //listen to ping events
      setBoolAndCount(event);

      getIpAndResponseList(event);
      createPingDataModelObject();

      removeOldPingDataModelObject();
      getListOfPingDataModel();

      notifyListeners();
    });
  }

  void resetCountAndListOfResponseTime() {
    count = 0; //reset count to zero for new button taps
    this.responsetimeList = []; // reset list
  }

  void getListOfPingDataModel() {
    pingDataList.add(
        pingData); //add the new PingDataModel with updated list of response times.
  }

  void removeOldPingDataModelObject() {
    if (count >= 2) {
      //remove the last object of PingDataModel added to  pingDataList which has old list of response times.
      //this code is not executed for first event since pingDataList is empty here.
      var index = pingDataList.length - 1;
      pingDataList.removeAt(index);
    }
  }

  void createPingDataModelObject() {
    this.pingData = PingDataModel.fromEvent(this
        .responsetimeList); //create object of PingDataModel with current list of response times.
  }

  void getIpAndResponseList(PingData event) {
    if (event.response != null) {
      //get ip and updated list of response times from events
      this.ip = event.response!.ip!;
      this.responsetimeList.add(event.response!.time);
    }
  }

  void setBoolAndCount(PingData event) {
    //controls what widgets are displayed on screen
    count++;
    this.isPinged = true;
    if (event.response == null) {
      isPinged = false;
    }
    this.hasData = true;
  }
}
