import "key.dart";
import 'dart:convert';
import 'package:http/http.dart' as http;

class API {
  final String currentWeatherAPI =
      "http://api.weatherapi.com/v1/current.json"; //?key=&q="
  final String forecastWeatherAPI =
      "http://api.weatherapi.com/v1/forecast.json"; // key=&q=athens&days=7

  void fetchCurrentWeatherData(String location, Function callback, Function errorCallback) {
    print("fetching data for: ${location}");

    _loadCurrentWeatherData(location, callback, errorCallback);
  }

  void fetchForecastWeatherData(String location, String days, Function callback, Function errorCallback) {
    print("fetching data for: ${location}");

    _loadForecastWeatherData(location, days, callback, errorCallback);
  }

/**
 * Fetch current day weather data
 */
  _loadCurrentWeatherData(String location, Function callback, Function errorCallback) async {
    print("KEY: ${key} ${location}");
    
    String dataURL = currentWeatherAPI + "?key=" + key + "&q=" +Uri.encodeComponent(location);
    http.Response response = await http.get(dataURL);
    var _json = json.decode(response.body);
    print(_json);
    print(_json["error"]);
    if (_json["error"] != null) {
      print(_json["error"]["message"]);
      errorCallback(_json["error"]);
    } else {
      callback(_json);
    }
    // setState(() {
    //   _members = json.decode(response.body);
    // });
  }

/**
 * Fetch forecast weather data for upcoming days
 */
  _loadForecastWeatherData(String location, String days, Function callback, Function errorCallback) async {
    String dataURL = forecastWeatherAPI + "?key=" + key + "&days=" + days + "&q=" + Uri.encodeComponent(location);
    http.Response response = await http.get(dataURL);
    var _json = json.decode(response.body);
    print(_json);
    print(_json["error"]);
    if (_json["error"] != null) {
      print(_json["error"]["message"]);
      errorCallback();
    } else {
      callback(_json);
    }
  }
}
