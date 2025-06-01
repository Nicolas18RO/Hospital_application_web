import 'package:flutter/material.dart';

class ContainerHome extends StatelessWidget {
  final Widget child;
  const ContainerHome({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: 400,
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
