import 'package:flutter/material.dart';

class LocalField extends StatelessWidget {
  final String title;
  final String hint;
  const LocalField({super.key, required this.title, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
      child: Row(
        children: [
          const Icon(Icons.pin_drop_rounded),
          const SizedBox(width: 8),
          Text("$title:", style: TextStyle(
              fontSize: 20
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: TextField(
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              isDense: true,
              hintStyle: TextStyle(
                fontSize: 18,
              ),
            ),
          ))
        ],
      ),
    );
  }
}