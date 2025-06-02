import 'package:flutter/material.dart';
import 'package:hospital_gestion_application/Components/Widgets/my_text.dart';
import 'package:hospital_gestion_application/UserRole%20Module/Components/style_user.dart';
import 'package:hospital_gestion_application/UserRole%20Module/User/Agendar%20Citas%20Module/Components/style_agendar_citas.dart';
import 'package:hospital_gestion_application/UserRole%20Module/User/Components/my_button_user.dart';

class AgendarCitasScreen extends StatefulWidget {
  const AgendarCitasScreen({super.key});

  @override
  State<AgendarCitasScreen> createState() => _AgendarCitasScreenState();
}

class _AgendarCitasScreenState extends State<AgendarCitasScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          //Image Background
          Positioned.fill(
            child: Image.asset(
              'lib/Components/Images/HomeWallpaper.jpg',
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
            child: ContainerAgendarCitas(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Register Doctor Button
                      MyButtonUser(
                        onTap: _isLoading ? null : null,
                        text: _isLoading ? 'Agendando...' : 'Agendar Cita',
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
