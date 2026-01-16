import 'package:flutter/material.dart';

class CampoRota extends StatelessWidget {
  final String titulo;
  final String hint;
  const CampoRota({super.key, required this.titulo, required this.hint});

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
          Text("$titulo:", style: TextStyle(
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