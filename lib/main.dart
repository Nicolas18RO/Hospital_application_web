import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hospital_gestion_application/UserRole%20Module/User/Agendar%20Citas%20Module/Screen/agendar_cita_screen.dart';
import 'package:hospital_gestion_application/UserRole%20Module/User/Screen/home_user_screen.dart';

import 'package:hospital_gestion_application/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: UserScreen() //LoginOrRegisterScreen()
        );
  }
}
