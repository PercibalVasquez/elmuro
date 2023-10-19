import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController textEdit;
  final String hintText;
  final bool obscureText;
  const MyTextField(
      {super.key,
      required this.textEdit,
      required this.hintText,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller:  textEdit,
      obscureText: obscureText,
      decoration:  InputDecoration(
        enabledBorder:  const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white)
        ),
        focusedBorder:  const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white)
        ),
        fillColor: Colors.grey.shade200,
    filled: true,
    hintText: hintText,
    hintStyle: TextStyle(color: Colors.grey[500])
      ),
    );
  }
}
