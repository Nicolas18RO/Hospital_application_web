import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hospital_gestion_application/UserRole%20Module/Admin/Doctor%20Module/Components/my_form_textfield.dart';
import 'package:hospital_gestion_application/UserRole%20Module/Admin/Doctor%20Module/Components/style_doctor.dart';
import 'package:hospital_gestion_application/Components/Widgets/my_button.dart';
import 'package:hospital_gestion_application/Components/Widgets/my_text.dart';
import 'package:hospital_gestion_application/UserRole%20Module/Components/style_user.dart';

import '../Models/doctor_model.dart';

class DoctorScreen extends StatefulWidget {
  const DoctorScreen({super.key});

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _specialtyController = TextEditingController();
  final TextEditingController _documentController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final List<String> _selectedDays = [];
  final List<String> _daysOfWeek = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado'
  ];

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _specialtyController.dispose();
    _documentController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _toggleDay(String day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  Future<void> _registerDoctor() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final newDoctor = Doctor(
          name: _nameController.text,
          lastName: _lastNameController.text,
          specialty: _specialtyController.text,
          document: _documentController.text,
          phone: _phoneController.text,
          email: _emailController.text,
          workingDays: _selectedDays,
          availability: {},
          id: '',
        );

        await FirebaseFirestore.instance
            .collection('doctors')
            .add(newDoctor.toMap());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Doctor registrado exitosamente!')),
        );
        _formKey.currentState?.reset();
        setState(() => _selectedDays.clear());
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar: $e')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  //===========================================================================================================================

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
            child: ContainerFormDoctor(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      // Doctor Name
                      MyTextFormField(
                        controller: _nameController,
                        labelText: 'Nombre',
                        prefixIcon: Icons.person,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa un Nombre';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      // Doctor Last Name
                      MyTextFormField(
                        controller: _lastNameController,
                        labelText: 'Apellido',
                        prefixIcon: Icons.person,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa un apellido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      // Specialty
                      MyTextFormField(
                        controller: _specialtyController,
                        labelText: 'Especialidad',
                        prefixIcon: Icons.medical_information,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa una espcialidad';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      // ID_Document Number
                      MyTextFormField(
                        controller: _documentController,
                        labelText: 'Numero De Documento',
                        prefixIcon: Icons.numbers_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa un numero de documento';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      // Phone Number
                      MyTextFormField(
                        controller: _phoneController,
                        labelText: 'Numero De Telefono',
                        prefixIcon: Icons.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa un numero telefonico';
                          }
                          return null;
                        },
                      ),

                      // Email
                      const SizedBox(height: 10),
                      MyTextFormField(
                        controller: _emailController,
                        labelText: 'Correo',
                        prefixIcon: Icons.email,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa un correo';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      //New Test
                      // Add Working Days Selection
                      const SizedBox(height: 10),
                      const MyText(
                        texto: 'Días de Trabajo',
                        fontSizeText: 16,
                        color: Colors.black54,
                      ),
                      Wrap(
                        spacing: 8.0,
                        children: _daysOfWeek.map((day) {
                          return FilterChip(
                            label: Text(day),
                            selected: _selectedDays.contains(day),
                            onSelected: (bool selected) {
                              _toggleDay(day);
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),

                      // Register Doctor Button
                      MyButton(
                        onTap: _isLoading ? null : _registerDoctor,
                        text:
                            _isLoading ? 'Registrando...' : 'Registrar Doctor',
                      ),
                      SizedBox(height: 10)
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
