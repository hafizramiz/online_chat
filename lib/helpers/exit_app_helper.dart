import 'package:flutter/material.dart';

class ExitAppHelper {
  static Future<bool?> exitApp(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Onaylama"),
              content: Text('Çıkmak istediğinizden emin misiniz?'),
              actions: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text("Hayir")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text("Evet")),
              ],
            ));
  }
}
