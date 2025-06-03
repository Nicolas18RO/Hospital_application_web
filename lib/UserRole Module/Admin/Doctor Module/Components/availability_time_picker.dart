// availability_time_picker.dart
import 'package:flutter/material.dart';

class AvailabilityTimePicker extends StatefulWidget {
  final String day;
  final List<String> initialHours;
  final ValueChanged<List<String>> onChanged;

  const AvailabilityTimePicker({
    super.key,
    required this.day,
    required this.initialHours,
    required this.onChanged,
  });

  @override
  State<AvailabilityTimePicker> createState() => _AvailabilityTimePickerState();
}

class _AvailabilityTimePickerState extends State<AvailabilityTimePicker> {
  late List<String> _selectedHours;
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

  @override
  void initState() {
    super.initState();
    _selectedHours = List.from(widget.initialHours);
  }

  void _toggleTime(String time) {
    setState(() {
      if (_selectedHours.contains(time)) {
        _selectedHours.remove(time);
      } else {
        _selectedHours.add(time);
      }
      _selectedHours.sort();
      widget.onChanged(_selectedHours);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.day,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _timeSlots.map((time) {
                return FilterChip(
                  label: Text(time),
                  selected: _selectedHours.contains(time),
                  onSelected: (_) => _toggleTime(time),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
