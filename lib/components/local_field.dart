import 'package:flutter/material.dart';

class LocalField extends StatelessWidget {

  final String title;
  final String hint;
  final TextEditingController controller;

  const LocalField({
    super.key,
    required this.title,
    required this.hint,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(title),

        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
          ),
        ),
      ],
    );
  }
}
