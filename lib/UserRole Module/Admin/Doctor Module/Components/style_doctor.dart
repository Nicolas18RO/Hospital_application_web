import 'package:flutter/material.dart';

class ContainerFormDoctor extends StatelessWidget {
  final Widget child;
  const ContainerFormDoctor({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.4,
      width: MediaQuery.of(context).size.width / 1.2,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: <Color>[
          Color(0xFF28E9E8),
          Color(0xFF4EFAF4),
          Color(0xFF8EFFF9)
        ], begin: Alignment.topRight, end: Alignment.bottomLeft),
        borderRadius: BorderRadius.circular(50),
      ),
      child: child,
    );
  }
}
