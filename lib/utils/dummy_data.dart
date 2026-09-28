import 'uuid_util.dart';
import '../models/medicine.dart';
import '../models/dose_log.dart';
import '../models/hospital_appointment.dart';
import '../models/doctor.dart';
import '../models/health_journal_entry.dart';
import '../models/emergency_profile.dart';
import '../models/app_settings.dart';

class DummyData {
  static const _uuid = Uuid();

  static List<Medicine> getInitialMedicines() {
    final now = DateTime.now();
    return [
      Medicine(
        id: 'med_ketoconazole',
        name: 'Ketoconazole 200mg',
        type: 'Tablet',
        purpose: 'Controls dandruff, reduces fungal infection and relieves scalp inflammation',
        doctorName: 'Dr. K. Ramesh',
        specialization: 'Dermatologist',
        hospitalName: 'Apollo Hospital',
        doctorPhone: '+91 98480 12345',
        hospitalPhone: '+91 40 2345 6789',
        hospitalAddress: 'Road No. 72, Jubilee Hills, Hyderabad, Telangana',
        startDate: now.subtract(const Duration(days: 14)),
        endDate: now.add(const Duration(days: 30)),
        beforeFood: false,
        afterFood: true,
        doseTimes: ['01:30 PM'],
        repeat: 'Daily',
        remainingStock: 8, // Triggers low-stock notice when below 5
        totalStock: 30,
        lowStockThreshold: 5,
        notes: 'Take with a glass of water right after lunch. Do not skip days.',
        commonSideEffects: [
          'Mild headache',
          'Slight stomach upset if taken empty stomach',
          'Temporary nausea',
        ],
        warnings: [
          'Don\'t stop without doctor\'s advice.',
          'Always take after proper meal.',
          'Avoid alcohol during course.',
        ],
      ),
      Medicine(
        id: 'med_cetirizine',
        name: 'Cetirizine 10mg',
        type: 'Tablet',
        purpose: 'Relieves scalp itching, allergic irritation, and redness',
        doctorName: 'Dr. K. Ramesh',
        hospitalName: 'Apollo Hospital',
        doctorPhone: '+91 98480 12345',
        hospitalPhone: '+91 40 2345 6789',
        hospitalAddress: 'Road No. 72, Jubilee Hills, Hyderabad, Telangana',
        startDate: now.subtract(const Duration(days: 14)),
        endDate: now.add(const Duration(days: 16)),
        beforeFood: false,
        afterFood: true,
        doseTimes: ['09:00 PM'],
        repeat: 'Daily',
        remainingStock: 14,
        totalStock: 30,
        lowStockThreshold: 5,
        notes: 'Take before bedtime after dinner. May cause light sleepiness.',
        commonSideEffects: [
          'Mild drowsiness / sleepiness',
          'Dry mouth',
        ],
        warnings: [
          'Best taken at bedtime.',
          'Do not drive if feeling drowsy.',
        ],
      ),
      Medicine(
        id: 'med_biotin',
        name: 'Biotin & Hair Multivitamin',
        type: 'Capsule',
        purpose: 'Strengthens hair roots, stimulates growth, and reduces hair fall',
        doctorName: 'Dr. K. Ramesh',
        hospitalName: 'Apollo Hospital',
        doctorPhone: '+91 98480 12345',
        hospitalPhone: '+91 40 2345 6789',
        hospitalAddress: 'Road No. 72, Jubilee Hills, Hyderabad, Telangana',
        startDate: now.subtract(const Duration(days: 20)),
        endDate: now.add(const Duration(days: 40)),
        beforeFood: false,
        afterFood: true,
        doseTimes: ['08:30 AM'],
        repeat: 'Daily',
        remainingStock: 22,
        totalStock: 30,
        lowStockThreshold: 5,
        notes: 'Take in the morning after breakfast.',
        commonSideEffects: [
          'None reported (Gentle nutrition supplement)',
        ],
        warnings: [
          'Drink at least 2 liters of water daily.',
        ],
      ),
    ];
  }

  static HospitalAppointment getInitialAppointment() {
    final now = DateTime.now();
    // Default to October 28 or 30 days ahead
    final targetDate = DateTime(now.year, now.month + 1, 28, 10, 30);
    return HospitalAppointment(
      id: 'apt_monthly_dermatology',
      doctorName: 'Dr. K. Ramesh',
      specialization: 'Dermatologist',
      hospitalName: 'Apollo Hospital',
      hospitalAddress: 'Road No. 72, Jubilee Hills, Hyderabad, Telangana',
      doctorPhone: '+91 98480 12345',
      hospitalPhone: '+91 40 2345 6789',
      emergencyPhone: '108',
      workingHours: '9:00 AM - 6:00 PM (Mon-Sat)',
      appointmentDateTime: targetDate,
      prescriptionNotes: 'Review dandruff clearance, evaluate scalp itching response, inspect hair roots, and renew Ketoconazole prescription if required.',
      isCompleted: false,
      recurrenceIntervalMonths: 1,
    );
  }

