import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';
import "LocalStorage.dart";

class SettingsPageWidget extends StatefulWidget {
  SettingsPageWidget({Key key}) : super(key: key);

  @override
  SettingsPage createState() => SettingsPage();
}

class SettingsPage extends State<SettingsPageWidget> {
  final String _temperature = "Temperature: ";
  String _measure = "Celcius";
  bool _tempChecked = false;
  String _dropdownValue = "7 Days";

  void initState() {
    super.initState();

    _getRange();

    _getTemperature();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _smallerFont = const TextStyle(fontSize: 16.0, color: Colors.grey);

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  BoxedIcon(WeatherIcons.thermometer,
                      color: _smallerFont.color),
                  Text(_temperature + _measure,
                      style: _smallerFont, textAlign: TextAlign.start),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Switch(
                        value: _tempChecked,
                        onChanged: (bool value) {
                          var result = "Celcius";
                          if (value == true) {
                            // means user want's fahrenheit
                            result = "Fahrenheit";
                          }

                          setState(() {
                            _measure = result;
                            _tempChecked = value;
                          });

                          _setGlobalSettings("temp", result);
                        }
                        //secondary: const BoxedIcon(WeatherIcons.thermometer),
                        ),
                  )
                ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                BoxedIcon(WeatherIcons.thermometer, color: _smallerFont.color),
                Text("Forecast range",
                    style: _smallerFont, textAlign: TextAlign.start),
                Flexible(
                    fit: FlexFit.loose,
                    child: DropdownButton<String>(
                      value: _dropdownValue,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.blueAccent),
                      underline: Container(
                        height: 2,
                        color: Colors.blueAccent,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          _dropdownValue = newValue;
                        });
                        _setGlobalSettings("range", newValue);
                      },
                      items: <String>['7 Days', '3 Days', '2 Days', 'Next Day']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ))
              ],
            )
          ]),
      // Center(
      //   child: RaisedButton(
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //     child: Text('Go back!'),
      //   ),
      // ),
    );
  }

  _getTemperature() {
    SharedPreferencesHelper.getTemperatureCode().then((value) => {
          if (value == "Celcius")
            {
              setState(() {
                _tempChecked = false;
                _measure = value;
              })
            }
          else
            {
              setState(() {
                _tempChecked = true;
                _measure = value;
              })
            }
        });
  }

  _getRange() {
    var _map = <String, String>{
      "7": "7 Days",
      "3": "3 Days",
      "2": "2 Days",
      "1": "Next Day"
    };

    SharedPreferencesHelper.getForecastRangeCode().then((value) => {
          setState(() {
            _dropdownValue = _map[value.toString()];
          })
        });
  }

  _setGlobalSettings(String type, String value) {
    print(type + "-" + value);
    if (type == "temp") {
      SharedPreferencesHelper.setTemperatureCode(_measure);
    } else if (type == "range") {
      var _map = <String, int>{
        "7 Days": 7,
        "3 Days": 3,
        "2 Days": 2,
        "Next Day": 1
      };
      SharedPreferencesHelper.setForecastRangeCode(_map[value]);
    }
  }
}
