class DoseLog {
  final String id;
  final String medicineId;
  final String medicineName;
  final String scheduledTime;
  final String dateString; // YYYY-MM-DD
  final DateTime? actionTime;
  final String status; // 'taken', 'snoozed', 'missed', 'upcoming'
  final String doseNote;

  DoseLog({
    required this.id,
    required this.medicineId,
    required this.medicineName,
    required this.scheduledTime,
    required this.dateString,
    this.actionTime,
    required this.status,
    this.doseNote = '',
  });

  bool get isTaken => status == 'taken';
  bool get isSnoozed => status == 'snoozed';
  bool get isMissed => status == 'missed';
  bool get isUpcoming => status == 'upcoming';

  Map<String, dynamic> toJson() => {
        'id': id,
        'medicineId': medicineId,
        'medicineName': medicineName,
        'scheduledTime': scheduledTime,
        'dateString': dateString,
        'actionTime': actionTime?.toIso8601String(),
        'status': status,
        'doseNote': doseNote,
      };

  factory DoseLog.fromJson(Map<String, dynamic> json) => DoseLog(
        id: json['id'] as String,
        medicineId: json['medicineId'] as String,
        medicineName: json['medicineName'] as String,
        scheduledTime: json['scheduledTime'] as String,
        dateString: json['dateString'] as String,
        actionTime: json['actionTime'] != null
            ? DateTime.tryParse(json['actionTime'] as String)
            : null,
        status: json['status'] as String? ?? 'upcoming',
        doseNote: json['doseNote'] as String? ?? '',
      );

  DoseLog copyWith({
    String? id,
    String? medicineId,
    String? medicineName,
    String? scheduledTime,
    String? dateString,
    DateTime? actionTime,
    String? status,
    String? doseNote,
  }) {
    return DoseLog(
      id: id ?? this.id,
      medicineId: medicineId ?? this.medicineId,
      medicineName: medicineName ?? this.medicineName,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      dateString: dateString ?? this.dateString,
      actionTime: actionTime ?? this.actionTime,
      status: status ?? this.status,
      doseNote: doseNote ?? this.doseNote,
    );
  }
}
