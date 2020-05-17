import 'package:flutter/material.dart';
import "models/forecast.dart";

class ForecastListWidget extends StatefulWidget {
  final List<Forecast> list;
  ForecastListWidget({Key key, this.list}) : super(key: key);

  @override
  ForecastList createState() => ForecastList();
}

class ForecastList extends State<ForecastListWidget> {

  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 16.0, bottom: 16.0),
      child: getHomePageBody(context),
      );
  }


  getHomePageBody(BuildContext context) {
  return ListView.builder(
    itemCount: widget.list.length,
    itemBuilder: _getItemUI,
    padding: EdgeInsets.all(0.0),
  );
}
  // First Attempt
  Widget _getItemUI(BuildContext context, int index) {
    return new Text(widget.list[index].date);
  }


}