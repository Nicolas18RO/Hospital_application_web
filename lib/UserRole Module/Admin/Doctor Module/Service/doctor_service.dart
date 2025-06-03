// lib/services/doctor_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hospital_gestion_application/UserRole%20Module/Admin/Doctor%20Module/Models/doctor_model.dart';

class DoctorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createDoctor(Doctor doctor) async {
    try {
      await _firestore
          .collection('doctors')
          .doc(doctor.id) // Use existing ID or let Firestore auto-generate
          .set(doctor.toMap());
    } catch (e) {
      throw Exception('Failed to create doctor: $e');
    }
  }
}
