import 'dart:ui';

import 'package:flutter/material.dart';

class CommonAlert extends StatelessWidget {
  String title;
  String content;
  VoidCallback continueCallBack;

  CommonAlert(this.title, this.content, this.continueCallBack);

  TextStyle textStyle = TextStyle(color: Colors.black);

  @override
  Widget build(BuildContext context) {
    // TODO: implement createState
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          title: new Text(
            title,
            style: textStyle,
          ),
          content: new Text(
            content,
            style: textStyle,
          ),
          actions: <Widget>[
            new ElevatedButton(
              child: new Text("Continue"),
              onPressed: () {
                continueCallBack();
              },
            ),
            new ElevatedButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }

  showAlertDialog(BuildContext context) {
    // AlertDialog(title: Text('Please enter correct plot number'));

    // Create button
    Widget okButton = ElevatedButton(
      child: Text("OK"),
      onPressed: () {
        // Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Error Alert"),
      content: Text('Please enter correct plot number'),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
