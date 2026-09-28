import '../lib/models/medicine.dart';
import '../lib/models/dose_log.dart';
import '../lib/models/hospital_appointment.dart';
import '../lib/models/health_journal_entry.dart';
import '../lib/models/emergency_profile.dart';
import '../lib/models/app_settings.dart';
import '../lib/utils/localization.dart';
import '../lib/utils/dummy_data.dart';

void main() {
  print('--- Running MediNest Logic & Verification Tests ---');

  // Test 1: Medicine Model & Low Stock Check
  print('Test 1: Testing Medicine model & Low Stock threshold...');
  final med = Medicine(
    id: 'test_med_1',
    name: 'Ketoconazole 200mg',
    type: 'Tablet',
    purpose: 'Controls dandruff and fungal infection',
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(days: 30)),
    doseTimes: ['01:30 PM'],
    remainingStock: 5,
    totalStock: 30,
    lowStockThreshold: 5,
  );
  assert(med.name == 'Ketoconazole 200mg');
  assert(med.isLowStock == true, 'Stock of 5 should trigger low stock alert');
  final refilledMed = med.copyWith(remainingStock: 15);
  assert(refilledMed.isLowStock == false, 'Stock of 15 should not trigger low stock alert');
  print('✓ Test 1 Passed: Low stock logic verified.');

  // Test 2: Hospital Appointment Countdown & Recurrence
  print('Test 2: Testing Hospital Appointment countdown & recurrence...');
  final now = DateTime.now();
  final targetDate = DateTime(now.year, now.month + 1, now.day);
  final appointment = HospitalAppointment(
    id: 'apt_test',
    doctorName: 'Dr. K. Ramesh',
    specialization: 'Dermatologist',
    hospitalName: 'Apollo Hospital',
    hospitalAddress: 'Jubilee Hills, Hyderabad',
    doctorPhone: '+91 98480 12345',
    hospitalPhone: '+91 40 2345 6789',
    appointmentDateTime: targetDate,
    recurrenceIntervalMonths: 1,
  );
  assert(appointment.daysUntil > 0, 'Upcoming visit should have positive days');
  assert(appointment.isCompleted == false);
  final completedAppt = appointment.copyWith(isCompleted: true);
  assert(completedAppt.isCompleted == true);
  print('✓ Test 2 Passed: Hospital appointment daysUntil is ${appointment.daysUntil} days.');

  // Test 3: Health Journal Entry Severity & Moods
  print('Test 3: Testing Health Journal data structures...');
  final journal = HealthJournalEntry(
    id: 'j_1',
    date: DateTime.now(),
    mood: '😊',
    sleepHours: 8.0,
    itching: 'Mild',
    hairFall: 'Less',
    notes: 'Scalp feels cooler after Ketoconazole.',
  );
  assert(journal.mood == '😊');
  assert(journal.itching == 'Mild');
  assert(journal.hairFall == 'Less');
  print('✓ Test 3 Passed: Journal entries correctly represent symptoms and mood.');

  // Test 4: Localization Dictionaries (English, Telugu, Hindi)
  print('Test 4: Verifying English, Telugu, and Hindi translations...');
  final locEn = AppLocalization('en');
  final locTe = AppLocalization('te');
  final locHi = AppLocalization('hi');

  // Verify App Names & Taglines
  assert(locEn.tr('tagline') == 'Never Miss a Tablet. Never Miss a Check-up.');
  assert(locTe.tr('tagline') == 'టాబ్లెట్ మరచిపోకండి. డాక్టర్ చెకప్ మిస్ కావద్దు.');
  assert(locHi.tr('tagline') == 'दवा कभी न भूलें। डॉक्टर चेक-अप कभी न छोड़ें।');

  // Verify Greetings for Ammu
  assert(locEn.tr('user_greeting') == 'Good Morning, Ammu 🌸');
  assert(locTe.tr('user_greeting') == 'శుభోదయం, అమ్ము 🌸');
  assert(locHi.tr('user_greeting') == 'शुभ प्रभात, अम्मू 🌸');

  // Verify Critical Buttons (Take Now, Snooze, Emergency)
  assert(locEn.tr('take_now') == 'Take Now');
  assert(locTe.tr('take_now') == 'ఇప్పుడే తీసుకోండి');
  assert(locHi.tr('take_now') == 'अभी लें');

  assert(locEn.tr('snooze_10m') == 'Snooze (10 min)');
  assert(locTe.tr('snooze_10m') == '10 నిమిషాలు ఆపండి (స్నూజ్)');
  assert(locHi.tr('snooze_10m') == '10 मिनट बाद याद दिलाएं (स्नूज़)');

  assert(locEn.tr('low_stock_warning') == 'Only 5 tablets left. Buy refill soon.');
  assert(locTe.tr('low_stock_warning') == 'కేవలం 5 టాబ్లెట్లు మాత్రమే మిగిలి ఉన్నాయి. త్వరగా కొనండి.');
  assert(locHi.tr('low_stock_warning') == 'केवल 5 गोलियां बची हैं। जल्द ही नया पैकेट खरीदें।');
  print('✓ Test 4 Passed: English, Telugu, and Hindi translations fully intact.');

  // Test 5: Pre-seeded Patient Profile for Ammu
  print('Test 5: Verifying Ammu DummyData initial setup...');
  final meds = DummyData.getInitialMedicines();
  assert(meds.isNotEmpty);
  assert(meds.any((m) => m.name.contains('Ketoconazole')));
  assert(meds.any((m) => m.name.contains('Cetirizine')));
  assert(meds.any((m) => m.name.contains('Biotin')));

  final emg = DummyData.getInitialEmergencyProfile();
  assert(emg.userName == 'Ammu');
  assert(emg.bloodGroup == 'O+ Positive');
  assert(emg.emergencyContactPhone == '+91 98765 43210');
  assert(emg.doctorPhone == '+91 98480 12345');
  assert(emg.hospitalPhone == '+91 40 2345 6789');
  print('✓ Test 5 Passed: DummyData matches user specifications.');

  print('\n========================================');
  print('🎉 ALL 5 TEST SUITES PASSED SUCCESSFULLY!');
  print('========================================');
}
