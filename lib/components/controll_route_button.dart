import 'package:flutter/material.dart';

class ControllRoteButton extends StatelessWidget {
  final IconData icone;
  final double buttonSize;
  final double iconSize;
  final Color color;
  final bool finish;
  final VoidCallback? onTap;

  const ControllRoteButton({
    super.key, 
    required this.icone, 
    required this.buttonSize, 
    required this.iconSize,
    required this.color,
    required this.finish,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: ElevatedButton(
        onPressed: onTap,
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