import 'package:flutter/material.dart';

class WarningRota extends StatelessWidget {
  final String mensagem;
  const WarningRota({super.key, required this.mensagem});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.amberAccent,
        borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Icon(Icons.warning, size: 30, color: Colors.deepOrange,),
            SizedBox(width: 10,),
            const Text("Atenção!", style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18
              ),),
            SizedBox(width: 5,),
            Text(mensagem, style: TextStyle(
              fontSize: 18
              ),)
          ],
        )
      ),
    );
  }
}