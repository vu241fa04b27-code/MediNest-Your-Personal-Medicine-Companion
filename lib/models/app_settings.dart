class AppSettings {
  final String language; // 'en', 'te', 'hi'
  final bool soundEnabled;
  final String ringtoneName; // 'Gentle Chime', 'Medicine Bell', 'Hospital Harp'
  final bool vibrationEnabled;
  final int snoozeDurationMinutes; // 5, 10, 15, 30
  final bool voiceReaderEnabled;
  final bool largeFontEnabled;
  final bool highContrastEnabled;
  final bool cloudBackupEnabled;
  final bool exactAlarmGranted;

  AppSettings({
    this.language = 'en',
    this.soundEnabled = true,
    this.ringtoneName = 'Gentle Chime',
    this.vibrationEnabled = true,
    this.snoozeDurationMinutes = 10,
    this.voiceReaderEnabled = true,
    this.largeFontEnabled = false,
    this.highContrastEnabled = false,
    this.cloudBackupEnabled = false,
    this.exactAlarmGranted = true,
  });

  Map<String, dynamic> toJson() => {
        'language': language,
        'soundEnabled': soundEnabled,
        'ringtoneName': ringtoneName,
        'vibrationEnabled': vibrationEnabled,
        'snoozeDurationMinutes': snoozeDurationMinutes,
        'voiceReaderEnabled': voiceReaderEnabled,
        'largeFontEnabled': largeFontEnabled,
        'highContrastEnabled': highContrastEnabled,
        'cloudBackupEnabled': cloudBackupEnabled,
        'exactAlarmGranted': exactAlarmGranted,
      };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
        language: json['language'] as String? ?? 'en',
        soundEnabled: json['soundEnabled'] as bool? ?? true,
        ringtoneName: json['ringtoneName'] as String? ?? 'Gentle Chime',
        vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
        snoozeDurationMinutes: json['snoozeDurationMinutes'] as int? ?? 10,
        voiceReaderEnabled: json['voiceReaderEnabled'] as bool? ?? true,
        largeFontEnabled: json['largeFontEnabled'] as bool? ?? false,
        highContrastEnabled: json['highContrastEnabled'] as bool? ?? false,
        cloudBackupEnabled: json['cloudBackupEnabled'] as bool? ?? false,
        exactAlarmGranted: json['exactAlarmGranted'] as bool? ?? true,
      );

  AppSettings copyWith({
    String? language,
    bool? soundEnabled,
    String? ringtoneName,
    bool? vibrationEnabled,
    int? snoozeDurationMinutes,
    bool? voiceReaderEnabled,
    bool? largeFontEnabled,
    bool? highContrastEnabled,
    bool? cloudBackupEnabled,
    bool? exactAlarmGranted,
  }) {
    return AppSettings(
      language: language ?? this.language,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      ringtoneName: ringtoneName ?? this.ringtoneName,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      snoozeDurationMinutes: snoozeDurationMinutes ?? this.snoozeDurationMinutes,
      voiceReaderEnabled: voiceReaderEnabled ?? this.voiceReaderEnabled,
      largeFontEnabled: largeFontEnabled ?? this.largeFontEnabled,
      highContrastEnabled: highContrastEnabled ?? this.highContrastEnabled,
      cloudBackupEnabled: cloudBackupEnabled ?? this.cloudBackupEnabled,
      exactAlarmGranted: exactAlarmGranted ?? this.exactAlarmGranted,
    );
  }
}
