class Medicine {
  final String id;
  final String name;
  final String type; // Tablet, Capsule, Syrup, Drops, Injection, Inhaler
  final String purpose;
  final String doctorName;
  final String specialization;
  final String hospitalName;
  final String doctorPhone;
  final String hospitalPhone;
  final String hospitalAddress;
  final DateTime startDate;
  final DateTime endDate;
  final bool beforeFood;
  final bool afterFood;
  final List<String> doseTimes; // e.g. ["08:00 AM", "01:30 PM", "08:30 PM"]
  final String repeat; // Daily, Weekly, Custom
  final int remainingStock;
  final int totalStock;
  final int lowStockThreshold;
  final String notes;
  final String? photoPath;
  final List<String> commonSideEffects;
  final List<String> warnings;
  final bool isArchived;

  Medicine({
    required this.id,
    required this.name,
    this.type = 'Tablet',
    required this.purpose,
    this.doctorName = '',
    this.specialization = '',
    this.hospitalName = '',
    this.doctorPhone = '',
    this.hospitalPhone = '',
    this.hospitalAddress = '',
    required this.startDate,
    required this.endDate,
    this.beforeFood = false,
    this.afterFood = true,
    required this.doseTimes,
    this.repeat = 'Daily',
    this.remainingStock = 30,
    this.totalStock = 30,
    this.lowStockThreshold = 5,
    this.notes = '',
    this.photoPath,
    this.commonSideEffects = const [],
    this.warnings = const [],
    this.isArchived = false,
  });

  bool get isLowStock => remainingStock <= lowStockThreshold;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'purpose': purpose,
        'doctorName': doctorName,
        'specialization': specialization,
        'hospitalName': hospitalName,
        'doctorPhone': doctorPhone,
        'hospitalPhone': hospitalPhone,
        'hospitalAddress': hospitalAddress,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'beforeFood': beforeFood,
        'afterFood': afterFood,
        'doseTimes': doseTimes,
        'repeat': repeat,
        'remainingStock': remainingStock,
        'totalStock': totalStock,
        'lowStockThreshold': lowStockThreshold,
        'notes': notes,
        'photoPath': photoPath,
        'commonSideEffects': commonSideEffects,
        'warnings': warnings,
        'isArchived': isArchived,
      };

  factory Medicine.fromJson(Map<String, dynamic> json) => Medicine(
        id: json['id'] as String,
        name: json['name'] as String,
        type: json['type'] as String? ?? 'Tablet',
        purpose: json['purpose'] as String? ?? '',
        doctorName: json['doctorName'] as String? ?? '',
        specialization: json['specialization'] as String? ?? '',
        hospitalName: json['hospitalName'] as String? ?? '',
        doctorPhone: json['doctorPhone'] as String? ?? '',
        hospitalPhone: json['hospitalPhone'] as String? ?? '',
        hospitalAddress: json['hospitalAddress'] as String? ?? '',
        startDate: DateTime.tryParse(json['startDate'] as String? ?? '') ?? DateTime.now(),
        endDate: DateTime.tryParse(json['endDate'] as String? ?? '') ?? DateTime.now().add(const Duration(days: 30)),
        beforeFood: json['beforeFood'] as bool? ?? false,
        afterFood: json['afterFood'] as bool? ?? true,
        doseTimes: (json['doseTimes'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? ['08:00 AM'],
        repeat: json['repeat'] as String? ?? 'Daily',
        remainingStock: json['remainingStock'] as int? ?? 10,
        totalStock: json['totalStock'] as int? ?? 30,
        lowStockThreshold: json['lowStockThreshold'] as int? ?? 5,
        notes: json['notes'] as String? ?? '',
        photoPath: json['photoPath'] as String?,
        commonSideEffects: (json['commonSideEffects'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        warnings: (json['warnings'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        isArchived: json['isArchived'] as bool? ?? false,
      );

  Medicine copyWith({
    String? id,
    String? name,
    String? type,
    String? purpose,
    String? doctorName,
    String? specialization,
    String? hospitalName,
    String? doctorPhone,
    String? hospitalPhone,
    String? hospitalAddress,
    DateTime? startDate,
    DateTime? endDate,
    bool? beforeFood,
    bool? afterFood,
    List<String>? doseTimes,
    String? repeat,
    int? remainingStock,
    int? totalStock,
    int? lowStockThreshold,
    String? notes,
    String? photoPath,
    List<String>? commonSideEffects,
    List<String>? warnings,
    bool? isArchived,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      purpose: purpose ?? this.purpose,
      doctorName: doctorName ?? this.doctorName,
      specialization: specialization ?? this.specialization,
      hospitalName: hospitalName ?? this.hospitalName,
      doctorPhone: doctorPhone ?? this.doctorPhone,
      hospitalPhone: hospitalPhone ?? this.hospitalPhone,
      hospitalAddress: hospitalAddress ?? this.hospitalAddress,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      beforeFood: beforeFood ?? this.beforeFood,
      afterFood: afterFood ?? this.afterFood,
      doseTimes: doseTimes ?? this.doseTimes,
      repeat: repeat ?? this.repeat,
      remainingStock: remainingStock ?? this.remainingStock,
      totalStock: totalStock ?? this.totalStock,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      notes: notes ?? this.notes,
      photoPath: photoPath ?? this.photoPath,
      commonSideEffects: commonSideEffects ?? this.commonSideEffects,
      warnings: warnings ?? this.warnings,
      isArchived: isArchived ?? this.isArchived,
    );
  }
}
