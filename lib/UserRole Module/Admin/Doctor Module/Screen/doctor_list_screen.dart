import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/doctor_model.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  final List<String> _allDays = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado'
  ];
  final List<String> _timeSlots = [
    '08:00',
    '09:00',
    '10:00',
    '11:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00'
  ];
  final Map<String, Doctor> _pendingUpdates = {};
  final Set<String> _expandedDoctors = {};
  bool _isSaving = false;

  Future<void> _saveChanges() async {
    setState(() => _isSaving = true);
    try {
      final batch = FirebaseFirestore.instance.batch();

      _pendingUpdates.forEach((doctorId, doctor) {
        final docRef =
            FirebaseFirestore.instance.collection('doctors').doc(doctorId);
        batch.update(docRef, {
          'workingDays': doctor.workingDays,
          'availability': doctor.availability,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });

      await batch.commit();
      _pendingUpdates.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cambios guardados exitosamente!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: $e')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _toggleWorkingDay(Doctor doctor, String day) {
    setState(() {
      final updatedDoctor = _pendingUpdates[doctor.id!] ?? doctor.copyWith();
      if (updatedDoctor.workingDays.contains(day)) {
        updatedDoctor.removeWorkingDay(day);
        updatedDoctor.availability.remove(day);
      } else {
        updatedDoctor.addWorkingDay(day);
        updatedDoctor.availability[day] = [];
      }
      _pendingUpdates[doctor.id!] = updatedDoctor;
    });
  }

  void _toggleTimeSlot(Doctor doctor, String day, String time) {
    setState(() {
      final updatedDoctor = _pendingUpdates[doctor.id!] ?? doctor.copyWith();
      if (updatedDoctor.availability[day]?.contains(time) ?? false) {
        updatedDoctor.removeTimeSlot(day, time);
      } else {
        updatedDoctor.addTimeSlot(day, time);
      }
      _pendingUpdates[doctor.id!] = updatedDoctor;
    });
  }

  Widget _buildDayAvailability(Doctor doctor, String day) {
    final editedDoctor = _pendingUpdates[doctor.id!] ?? doctor;
    final isDaySelected = editedDoctor.workingDays.contains(day);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            day,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDaySelected ? Colors.blue : Colors.grey,
            ),
          ),
          trailing: Switch(
            value: isDaySelected,
            onChanged: (_) => _toggleWorkingDay(doctor, day),
          ),
        ),
        if (isDaySelected) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _timeSlots.map((time) {
                final isSelected =
                    editedDoctor.availability[day]?.contains(time) ?? false;
                return ChoiceChip(
                  label: Text(time),
                  selected: isSelected,
                  onSelected: (_) => _toggleTimeSlot(doctor, day, time),
                  selectedColor: Colors.blue[200],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disponibilidad de Doctores'),
        actions: [
          IconButton(
            icon: _isSaving
                ? const CircularProgressIndicator()
                : const Icon(Icons.save),
            onPressed:
                _pendingUpdates.isEmpty || _isSaving ? null : _saveChanges,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('doctors').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final doctor = Doctor.fromFirestore(doc);
              final editedDoctor = _pendingUpdates[doctor.id!] ?? doctor;
              final isExpanded = _expandedDoctors.contains(doctor.id!);

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dr. ${editedDoctor.name} ${editedDoctor.lastName}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        editedDoctor.specialty,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          icon: Icon(isExpanded
                              ? Icons.expand_less
                              : Icons.expand_more),
                          label: Text(
                              isExpanded ? 'Ocultar Horario' : 'Ver Horario'),
                          onPressed: () {
                            setState(() {
                              if (isExpanded) {
                                _expandedDoctors.remove(doctor.id!);
                              } else {
                                _expandedDoctors.add(doctor.id!);
                              }
                            });
                          },
                        ),
                      ),
                      if (isExpanded) ...[
                        const Divider(),
                        const Text(
                          'Días de trabajo:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ..._allDays
                            .map((day) => _buildDayAvailability(doctor, day))
                            .toList(),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
