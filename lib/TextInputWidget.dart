import 'package:flutter/material.dart';

class TextInputWidget extends StatefulWidget {
  final TextEditingController controller;
  TextInputWidget({Key key, this.controller}) : super(key: key);

  @override
  TextInputWidgetState createState() => TextInputWidgetState();
}

class TextInputWidgetState extends State<TextInputWidget> {
  var _controller = TextEditingController();

  void initState() {
    super.initState();
  }

  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 38.0, right: 24.0, top: 16.0, bottom: 16.0),
      child: TextField(
        decoration: InputDecoration(
    hintText: 'Enter City Name'
  ),
        controller: widget.controller ?? _controller,
        onSubmitted: (String value) {
          // await showDialog<void>(
          //   context: context,
          //   builder: (BuildContext context) {
          //     return AlertDialog(
          //       title: const Text('Thanks!'),
          //       content: Text('You typed "$value".'),
          //       actions: <Widget>[
          //         FlatButton(
          //           onPressed: () {
          //             Navigator.pop(context);
          //           },
          //           child: const Text('OK'),
          //         ),
          //       ],
          //     );
          //   },
          // );
        },
      ),
    );
  }
}