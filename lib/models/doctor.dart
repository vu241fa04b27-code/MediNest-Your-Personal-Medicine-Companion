class Doctor {
  final String id;
  final String name;
  final String specialization;
  final String hospital;
  final String phone;
  final String address;
  final DateTime lastConsultationDate;
  final DateTime nextVisitDate;
  final String prescriptionNotes;

  Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.hospital,
    required this.phone,
    this.address = '',
    required this.lastConsultationDate,
    required this.nextVisitDate,
    this.prescriptionNotes = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'specialization': specialization,
        'hospital': hospital,
        'phone': phone,
        'address': address,
        'lastConsultationDate': lastConsultationDate.toIso8601String(),
        'nextVisitDate': nextVisitDate.toIso8601String(),
        'prescriptionNotes': prescriptionNotes,
      };

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        id: json['id'] as String,
        name: json['name'] as String,
        specialization: json['specialization'] as String? ?? 'General Medicine',
        hospital: json['hospital'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        address: json['address'] as String? ?? '',
        lastConsultationDate: DateTime.tryParse(json['lastConsultationDate'] as String? ?? '') ??
            DateTime.now().subtract(const Duration(days: 14)),
        nextVisitDate: DateTime.tryParse(json['nextVisitDate'] as String? ?? '') ??
            DateTime.now().add(const Duration(days: 16)),
        prescriptionNotes: json['prescriptionNotes'] as String? ?? '',
      );

  Doctor copyWith({
    String? id,
    String? name,
    String? specialization,
    String? hospital,
    String? phone,
    String? address,
    DateTime? lastConsultationDate,
    DateTime? nextVisitDate,
    String? prescriptionNotes,
  }) {
    return Doctor(
      id: id ?? this.id,
      name: name ?? this.name,
      specialization: specialization ?? this.specialization,
      hospital: hospital ?? this.hospital,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      lastConsultationDate: lastConsultationDate ?? this.lastConsultationDate,
      nextVisitDate: nextVisitDate ?? this.nextVisitDate,
      prescriptionNotes: prescriptionNotes ?? this.prescriptionNotes,
    );
  }
}
