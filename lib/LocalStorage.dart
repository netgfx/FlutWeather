import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  ///
  /// Instantiation of the SharedPreferences library
  ///
  static final String _temperatureMeasure = "measure";
  static final String _forecastRange = "range";

  /// ------------------------------------------------------------
  /// Method that returns the user temperature preference, 'Celcius' if not set
  /// ------------------------------------------------------------
  static Future<String> getTemperatureCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_temperatureMeasure) ?? 'Celcius';
  }

  /// ----------------------------------------------------------
  /// Method that saves the user temperature preference
  /// ----------------------------------------------------------
  static Future<bool> setTemperatureCode(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(_temperatureMeasure, value);
  }

  // ------------------------------------------------------------
  /// Method that returns the user forecast range preference, 'Celcius' if not set
  /// ------------------------------------------------------------
  static Future<int> getForecastRangeCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt(_forecastRange) ?? 7;
  }

  /// ----------------------------------------------------------
  /// Method that saves the user forecast range preference
  /// ----------------------------------------------------------
  static Future<bool> setForecastRangeCode(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt(_forecastRange, value);
  }
}
