import 'package:flutter/material.dart';
import 'package:hospital_gestion_application/UserRole%20Module/Admin/Components/style_admin.dart';
import 'package:hospital_gestion_application/UserRole%20Module/Admin/Doctor%20Module/Screen/doctor_list_screen.dart';
import 'package:hospital_gestion_application/UserRole%20Module/Admin/Doctor%20Module/Screen/doctor_screen.dart';
import 'package:hospital_gestion_application/Components/Widgets/my_button.dart';
import 'package:hospital_gestion_application/Components/Widgets/my_text.dart';
import 'package:hospital_gestion_application/UserRole%20Module/Components/style_user.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

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
              top: 10, left: 10, child: AccountUser(textIcon: 'Admin')),

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
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ContainerAdmin(
                  child: Column(
                children: [
                  SizedBox(
                      width: 400,
                      height: 300,
                      child: Image.asset(
                        'lib/Components/Images/Doctor.webp',
                        fit: BoxFit.scaleDown,
                      )),

                  //Registrar Doctor
                  const SizedBox(height: 20),
                  MyButton(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DoctorScreen(),
                          )),
                      text: 'Registrar Doctor')
                ],
              )),
              const SizedBox(width: 50),
              ContainerAdmin(
                  child: Column(
                children: [
                  SizedBox(
                      width: 400,
                      height: 300,
                      child: Image.asset(
                        'lib/Components/Images/Schedule.webp',
                        fit: BoxFit.scaleDown,
                      )),

                  //Registrar Doctor
                  const SizedBox(height: 20),
                  MyButton(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DoctorListScreen(),
                          )),
                      text: 'Horario Doctor')
                ],
              )),
            ],
          ))
        ],
      ),
    );
  }
}
