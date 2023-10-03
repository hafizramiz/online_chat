import 'package:flutter/material.dart';

class AlertDialogHelper {
  static Future<void> showMyDialog(
      {required BuildContext context,
        required String alertDialogTitle,
        required String alertDialogContent,
        required Function onPressed}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(alertDialogTitle),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(alertDialogContent),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                onPressed();
              },
            ),
          ],
        );
      },
    );
  }
}
