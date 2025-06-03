import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hospital_gestion_application/Components/Widgets/my_text.dart';
import 'package:hospital_gestion_application/UserRole%20Module/Admin/Doctor%20Module/Models/doctor_model.dart';
import 'package:hospital_gestion_application/UserRole%20Module/Components/style_user.dart';
import 'package:hospital_gestion_application/UserRole%20Module/User/Agendar%20Citas%20Module/Components/style_agendar_citas.dart';
import 'package:hospital_gestion_application/UserRole%20Module/User/Agendar%20Citas%20Module/Models/appointment_model.dart';
import 'package:hospital_gestion_application/UserRole%20Module/User/Components/my_button_user.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';

class AgendarCitaScreen extends StatefulWidget {
  const AgendarCitaScreen({super.key});

  @override
  State<AgendarCitaScreen> createState() => _AgendarCitaScreenState();
}

class _AgendarCitaScreenState extends State<AgendarCitaScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  String? _selectedTime;
  String? _selectedDoctorId;
  final TextEditingController _reasonController = TextEditingController();

  List<Doctor> _doctors = [];
  Map<String, List<String>> _availableSlots = {};
  bool _isLoading = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_ES', '').then((_) {
      _loadDoctors();
    });
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _loadDoctors() async {
    setState(() => _isLoading = true);
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .get()
          .timeout(const Duration(seconds: 15));

      debugPrint('Loaded ${snapshot.docs.length} doctors');

      setState(() {
        _doctors = snapshot.docs.map((doc) {
          debugPrint('Doctor data: ${doc.data()}');
          return Doctor.fromFirestore(doc);
        }).toList();
      });

      if (_doctors.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontraron doctores')),
        );
      }
    } catch (e) {
      debugPrint('Error loading doctors: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cargando doctores: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadAvailability(String doctorId, DateTime date) async {
    setState(() => _isLoading = true);
    try {
      final dayName = DateFormat('EEEE', 'es_ES').format(date);
      debugPrint('Checking availability for $dayName');

      final doctor = _doctors.firstWhere((d) => d.id == doctorId);

      if (!doctor.workingDays.contains(dayName)) {
        setState(() {
          _availableSlots[doctorId] = [];
        });
        return;
      }

      final bookedAppointments = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctorId', isEqualTo: doctorId)
          .where('date', isEqualTo: Timestamp.fromDate(date))
          .where('status', whereIn: ['pending', 'confirmed']).get();

      final bookedTimes =
          bookedAppointments.docs.map((doc) => doc['time'] as String).toList();

      debugPrint('Booked times: $bookedTimes');
      debugPrint('All available times: ${doctor.availability[dayName]}');

      final availableTimes = doctor.availability[dayName]
              ?.where((time) => !bookedTimes.contains(time))
              .toList() ??
          [];

      debugPrint('Available times after filtering: $availableTimes');

      setState(() {
        _availableSlots[doctorId] = availableTimes;
      });
    } catch (e) {
      debugPrint('Error loading availability: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cargando disponibilidad: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
      locale: const Locale('es', 'ES'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      debugPrint('Selected date: $picked');
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
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDoctorId == null ||
        _selectedDate == null ||
        _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete todos los campos')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Usuario no autenticado');

      final appointment = Appointment(
        id: FirebaseFirestore.instance.collection('appointments').doc().id,
        patientId: user.uid,
        doctorId: _selectedDoctorId!,
        date: _selectedDate!,
        time: _selectedTime!,
        reason: _reasonController.text,
      );

      // Check for duplicate appointments
      final existingAppointment = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctorId', isEqualTo: _selectedDoctorId)
          .where('date', isEqualTo: Timestamp.fromDate(_selectedDate!))
          .where('time', isEqualTo: _selectedTime)
          .where('status', whereIn: ['pending', 'confirmed']).get();

      if (existingAppointment.docs.isNotEmpty) {
        throw Exception('Este horario ya fue reservado');
      }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/Components/Images/HomeWallpaper.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: Colors.grey[200]),
            ),
          ),
          const Positioned(
            top: 10,
            left: 10,
            child: AccountUser(textIcon: 'Admin'),
          ),
          const Align(
            alignment: Alignment.topCenter,
            child: MyText(
              texto: 'Tu Salud CM',
              fontSizeText: 50,
              color: Colors.black,
            ),
          ),
          Center(
            child: ContainerAgendarCitas(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // Doctor Selection
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Seleccionar Doctor',
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        value: _selectedDoctorId,
                        items: _doctors.map((doctor) {
                          return DropdownMenuItem<String>(
                            value: doctor.id,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dr. ${doctor.name} ${doctor.lastName}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  doctor.specialty,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          debugPrint('Selected doctor: $value');
                          setState(() {
                            _selectedDoctorId = value;
                            _selectedDate = null;
                            _selectedTime = null;
                            _availableSlots.clear();
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Seleccione un doctor' : null,
                        isExpanded: true,
                      ),

                      const SizedBox(height: 20),

                      // Date Picker
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.white,
                        ),
                        onPressed: _selectedDoctorId == null
                            ? null
                            : () => _selectDate(context),
                        child: Text(
                          _selectedDate == null
                              ? 'Seleccionar Fecha'
                              : 'Fecha: ${DateFormat('EEEE dd/MM/yyyy', 'es_ES').format(_selectedDate!)}',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),

                      // Time Slots
                      if (_selectedDate != null &&
                          _selectedDoctorId != null) ...[
                        const SizedBox(height: 20),
                        const Text(
                          'Horarios Disponibles:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        _availableSlots[_selectedDoctorId]?.isNotEmpty ?? false
                            ? Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: _availableSlots[_selectedDoctorId]!
                                    .map((time) {
                                  return FilterChip(
                                    label: Text(time),
                                    selected: _selectedTime == time,
                                    onSelected: (selected) {
                                      setState(() {
                                        _selectedTime = selected ? time : null;
                                        _hasChanges = true;
                                      });
                                    },
                                    selectedColor: Colors.blue[200],
                                    checkmarkColor: Colors.white,
                                    labelStyle: TextStyle(
                                      color: _selectedTime == time
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  );
                                }).toList(),
                              )
                            : const Text('No hay horarios disponibles'),
                      ],

                      // Reason
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _reasonController,
                        decoration: InputDecoration(
                          labelText: 'Motivo de la cita',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                        ),
                        maxLines: 3,
                        validator: (value) =>
                            value!.isEmpty ? 'Ingrese el motivo' : null,
                        onChanged: (value) => _hasChanges = true,
                      ),

                      // Submit Button
                      const SizedBox(height: 30),
                      MyButtonUser(
                        onTap: _isLoading || !_hasChanges
                            ? null
                            : _bookAppointment,
                        text: _isLoading ? 'Agendando...' : 'Agendar Cita',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
