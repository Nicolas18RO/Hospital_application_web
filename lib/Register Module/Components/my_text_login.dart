import 'package:flutter/material.dart';

class MyTextLogin extends StatelessWidget {
  final String texto;
  final double fontSizeText;
  final Color? color;

  const MyTextLogin(
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
