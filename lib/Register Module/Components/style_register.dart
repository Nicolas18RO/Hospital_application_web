import 'package:flutter/material.dart';

class ContainerRegister extends StatelessWidget {
  final Widget child;
  const ContainerRegister({super.key, required this.child});

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

class HalfColorBackgroundRegister extends StatelessWidget {
  const HalfColorBackgroundRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width / 1.6,
      child: const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
            Color(0xFF16234D),
            Color(0xE616234D),
            Color(0x001F3C89),
          ], begin: Alignment.centerLeft, end: Alignment.centerRight),
        ),
      ),
    );
  }
}
