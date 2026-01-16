//classe que cria as linhas das estatisticas
import 'package:flutter/material.dart';

class RouteStatisticFinishedLabel extends StatelessWidget {
  final String label;
  final String value;

  const RouteStatisticFinishedLabel({super.key, 
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}