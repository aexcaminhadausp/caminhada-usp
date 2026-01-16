import 'package:app/screens/rote_statistic.dart';
import 'package:flutter/material.dart';

class BotaoRota extends StatelessWidget {
  final IconData icone;
  final double tamanhoBotao;
  final double tamanhoIcone;
  final Color cor;
  final bool finalizar;
  const BotaoRota({
    super.key, 
    required this.icone, 
    required this.tamanhoBotao, 
    required this.tamanhoIcone,
    required this.cor,
    required this.finalizar});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: tamanhoBotao,
      height: tamanhoBotao,
      child: ElevatedButton(
        onPressed: () {if(finalizar){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RotaFinalizada(),));
        }},
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
          backgroundColor: cor,
        ),
        child: Icon(icone, size: tamanhoIcone,),
      ),
    );
  }
}