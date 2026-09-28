import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../models/dose_log.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';
import '../services/call_launcher_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../utils/localization.dart';
import '../widgets/summary_stat_card.dart';
import '../widgets/next_medicine_banner.dart';
import '../widgets/voice_reading_bar.dart';
import 'emergency_card_screen.dart';
import 'medicine_details_screen.dart';
import 'hospital_tracker_screen.dart';
import 'medicine_tracker_screen.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  final StorageService _storage = StorageService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _storage.init();
    if (mounted) setState(() => _isLoading = false);
    _storage.addListener(_onStorageUpdate);
  }

  void _onStorageUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _storage.removeListener(_onStorageUpdate);
    super.dispose();
  }

  String _getGreeting(AppLocalization loc) {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return loc.tr('good_morning');
    } else if (hour < 17) {
      return loc.tr('good_afternoon');
    } else {
      return loc.tr('good_evening');
    }
  }

  void _markDoseTaken(DoseLog dose) async {
    await _storage.markDoseTaken(dose.medicineId, dose.scheduledTime);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.primaryGreenDark,
          content: Text('✓ Marked ${dose.medicineName} as Taken! Remaining stock updated.'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _markDoseSnooze(DoseLog dose) async {
    await _storage.markDoseSnoozed(dose.medicineId, dose.scheduledTime);
    // Trigger notification snooze escalation (10m)
    NotificationService().showMedicineAlert(
      id: dose.medicineId.hashCode,
      medicineId: dose.medicineId,
      medicineName: dose.medicineName,
      timing: 'Snoozed dose • 10 minutes',
      purpose: 'Reminder to take your scheduled dose',
      repeatAttempt: 1,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.warning,
          content: Text('⏱ Snoozed for 10 minutes. Reminder alert set.'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator(color: AppColors.primaryGreen)),
      );
    }

    final loc = AppLocalization(_storage.settings.language);
    final profile = _storage.emergencyProfile;
    final userName = profile.userName.isNotEmpty ? profile.userName : 'Ammu';
    final greeting = '${_getGreeting(loc)}, $userName 🌸';

    final todayDoses = _storage.todayDoseLogs;
    final int tabletsToday = todayDoses.length;
    final int takenCount = todayDoses.where((d) => d.isTaken).length;
    final int upcomingCount = todayDoses.where((d) => !d.isTaken).length;

    final nextAppt = _storage.nextAppointment;
    final int daysUntilHospital = nextAppt?.daysUntil ?? 0;

    // Determine the next upcoming dose
    final upcomingDoses = todayDoses.where((d) => !d.isTaken).toList();
    DoseLog? nextDose = upcomingDoses.isNotEmpty ? upcomingDoses.first : null;
    Medicine? nextMedicine;
    if (nextDose != null) {
      nextMedicine = _storage.medicines.firstWhere(
        (m) => m.id == nextDose!.medicineId,
        orElse: () => _storage.medicines.first,
      );
    }

    // Prepare text for Voice Reader
    final voiceScript = 'Hello $userName. You have $tabletsToday tablets scheduled for today. '
        'You have taken $takenCount, and $upcomingCount doses are remaining. '
        '${nextMedicine != null ? "Your next medicine is ${nextMedicine.name} at ${nextDose?.scheduledTime}." : "All your medicines are taken for today!"} '
        'Your next hospital visit is in $daysUntilHospital days.';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Medi',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryGreen,
                  ),
                ),
                Text(
                  'Nest',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.accentBlue,
                  ),
                ),
              ],
            ),
            Text(
              loc.tr('tagline'),
              style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          // Emergency Card speed shortcut
          IconButton(
            tooltip: 'Emergency Medical Card',
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AppColors.dangerLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.emergency_rounded, color: AppColors.danger, size: 22),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const EmergencyCardScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primaryGreen,
          onRefresh: () async => setState(() {}),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting banner
                Text(
                  greeting,
                  style: AppStyles.headingLarge.copyWith(
                    fontSize: 26,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Here is your health schedule for today.',
                  style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 14),

                // Voice reading bar
                VoiceReadingBar(
                  textToSpeak: voiceScript,
                  languageCode: _storage.settings.language,
                ),
                const SizedBox(height: 16),

                // Four Large Summary Cards
                Row(
                  children: [
                    Expanded(
                      child: SummaryStatCard(
                        title: loc.tr('tablets_today'),
                        value: '$tabletsToday',
                        subtitle: 'Doses Total',
                        icon: Icons.medication_rounded,
                        accentColor: AppColors.accentBlue,
                        bgColor: AppColors.accentBlueLight.withOpacity(0.4),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: SummaryStatCard(
                        title: loc.tr('taken'),
                        value: '$takenCount',
                        subtitle: 'Completed',
                        icon: Icons.check_circle_rounded,
                        accentColor: AppColors.primaryGreen,
                        bgColor: AppColors.primaryGreenLight.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: SummaryStatCard(
                        title: loc.tr('upcoming'),
                        value: '$upcomingCount',
                        subtitle: 'Pending Now',
                        icon: Icons.schedule_rounded,
                        accentColor: AppColors.warning,
                        bgColor: AppColors.warningLight.withOpacity(0.4),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: SummaryStatCard(
                        title: 'Hospital Visit',
                        value: daysUntilHospital > 0 ? '$daysUntilHospital' : '0',
                        subtitle: loc.tr('days_left'),
                        icon: Icons.local_hospital_rounded,
                        accentColor: const Color(0xFF8E24AA),
                        bgColor: const Color(0xFFF3E5F5).withOpacity(0.6),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const HospitalTrackerScreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Next Medicine Card
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      loc.tr('next_medicine'),
                      style: AppStyles.headingMedium,
                    ),
                    if (nextMedicine != null)
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MedicineDetailsScreen(medicine: nextMedicine!),
                            ),
                          );
                        },
                        child: const Text(
                          'View Info →',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accentBlue,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),

                NextMedicineBanner(
                  medicine: nextMedicine,
                  nextDose: nextDose,
                  onTaken: () {
                    if (nextDose != null) _markDoseTaken(nextDose);
                  },
                  onSnooze: () {
                    if (nextDose != null) _markDoseSnooze(nextDose);
                  },
                  onTapDetails: () {
                    if (nextMedicine != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MedicineDetailsScreen(medicine: nextMedicine!),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 24),

                // Monthly Hospital Reminder Alert Banner
                if (nextAppt != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppStyles.cardRadius,
                      border: Border.all(color: AppColors.accentBlue.withOpacity(0.4), width: 1.5),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: AppColors.accentBlueLight,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.event_available_rounded, color: AppColors.accentBlueDark, size: 24),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${nextAppt.specialization} Check-up',
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${nextAppt.doctorName} • ${nextAppt.hospitalName}',
                                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.accentBlueLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                daysUntilHospital == 0
                                    ? 'Today!'
                                    : (daysUntilHospital == 1 ? 'Tomorrow' : '$daysUntilHospital Days Left'),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.accentBlueDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                ),
                                icon: const Icon(Icons.phone_rounded, color: AppColors.primaryGreen, size: 18),
                                label: const Text('Call Doctor', style: TextStyle(color: AppColors.primaryGreenDark, fontWeight: FontWeight.bold)),
                                onPressed: () => CallLauncherService.makePhoneCall(nextAppt.doctorPhone),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.accentBlue,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                ),
                                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                                label: const Text('Hospital Tracker', style: TextStyle(fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => const HospitalTrackerScreen()),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Today's Doses Checklist
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Today\'s Medication Schedule',
                      style: AppStyles.headingMedium,
                    ),
                    Text(
                      '${takenCount}/${tabletsToday} Done',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreenDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                ...todayDoses.map((dose) {
                  final med = _storage.medicines.firstWhere(
                    (m) => m.id == dose.medicineId,
                    orElse: () => DummyData.getInitialMedicines().first,
                  );
                  final isTaken = dose.isTaken;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isTaken ? AppColors.primaryGreenLight.withOpacity(0.4) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isTaken ? AppColors.primaryGreen.withOpacity(0.3) : AppColors.border,
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: isTaken,
                          activeColor: AppColors.primaryGreen,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          onChanged: (val) {
                            if (val == true) {
                              _markDoseTaken(dose);
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dose.medicineName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  decoration: isTaken ? TextDecoration.lineThrough : null,
                                  color: isTaken ? AppColors.textSecondary : AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                '${dose.scheduledTime} • ${med.afterFood ? "After Food 🍲" : "Before Food 🍎"}',
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        if (!isTaken)
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: AppColors.primaryGreenLight,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () => _markDoseTaken(dose),
                            child: const Text(
                              'Take',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryGreenDark,
                              ),
                            ),
                          )
                        else
                          const Icon(Icons.done_all_rounded, color: AppColors.primaryGreen, size: 20),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
