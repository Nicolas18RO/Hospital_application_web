import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String texto;
  final double fontSizeText;
  final Color? color;

  const MyText(
      {super.key, required this.texto, required this.fontSizeText, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: TextStyle(
          color: color, fontSize: fontSizeText, fontWeight: FontWeight.bold),
    );
  }
}
