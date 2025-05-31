import 'package:flutter/material.dart';
import 'package:hospital_gestion_application/Login%20Module/Components/my_button_login.dart';
import 'package:hospital_gestion_application/Login%20Module/Components/my_text_login.dart';
import 'package:hospital_gestion_application/Login%20Module/Components/my_textfield_login.dart';
import 'package:hospital_gestion_application/Login%20Module/Components/register_ontap.dart';
import 'package:hospital_gestion_application/Login%20Module/Components/style_login.dart';
import 'package:hospital_gestion_application/Login%20Module/Screen/register_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController? emailController, passwordController;
  const LoginScreen({
    super.key,
    this.emailController,
    this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        //Image Background
        Positioned.fill(
          child: Image.asset(
            'lib/Components/Images/LoginWallpaper.jpg',
            fit: BoxFit.cover,
          ),
        ),

        //Half-Color Gradient Background
        const Align(
            alignment: Alignment.centerRight, child: HalfColorBackground()),

        //Login Container
        Align(
          alignment: Alignment.centerRight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const MyTextLogin(
                texto: 'Tu Salud CM',
                fontSizeText: 25,
                color: Color(0xFFEFF6FF),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(right: 40),
                //Login Container
                child: ContainerLogin(
                  child: Column(
                    children: [
                      //Text: INICIO DE SESION
                      const SizedBox(height: 10),
                      const MyTextLogin(
                        texto: 'INICIO DE ',
                        fontSizeText: 30,
                        color: Color(0xFF16234D),
                      ),
                      const MyTextLogin(
                        texto: 'SESIÓN',
                        fontSizeText: 30,
                        color: Color(0xFF16234D),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Text: Correo Electronico
                            const SizedBox(height: 20),
                            const MyTextLogin(
                                texto: 'Correo :',
                                fontSizeText: 20,
                                color: Color(0xFF002F34)),

                            //TextField Email
                            MyTextFieldLogin(
                              controller: emailController,
                              obscureText: false,
                            ),

                            //Text: Contraseña
                            const SizedBox(height: 20),
                            const MyTextLogin(
                                texto: 'Contraseña :',
                                fontSizeText: 20,
                                color: Color(0xFF002F34)),

                            //TextField Password
                            MyTextFieldLogin(
                              controller: passwordController,
                              obscureText: true,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              //INGRESAR Button
              const SizedBox(height: 20),
              const MyButtonLogin(onTap: null, text: 'INGRESAR'),

              //Text: No estás registrado?
              //OnTap: Navagate to RegisterScreen
              const SizedBox(height: 15),
              SizedBox(
                height: 30,
                width: 400,
                child: RegisterOnTap(onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterScreen()));
                }),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
