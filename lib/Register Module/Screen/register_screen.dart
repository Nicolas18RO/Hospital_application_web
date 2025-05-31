import 'package:flutter/material.dart';
import '../../Components/Widgets/my_button.dart';
import '../../Components/Widgets/my_text.dart';
import '../../Components/Widgets/my_textfield.dart';
import '../../Components/Widgets/text_ontap.dart';
import '../../Login Module/Screen/login_screen.dart';
import '../Components/style_register.dart';

class RegisterScreen extends StatelessWidget {
  final Function()? onTap;
  final TextEditingController? emailController,
      passwordController,
      confirmPasswordController;
  const RegisterScreen({
    super.key,
    this.emailController,
    this.passwordController,
    this.confirmPasswordController,
    this.onTap,
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
            alignment: Alignment.centerLeft,
            child: HalfColorBackgroundRegister()),

        //Login Container
        Align(
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const MyText(
                texto: 'Tu Salud CM',
                fontSizeText: 25,
                color: Color(0xFFEFF6FF),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                //Login Container
                child: ContainerRegister(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //Text: INICIO DE SESION
                        const SizedBox(height: 10),
                        const MyText(
                          texto: 'REGISTRATE',
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
                              const MyText(
                                  texto: 'Correo :',
                                  fontSizeText: 20,
                                  color: Color(0xFF002F34)),

                              //TextField Email
                              MyTextField(
                                controller: emailController,
                                obscureText: false,
                              ),

                              //Text: Contraseña
                              const SizedBox(height: 20),
                              const MyText(
                                  texto: 'Contraseña :',
                                  fontSizeText: 20,
                                  color: Color(0xFF002F34)),

                              //TextField Password
                              MyTextField(
                                controller: passwordController,
                                obscureText: true,
                              ),

                              //Text: Confirmar Contraseña
                              const SizedBox(height: 20),
                              const MyText(
                                  texto: 'Confirmar Contraseña :',
                                  fontSizeText: 20,
                                  color: Color(0xFF002F34)),

                              //TextField Confirm Password
                              MyTextField(
                                controller: confirmPasswordController,
                                obscureText: true,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              //INGRESAR Button
              const SizedBox(height: 20),
              const MyButton(onTap: null, text: 'INGRESAR'),

              //Text: No estás registrado?
              //OnTap: Navagate to LoginScreen
              const SizedBox(height: 15),
              SizedBox(
                height: 30,
                width: 400,
                child: TextOnTap(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    messageText: 'Ya estás Registrado? ',
                    onTapText: 'Inicia Sesión Ahora'),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
