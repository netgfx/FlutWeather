import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart' as prefix0;
import 'dart:async';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import "LocalStorage.dart";
import 'models/status.dart';
import 'models/forecast.dart';
import 'TextInputWidget.dart';
import 'ForecastList.dart';
// PAGES //
import 'settings.dart';

// API
import 'API.dart';

final _biggerFont = const TextStyle(fontSize: 18.0);
final _smallerFont = const TextStyle(
    fontSize: 16.0, color: Colors.grey, fontStyle: FontStyle.italic);
final _locationStyle = const TextStyle(fontSize: 18.0, color: Colors.blue);
final _conditionStyle =
    const TextStyle(fontSize: 14.0, color: Colors.blueAccent);
final _tempStyle = const TextStyle(fontSize: 28.0, color: Colors.blue);

void main() {
  runApp(
    MaterialApp(
      home: MainPage(),
    ),
  );
}

class Strings {
  static String appTitle = "Weather Conditions";
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => GHFlutter(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/settings': (context) => SettingsPageWidget(),
      },
      title: 'GHFlutter',
      //home: GHFlutter(),
    );
  }
}

class GHFlutterState extends State<GHFlutter> {
  final locationController = TextEditingController();
  final apiClass = API();
  var _listStates = <Status>[];
  var _forecastStates = <Forecast>[];
  String _currentLocation = "";
  String _currentTemp = "";
  String _currentCondition = "";
  String _currentConditionIcon = "";
  bool forecastData = false;
  var location = new Location();
  prefix0.Geolocator geolocator = prefix0.Geolocator();
  prefix0.Position userLocation;

  //
  var _tempSetting = "";
  var _rangeSetting = "";

  @override
  void initState() {
    super.initState();

    // first load the location
    // then fetch the forecast for that location
    // then set the state for showing the list
    String currentLocation;
    _checkSettings(() => {
          _checkPermissions(() {
            // fetch forecast //
            currentLocation = userLocation.latitude.toString() +
                "," +
                userLocation.longitude.toString();
            apiClass.fetchForecastWeatherData(currentLocation, _rangeSetting,
                (response) {
              _loadForecastData(response);
              setState(() {
                forecastData = true;
              });
            }, (error) {
              print(error);
              setState(() {
                forecastData = false;
              });
            });
          })
        });

    //_listStates = [];
    //_loadData();

    //locationController.addListener(_printLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                _selectMenuOption("settings");
              },
            ),
          ],
          title: Text(Strings.appTitle),
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 30),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextInputWidget(controller: locationController),
                    RaisedButton(
                      onPressed: () {
                        _printLocation();
                        apiClass.fetchCurrentWeatherData(
                            locationController.text, _loadData, _errorFn);
                      },
                      child: const Text('Show Weather',
                          style: TextStyle(fontSize: 20)),
                    ),
                  ]),
              FittedBox(
                  fit: BoxFit.contain,
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 0.0, right: 0.0, top: 24.0, bottom: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(_currentLocation, style: _locationStyle),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.network(_currentConditionIcon,
                                        width: 32,
                                        height: 32,
                                        fit: BoxFit.fill),
                                    Text(_currentCondition,
                                        style: _conditionStyle),
                                  ]),
                              Text(_currentTemp, style: _tempStyle),
                            ],
                          )
                        ],
                      ))),
              (forecastData == true && _forecastStates.length > 0)
                  ? Expanded(child: ForecastListWidget(list: _forecastStates))
                  : Text("Forecast Data not found", style: _locationStyle)

              // ListView.builder(
              //     padding: const EdgeInsets.all(16.0),
              //     itemCount: _listStates.length * 2,
              //     itemBuilder: (BuildContext context, int position) {
              //       if (position.isOdd)
              //         return Divider(
              //           color: Colors.black,
              //           height: 1,
              //           thickness: 1,
              //           indent: 20,
              //           endIndent: 0,
              //         );

              //       final index = position ~/ 2;

              //       return _buildRow(index);
              //     })),
            ]));
  }

  Widget _buildRow(int i) {
    var location = _listStates[i].location ?? "";
    var icon = _listStates[i].url ?? "";
    String celciusTemp = _listStates[i].temp_c.toString() + "℃";
    String theotherguyTemp = _listStates[i].temp_f.toString() + "℉";
    var finalTemp = (_tempSetting == "Celcius") ? celciusTemp : theotherguyTemp;

    var temp = finalTemp;
    print(location + icon);
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListTile(
          title: Text("$location", style: _biggerFont),
          subtitle: Text("$temp", style: _smallerFont),
          leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(icon)),
        ));
  }

  _errorFn() {
    setState(() {
      _listStates = [];
    });
  }

  _selectMenuOption(String choise) {
    print(choise);
    Navigator.pushNamed(context, '/' + choise);
  }

  _loadForecastData(response) {
    //print(response);
    var _list = <Forecast>[];
    final statusJSON = response;
    final forecastDays = statusJSON["forecast"]["forecastday"];
    _forecastStates = [];
    print("LENGTH: " + forecastDays.length.toString());
    for (var i = 0; i < forecastDays.length; i++) {
      
      var _dayOfWeek = new DateFormat('EEEE')
          .format(DateTime.parse(forecastDays[i]["date"].toString()));
          print(_dayOfWeek+"\n");
      var _day = Forecast(
          forecastDays[i]["day"]["condition"]["code"],
          forecastDays[i]["day"]["condition"]["icon"],
          forecastDays[i]["day"]["avgtemp_f"],
          forecastDays[i]["day"]["avgtemp_c"],
          _dayOfWeek,
          forecastDays[i]["date_epoch"]);
      _list.add(_day);
    }

    setState(() {
      _forecastStates = _list;
    });
  }

