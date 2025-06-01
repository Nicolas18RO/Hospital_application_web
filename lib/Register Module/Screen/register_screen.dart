import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hospital_gestion_application/Components/Widgets/my_error_message.dart';
import '../../Components/Widgets/my_button.dart';
import '../../Components/Widgets/my_text.dart';
import '../../Components/Widgets/my_textfield.dart';
import '../../Components/Widgets/text_ontap.dart';
import '../../Login Module/Screen/login_screen.dart';
import '../Components/style_register.dart';

class RegisterScreen extends StatefulWidget {
  final Function()? onTap;

  const RegisterScreen({
    super.key,
    this.onTap,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  //Metodo Registrar ususario de Sesion
  Future<void> registrarSesion() async {
    // Mostrar un círculo de carga mientras se inicia la sesión
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      // Confirmar si la contraseña está confirmada
      if (passwordController.text == confirmPasswordController.text) {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text.trim());

        // Obtener el usuario actual
        User? user = userCredential.user;

        if (user != null && !user.emailVerified) {
          await user.sendEmailVerification();

          // Cerrar el círculo de carga
          Navigator.pop(context);

          // Mostrar mensaje de verificación y esperar a que el usuario lo cierre
          await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: const Color.fromARGB(255, 198, 178, 233),
                title: const Text(
                  'Verificación de correo',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                content: Text(
                  'Se ha enviado un correo de verificación a: ${user.email}',
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Cerrar el diálogo
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(onTap: () {}),
                        ),
                      );
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              );
            },
          );
        }
      } else {
        // Cerrar el círculo de carga
        Navigator.pop(context);
        // Mostrar mensaje de error
        mostrarMensajeError(context, "¡Las contraseñas no coinciden!");
      }
    } on FirebaseAuthException catch (e) {
      // Cerrar el círculo de carga
      Navigator.pop(context);
      // Mostrar mensaje de error
      mostrarMensajeError(context, e.code);
    }
  }

  //=========================================================================================================================================
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
              MyButton(onTap: () => registrarSesion(), text: 'REGISTRAR'),

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
