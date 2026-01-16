import 'package:app/screens/route_statistic.dart';
import 'package:flutter/material.dart';

class ControllRoteButton extends StatelessWidget {
  final IconData icone;
  final double buttonSize;
  final double iconSize;
  final Color color;
  final bool finish;
  const ControllRoteButton({
    super.key, 
    required this.icone, 
    required this.buttonSize, 
    required this.iconSize,
    required this.color,
    required this.finish});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: ElevatedButton(
        onPressed: () {if(finish){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RotaFinalizada(),));
        }},
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
          backgroundColor: color,
        ),
        child: Icon(icone, size: iconSize,),
      ),
    );
  }
}