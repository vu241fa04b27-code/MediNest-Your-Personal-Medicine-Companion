class HealthJournalEntry {
  final String id;
  final DateTime date;
  final String mood; // 😊 Happy, 😐 Okay, 😔 Low, 😣 In Pain
  final double sleepHours;
  final String energyLevel; // Low, Normal, High
  final String itching; // None, Mild, Moderate, Severe
  final String hairFall; // None, Less, Moderate, Heavy
  final String notes;

  HealthJournalEntry({
    required this.id,
    required this.date,
    this.mood = '😊',
    this.sleepHours = 7.5,
    this.energyLevel = 'Normal',
    this.itching = 'Mild',
    this.hairFall = 'Less',
    this.notes = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'mood': mood,
        'sleepHours': sleepHours,
        'energyLevel': energyLevel,
        'itching': itching,
        'hairFall': hairFall,
        'notes': notes,
      };

  factory HealthJournalEntry.fromJson(Map<String, dynamic> json) => HealthJournalEntry(
        id: json['id'] as String,
        date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
        mood: json['mood'] as String? ?? '😊',
        sleepHours: (json['sleepHours'] as num?)?.toDouble() ?? 7.5,
        energyLevel: json['energyLevel'] as String? ?? 'Normal',
        itching: json['itching'] as String? ?? 'Mild',
        hairFall: json['hairFall'] as String? ?? 'Less',
        notes: json['notes'] as String? ?? '',
      );

  HealthJournalEntry copyWith({
    String? id,
    DateTime? date,
    String? mood,
    double? sleepHours,
    String? energyLevel,
    String? itching,
    String? hairFall,
    String? notes,
  }) {
    return HealthJournalEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      mood: mood ?? this.mood,
      sleepHours: sleepHours ?? this.sleepHours,
      energyLevel: energyLevel ?? this.energyLevel,
      itching: itching ?? this.itching,
      hairFall: hairFall ?? this.hairFall,
      notes: notes ?? this.notes,
    );
  }
}
