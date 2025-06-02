import 'package:flutter/material.dart';

class ContainerUser extends StatelessWidget {
  final Widget child;
  const ContainerUser({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: 400,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: <Color>[
          Color(0xFFC4DDDA),
          Color(0xFFE0EDEC),
          Color(0xFFF3F8F7)
        ], begin: Alignment.topRight, end: Alignment.bottomLeft),
        borderRadius: BorderRadius.circular(50),
      ),
      child: child,
    );
  }
}
