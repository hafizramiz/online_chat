import 'package:flutter/material.dart';

class MyTextFromField extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  final String hintText;
  final Icon icon;
  final String errorMessage;
  final bool obscureText;

  MyTextFromField({
    required this.controller,
    required String this.hintText,
    required this.icon,
    required this.errorMessage,
    required this.obscureText
  });

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(15),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: obscureText,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return errorMessage;
          }
          return null;
        },
        //obscureText: true,
        controller: controller,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            prefixIcon: icon),
      ),
    );
  }
}
