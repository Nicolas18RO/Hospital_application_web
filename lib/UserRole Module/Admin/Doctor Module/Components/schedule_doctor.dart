// components/doctor_schedule_card.dart
import 'package:flutter/material.dart';
import '../Models/doctor_model.dart';

class DoctorScheduleCard extends StatefulWidget {
  final Doctor doctor;
  final Function(Doctor) onUpdate;

  const DoctorScheduleCard({
    super.key,
    required this.doctor,
    required this.onUpdate,
  });

  @override
  State<DoctorScheduleCard> createState() => _DoctorScheduleCardState();
}

class _DoctorScheduleCardState extends State<DoctorScheduleCard> {
  late Doctor _editedDoctor;

  @override
  void initState() {
    super.initState();
    _editedDoctor = widget.doctor.copyWith();
  }

  void _toggleDay(String day) {
    setState(() {
      if (_editedDoctor.workingDays.contains(day)) {
        _editedDoctor.removeWorkingDay(day);
      } else {
        _editedDoctor.addWorkingDay(day);
      }
    });
    widget.onUpdate(_editedDoctor);
  }

  void _toggleTimeSlot(String day, String time) {
    setState(() {
      if (_editedDoctor.availability[day]?.contains(time) ?? false) {
        _editedDoctor.removeTimeSlot(day, time);
      } else {
        _editedDoctor.addTimeSlot(day, time);
      }
    });
    widget.onUpdate(_editedDoctor);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dr. ${_editedDoctor.name} ${_editedDoctor.lastName}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(_editedDoctor.specialty),

            // Working Days Selection
            Wrap(
              spacing: 8,
              children: [
                'Lunes',
                'Martes',
                'Miércoles',
                'Jueves',
                'Viernes',
                'Sábado'
              ]
                  .map((day) => FilterChip(
                        label: Text(day),
                        selected: _editedDoctor.workingDays.contains(day),
                        onSelected: (_) => _toggleDay(day),
                      ))
                  .toList(),
            ),

            // Time Slots for Selected Days
            ..._editedDoctor.workingDays.map((day) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Text(day, style: TextStyle(fontWeight: FontWeight.bold)),
                    Wrap(
                      spacing: 8,
                      children: [
                        '08:00',
                        '09:00',
                        '10:00',
                        '11:00',
                        '14:00',
                        '15:00',
                        '16:00',
                        '17:00'
                      ]
                          .map((time) => FilterChip(
                                label: Text(time),
                                selected: _editedDoctor.availability[day]
                                        ?.contains(time) ??
                                    false,
                                onSelected: (_) => _toggleTimeSlot(day, time),
                              ))
                          .toList(),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
