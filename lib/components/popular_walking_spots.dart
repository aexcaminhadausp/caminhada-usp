import 'package:flutter/material.dart';

class PontoPopular extends StatelessWidget {
  final String nomeLocal;
  final Color cor;
  const PontoPopular({super.key, required this.nomeLocal, required this.cor});

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
          backgroundColor: cor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child:Align(
            alignment: Alignment.bottomLeft,
            child: Text(nomeLocal, style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold
            ),)
          )
        )
        ),
    );
  }
}