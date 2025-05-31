import 'package:flutter/material.dart';

class MyTextFieldLogin extends StatelessWidget {
  final TextEditingController? controller;
  final bool obscureText;

  const MyTextFieldLogin({
    super.key,
    required this.controller,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 2, // Shadow spread
              blurRadius: 5, // Shadow blur
              offset: const Offset(0, 3), // Shadow position (x, y)
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(color: Color(0xff16234D)), // Text color
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFEFF6FF), // Background color
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              // Border when focused
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Color(0xFF16234D), // Focus border color
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
