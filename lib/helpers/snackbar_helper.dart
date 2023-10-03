import 'package:flutter/material.dart';

class  SnackBarHelper{
  static void showSnackBar({required String message, required BuildContext context}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}