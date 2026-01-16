import 'package:flutter/material.dart';

class PopularWWalkingSpots extends StatelessWidget {
  final String localName;
  final Color color;
  const PopularWWalkingSpots({super.key, required this.localName, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 130,
      child: ElevatedButton(
        onPressed: () {
          
        }, 
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: color,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child:Align(
            alignment: Alignment.bottomLeft,
            child: Text(localName, style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold
            ),)
          )
        )
        ),
    );
  }
}