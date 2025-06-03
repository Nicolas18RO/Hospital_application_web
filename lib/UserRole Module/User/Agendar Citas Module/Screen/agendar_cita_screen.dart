import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hospital_gestion_application/UserRole%20Module/Admin/Doctor%20Module/Models/doctor_model.dart';
import 'package:hospital_gestion_application/UserRole%20Module/User/Agendar%20Citas%20Module/Models/appointment_model.dart';
import 'package:intl/intl.dart';

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
  DateTime? _selectedDate;
  String? _selectedTime;
  String? _selectedDoctorId;
  final TextEditingController _reasonController = TextEditingController();

  List<Doctor> _doctors = [];
  Map<String, List<String>> _availableSlots = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  Future<void> _loadDoctors() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('doctors').get();
    setState(() {
      _doctors = snapshot.docs.map((doc) => Doctor.fromFirestore(doc)).toList();
    });
  }

  Future<void> _loadAvailability(String doctorId, DateTime date) async {
    final doc = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorId)
        .get();
    final doctor = Doctor.fromFirestore(doc);
    final dayName = DateFormat('EEEE').format(date);

    if (doctor.workingDays.contains(dayName)) {
      final bookedAppointments = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctorId', isEqualTo: doctorId)
          .where('date', isEqualTo: Timestamp.fromDate(date))
          .where('status', whereIn: ['pending', 'confirmed']).get();

      final bookedTimes =
          bookedAppointments.docs.map((doc) => doc['time'] as String).toList();

      final availableTimes = doctor.availability[dayName]
              ?.where(
                (time) => !bookedTimes.contains(time),
              )
              .toList() ??
          [];

      setState(() {
        _availableSlots[doctorId] = availableTimes;
      });
    } else {
      setState(() {
        _availableSlots[doctorId] = [];
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _selectedTime = null;
      });
      if (_selectedDoctorId != null) {
        await _loadAvailability(_selectedDoctorId!, picked);
      }
    }
  }

  Future<void> _bookAppointment() async {
    if (_formKey.currentState!.validate() &&
        _selectedDoctorId != null &&
        _selectedDate != null &&
        _selectedTime != null) {
      setState(() => _isLoading = true);

      final appointment = Appointment(
        id: FirebaseFirestore.instance.collection('appointments').doc().id,
        patientId: FirebaseAuth.instance.currentUser!.uid,
        doctorId: _selectedDoctorId!,
        date: _selectedDate!,
        time: _selectedTime!,
        reason: _reasonController.text,
      );

      try {
        await FirebaseFirestore.instance
            .collection('appointments')
            .doc(appointment.id)
            .set(appointment.toMap());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cita agendada exitosamente!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al agendar: $e')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Fondo
          Positioned.fill(
            child: Image.asset(
              'lib/Components/Images/HomeWallpaper.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Icono de usuario
          const Positioned(
            top: 10,
            left: 10,
            child: AccountUser(textIcon: 'Admin'),
          ),

          // Título
          const Align(
            alignment: Alignment.topCenter,
            child: MyText(
              texto: 'Tu Salud CM',
              fontSizeText: 50,
              color: Colors.black,
            ),
          ),

          // Contenido principal
          Center(
            child: ContainerAgendarCitas(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // Doctor
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                            labelText: 'Seleccionar Doctor'),
                        items: _doctors.map((doctor) {
                          return DropdownMenuItem(
                            value: doctor.id,
                            child: Text(
                                'Dr. ${doctor.name} ${doctor.lastName} - ${doctor.specialty}'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedDoctorId = value;
                            _selectedDate = null;
                            _selectedTime = null;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Seleccione un doctor' : null,
                      ),

                      const SizedBox(height: 20),

                      // Fecha
                      ElevatedButton(
                        onPressed: _selectedDoctorId == null
                            ? null
                            : () => _selectDate(context),
                        child: Text(
                          _selectedDate == null
                              ? 'Seleccionar Fecha'
                              : 'Fecha: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
                        ),
                      ),

                      if (_selectedDate != null &&
                          _selectedDoctorId != null) ...[
                        const SizedBox(height: 20),
                        const Text('Horarios Disponibles:'),
                        Wrap(
                          spacing: 8,
                          children: _availableSlots[_selectedDoctorId]
                                  ?.map((time) {
                                return ChoiceChip(
                                  label: Text(time),
                                  selected: _selectedTime == time,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedTime = selected ? time : null;
                                    });
                                  },
                                );
                              }).toList() ??
                              [
                                const Text(
                                    'No hay horarios disponibles para este día')
                              ],
                        ),
                      ],

                      const SizedBox(height: 20),

                      // Motivo
                      TextFormField(
                        controller: _reasonController,
                        decoration: const InputDecoration(
                          labelText: 'Motivo de la cita',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) => value!.isEmpty
                            ? 'Ingrese el motivo de la cita'
                            : null,
                      ),

                      const SizedBox(height: 30),

                      // Botón
                      MyButtonUser(
                        onTap: _isLoading ? null : _bookAppointment,
                        text: _isLoading ? 'Agendando...' : 'Agendar Cita',
                      ),
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
