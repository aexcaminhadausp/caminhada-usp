import 'package:flutter/material.dart';

class LoginField extends StatelessWidget {
  final TextEditingController controller; 
  final bool obscureText;
  final String hintText;


  const LoginField({
    super.key, 
    required this.controller,
    required this.obscureText,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
                borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            fillColor: Colors.grey.shade100,
            filled: true,
            hintText: hintText,
        ),
    );
  }
}