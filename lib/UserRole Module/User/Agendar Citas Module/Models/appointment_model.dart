import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String id;
  final String patientId;
  final String doctorId;
  final DateTime date;
  final String time;
  final String reason;
  final String status; // 'pending', 'confirmed', 'cancelled'

  Appointment({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.date,
    required this.time,
    required this.reason,
    this.status = 'pending',
  });

  factory Appointment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Appointment(
      id: doc.id,
      patientId: data['patientId'],
      doctorId: data['doctorId'],
      date: (data['date'] as Timestamp).toDate(),
      time: data['time'],
      reason: data['reason'],
      status: data['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'doctorId': doctorId,
      'date': Timestamp.fromDate(date),
      'time': time,
      'reason': reason,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
