import 'package:flutter/material.dart';

class ContainerAgendarCitas extends StatelessWidget {
  final Widget child;
  const ContainerAgendarCitas({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.6,
      width: MediaQuery.of(context).size.width / 1.2,
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
