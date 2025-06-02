import 'package:flutter/material.dart';

class MyButtonUser extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const MyButtonUser({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 200,
        decoration: BoxDecoration(
          color: const Color(0xFF1D2D2F),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                color: Color(0xFFF3F8F7),
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
