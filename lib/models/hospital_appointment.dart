class HospitalAppointment {
  final String id;
  final String doctorName;
  final String specialization;
  final String hospitalName;
  final String hospitalAddress;
  final String doctorPhone;
  final String hospitalPhone;
  final String emergencyPhone;
  final String workingHours;
  final DateTime appointmentDateTime;
  final String prescriptionNotes;
  final bool isCompleted;
  final int recurrenceIntervalMonths;

  HospitalAppointment({
    required this.id,
    required this.doctorName,
    required this.specialization,
    required this.hospitalName,
    required this.hospitalAddress,
    required this.doctorPhone,
    required this.hospitalPhone,
    this.emergencyPhone = '108',
    this.workingHours = '9:00 AM - 6:00 PM',
    required this.appointmentDateTime,
    this.prescriptionNotes = '',
    this.isCompleted = false,
    this.recurrenceIntervalMonths = 1,
  });

  int get daysUntil {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(appointmentDateTime.year, appointmentDateTime.month, appointmentDateTime.day);
    return target.difference(today).inDays;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'doctorName': doctorName,
        'specialization': specialization,
        'hospitalName': hospitalName,
        'hospitalAddress': hospitalAddress,
        'doctorPhone': doctorPhone,
        'hospitalPhone': hospitalPhone,
        'emergencyPhone': emergencyPhone,
        'workingHours': workingHours,
        'appointmentDateTime': appointmentDateTime.toIso8601String(),
        'prescriptionNotes': prescriptionNotes,
        'isCompleted': isCompleted,
        'recurrenceIntervalMonths': recurrenceIntervalMonths,
      };

  factory HospitalAppointment.fromJson(Map<String, dynamic> json) => HospitalAppointment(
        id: json['id'] as String,
        doctorName: json['doctorName'] as String,
        specialization: json['specialization'] as String? ?? 'General Physician',
        hospitalName: json['hospitalName'] as String,
        hospitalAddress: json['hospitalAddress'] as String? ?? '',
        doctorPhone: json['doctorPhone'] as String? ?? '',
        hospitalPhone: json['hospitalPhone'] as String? ?? '',
        emergencyPhone: json['emergencyPhone'] as String? ?? '108',
        workingHours: json['workingHours'] as String? ?? '9:00 AM - 6:00 PM',
        appointmentDateTime: DateTime.tryParse(json['appointmentDateTime'] as String? ?? '') ??
            DateTime.now().add(const Duration(days: 30)),
        prescriptionNotes: json['prescriptionNotes'] as String? ?? '',
        isCompleted: json['isCompleted'] as bool? ?? false,
        recurrenceIntervalMonths: json['recurrenceIntervalMonths'] as int? ?? 1,
      );

  HospitalAppointment copyWith({
    String? id,
    String? doctorName,
    String? specialization,
    String? hospitalName,
    String? hospitalAddress,
    String? doctorPhone,
    String? hospitalPhone,
    String? emergencyPhone,
    String? workingHours,
    DateTime? appointmentDateTime,
    String? prescriptionNotes,
    bool? isCompleted,
    int? recurrenceIntervalMonths,
  }) {
    return HospitalAppointment(
      id: id ?? this.id,
      doctorName: doctorName ?? this.doctorName,
      specialization: specialization ?? this.specialization,
      hospitalName: hospitalName ?? this.hospitalName,
      hospitalAddress: hospitalAddress ?? this.hospitalAddress,
      doctorPhone: doctorPhone ?? this.doctorPhone,
      hospitalPhone: hospitalPhone ?? this.hospitalPhone,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      workingHours: workingHours ?? this.workingHours,
      appointmentDateTime: appointmentDateTime ?? this.appointmentDateTime,
      prescriptionNotes: prescriptionNotes ?? this.prescriptionNotes,
      isCompleted: isCompleted ?? this.isCompleted,
      recurrenceIntervalMonths: recurrenceIntervalMonths ?? this.recurrenceIntervalMonths,
    );
  }
}