/**
 * 
 */
  _loadData(response) {
    var _list = <Status>[];
    final statusJSON = response; //_states;
    _listStates = [];
    final status = Status(
        statusJSON['location']['name'] +
            " - " +
            statusJSON['location']['country'],
        statusJSON['current']['condition']['code'],
        'https://' +
            statusJSON['current']['condition']['icon']
                .replaceAll("//", "")
                .replaceAll("http://", "")
                .replaceAll("https://", ""),
        statusJSON['current']['temp_f'],
        statusJSON['current']['temp_c']);

    print(statusJSON['location']['name'] +
        " - " +
        statusJSON['location']['country']);
    _list.add(status);
    print(_list.length);

    setState(() {
      _listStates = _list;
      _currentCondition = statusJSON['current']['condition']["text"];
      _currentLocation = statusJSON['location']['name'] +
          " - " +
          statusJSON['location']['country'];
      String celciusTemp = (statusJSON['current']['temp_c']).toString() + "℃";
      String theotherguyTemp =
          (statusJSON['current']['temp_f']).toString() + "℉";
      var finalTemp =
          (_tempSetting == "Celcius") ? celciusTemp : theotherguyTemp;
      _currentTemp = finalTemp;
      _currentConditionIcon = 'https://' +
          statusJSON['current']['condition']['icon']
              .replaceAll("//", "")
              .replaceAll("http://", "")
              .replaceAll("https://", "");
    });
  }

  _printLocation() {
    print('${locationController.text}');
  }

/**
 * 
 */
  _checkSettings(Function callback) {
    SharedPreferencesHelper.getTemperatureCode().then((value) => {
          print("temp: " + value),
          setState(() {
            _tempSetting = value;
          })
        });

    SharedPreferencesHelper.getForecastRangeCode().then((value) => {
          print("range: " + value.toString()),
          setState(() {
            _rangeSetting = value.toString();
          }),
          callback()
        });
  }

// GEO LOCATION //
  _checkPermissions(Set<void> Function() callback) async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        _showMyDialog("No Service", "Location service is unavailable");
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        _showMyDialog("Permissions requested",
            "This App requests to access your location");
        return;
      }
    }

    print(_serviceEnabled.toString() + " - " + _permissionGranted.toString());

    _getLocation().then((value) {
      print(value.latitude.toString() + " : " + value.longitude.toString());
      setState(() {
        userLocation = value;
      });

      apiClass.fetchCurrentWeatherData(
          value.latitude.toString() + "," + value.longitude.toString(),
          _loadData,
          _errorFn);

      callback();
    });
  }

  Future<prefix0.Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: prefix0.LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  //////// END OF GEOLOCATION //////////////////////

  Future<void> _showMyDialog(String title, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class GHFlutter extends StatefulWidget {
  @override
  createState() => GHFlutterState();
}
