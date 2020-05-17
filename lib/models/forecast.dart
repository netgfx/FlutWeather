class Forecast {
  final String date;
  final String url;
  final double tempF;
  final double tempC;
  final int code;
  final int epoch;

  Forecast(this.code, this.url, this.tempF, this.tempC, this.date, this.epoch) {
    if (code == null) {
      throw ArgumentError("Code of Forecast cannot be null. "
          "Received: '$code'");
    }

    if (url == null) {
      throw ArgumentError("Url of Forecast cannot be null. "
          "Received: '$url'");
    }
  }
}