  static List<Doctor> getInitialDoctors() {
    final now = DateTime.now();
    return [
      Doctor(
        id: 'doc_ramesh',
        name: 'Dr. K. Ramesh',
        specialization: 'Dermatologist',
        hospital: 'Apollo Hospital',
        phone: '+91 98480 12345',
        address: 'Road No. 72, Jubilee Hills, Hyderabad',
        lastConsultationDate: now.subtract(const Duration(days: 14)),
        nextVisitDate: DateTime(now.year, now.month + 1, 28),
        prescriptionNotes: 'Ketoconazole 200mg OD, Cetirizine 10mg HS, Biotin Multivitamin daily.',
      ),
      Doctor(
        id: 'doc_sharma',
        name: 'Dr. P. Sharma',
        specialization: 'General Physician',
        hospital: 'Care Hospital',
        phone: '+91 98490 54321',
        address: 'Banjara Hills, Hyderabad',
        lastConsultationDate: now.subtract(const Duration(days: 45)),
        nextVisitDate: now.add(const Duration(days: 60)),
        prescriptionNotes: 'Routine blood pressure and wellness monitoring.',
      ),
    ];
  }

  static List<HealthJournalEntry> getInitialJournalEntries() {
    final now = DateTime.now();
    return [
      HealthJournalEntry(
        id: 'entry_today',
        date: now,
        mood: '😊',
        sleepHours: 8.0,
        energyLevel: 'Normal',
        itching: 'Mild',
        hairFall: 'Less',
        notes: 'Scalp feels much cooler today. Ketoconazole taken after lunch without any stomach irritation.',
      ),
      HealthJournalEntry(
        id: 'entry_yesterday',
        date: now.subtract(const Duration(days: 1)),
        mood: '😊',
        sleepHours: 7.5,
        energyLevel: 'Normal',
        itching: 'Mild',
        hairFall: 'Moderate',
        notes: 'Applied lotion at night. Slept well.',
      ),
      HealthJournalEntry(
        id: 'entry_2days_ago',
        date: now.subtract(const Duration(days: 2)),
        mood: '😐',
        sleepHours: 7.0,
        energyLevel: 'Low',
        itching: 'Moderate',
        hairFall: 'Moderate',
        notes: 'Slight itching in the afternoon, took Cetirizine at 9:00 PM.',
      ),
    ];
  }

  static List<DoseLog> getInitialDoseLogs() {
    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    
    return [
      DoseLog(
        id: _uuid.v4(),
        medicineId: 'med_biotin',
        medicineName: 'Biotin & Hair Multivitamin',
        scheduledTime: '08:30 AM',
        dateString: todayStr,
        actionTime: now.subtract(const Duration(hours: 3)),
        status: 'taken',
        doseNote: 'Taken with breakfast',
      ),
      DoseLog(
        id: _uuid.v4(),
        medicineId: 'med_ketoconazole',
        medicineName: 'Ketoconazole 200mg',
        scheduledTime: '01:30 PM',
        dateString: todayStr,
        status: 'upcoming',
      ),
      DoseLog(
        id: _uuid.v4(),
        medicineId: 'med_cetirizine',
        medicineName: 'Cetirizine 10mg',
        scheduledTime: '09:00 PM',
        dateString: todayStr,
        status: 'upcoming',
      ),
    ];
  }

  static EmergencyProfile getInitialEmergencyProfile() {
    return EmergencyProfile(
      userName: 'Ammu',
      bloodGroup: 'O+ Positive',
      emergencyContactName: 'Family Member (Son/Daughter)',
      emergencyContactPhone: '+91 98765 43210',
      allergies: 'Penicillin, Sulfa drugs',
      currentMedicinesSummary: 'Ketoconazole 200mg (1:30 PM), Cetirizine 10mg (9:00 PM), Biotin (8:30 AM)',
      doctorName: 'Dr. K. Ramesh (Dermatologist)',
      doctorPhone: '+91 98480 12345',
      hospitalName: 'Apollo Hospital, Jubilee Hills',
      hospitalPhone: '+91 40 2345 6789',
      hospitalEmergencyPhone: '108',
    );
  }

  static AppSettings getInitialSettings() {
    return AppSettings(
      language: 'en',
      soundEnabled: true,
      ringtoneName: 'Gentle Chime',
      vibrationEnabled: true,
      snoozeDurationMinutes: 10,
      voiceReaderEnabled: true,
      largeFontEnabled: false,
      highContrastEnabled: false,
      cloudBackupEnabled: false,
      exactAlarmGranted: true,
    );
  }
}
