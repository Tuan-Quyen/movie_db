import 'package:flutter/material.dart';

class mAlertDialog {
  showAlertDialog(String title, String message, BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("OK"))
            ],
          );
        });
  }
}
