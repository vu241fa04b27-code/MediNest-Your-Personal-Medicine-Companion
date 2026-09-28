import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/uuid_util.dart';
import '../models/medicine.dart';
import '../models/dose_log.dart';
import '../models/hospital_appointment.dart';
import '../models/doctor.dart';
import '../models/health_journal_entry.dart';
import '../models/emergency_profile.dart';
import '../models/app_settings.dart';
import '../utils/dummy_data.dart';

class StorageService extends ChangeNotifier {
  static const String _keyMedicines = 'medinest_medicines';
  static const String _keyDoseLogs = 'medinest_dose_logs';
  static const String _keyAppointments = 'medinest_appointments';
  static const String _keyDoctors = 'medinest_doctors';
  static const String _keyJournal = 'medinest_journal';
  static const String _keyEmergency = 'medinest_emergency';
  static const String _keySettings = 'medinest_settings';
  static const String _keyInitialized = 'medinest_initialized_v1';

  final Uuid _uuid = const Uuid();

  List<Medicine> _medicines = [];
  List<DoseLog> _doseLogs = [];
  List<HospitalAppointment> _appointments = [];
  List<Doctor> _doctors = [];
  List<HealthJournalEntry> _journalEntries = [];
  EmergencyProfile _emergencyProfile = DummyData.getInitialEmergencyProfile();
  AppSettings _settings = DummyData.getInitialSettings();

  bool _isLoaded = false;

  // Getters
  List<Medicine> get medicines => List.unmodifiable(_medicines.where((m) => !m.isArchived));
  List<DoseLog> get doseLogs => List.unmodifiable(_doseLogs);
  List<HospitalAppointment> get appointments => List.unmodifiable(_appointments);
  HospitalAppointment? get nextAppointment {
    final active = _appointments.where((a) => !a.isCompleted).toList();
    if (active.isEmpty) return null;
    active.sort((a, b) => a.appointmentDateTime.compareTo(b.appointmentDateTime));
    return active.first;
  }
  List<Doctor> get doctors => List.unmodifiable(_doctors);
  List<HealthJournalEntry> get journalEntries => List.unmodifiable(_journalEntries);
  EmergencyProfile get emergencyProfile => _emergencyProfile;
  AppSettings get settings => _settings;
  bool get isLoaded => _isLoaded;

  // Initialization
  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasInit = prefs.getBool(_keyInitialized) ?? false;

      if (!hasInit) {
        // Pre-populate with dummy data
        _medicines = DummyData.getInitialMedicines();
        _appointments = [DummyData.getInitialAppointment()];
        _doctors = DummyData.getInitialDoctors();
        _journalEntries = DummyData.getInitialJournalEntries();
        _doseLogs = DummyData.getInitialDoseLogs();
        _emergencyProfile = DummyData.getInitialEmergencyProfile();
        _settings = DummyData.getInitialSettings();
        await _saveAll(prefs);
        await prefs.setBool(_keyInitialized, true);
      } else {
        // Load existing
        final medStr = prefs.getString(_keyMedicines);
        if (medStr != null) {
          final List list = jsonDecode(medStr);
          _medicines = list.map((e) => Medicine.fromJson(e)).toList();
        } else {
          _medicines = DummyData.getInitialMedicines();
        }

        final logsStr = prefs.getString(_keyDoseLogs);
        if (logsStr != null) {
          final List list = jsonDecode(logsStr);
          _doseLogs = list.map((e) => DoseLog.fromJson(e)).toList();
        } else {
          _doseLogs = DummyData.getInitialDoseLogs();
        }

        final aptStr = prefs.getString(_keyAppointments);
        if (aptStr != null) {
          final List list = jsonDecode(aptStr);
          _appointments = list.map((e) => HospitalAppointment.fromJson(e)).toList();
        } else {
          _appointments = [DummyData.getInitialAppointment()];
        }

        final docStr = prefs.getString(_keyDoctors);
        if (docStr != null) {
          final List list = jsonDecode(docStr);
          _doctors = list.map((e) => Doctor.fromJson(e)).toList();
        } else {
          _doctors = DummyData.getInitialDoctors();
        }

        final jrnStr = prefs.getString(_keyJournal);
        if (jrnStr != null) {
          final List list = jsonDecode(jrnStr);
          _journalEntries = list.map((e) => HealthJournalEntry.fromJson(e)).toList();
        } else {
          _journalEntries = DummyData.getInitialJournalEntries();
        }

        final emgStr = prefs.getString(_keyEmergency);
        if (emgStr != null) {
          _emergencyProfile = EmergencyProfile.fromJson(jsonDecode(emgStr));
        }

        final setStr = prefs.getString(_keySettings);
        if (setStr != null) {
          _settings = AppSettings.fromJson(jsonDecode(setStr));
        }
      }

