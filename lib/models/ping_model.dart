class PingDataModel {
  late List<Duration?> responseTimeList;
  Duration? totalResponseTime;
  PingDataModel.fromEvent(List<Duration?> list) {
    this.responseTimeList = list;
    this.totalResponseTime = Duration();
    for (int i = 0; i < list.length; i++) {
      this.totalResponseTime = this.totalResponseTime! + responseTimeList[i]!;
    }
  }
}
