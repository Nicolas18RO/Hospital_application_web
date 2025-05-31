import 'package:flutter/material.dart';

class RegisterOnTap extends StatelessWidget {
  final VoidCallback? onTap;

  const RegisterOnTap({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'No estás registrado?',
          style: TextStyle(color: Color(0xfff7e6ff)),
        ),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: onTap,
          child: const Text(
            'Regístrate Ahora',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
