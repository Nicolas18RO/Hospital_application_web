import 'package:flutter/material.dart';
import 'package:hospital_gestion_application/Components/Widgets/login_or_register.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: LoginOrRegisterScreen());
  }
}
