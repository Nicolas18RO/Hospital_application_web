import 'package:flutter/material.dart';
import 'package:hospital_gestion_application/Components/Widgets/my_text.dart';
import 'package:hospital_gestion_application/UserRole%20Module/Components/style_user.dart';
import 'package:hospital_gestion_application/UserRole%20Module/User/Agendar%20Citas%20Module/Screen/agendar_cita_screen.dart';
import 'package:hospital_gestion_application/UserRole%20Module/User/Components/my_button_user.dart';
import 'package:hospital_gestion_application/UserRole%20Module/User/Components/style_user.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          //Image Background
          Positioned.fill(
            child: Image.asset(
              'lib/Components/Images/HomeWallpaper.webp',
              fit: BoxFit.cover,
            ),
          ),

          //Account Admin Icon
          const Positioned(
              top: 10, left: 10, child: AccountUser(textIcon: 'Paciente')),

          //Title Text: Tu Salud CM
          const Align(
            alignment: Alignment.topCenter,
            child: MyText(
              texto: 'Tu Salud CM',
              fontSizeText: 50,
              color: Colors.black,
            ),
          ),

          //Container
          Center(
              child: ContainerUser(
                  child: Column(
            children: [
              SizedBox(
                  width: 400,
                  height: 300,
                  child: Image.asset(
                    'lib/Components/Images/AgendarCita.webp',
                    fit: BoxFit.scaleDown,
                  )),

              //Registrar Doctor
              const SizedBox(height: 20),
              MyButtonUser(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AgendarCitasScreen(),
                      )),
                  text: 'Agendar Cita')
            ],
          )))
        ],
      ),
    );
  }
}
