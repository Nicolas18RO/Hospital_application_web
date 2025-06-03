// lib/models/doctor_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  final String? id; // Nullable for new records
  final String name;
  final String lastName;
  final String specialty;
  final String document;
  final String phone;
  final String email;
  final List<String> workingDays;
  final Map<String, List<String>> availability;

  Doctor({
    this.id,
    required this.name,
    required this.lastName,
    required this.specialty,
    required this.document,
    required this.phone,
    required this.email,
    this.workingDays = const [],
    required this.availability,
  });

  void addWorkingDay(String day) {
    if (!workingDays.contains(day)) {
      workingDays.add(day);
      availability[day] = []; // Initialize empty schedule
    }
  }

  void removeWorkingDay(String day) {
    workingDays.remove(day);
    availability.remove(day);
  }

  void addTimeSlot(String day, String time) {
    if (availability[day] == null) {
      availability[day] = [];
    }
    if (!availability[day]!.contains(time)) {
      availability[day]!.add(time);
      availability[day]!.sort();
    }
  }

  void removeTimeSlot(String day, String time) {
    availability[day]?.remove(time);
  }

  Doctor copyWith({
    String? id,
    String? name,
    String? lastName,
    String? specialty,
    String? document,
    String? phone,
    String? email,
    List<String>? workingDays,
    Map<String, List<String>>? availability,
  }) {
    return Doctor(
      id: id ?? this.id,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      specialty: specialty ?? this.specialty,
      document: document ?? this.document,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      workingDays: workingDays ?? List.from(this.workingDays),
      availability: availability ?? Map.from(this.availability),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lastName': lastName,
      'specialty': specialty,
      'document': document,
      'phone': phone,
      'email': email,
      'workingDays': workingDays,
      'availability': availability,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory Doctor.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Doctor(
      id: doc.id,
      name: data['name'] ?? '',
      lastName: data['lastName'] ?? '',
      specialty: data['specialty'] ?? '',
      document: data['document'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      workingDays: List<String>.from(data['workingDays'] ?? []),
      availability: Map<String, List<String>>.from(data['availability']
              ?.map((key, value) => MapEntry(key, List<String>.from(value))) ??
          {}),
    );
  }
}