      // Check and generate today's doses if needed
      _generateTodayDoseLogs();

      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      debugPrint("StorageService init error: $e");
      // Fallback
      _medicines = DummyData.getInitialMedicines();
      _appointments = [DummyData.getInitialAppointment()];
      _doctors = DummyData.getInitialDoctors();
      _journalEntries = DummyData.getInitialJournalEntries();
      _doseLogs = DummyData.getInitialDoseLogs();
      _isLoaded = true;
      notifyListeners();
    }
  }

  void _generateTodayDoseLogs() {
    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    
    for (final med in _medicines.where((m) => !m.isArchived)) {
      for (final time in med.doseTimes) {
        final existing = _doseLogs.any((l) => l.medicineId == med.id && l.scheduledTime == time && l.dateString == todayStr);
        if (!existing) {
          _doseLogs.add(DoseLog(
            id: _uuid.v4(),
            medicineId: med.id,
            medicineName: med.name,
            scheduledTime: time,
            dateString: todayStr,
            status: 'upcoming',
          ));
        }
      }
    }
  }

  Future<void> _saveAll(SharedPreferences prefs) async {
    await prefs.setString(_keyMedicines, jsonEncode(_medicines.map((e) => e.toJson()).toList()));
    await prefs.setString(_keyDoseLogs, jsonEncode(_doseLogs.map((e) => e.toJson()).toList()));
    await prefs.setString(_keyAppointments, jsonEncode(_appointments.map((e) => e.toJson()).toList()));
    await prefs.setString(_keyDoctors, jsonEncode(_doctors.map((e) => e.toJson()).toList()));
    await prefs.setString(_keyJournal, jsonEncode(_journalEntries.map((e) => e.toJson()).toList()));
    await prefs.setString(_keyEmergency, jsonEncode(_emergencyProfile.toJson()));
    await prefs.setString(_keySettings, jsonEncode(_settings.toJson()));
  }

  // --- Medicine Operations ---
  Future<void> addMedicine(Medicine med) async {
    _medicines.add(med);
    _generateTodayDoseLogs();
    await _saveMedicines();
    notifyListeners();
  }

  Future<void> updateMedicine(Medicine updated) async {
    final idx = _medicines.indexWhere((m) => m.id == updated.id);
    if (idx != -1) {
      _medicines[idx] = updated;
      await _saveMedicines();
      notifyListeners();
    }
  }

  Future<void> deleteMedicine(String id) async {
    _medicines.removeWhere((m) => m.id == id);
    _doseLogs.removeWhere((l) => l.medicineId == id);
    await _saveMedicines();
    await _saveDoseLogs();
    notifyListeners();
  }

  Future<void> refillMedicineStock(String id, int addedTablets) async {
    final idx = _medicines.indexWhere((m) => m.id == id);
    if (idx != -1) {
      final med = _medicines[idx];
      _medicines[idx] = med.copyWith(
        remainingStock: med.remainingStock + addedTablets,
        totalStock: med.totalStock + addedTablets,
      );
      await _saveMedicines();
      notifyListeners();
    }
  }

  // --- Dose Log & Take Now Operations ---
  List<DoseLog> get todayDoseLogs {
    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    return _doseLogs.where((l) => l.dateString == todayStr).toList();
  }

  Future<void> markDoseTaken(String medicineId, String scheduledTime) async {
    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final logIdx = _doseLogs.indexWhere(
      (l) => l.medicineId == medicineId && l.scheduledTime == scheduledTime && l.dateString == todayStr,
    );

    if (logIdx != -1) {
      _doseLogs[logIdx] = _doseLogs[logIdx].copyWith(
        status: 'taken',
        actionTime: now,
      );
    } else {
      final med = _medicines.firstWhere((m) => m.id == medicineId, orElse: () => DummyData.getInitialMedicines().first);
      _doseLogs.add(DoseLog(
        id: _uuid.v4(),
        medicineId: medicineId,
        medicineName: med.name,
        scheduledTime: scheduledTime,
        dateString: todayStr,
        actionTime: now,
        status: 'taken',
      ));
    }

    // Decrement remaining tablets count automatically
    final medIdx = _medicines.indexWhere((m) => m.id == medicineId);
    if (medIdx != -1) {
      final med = _medicines[medIdx];
      if (med.remainingStock > 0) {
        _medicines[medIdx] = med.copyWith(remainingStock: med.remainingStock - 1);
        await _saveMedicines();
      }
    }

    await _saveDoseLogs();
    notifyListeners();
  }

  Future<void> markDoseSnoozed(String medicineId, String scheduledTime) async {
    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final logIdx = _doseLogs.indexWhere(
      (l) => l.medicineId == medicineId && l.scheduledTime == scheduledTime && l.dateString == todayStr,
    );

    if (logIdx != -1) {
      _doseLogs[logIdx] = _doseLogs[logIdx].copyWith(
        status: 'snoozed',
        actionTime: now,
      );
    }

    await _saveDoseLogs();
    notifyListeners();
  }

  // --- Hospital Tracker Operations ---
  Future<void> completeAppointmentAndScheduleNext(String appointmentId) async {
    final idx = _appointments.indexWhere((a) => a.id == appointmentId);
    if (idx != -1) {
      final current = _appointments[idx];
      _appointments[idx] = current.copyWith(isCompleted: true);

      // Automatically create next monthly checkup (recurrence)
      final nextDate = DateTime(
        current.appointmentDateTime.year,
        current.appointmentDateTime.month + current.recurrenceIntervalMonths,
        current.appointmentDateTime.day,
        current.appointmentDateTime.hour,
        current.appointmentDateTime.minute,
      );

      final nextAppt = HospitalAppointment(
        id: _uuid.v4(),
        doctorName: current.doctorName,
        specialization: current.specialization,
        hospitalName: current.hospitalName,
        hospitalAddress: current.hospitalAddress,
        doctorPhone: current.doctorPhone,
        hospitalPhone: current.hospitalPhone,
        emergencyPhone: current.emergencyPhone,
        workingHours: current.workingHours,
        appointmentDateTime: nextDate,
        prescriptionNotes: 'Follow-up monthly check-up with ${current.doctorName}',
        isCompleted: false,
        recurrenceIntervalMonths: current.recurrenceIntervalMonths,
      );

      _appointments.add(nextAppt);
      await _saveAppointments();
      notifyListeners();
    }
  }

  Future<void> rescheduleAppointment(String appointmentId, DateTime newDateTime) async {
    final idx = _appointments.indexWhere((a) => a.id == appointmentId);
    if (idx != -1) {
      _appointments[idx] = _appointments[idx].copyWith(appointmentDateTime: newDateTime);
      await _saveAppointments();
      notifyListeners();
    }
  }

  // --- Health Journal Operations ---
  Future<void> addJournalEntry(HealthJournalEntry entry) async {
    _journalEntries.insert(0, entry);
    await _saveJournal();
    notifyListeners();
  }

  // --- Doctor Operations ---
  Future<void> addDoctor(Doctor doctor) async {
    _doctors.add(doctor);
    await _saveDoctors();
    notifyListeners();
  }

  // --- Emergency Profile Operations ---
  Future<void> updateEmergencyProfile(EmergencyProfile profile) async {
    _emergencyProfile = profile;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmergency, jsonEncode(_emergencyProfile.toJson()));
    notifyListeners();
  }

  // --- Settings Operations ---
  Future<void> updateSettings(AppSettings newSettings) async {
    _settings = newSettings;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySettings, jsonEncode(_settings.toJson()));
    notifyListeners();
  }

  Future<void> setLanguage(String langCode) async {
    _settings = _settings.copyWith(language: langCode);
    await updateSettings(_settings);
  }

  // Adherence calculation
  double get adherencePercentage {
    if (_doseLogs.isEmpty) return 100.0;
    final nonUpcoming = _doseLogs.where((l) => l.status != 'upcoming').toList();
    if (nonUpcoming.isEmpty) return 96.0; // Sample default
    final taken = nonUpcoming.where((l) => l.isTaken).length;
    return (taken / nonUpcoming.length) * 100.0;
  }

  // Internal save helpers
  Future<void> _saveMedicines() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyMedicines, jsonEncode(_medicines.map((e) => e.toJson()).toList()));
  }

  Future<void> _saveDoseLogs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDoseLogs, jsonEncode(_doseLogs.map((e) => e.toJson()).toList()));
  }

  Future<void> _saveAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAppointments, jsonEncode(_appointments.map((e) => e.toJson()).toList()));
  }

  Future<void> _saveDoctors() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDoctors, jsonEncode(_doctors.map((e) => e.toJson()).toList()));
  }

  Future<void> _saveJournal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyJournal, jsonEncode(_journalEntries.map((e) => e.toJson()).toList()));
  }

  // Reset to initial demo data
  Future<void> resetToDemoData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await init();
  }
}
