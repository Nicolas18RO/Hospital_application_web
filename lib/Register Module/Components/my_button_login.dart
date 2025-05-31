import 'package:flutter/material.dart';

class MyButtonLogin extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const MyButtonLogin({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 200,
        decoration: BoxDecoration(
          color: const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                color: Color(0xFF002F34),
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
