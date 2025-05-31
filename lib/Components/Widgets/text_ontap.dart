import 'package:flutter/material.dart';

class TextOnTap extends StatelessWidget {
  final String messageText, onTapText;
  final VoidCallback? onTap;

  const TextOnTap({
    super.key,
    required this.onTap,
    required this.messageText,
    required this.onTapText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          messageText,
          style: const TextStyle(color: Color(0xfff7e6ff)),
        ),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: onTap,
          child: Text(
            onTapText,
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
