import 'package:flutter/material.dart';

import '../../Login Module/Screen/login_screen.dart';
import '../../Register Module/Screen/register_screen.dart';

class LoginOrRegisterScreen extends StatefulWidget {
  const LoginOrRegisterScreen({super.key});

  @override
  State<LoginOrRegisterScreen> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterScreen> {
  //Inicialmente se mostrará LoginPage
  bool showLoginScreen = true;

  //Luego entre login y Register page
  void togglePage() {
    setState(() {
      showLoginScreen = !showLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginScreen) {
      return LoginScreen(
        onTap: togglePage,
      );
    } else {
      return RegisterScreen(onTap: togglePage);
    }
  }
}
