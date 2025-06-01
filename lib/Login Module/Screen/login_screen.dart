import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hospital_gestion_application/Components/Widgets/my_error_message.dart';
import 'package:hospital_gestion_application/Components/Widgets/text_ontap.dart';
import 'package:hospital_gestion_application/Components/Widgets/my_button.dart';
import 'package:hospital_gestion_application/Components/Widgets/my_text.dart';
import 'package:hospital_gestion_application/Components/Widgets/my_textfield.dart';
import 'package:hospital_gestion_application/Home%20Module/Screen/home_screen.dart';
import 'package:hospital_gestion_application/Login%20Module/Components/style_login.dart';
import 'package:hospital_gestion_application/Register%20Module/Screen/register_screen.dart';

class LoginScreen extends StatefulWidget {
  final Function()? onTap;
  const LoginScreen({
    super.key,
    this.onTap,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Método para iniciar sesión
  Future<void> iniciarSesion() async {
    // Mostrar un círculo de carga mientras se inicia la sesión
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        Navigator.pop(context);
        mostrarMensajeError(
            context, "Por favor, ingresa el correo y la contraseña");
        return;
      }

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim());

      // Obtener el usuario actual
      User? user = userCredential.user;

      if (user != null) {
        // Recargar usuario para asegurarse de que emailVerified esté actualizado
        await user.reload();
        user = FirebaseAuth.instance.currentUser;

        if (!user!.emailVerified) {
          // Si el email no está verificado, mostrar mensaje y opción para reenviar
          Navigator.pop(context); // Cerrar el círculo de carga
          await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.deepPurple,
                title: const Text(
                  'Correo no verificado',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                content: Text(
                  'Debes verificar tu correo electrónico antes de iniciar sesión.\n\n¿Quieres que te enviemos un nuevo correo de verificación?',
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Cerrar el diálogo
                    },
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await user?.sendEmailVerification();
                      Navigator.pop(context); // Cerrar el diálogo
                      mostrarMensajeError(context,
                          'Se ha enviado un nuevo correo de verificación a: ${user?.email}');
                    },
                    child: const Text(
                      'Reenviar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          );
          return;
        }

        // Finalización del círculo de carga
        Navigator.pop(context);

        // Redireccionar a HomePage si el correo está verificado
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    } on FirebaseAuthException catch (e) {
      // Finalización del círculo de carga
      Navigator.pop(context);

      // Mensajes de error
      switch (e.code) {
        case 'invalid-email':
          mostrarMensajeError(context, 'E-mail inválido');
          break;
        case 'user-not-found':
          mostrarMensajeError(
              context, 'No se encontró un usuario con ese correo electrónico');
          break;
        case 'wrong-password':
          mostrarMensajeError(context, 'Contraseña incorrecta');
          break;
        default:
          mostrarMensajeError(context, 'Error desconocido: ${e.code}');
      }
    }
  }

  //==============================================================================================================================================================================

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
              const MyText(
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
                      const MyText(
                        texto: 'INICIO DE ',
                        fontSizeText: 30,
                        color: Color(0xFF16234D),
                      ),
                      const MyText(
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
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              //INGRESAR Button
              const SizedBox(height: 20),
              MyButton(onTap: iniciarSesion, text: 'INGRESAR'),

              //Text: No estás registrado?
              //OnTap: Navagate to RegisterScreen
              const SizedBox(height: 15),
              SizedBox(
                height: 30,
                width: 400,
                child: TextOnTap(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()));
                    },
                    messageText: 'No estás Registrado? ',
                    onTapText: 'Registrate Ahora'),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
