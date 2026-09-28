class EmergencyProfile {
  final String userName;
  final String bloodGroup;
  final String emergencyContactName;
  final String emergencyContactPhone;
  final String allergies;
  final String currentMedicinesSummary;
  final String doctorName;
  final String doctorPhone;
  final String hospitalName;
  final String hospitalPhone;
  final String hospitalEmergencyPhone;

  EmergencyProfile({
    this.userName = 'Ammu',
    this.bloodGroup = 'O+ Positive',
    this.emergencyContactName = 'Family Member',
    this.emergencyContactPhone = '+91 98765 43210',
    this.allergies = 'Penicillin, Sulfa drugs',
    this.currentMedicinesSummary = 'Ketoconazole 200mg, Cetirizine 10mg, Multivitamin',
    this.doctorName = 'Dr. K. Ramesh (Dermatologist)',
    this.doctorPhone = '+91 98480 12345',
    this.hospitalName = 'Apollo Hospital',
    this.hospitalPhone = '+91 40 2345 6789',
    this.hospitalEmergencyPhone = '108',
  });

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'bloodGroup': bloodGroup,
        'emergencyContactName': emergencyContactName,
        'emergencyContactPhone': emergencyContactPhone,
        'allergies': allergies,
        'currentMedicinesSummary': currentMedicinesSummary,
        'doctorName': doctorName,
        'doctorPhone': doctorPhone,
        'hospitalName': hospitalName,
        'hospitalPhone': hospitalPhone,
        'hospitalEmergencyPhone': hospitalEmergencyPhone,
      };

  factory EmergencyProfile.fromJson(Map<String, dynamic> json) => EmergencyProfile(
        userName: json['userName'] as String? ?? 'Ammu',
        bloodGroup: json['bloodGroup'] as String? ?? 'O+ Positive',
        emergencyContactName: json['emergencyContactName'] as String? ?? 'Family Member',
        emergencyContactPhone: json['emergencyContactPhone'] as String? ?? '+91 98765 43210',
        allergies: json['allergies'] as String? ?? 'Penicillin, Sulfa drugs',
        currentMedicinesSummary: json['currentMedicinesSummary'] as String? ?? '',
        doctorName: json['doctorName'] as String? ?? 'Dr. K. Ramesh',
        doctorPhone: json['doctorPhone'] as String? ?? '+91 98480 12345',
        hospitalName: json['hospitalName'] as String? ?? 'Apollo Hospital',
        hospitalPhone: json['hospitalPhone'] as String? ?? '+91 40 2345 6789',
        hospitalEmergencyPhone: json['hospitalEmergencyPhone'] as String? ?? '108',
      );

  EmergencyProfile copyWith({
    String? userName,
    String? bloodGroup,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? allergies,
    String? currentMedicinesSummary,
    String? doctorName,
    String? doctorPhone,
    String? hospitalName,
    String? hospitalPhone,
    String? hospitalEmergencyPhone,
  }) {
    return EmergencyProfile(
      userName: userName ?? this.userName,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
      allergies: allergies ?? this.allergies,
      currentMedicinesSummary: currentMedicinesSummary ?? this.currentMedicinesSummary,
      doctorName: doctorName ?? this.doctorName,
      doctorPhone: doctorPhone ?? this.doctorPhone,
      hospitalName: hospitalName ?? this.hospitalName,
      hospitalPhone: hospitalPhone ?? this.hospitalPhone,
      hospitalEmergencyPhone: hospitalEmergencyPhone ?? this.hospitalEmergencyPhone,
    );
  }
}
