import 'package:flutter/material.dart';

class MyTextFromField extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  final String hintText;
  final IconData icon;
  final String errorMessage;

  MyTextFromField({
    required this.controller,
    required String this.hintText,
    required this.icon,
    required this.errorMessage
  });

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(15),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return errorMessage;
          }
          return null;
        },
        //obscureText: true,
        controller: controller,
        decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )),
      ),
    );
  }
}
